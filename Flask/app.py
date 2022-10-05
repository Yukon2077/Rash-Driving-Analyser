from flask import Flask, render_template, redirect, url_for, request, session
from flask_restful import Resource, Api
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
import secrets

app=Flask(__name__)

api = Api(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

app.secret_key = secrets.token_hex()

#========================================MODELS========================================#

class User(db.Model):
    user_id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String, nullable = False)
    email = db.Column(db.String, unique = True, nullable = False)
    password = db.Column(db.String, nullable = False)
    vehicles = db.relationship('Vehicle', backref = 'user')

class Vehicle(db.Model):
    vehicle_id = db.Column(db.Integer, primary_key = True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable = False)
    vehicle_image = db.Column(db.LargeBinary, nullable=False)
    vehicle_name = db.Column(db.String, nullable = False)
    vehicle_number = db.Column(db.String, nullable = False)
    data = db.relationship('DrivingData', backref = 'vehicle')

class DrivingData(db.Model):
    data_id = db.Column(db.Integer, primary_key = True)
    vehicle_id = db.Column(db.Integer, db.ForeignKey('vehicle.vehicle_id'), nullable = False)
    driving_vehicle_speed = db.Column(db.Float, nullable = False)
    nearby_vehicle_speed = db.Column(db.Float, nullable = False)
    nearby_vehicle_distance = db.Column(db.Float, nullable = False)
    latitude = db.Column(db.Float, nullable = False)
    longitude = db.Column(db.Float, nullable = False)

#========================================WEB APPLICATION========================================#

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods = ['GET', 'POST'])
def login():
    if request.method == 'GET':
        return render_template('login.html')
    else:
        email = request.form.get('email')
        password = request.form.get('password')
        user = User.query.filter_by(email = email).first()
        if user and check_password_hash(user.password, password):
            return redirect(url_for('profile'))
        else:
            return render_template('login.html')

@app.route('/register', methods = ['GET', 'POST'])
def register():
    if request.method == 'GET':
        return render_template('register.html')
    else:
        name = request.form.get('name')
        email = request.form.get('email')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        if password != confirm_password:
            return render_template('register.html')
        if not User.query.filter_by(email = email).first():
            user = User(name = name, email = email, password = generate_password_hash(password))
            db.session.add(user)
            db.session.commit()
            if user.user_id:
                session['user_id'] = user.user_id
                return redirect(url_for('profile'))
        else:
            return render_template('register.html')

@app.route('/profile')
def profile():
    return render_template('profile.html')

#========================================REST APIS========================================#

class LoginApi(Resource):
    def post(self, email, password):
        return '1234'

class RegisterApi(Resource):
    def post(self, name, email, password):
        return '1234'

class VehicleListApi(Resource):
    def get(self, token):
        return '1234'

class VehicleApi(Resource):
    def get(self, token, id):
        return '1234'

api.add_resource(LoginApi, '/api/login')
api.add_resource(RegisterApi, '/api/register')
api.add_resource(VehicleListApi, '/api/vehicle')
api.add_resource(VehicleApi, '/api/vehicle/<int:id>')

#========================================GENERAL========================================#

@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    return response

if __name__ == '__main__':
    #db.create_all()
    app.run(debug = True, port = 80, host = '0.0.0.0')