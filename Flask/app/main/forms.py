from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed, FileSize
from wtforms import StringField, EmailField, PasswordField, SubmitField
from wtforms.validators import Email, DataRequired, EqualTo


class LoginForm(FlaskForm):
    email = EmailField('Email', validators=[Email(), DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')


class RegisterForm(FlaskForm):
    name = StringField('Name', validators=[DataRequired()])
    email = EmailField('Email', validators=[Email(), DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    verify_password = PasswordField('Verify Password', validators=[
        DataRequired(),
        EqualTo('password')])
    submit = SubmitField('Register')


class ConnectForm(FlaskForm):
    vehicle_name = StringField('Vehicle Name/Number', validators=[DataRequired()])
    vehicle_image = FileField('Vehicle Image', validators=[
        FileSize(max_size=32 * 1000 * 1000),
        FileAllowed(['png', 'jpg', 'jpeg', 'webp'])
    ])
    submit = SubmitField('Connect')
