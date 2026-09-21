SET search_path TO 'shopper';

DROP TABLE IF EXISTS Wishlist CASCADE;
DROP TABLE IF EXISTS Cart CASCADE;
DROP TABLE IF EXISTS OrderItem CASCADE;
DROP TABLE IF EXISTS Tag CASCADE;
DROP TABLE IF EXISTS ItemCategory CASCADE;
DROP TABLE IF EXISTS Category CASCADE;
DROP TABLE IF EXISTS UserOrder CASCADE;
DROP TABLE IF EXISTS Item CASCADE;
DROP TABLE IF EXISTS UserAccount CASCADE;
DROP TABLE IF EXISTS Address CASCADE;
DROP TABLE IF EXISTS VerificationCode CASCADE;
DROP TABLE IF EXISTS ApiKey CASCADE;

CREATE TABLE UserAccount (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    hashed_pw VARCHAR(300) NOT NULL,
    user_type INTEGER NOT NULL,
    salt VARCHAR(300)
);

CREATE TABLE Item (
    item_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    seller_id INTEGER REFERENCES UserAccount(user_id), 
    price INTEGER,
    image_path VARCHAR(2000),
    description VARCHAR(2000),
    quantity INTEGER   
);

CREATE TABLE Cart(
    user_id INTEGER REFERENCES UserAccount(user_id),
    item_id INTEGER REFERENCES Item(item_id),
    quantity INTEGER
);

CREATE TABLE Wishlist(
    user_id INTEGER REFERENCES UserAccount(user_id),
    item_id INTEGER REFERENCES Item(item_id)
);

CREATE TABLE Address(
    address_id SERIAL PRIMARY KEY,
    street_address VARCHAR(256),
    suburb VARCHAR(128),
    state VARCHAR(50),
    postcode INTEGER,
    country VARCHAR(128)
);

CREATE TABLE UserOrder(
    order_id SERIAL PRIMARY KEY,
    seller_id INTEGER REFERENCES UserAccount(user_id),
    buyer_id INTEGER REFERENCES UserAccount(user_id),
    address_id INTEGER REFERENCES Address(address_id),
    order_status INTEGER
);

CREATE TABLE OrderItem(
    order_id INTEGER REFERENCES UserOrder(order_id),
    item_id INTEGER REFERENCES Item(item_id),
    quantity INTEGER,
    PRIMARY KEY(order_id, item_id)
);

CREATE TABLE Tag(
    item_id INTEGER REFERENCES Item(item_id),
    tag_name VARCHAR(20),
    PRIMARY KEY(item_id, tag_name)
);

CREATE TABLE Category(
    category_id SERIAL PRIMARY KEY,
    image_path VARCHAR(2000),
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE ItemCategory(
    item_id INTEGER REFERENCES Item(item_id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES Category(category_id) ON DELETE CASCADE,
    PRIMARY KEY(item_id,category_id)
);

CREATE TABLE VerificationCode(
    code_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES UserAccount(user_id),
    code INTEGER,
    date_time VARCHAR(128),
    is_used INTEGER
);
CREATE TABLE ApiKey(
    apikey_id SERIAL PRIMARY KEY,
    apikey VARCHAR(256),
    api VARCHAR(50)
);
INSERT INTO ApiKey (apikey,api) VALUES ('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','SendGrid');

