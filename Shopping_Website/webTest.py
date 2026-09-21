from dataclasses import dataclass
from re import template
from urllib import response
import pytest
from flask import render_template, Blueprint, request, session, redirect, template_rendered
from routes import action_reset_password
from main import create_app
from model import sql_handler

database = sql_handler.SqlDatabase()
png_file = open('cat.png', 'rb')

@pytest.fixture()
def app():
    app = create_app()
    app.config.update({
        "TESTING": True,
    })

    yield app

@pytest.fixture()
def client(app):
    return app.test_client()

@pytest.fixture()
def runner(app):
    return app.test_cli_runner()

@pytest.fixture
def captured_templates(app):
    recorded = []

    def record(sender, template, context, **extra):
        recorded.append((template, context))

    template_rendered.connect(record, app)
    try:
        yield recorded
    finally:
        template_rendered.disconnect(record, app)


# Test for register / log in session

def test_login_session_admin(client):
    with client:
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        assert session['state'] == "admin"

def test_login_session_seller(client):
    with client:
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        assert session['state'] == "seller"

def test_register_success_session(client, captured_templates):
    with client:
        database.delete_user("SS3@shopper.com")
        response = client.post("/action_register", data={"first_name": "Seller3", "last_name": "Account", "email": "SS3@shopper.com", "password": "seller3Password", "password_conf": "seller3Password"})
        assert response.status_code == 200
        assert len(captured_templates) == 1
        template, context = captured_templates[0]
        assert template.name == "register_success.html"

def test_login_failed_session(client, captured_templates):
    with client:
        response = client.post("/authenticate", data={"email": "SS@shopper.com", "password": "wrongpassword"})
        assert response.status_code == 200
        assert len(captured_templates) == 1
        template, context = captured_templates[0]
        assert template.name == "login_failed.html"

def test_register_failed_session(client, captured_templates):
    with client:
        # existed email register
        response = client.post("/action_register", data={"first_name": "Seller3", "last_name": "Account", "email": "SS@shopper.com", "password": "seller3Password", "password_conf": "seller3Password"})
        assert response.status_code == 200
        assert len(captured_templates) == 1
        template, context = captured_templates[0]
        assert template.name == "register_failed.html"

        # wrong confirm password
        response = client.post("/action_register", data={"first_name": "Seller3", "last_name": "Account", "email": "SS3@shopper.com", "password": "seller3Password", "password_conf": "seller2Password"})
        assert response.status_code == 200
        assert len(captured_templates) == 2
        template, context = captured_templates[1]
        assert template.name == "register_failed_conf_password_wrong.html"

        # no input error
        response = client.post("/action_register", data={"first_name": "", "last_name": "Account", "email": "SS3@shopper.com", "password": "seller3Password", "password_conf": "seller2Password"})
        assert response.status_code == 200
        assert len(captured_templates) == 3
        template, context = captured_templates[2]
        assert template.name == "register_failed_input.html"

        # wrong email form
        response = client.post("/action_register", data={"first_name": "Seller3", "last_name": "Account", "email": "SS3WrongForm.com", "password": "seller3Password", "password_conf": "seller2Password"})
        assert response.status_code == 200
        assert len(captured_templates) == 4
        template, context = captured_templates[3]
        assert template.name == "register_failed_malformed_email.html"


# Test for log out session

def test_log_out(client):
    with client:
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        response = client.get("/logout")
        assert b"<h1>Successfully logged out!</h1>" in response.data


# Test for categories session

def test_categories_success_session(client, captured_templates):
    with client:
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        response = client.get("/categories")
        assert response.status_code == 200
        assert session['state'] == "admin"
        template, context = captured_templates[0]
        assert template.name == "admin/categories.html"

def test_categories_failed_session(client, captured_templates):
    with client:
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        response = client.get("/categories")
        assert response.status_code == 200
        assert session['state'] == "seller"
        template, context = captured_templates[0]
        assert template.name == "/permission_denied.html"

def test_add_category_session(client):
    with client:
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        assert session['state'] == "admin"
        client.get("/categories")
        client.get("/add_category")
        response = client.post("/action_add_category", data={"name": "Computer", "image": png_file})
        assert response.status_code == 302 # test for correct redirect


# Test for orders session

def test_orders_session(client, captured_templates):
    with client:
        # Admin login
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        response = client.get("/orders")
        assert response.status_code == 200
        assert session['state'] == "admin"
        template, context = captured_templates[0]
        assert template.name == "admin/orders.html"

        client.get("/logout")

        # Seller login
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        response = client.get("/orders")
        assert response.status_code == 200
        assert session['state'] == "seller"
        template, context = captured_templates[2]
        assert template.name == "seller/orders.html"

def test_order_failed_session(client, captured_templates):
    with client:
        response = client.get("/orders")
        assert response.status_code == 200
        template, context = captured_templates[0]
        assert template.name == "/permission_denied.html"

