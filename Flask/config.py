import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    SECRET_KEY = b'\xe5GW8\x10\x0c$\xa4\xcc\xe4\x00\x16\xb3\x0b=\x8f\xcc\xb2\xb9(,\xf2\xc8P'
    MAX_CONTENT_LENGTH = 32 * 1000 * 1000


class DevelopmentConfig(Config):
    DEBUG = True
    UPLOAD_FOLDER = os.path.join(basedir, 'database\\development\\images')
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'database\\development\\database.sqlite3')
    SQLALCHEMY_TRACK_MODIFICATIONS = False


class ProductionConfig(Config):
    UPLOAD_FOLDER = os.path.join(basedir, 'database\\production\\images')
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'database\\production\\database.sqlite3')


config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig,
}
