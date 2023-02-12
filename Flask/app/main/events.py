import sys

from flask import current_app

from .. import socketio
from flask_socketio import emit, join_room, leave_room
from ..models import DrivingData


@socketio.on('connect')
def connect():
    current_app.logger.info('Connected')


@socketio.on('join')
def on_join(room):
    join_room(room)
    emit('entered_room', to=room)


@socketio.on('leave')
def on_leave(room):
    leave_room(room)
    emit('left_room', to=room)