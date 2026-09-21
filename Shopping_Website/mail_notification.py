import datetime
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from model import sql_handler
import bcrypt

database = sql_handler.SqlDatabase()

def send_message(email, salt):
    date = datetime.datetime.now()
    time = int(date.timestamp())
    time_string = str(time)
    

    hash = bcrypt.hashpw(time_string.encode('utf-8'), salt.encode('utf-8'))

    message_html = """
        <strong>Are you going to reset password?</strong>
        <br />
        <a style="float: center" href="http://127.0.0.1:5000/reset_new_password?email={}&time={}&hash={}">Yes</a>
        <br />
        This link will stay valid for 10 minutes
        <strong>If you did not make this request then please ignore this email.</strong> 
    """.format(email, time_string, hash)

    message = Mail(
    from_email='shoppernotifications@gmail.com',
    to_emails=email,
    subject='Password Reset Notification',
    html_content=message_html)
    sg = SendGridAPIClient(database.getApiKey())
    response = sg.send(message)
    print(response.status_code)
    print(response.body)
    print(response.headers)

