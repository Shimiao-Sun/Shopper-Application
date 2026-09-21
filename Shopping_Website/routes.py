import datetime
from flask import render_template, Blueprint, request, session, redirect
from model import sql_handler
from mail_notification import send_message
import bcrypt, re

router = Blueprint('routes', __name__)
database = sql_handler.SqlDatabase()

@router.route('/')
def home():
    if session.get('state') != None:
        if (session.get('userType') == 3):
            return render_template('admin/sa_home.html')
        else:
            return render_template(session['state'] + '/home.html')
    else:
        return render_template('login.html')

@router.route('/register')
def register():
    if session.get('state') != None:
        return render_template('already_logged_in.html')
    return render_template('register.html')

@router.route('/reset_new_password')
def reset_new_password_input():
    args = request.args
    time = args.get("time")
    hash = str(args.get("hash"))
    email = args.get("email")
    salt = database.get_salt(email)
    new_hash = str(bcrypt.hashpw(time.encode('utf-8'), salt.encode('utf-8')))
    time_delta = int(datetime.datetime.now().timestamp()) - int(time)
    #10 minutes time limit
    time_limit = 60*10
    if new_hash != hash or time_delta > time_limit:
        return render_template("permission_denied.html")
    elif session.get('state') != None:
        return render_template('already_logged_in.html')
    return render_template('reset_new_password.html', email = email)

@router.route('/categories')
def categories():
    if session.get('state') == "admin":
        return render_template('admin/categories.html', categories=database.list_categories())
        # return render_template('admin/categories.html', categories=None)
    else:
        return render_template('/permission_denied.html')

@router.route('/add_category')
def add_category():
    if session.get('state') == "admin" :
        return render_template('admin/add_category.html')
    else:
        return render_template('/permission_denied.html')

@router.route('/admins')
def admins():
    if session.get('state') == "admin" and session.get('userType') == 3:
        return render_template('admin/admins.html', admins = database.list_admins())
    else:
        return render_template('/permission_denied.html')

@router.route('/add_admin')
def add_admin():
    if session.get('state') == 'admin' and session.get('userType') == 3:
        return render_template('admin/sa_register.html')
    else:
        return render_template('/permission_denied.html')

@router.route('/category_details/<id>')
def category_details(id):  
    if session.get('state') == "admin":
        return render_template(session['state'] + '/category_details.html', items=database.show_category(id))
    else:
        return render_template('/permission_denied.html')

@router.route('/items')
def items():
    if session.get('state') == "seller":
        return render_template(session['state'] + '/items.html', items=database.list_items_for_seller(session['email']))
    elif session.get('state') == "admin":
        return render_template(session['state'] + '/items.html', items=database.list_items_for_admin())
    else:
        return render_template('/permission_denied.html')

@router.route('/add_item')
def add_item():
    if session.get('state') != None:
        return render_template(session['state'] + '/add_item.html', category=database.show_categories(), username=database.show_all_users())
    else:
        return render_template('/permission_denied.html')

@router.route('/orders')
def orders():
    if session.get('state') == "admin":
        return render_template(session['state'] + '/orders.html', orders=database.get_order_details_for_admin())
    elif session.get('state') == "seller":
        return render_template(session['state'] + '/orders.html', orders=database.get_order_details_for_seller(session['email']))
    else:
        return render_template('/permission_denied.html')

@router.route('/view_order/<id>')
def order_details(id):  
    if session.get('state') == "seller":
        return render_template(session['state'] + '/order_details.html', items=database.get_order_id_for_seller(session['email'], id), id=id)
    elif session.get('state') == "admin":
        return render_template(session['state'] + '/order_details.html', items=database.get_order_id_for_admin(id), id=id)
    else:
        return render_template('/permission_denied.html')

@router.route('/login')
def login():
    if session.get('state') != None:
        return render_template('already_logged_in.html')
    return render_template('login.html')

@router.route('/logout')
def logout():
    session['username'] = None
    session['state'] = None
    # return redirect('/')
    return render_template('logged_out.html')
    
@router.route('/authenticate', methods = ['POST'])
def auth():
    if request.method == 'POST':
        data = request.form
        email = data['email']
        password = data['password']
        salt = database.get_salt(email)
        
        if salt == None: #user doesn't exist. 
            return render_template('login_failed.html')

        hash = bcrypt.hashpw(password.encode('utf-8'), salt.encode('utf-8'))

        if database.authenticate(email, hash.decode('ascii')):
            userType = database.get_user_type(email)
            if(userType == 0 or userType == 3):
                session['state'] = "admin"
            else:
                session['state'] = "seller"
            session['username'] = database.get_user_first_name(email)
            session['email'] = email
            session['userType'] = userType
            return redirect('/') 
        else:
            return render_template('login_failed.html')

