import os
import uuid
import pickle
import pandas as pd

from werkzeug.datastructures import FileStorage
from flask import current_app, make_response, request
from flask_restful import reqparse, Resource
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename

from .. import db, api, socketio
from ..models import User, Vehicle, DrivingData

token_parser = reqparse.RequestParser()
token_parser.add_argument('Authorization', location='headers')

user_parser = reqparse.RequestParser()
user_parser.add_argument('name', type=str)
user_parser.add_argument('email', type=str)
user_parser.add_argument('password', type=str)

vehicle_parser = reqparse.RequestParser()
vehicle_parser.add_argument('vehicle_name', type=str)
vehicle_parser.add_argument(
    'vehicle_image', type=FileStorage, location='files')

driving_data_parser = reqparse.RequestParser()
driving_data_parser.add_argument('token', type=str)
driving_data_parser.add_argument('driving_vehicle_speed', type=str)
driving_data_parser.add_argument('nearby_vehicle_speed', type=str)
driving_data_parser.add_argument('nearby_vehicle_distance', type=str)
driving_data_parser.add_argument('latitude', type=str)
driving_data_parser.add_argument('longitude', type=str)


class LoginApi(Resource):
    def post(self):
        args = user_parser.parse_args()
        email = args['email']
        password = args['password']
        user = User.query.filter_by(email=email).first()
        if user:
            if check_password_hash(user.password, password):
                user.user_token = uuid.uuid4().hex
                db.session.commit()
                return make_response({'token': user.user_token})
            else:
                return make_response({'code': 1, 'message': 'Wrong email or password'}, 404)
        else:
            return make_response({'code': 2, 'message': 'Email doesn\'t exists'}, 404)


class RegisterApi(Resource):
    def post(self):
        args = user_parser.parse_args()
        name = args['name']
        email = args['email']
        password = args['password']
        if not bool(User.query.filter_by(email=email).first()):
            user = User(name=name, email=email,
                        password=generate_password_hash(password))
            db.session.add(user)
            db.session.commit()
            if user.user_id:
                user.user_token = uuid.uuid4().hex
                db.session.commit()
                return make_response({'token': user.user_token})
            else:
                return make_response({'code': 1, 'message': 'Something went wrong'}, 404)
        else:
            return make_response({'code': 2, 'message': 'Email already exists'}, 404)


class VehicleApi(Resource):
    def get(self, vehicle_id=None):
        args = token_parser.parse_args()
        token = args['Authorization'].split()[1]
        user = User.query.filter_by(user_token=token).first()
        if bool(user):
            if vehicle_id:
                vehicle = Vehicle.query.filter_by(
                    user_id=user.user_id, vehicle_id=vehicle_id).first()
                if vehicle:
                    data = DrivingData.query.filter_by(
                        vehicle_id=vehicle.vehicle_id).all()
                    # return the data too
                    return make_response(row_to_dict(vehicle))
                else:
                    return make_response({'code': 2, 'message': 'Vehicle not found'}, 404)
            else:
                vehicles = Vehicle.query.filter_by(user_id=user.user_id).all()
                vehicle_as_json = []
                for i in vehicles:
                    vehicle_as_json.append(row_to_dict(i))
                return make_response(vehicle_as_json)
        else:
            return make_response({'code': 1, 'message': 'Unknown user. Please login again'}, 404)

    def post(self):
        token = request.headers.get('Authorization').split()[1]
        user = User.query.filter_by(user_token=token).first()
        if bool(user):
            vehicle_name = request.form.get('vehicle_name')
            vehicle_image = request.files.get('vehicle_image')
            vehicle = Vehicle(
                user_id=user.user_id,
                vehicle_name=vehicle_name)
            if vehicle_image:
                vehicle_image.filename = str(uuid.uuid4()) + '.' + \
                    vehicle_image.filename.rsplit('.', 1)[1]
                filename = secure_filename(vehicle_image.filename)
                path = current_app.config['UPLOAD_FOLDER']
                if not os.path.exists(path):
                    os.makedirs(path)
                vehicle_image.save(os.path.join(path, filename))
                vehicle.vehicle_image = filename
            db.session.add(vehicle)
            db.session.commit()
            if vehicle.vehicle_id:
                return make_response({'code': 1, 'message': 'Successfully added'}, 200)
            else:
                return make_response({'code': 2, 'message': 'Something went wrong'}, 404)
        else:
            return make_response({'code': 2, 'message': 'Please login again'}, 404)


class DrivingDataApi(Resource):
    def post(self):
        args = driving_data_parser.parse_args()
        # Incase if it's not possible to add bearer token, put the token in the body
        # token_arg = tokenParser.parse_args()
        # token = token_arg['Authorization'].split()[1]
        token = args['token']
        driving_vehicle_speed = args['driving_vehicle_speed']
        nearby_vehicle_speed = args['nearby_vehicle_speed']
        nearby_vehicle_distance = args['nearby_vehicle_distance']
        latitude = args['latitude']
        longitude = args['longitude']
        if token:
            vehicle = Vehicle.query.filter_by(vehicle_token=token).first()
            with open('model.pickle', 'rb') as data_file:
                model = pickle.load(data_file)
            input_data = {'driving_vehicle_speed': driving_vehicle_speed,
                          'nearby_vehicle_speed': nearby_vehicle_speed,
                          'nearby_vehicle_distance': nearby_vehicle_distance}
            is_rash = model.predict(pd.DataFrame(input_data, index=[0]))[0]
            if (driving_vehicle_speed < nearby_vehicle_speed):
                is_rash = False
            data = DrivingData(
                vehicle_id=vehicle.vehicle_id,
                driving_vehicle_speed=driving_vehicle_speed,
                nearby_vehicle_speed=nearby_vehicle_speed,
                nearby_vehicle_distance=nearby_vehicle_distance,
                latitude=latitude,
                longitude=longitude,
                is_rash=is_rash)
            db.session.add(data)
            db.session.commit()
            if data.data_id:
                new_data = row_to_dict(DrivingData.query.filter_by(
                    data_id=data.data_id).first())
                socketio.emit('new_data', new_data, to=vehicle.vehicle_id)
                return make_response({'code': 1, 'message': 'Successfully added'}, 200)
            else:
                return make_response({'code': 2, 'message': 'Something went wrong'}, 404)
        else:
            return make_response({'code': 3, 'message': 'Vehicle token missing'}, 404)


def row_to_dict(row):
    d = {}
    for column in row.__table__.columns:
        d[column.name] = str(getattr(row, column.name))
    return d


api.add_resource(LoginApi, '/api/login')
api.add_resource(RegisterApi, '/api/register')
api.add_resource(VehicleApi, '/api/vehicle', '/api/vehicle/<int:vehicle_id>')
api.add_resource(DrivingDataApi, '/api/data')
