from flask import Flask, Blueprint
from flask_bootstrap import Bootstrap
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Api

from config import config

db = SQLAlchemy()
bootstrap = Bootstrap()
api = Api()


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])

    db.init_app(app)
    bootstrap.init_app(app)

    from app.main import main as main_blueprint
    app.register_blueprint(main_blueprint)

    from app.resource import resource as resource_blueprint
    api.init_app(resource_blueprint)
    app.register_blueprint(resource_blueprint)

    return app