#TODO
@router.route('/action_register', methods = ['POST'])
def reg():
    if request.method == 'POST':
        data = request.form
        firstname = data['first_name']
        lastname = data['last_name']
        email = data['email']
        password = data['password']
        conf_password = data['password_conf']
        #Validate Inputs
        if '' in (firstname, lastname, email, password):
            return render_template('register_failed_input.html')
        
        pat = "^[a-zA-Z0-9-_]+@[a-zA-Z0-9]+\.[a-z]{1,3}$"
        if not re.match(pat, email):
            return render_template('register_failed_malformed_email.html') 

        if password != conf_password:
            return render_template('register_failed_conf_password_wrong.html')      
        
        salt = bcrypt.gensalt()
        pw_bytes = password.encode('utf-8')
        hash = bcrypt.hashpw(pw_bytes, salt)

        new_users_type = 1
        if session.get('userType') == 3:
            new_users_type = 0

        if database.addUser(firstname, lastname, email, hash.decode('ascii'), salt.decode('ascii'), new_users_type):
            return render_template('register_success.html')
        else:
            return render_template('register_failed.html')
    
@router.route('/action_add_item', methods = ['POST'])
def action_add_item():
    if request.method == 'POST' and session['state'] != "admin":
        email = session['email']
        user_id = database.search_user_id(email)
        data = request.form
        name = data['name']
        price = data['price']
        desc = data['desc']
        category = data['Category']
        quantity = data['quantity']
        image = request.files['image']
        database.add_item(name, user_id, price, image, desc, category, quantity)
        return redirect('/')
    elif request.method == 'POST' and session['state'] == "admin":
        data = request.form
        seller = data['username']
        user_id = database.search_user_id(seller)
        name = data['name']
        price = data['price']
        desc = data['desc']
        category = data['Category']
        quantity = data['quantity']
        image = request.files['image']
        database.add_item(name, user_id, price, image, desc, category, quantity)
        return redirect('/')

@router.route('/action_add_category', methods = ['POST'])
def action_add_category():
    if session['state'] == "admin":
        if request.method == 'POST':
            data = request.form
            name = data['name']
            image = request.files['image']
            database.add_category(name, image)
            return redirect('/categories')
    else: 
        return render_template('/permission_denied.html') 

@router.route('/action_delete_category/<id>')
def action_delete_category(id):  
    if session.get('state') == "admin":
        database.delete_category(id)
        return render_template('admin/categories.html', categories=database.list_categories())
    else:
        return render_template('/permission_denied.html')

@router.route('/action_delete_item/<id>')
def action_delete_item(id):  
    if session.get('state') == "admin" or session.get('state') == "seller":
        database.delete_item(id)
        return redirect("/items")
    else:
        return render_template('/permission_denied.html')

@router.route('/forgot_password')
def forgot_password():
    if session.get('state') != None:
        return render_template('already_logged_in.html')
    return render_template('forgot_password.html')

@router.route('/action_verify', methods = ['POST'])
def action_reset_password():
    if request.method == 'POST':
        data = request.form
        email = data['email']
        if not database.user_exists(email):
            return render_template('/reset_failed_user_not_exists.html')
        else:
            send_message(email, database.get_salt(email))
            return redirect('/login')

@router.route('/action_reset', methods = ['POST'])
def reset_new_password():
    if request.method == 'POST':
        data = request.form
        email = data['email']
        new_password = data['new_password']
        conf_new_password = data['conf_new_password']
        if new_password != conf_new_password:
            return render_template('/reset_failed_conf_password.html')
        else:
            salt = bcrypt.gensalt()
            newpw_bytes = new_password.encode('utf-8')
            new_hash_password = bcrypt.hashpw(newpw_bytes, salt)
            
            print("{} {}".format(new_hash_password.decode('ascii'), salt.decode('ascii')))
            database.reset_password(email, new_hash_password.decode('ascii'), salt.decode('ascii'))
            return render_template('/reset_successful.html')

@router.route('/action_delete_admin/<id>')
def action_delete_admin(id):
    if session.get('state') == "admin" and session.get('userType') == 3:
        database.delete_admin(id)
        return render_template('admin/admins.html', admins = database.list_admins())
    else:
        return render_template('/permission_denied.html')

@router.route('/action_update_order/<id>', methods = ['POST'])
def action_update_order(id):
    if request.method == 'POST':
        data = request.form
        order_status = data['status']
        database.order_status_update(order_status, id)
        return redirect("/orders")
    else:
        return render_template('/permission_denied.html')