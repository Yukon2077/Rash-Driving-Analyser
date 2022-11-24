from . import db


class User(db.Model):
    user_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, unique=True, nullable=False)
    password = db.Column(db.String, nullable=False)
    user_token = db.Column(db.String, unique=True)
    vehicles = db.relationship('Vehicle', backref='user')

    def __repr__(self):
        return '<User %r>' % self.name


class Vehicle(db.Model):
    __table_args__ = (db.UniqueConstraint('vehicle_id', 'user_id', 'vehicle_image'),)
    vehicle_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable=False)
    vehicle_image = db.Column(db.String, nullable=False)
    vehicle_name = db.Column(db.String, nullable=False)
    vehicle_number = db.Column(db.String, nullable=False)
    vehicle_token = db.Column(db.String, unique=True)
    data = db.relationship('DrivingData', backref='vehicle')

    def __repr__(self):
        return '<User %r>' % self.vehicle_name


class DrivingData(db.Model):
    data_id = db.Column(db.Integer, primary_key=True)
    vehicle_id = db.Column(db.Integer, db.ForeignKey('vehicle.vehicle_id'), nullable=False)
    driving_vehicle_speed = db.Column(db.Float, nullable=False)
    nearby_vehicle_speed = db.Column(db.Float, nullable=False)
    nearby_vehicle_distance = db.Column(db.Float, nullable=False)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return '<User %r>' % self.data_id
