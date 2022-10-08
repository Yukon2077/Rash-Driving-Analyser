from flask import Flask, render_template, redirect, url_for, request, session, send_from_directory
from flask_restful import Resource, Api, reqparse
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
import secrets, uuid, os

app=Flask(__name__)

api = Api(app)

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp'}
UPLOAD_FOLDER = 'images'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1000 * 1000

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
    user_token = db.Column(db.String, unique = True)
    vehicles = db.relationship('Vehicle', backref = 'user')


class Vehicle(db.Model):
    __table_args__ = (db.UniqueConstraint('vehicle_id', 'user_id', 'vehicle_image'),)
    vehicle_id = db.Column(db.Integer, primary_key = True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable = False)
    vehicle_image = db.Column(db.String, nullable=False)
    vehicle_name = db.Column(db.String, nullable = False)
    vehicle_number = db.Column(db.String, nullable = False)
    vehicle_token = db.Column(db.String, unique = True)
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
    if 'user_id' not in session:
        if request.method == 'GET':
            return render_template('login.html')
        else:
            email = request.form.get('email')
            password = request.form.get('password')
            user = User.query.filter_by(email = email).first()
            if user:
                if check_password_hash(user.password, password):
                    session['user_id'] = user.user_id
                    return redirect(url_for('profile'))
                else:
                    return render_template('login.html', error_code = 1)
            else:
                return render_template('login.html', error_code = 2)
    else:
        return redirect(url_for('profile'))


@app.route('/register', methods = ['GET', 'POST'])
def register():
    if 'user_id' not in session:
        if request.method == 'GET':
            return render_template('register.html')
        else:
            name = request.form.get('name')
            email = request.form.get('email')
            password = request.form.get('password')
            confirm_password = request.form.get('confirm_password')
            if password != confirm_password:
                return render_template('register.html', error_code = 1)
            if not bool(User.query.filter_by(email = email).first()):
                user = User(name = name, email = email, password = generate_password_hash(password))
                db.session.add(user)
                db.session.commit()
                if user.user_id:
                    session['user_id'] = user.user_id
                    return redirect(url_for('profile'))
                else:
                    return render_template('register.html', error_code = 3)
            else:
                return render_template('register.html', error_code = 2)
    else:
        return redirect(url_for('profile'))

@app.route('/profile')
def profile():
    if 'user_id' in session:
        user = User.query.with_entities(User.name, User.email).filter_by(user_id = session['user_id']).first()
        vehicles = Vehicle.query.filter_by(user_id = session['user_id']).all()
        vehicle_count = Vehicle.query.filter_by(user_id = session['user_id']).count()
        return render_template('profile.html', user = user, vehicles = vehicles, vehicle_count = vehicle_count)
    else:
        return redirect(url_for('login'))

@app.route('/vehicle/add', methods=['GET', 'POST'])
def add_vehicle():
    if 'user_id' in session:
        if request.method == 'GET':
            return render_template('add_vehicle.html')
        else:
            name = request.form.get('name')
            number = request.form.get('number')
            image = request.files.get('image')
            if name == '' or number == '':
                return render_template('add_vehicle.html', error_code = 1)
            if image.filename == '':
                return render_template('add_vehicle.html', error_code = 2)
            if image and allowed_file(image.filename):
                image.filename = str(uuid.uuid4()) + '.' + image.filename.rsplit('.', 1)[1]
                filename = secure_filename(image.filename)
                vehicle = Vehicle(
                    user_id = session['user_id'], 
                    vehicle_image = filename,
                    vehicle_name = name,
                    vehicle_number = number, 
                    )
                db.session.add(vehicle)
                db.session.commit()
                path = os.path.join(
                    app.config['UPLOAD_FOLDER'], 
                    str(session['user_id']), 
                    str(vehicle.vehicle_id))
                if not os.path.exists(path):
                    os.makedirs(path)
                image.save(os.path.join(path, filename))
                return redirect(url_for('profile'))
    else:
        return redirect(url_for('login'))

@app.route('/vehicle/<int:vehicle_id>')
def view_vehicle(vehicle_id):
    if 'user_id' in session:
        vehicle = Vehicle.query.filter_by(user_id = session['user_id'], vehicle_id = vehicle_id).first()
        return render_template('view_vehicle.html', vehicle = vehicle)
    else:
        return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.pop('user_id')
    return redirect(url_for('login'))

@app.route('/uploads/<int:vehicle_id>/<string:image>')
def download_file(vehicle_id, image):
    if 'user_id' in session:
        return send_from_directory(app.config["UPLOAD_FOLDER"] + '\\' +
            str(session['user_id']) + '\\' +
            str(vehicle_id), image)
    else:
        return redirect(url_for('login'))

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

#========================================REST APIS========================================#

parser = reqparse.RequestParser()
parser.add_argument('email', type=str)
parser.add_argument('password', type=str)
#args = parser.parse_args()

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

    def post(self, token, id):
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
    db.create_all()
    app.run(debug = True, port = 80, host = '0.0.0.0')