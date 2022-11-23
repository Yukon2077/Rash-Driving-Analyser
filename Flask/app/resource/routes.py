import uuid

import werkzeug
from flask import make_response
from flask_restful import reqparse, Resource
from werkzeug.security import check_password_hash, generate_password_hash

from .. import db, api
from ..models import User, Vehicle, DrivingData

parser = reqparse.RequestParser()
parser.add_argument('token', type=str)
parser.add_argument('name', type=str)
parser.add_argument('email', type=str)
parser.add_argument('password', type=str)
parser.add_argument('vehicle_id', type=str)
parser.add_argument('vehicle_name', type=str)
parser.add_argument('vehicle_number', type=str)
parser.add_argument('vehicle_image', type=werkzeug.datastructures.FileStorage, location='files')
parser.add_argument('driving_vehicle_speed', type=str)
parser.add_argument('nearby_vehicle_speed', type=str)
parser.add_argument('nearby_vehicle_distance', type=str)
parser.add_argument('latitude', type=str)
parser.add_argument('longitude', type=str)
tokenParser = reqparse.RequestParser()
tokenParser.add_argument('Authorization', location='headers')


class LoginApi(Resource):
    def post(self):
        args = parser.parse_args()
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
        args = parser.parse_args()
        name = args['name']
        email = args['email']
        password = args['password']
        if not bool(User.query.filter_by(email=email).first()):
            user = User(name=name, email=email, password=generate_password_hash(password))
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


class VehicleListApi(Resource):
    def get(self):
        args = tokenParser.parse_args()
        token = args['Authorization'].split()[1]
        user = User.query.filter_by(user_token=token).first()
        if bool(user):
            vehicles = Vehicle.query.filter_by(user_id=user.user_id).all()
            vehicle_as_json = []
            for i in vehicles:
                vehicle_as_json.append(row_to_dict(i))
            return make_response(vehicle_as_json)
        else:
            return make_response({'code': 1, 'message': 'Unknown user. Please login again'}, 404)


class VehicleApi(Resource):
    def get(self, vehicle_id):
        args = tokenParser.parse_args()
        token = args['Authorization'].split()[1]
        user = User.query.filter_by(user_token=token).first()
        if bool(user):
            vehicle = Vehicle.query.filter_by(user_id=user.user_id, vehicle_id=vehicle_id).first()
            data = DrivingData.query.filter_by(vehicle_id=vehicle.vehicle_id).all()
            return make_response(row_to_dict(vehicle))
        else:
            return make_response({'code': 1, 'message': 'Unknown user. Please login again'}, 404)


class AddVehicleApi(Resource):
    def post(self):
        args = parser.parse_args()
        vehicle_name = args['vehicle_name']
        vehicle_number = args['vehicle_number']
        vehicle_image = args['vehicle_image']
        vehicle = Vehicle(
            vehicle_name=vehicle_name,
            vehicle_number=vehicle_number,
            vehicle_image=vehicle_image)
        db.session.add(vehicle)
        db.session.commit()
        if vehicle.vehicle_id:
            return make_response({'code': 1, 'message': 'Sucessfully added'}, 200)
        else:
            return make_response({'code': 2, 'message': 'Something went wrong'}, 404)


class DrivingDataApi(Resource):
    def post(self):
        args = parser.parse_args()
        token = args['token']
        driving_vehicle_speed = args['driving_vehicle_speed']
        nearby_vehicle_speed = args['nearby_vehicle_speed']
        nearby_vehicle_distance = args['nearby_vehicle_distance']
        latitude = args['latitude']
        longitude = args['longitude']
        vehicle = Vehicle.query.filter_by(vehicle_token=token).first()
        data = DrivingData(
            vehicle_id=vehicle.vehicle_id,
            driving_vehicle_speed=driving_vehicle_speed,
            nearby_vehicle_speed=nearby_vehicle_speed,
            nearby_vehicle_distance=nearby_vehicle_distance,
            latitude=latitude,
            longitude=longitude)
        db.session.add(data)
        db.session.commit()
        if data.data_id:
            return make_response({'code': 1, 'message': 'Sucessfully added'}, 200)
        else:
            return make_response({'code': 2, 'message': 'Something went wrong'}, 404)


def row_to_dict(row):
    d = {}
    for column in row.__table__.columns:
        d[column.name] = str(getattr(row, column.name))
    return d


api.add_resource(LoginApi, '/api/login')
api.add_resource(RegisterApi, '/api/register')
api.add_resource(VehicleListApi, '/api/vehicle')
api.add_resource(AddVehicleApi, '/api/vehicle/add')
api.add_resource(VehicleApi, '/api/vehicle/<int:vehicle_id>')
api.add_resource(DrivingDataApi, '/api/data')
