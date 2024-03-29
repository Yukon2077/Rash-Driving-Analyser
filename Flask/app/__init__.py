from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Api
from flask_socketio import SocketIO

from config import config


db = SQLAlchemy()
api = Api()
socketio = SocketIO()


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])

    db.init_app(app)
    socketio.init_app(app, manage_session=False)

    from app.main import main as main_blueprint
    app.register_blueprint(main_blueprint)

    from app.resource import resource as resource_blueprint
    api.init_app(resource_blueprint)
    app.register_blueprint(resource_blueprint)

    return app
