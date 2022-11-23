from flask import Blueprint

resource = Blueprint('resource', __name__)

from . import routes
