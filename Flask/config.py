import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    SECRET_KEY = b'\xe5GW8\x10\x0c$\xa4\xcc\xe4\x00\x16\xb3\x0b=\x8f\xcc\xb2\xb9(,\xf2\xc8P'
    UPLOAD_FOLDER = os.path.join(basedir, 'images')
    MAX_CONTENT_LENGTH = 32 * 1000 * 1000


class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'development-database.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False


class ProductionConfig(Config):
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'production-database.db')


config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig,
}
