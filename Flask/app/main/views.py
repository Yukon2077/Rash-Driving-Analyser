import os
import uuid

from flask import render_template, session, request, redirect, url_for, send_from_directory, current_app
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename

from . import main
from .. import db
from ..models import User, Vehicle, DrivingData


@main.route('/')
def index():
    return render_template('index.html')


@main.route('/login', methods=['GET', 'POST'])
def login():
    if 'user_id' not in session:
        if request.method == 'GET':
            return render_template('login.html')
        else:
            email = request.form.get('email')
            password = request.form.get('password')
            user = User.query.filter_by(email=email).first()
            if user:
                if check_password_hash(user.password, password):
                    session['user_id'] = user.user_id
                    return redirect(url_for('.profile'))
                else:
                    return render_template('login.html', error_code=1)
            else:
                return render_template('login.html', error_code=2)
    else:
        return redirect(url_for('.profile'))


@main.route('/register', methods=['GET', 'POST'])
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
                return render_template('register.html', error_code=1)
            if not bool(User.query.filter_by(email=email).first()):
                user = User(name=name, email=email, password=generate_password_hash(password))
                db.session.add(user)
                db.session.commit()
                if user.user_id:
                    session['user_id'] = user.user_id
                    return redirect(url_for('.profile'))
                else:
                    return render_template('register.html', error_code=3)
            else:
                return render_template('register.html', error_code=2)
    else:
        return redirect(url_for('.profile'))


@main.route('/profile')
def profile():
    if 'user_id' in session:
        user = User.query.with_entities(User.name, User.email).filter_by(user_id=session['user_id']).first()
        vehicles = Vehicle.query.filter_by(user_id=session['user_id']).all()
        vehicle_count = Vehicle.query.filter_by(user_id=session['user_id']).count()
        return render_template('profile.html', user=user, vehicles=vehicles, vehicle_count=vehicle_count)
    else:
        return redirect(url_for('.login'))


@main.route('/vehicle/add', methods=['GET', 'POST'])
def add_vehicle():
    if 'user_id' in session:
        if request.method == 'GET':
            return render_template('add_vehicle.html')
        else:
            name = request.form.get('name')
            number = request.form.get('number')
            image = request.files.get('image')
            if name == '' or number == '':
                return render_template('add_vehicle.html', error_code=1)
            if image.filename == '':
                return render_template('add_vehicle.html', error_code=2)
            if image and allowed_file(image.filename):
                image.filename = str(uuid.uuid4()) + '.' + image.filename.rsplit('.', 1)[1]
                filename = secure_filename(image.filename)
                vehicle = Vehicle(
                    user_id=session['user_id'],
                    vehicle_image=filename,
                    vehicle_name=name,
                    vehicle_number=number,
                )
                db.session.add(vehicle)
                db.session.commit()
                path = current_app.config['UPLOAD_FOLDER']
                if not os.path.exists(path):
                    os.makedirs(path)
                image.save(os.path.join(path, filename))
                return redirect(url_for('.profile'))
    else:
        return redirect(url_for('.login'))


@main.route('/vehicle/<int:vehicle_id>')
def view_vehicle(vehicle_id):
    if 'user_id' in session:
        vehicle = Vehicle.query.filter_by(user_id=session['user_id'], vehicle_id=vehicle_id).first()
        data = DrivingData.query.filter_by(vehicle_id=vehicle.vehicle_id).all()
        return render_template('view_vehicle.html', vehicle=vehicle, data=data)
    else:
        return redirect(url_for('.login'))


@main.route('/contact')
def contact():
    return render_template('contact.html')


@main.route('/logout')
def logout():
    session.pop('user_id')
    return redirect(url_for('.login'))


@main.route('/uploads/<string:image>')
def download_file(image):
    return send_from_directory(current_app.config["UPLOAD_FOLDER"] + '\\', image)


@main.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    return response


ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp'}


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