def test_view_order_session(client):
    with client:
        # admin login
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        assert session['state'] == "admin"
        response = client.get("/orders")
        assert response.status_code == 200
        response = client.get("/view_order/1")
        assert response.status_code == 200
        assert b"<td> item: Bear </td>" in response.data
        assert b"<td> amount: 1 </td>" in response.data
        assert b"<td> price: 100 </td>" in response.data

        client.get("/logout")
        
        # seller login
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        assert session['state'] == "seller"
        response = client.get("/orders")
        assert response.status_code == 200
        response = client.get("/view_order/1")
        assert response.status_code == 200

def test_order_status(client):
    with client:
        # Admin log in
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        assert session['state'] == "admin"
        response = client.get("/view_order/1")
        assert response.status_code == 200
        response = client.post("/action_update_order/1", data={"status": "3"})
        assert response.status_code == 302  # test for correct redirect


# Test for items session

def test_items_session(client, captured_templates):
    with client:
        # Admin login
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        response = client.get("/items")
        assert response.status_code == 200
        assert session['state'] == "admin"
        template, context = captured_templates[0]
        assert template.name == "admin/items.html"

        client.get("/logout")

        # Seller login
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        response = client.get("/items")
        assert response.status_code == 200
        assert session['state'] == "seller"
        template, context = captured_templates[2]
        assert template.name == "seller/items.html"

def test_order_failed_session(client, captured_templates):
    with client:
        response = client.get("/items")
        assert response.status_code == 200
        template, context = captured_templates[0]
        assert template.name == "/permission_denied.html"

def test_add_item_session(client, captured_templates):
    with client:
        # Admin login
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        client.get("/categories")
        response = client.get("/add_item")
        assert response.status_code == 200
        assert session['state'] == "admin"
        template, context = captured_templates[1]
        assert template.name == "admin/add_item.html"

        client.get("/logout")

        # Seller login
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        response = client.get("/add_item")
        assert response.status_code == 200
        assert session['state'] == "seller"
        template, context = captured_templates[3]
        assert template.name == "seller/add_item.html"


# Test for add item function

def test_add_item_function(client):
    with client:
        # Admin login
        client.post("/authenticate", data={"email": "AA@shopper.com", "password": "adminPassword"})
        assert session['state'] == "admin"
        with open('cat.png', 'rb') as png_file:
            response = client.post("/action_add_item", data={
            "username": "SS@shopper.com", 
            "name": "Journal", 
            "price": 43, 
            "desc": "Journal test desc!", 
            "quantity": 10, 
            "Category": "Stationary", 
            "image": png_file
            })
        assert response.status_code == 302 # test for correct redirect

        client.get("/logout")

        # seller login 
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "sellerPassword"})
        assert session['state'] == "seller"
        with open('cat.png', 'rb') as png_file:
            response = client.post("/action_add_item", data={
            "username": "SS@shopper.com", 
            "name": "Journal", 
            "price": 43, 
            "desc": "Journal test desc!", 
            "quantity": 10, 
            "Category": "Stationary", 
            "image": png_file
            })
        assert response.status_code == 302 # test for correct redirect


# Test for reset password function

def test_reset_password(client, captured_templates):
    with client:
        # seller1 password reset
        response = client.post("/action_reset", data={"email": "SS@shopper.com", "new_password": "seller1Password", "conf_new_password": "seller1Password"})
        assert response.status_code == 200
        assert len(captured_templates) == 1
        template, context = captured_templates[0]
        assert template.name == "/reset_successful.html"
        client.post("/authenticate", data={"email": "SS@shopper.com", "password": "seller1Password"})
        # assert session['state'] == "seller"

        client.get("/logout")
        response = client.post("/action_reset", data={"email": "SS@shopper.com", "new_password": "sellerPassword", "conf_new_password": "sellerPassword"})

        # seller1 wrong confirm password input
        response = client.post("/action_reset", data={"email": "SS@shopper.com", "new_password": "sellerPassword", "conf_new_password": "seller1Password"})
        assert response.status_code == 200
        assert len(captured_templates) == 4
        template, context = captured_templates[3]
        assert template.name == "/reset_failed_conf_password.html"

        # uesr not exists input
        response = client.post("/action_verify", data={"email": "SSnotfound@shopper.com"})
        assert response.status_code == 200
        assert len(captured_templates) == 5
        template, context = captured_templates[4]
        assert template.name == "/reset_failed_user_not_exists.html"


# super admin test session

def test_super_admin(client):
    with client:
        # Super Admin login
        client.post("/authenticate", data={"email": "MA@shopper.com", "password": "adminPassword"})
        assert session['state'] == "admin"

        # SA add new admin
        client.get("/add_admin")
        response = client.post("/action_register", data={"first_name": "admin", "last_name": "test", "email": "AT@shopper.com", "password": "atestPassword", "password_conf": "atestPassword"})
        assert response.status_code == 200

        client.get("/logout")
        
        # new damin login 
        client.post("/authenticate", data={"email": "AT@shopper.com", "password": "atestPassword"})
        assert session['state'] == "admin"

        client.get("/logout")

        # delete new admin
        client.post("/authenticate", data={"email": "MA@shopper.com", "password": "adminPassword"})
        assert session['state'] == "admin"
        client.get("/admins")
        client.get("/action_delete_admin/" + str(database.search_user_id("AT@shopper.com")))
        assert response.status_code == 200

