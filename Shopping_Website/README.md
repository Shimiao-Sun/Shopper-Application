## Running the website
install flask (easiest way is to get pip and run the command ```pip install Flask``` )

install bcrypt (easiest way is to get pip and run the command ```pip install bcrypt``` )

install sendgrid (easiest way is to get pip and run the command ```pip install sendgrid``` )

run with command ```python3 app.py```

You can ctrl+click the URL it outputs in the terminal to open it in browser

(If you get error messages also install whatever it asks you to)


# Code Structure

## model
contains python code for the model (currently only has sql stuck, to be replaced)

## mail_notification.py
Using SendGrid API to send system notifications to users when doing password reset. 

Please install python package sendgrid before ruunning this function using this command: ```pip install sendgrid```

## static
contains CSS and other assets

## templates 
contains Jinja templates for html which makes up the website

## routes.py
contains routes which link urls to html pages

## main.py & app.py
contains application factory to build the website app

## webTest.py
contains testcases for website

please install pytest before running webTest.py using this command: ```pip install pyTest```

please install package coverage for coverage report: ```pip install coverage```

test running command: ```coverage run -m pytest webTest.py```

testcase coverage command: ```coverage report```
