import os
import uuid

from flask import render_template, session, request, redirect, url_for, send_from_directory, current_app, flash
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename

from . import main
from .forms import LoginForm, RegisterForm, ConnectForm
from .. import db
from ..models import User, Vehicle, DrivingData


@main.route('/')
def index():
    return render_template('index.html')


@main.route('/login', methods=['GET', 'POST'])
def login():
    if 'user_id' not in session:
        login_form = LoginForm()
        if login_form.validate_on_submit():
            email = login_form.email.data
            password = login_form.password.data
            user = User.query.filter_by(email=email).first()
            if user:
                if check_password_hash(user.password, password):
                    session['user_id'] = user.user_id
                    return redirect(url_for('.home'))
                else:
                    flash('Wrong password or email')
                    return redirect(url_for('.login'))  # Wrong password...............or email, I dunno
            else:
                flash('Email doesn\'t exists')
                return redirect(url_for('.login'))  # Email doesn't exists
        return render_template('login.html', login_form=login_form)
    else:
        return redirect(url_for('.home'))


@main.route('/register', methods=['GET', 'POST'])
def register():
    if 'user_id' not in session:
        register_form = RegisterForm()
        if register_form.validate_on_submit():
            name = register_form.name.data
            email = register_form.email.data
            password = register_form.password.data
            if not bool(User.query.filter_by(email=email).first()):
                user = User(
                    name=name,
                    email=email,
                    password=generate_password_hash(password)
                )
                db.session.add(user)
                db.session.commit()
                if user.user_id:
                    session['user_id'] = user.user_id
                    return redirect(url_for('.home'))
                else:
                    flash('Something went wrong')
                    return redirect(url_for('.register'))
            else:
                flash('Email already exists')
                return redirect(url_for('.register'))
        return render_template('register.html',
                               register_form=register_form)
    else:
        return redirect(url_for('.home'))


@main.route('/home')
def home():
    if 'user_id' in session:
        user = User.query.with_entities(User.name, User.email).filter_by(user_id=session['user_id']).first()
        vehicles = Vehicle.query.filter_by(user_id=session['user_id']).all()
        vehicle_count = Vehicle.query.filter_by(user_id=session['user_id']).count()
        return render_template('home.html', user=user, vehicles=vehicles, vehicle_count=vehicle_count)
    else:
        return redirect(url_for('.login'))


@main.route('/connect', methods=['GET', 'POST'])
def connect():
    if 'user_id' in session:
        connect_form = ConnectForm()
        current_app.logger.debug('before validation')
        if connect_form.validate_on_submit():
            current_app.logger.debug('validation started')
            name = connect_form.vehicle_name.data
            image = connect_form.vehicle_image.data
            vehicle = Vehicle(
                user_id=session['user_id'],
                vehicle_name=name,
            )
            current_app.logger.debug('before image check')
            if image:
                current_app.logger.debug('image checked and in process')
                image.filename = str(uuid.uuid4()) + '.' + image.filename.rsplit('.', 1)[1]
                filename = secure_filename(image.filename)
                path = current_app.config['UPLOAD_FOLDER']
                if not os.path.exists(path):
                    os.makedirs(path)
                image.save(os.path.join(path, filename))
                vehicle.vehicle_image = filename
            db.session.add(vehicle)
            db.session.commit()
            current_app.logger.debug('vehicle added')
            return redirect(url_for('.home'))
        return render_template('connect.html', connect_form=connect_form)
    else:
        return redirect(url_for('.login'))


@main.route('/vehicle/<int:vehicle_id>')
def view_vehicle(vehicle_id):
    if 'user_id' in session:
        vehicle = Vehicle.query.filter_by(user_id=session['user_id'], vehicle_id=vehicle_id).first()
        data = DrivingData.query.filter_by(vehicle_id=vehicle.vehicle_id).all()
        return render_template('vehicle.html', vehicle=vehicle, data=data)
    else:
        return redirect(url_for('.login'))


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
