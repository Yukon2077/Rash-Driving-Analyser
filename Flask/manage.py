import os

from app import create_app, db, socketio

app = create_app('default')

if __name__ == '__main__':
    with app.app_context():
        if not os.path.exists(app.config['UPLOAD_FOLDER']):
            os.makedirs(app.config['UPLOAD_FOLDER'])
        db.create_all()
    socketio.run(app, debug=True, host='0.0.0.0', port=80, allow_unsafe_werkzeug=True)
