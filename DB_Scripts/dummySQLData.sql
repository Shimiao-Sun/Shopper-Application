INSERT INTO UserAccount (
    first_name,
    last_name,
    email, 
    hashed_pw,
    salt,
    user_type
) VALUES 
    (
        'Admin',
        'Account',
        'AA@shopper.com',
        '$2b$12$KOdaNHPCjgjWEzNJ/tqObOlwtaItglumcLfCGNC/Zv0HKI94sBpay', --adminPassword
        '$2b$12$KOdaNHPCjgjWEzNJ/tqObO', 
        0
    ),
    (
        'Master',
        'Admin',
        'MA@shopper.com',
        '$2b$12$KOdaNHPCjgjWEzNJ/tqObOlwtaItglumcLfCGNC/Zv0HKI94sBpay', --adminPassword
        '$2b$12$KOdaNHPCjgjWEzNJ/tqObO', 
        3
    ),
    (
        'Seller',
        'Account',
        'SS@shopper.com',
        '$2b$12$yzT3UX5RIvoDE3DEgwxalOqb6TfhYmgyjyCXSHWEG63ox2PqNEady', --sellerPassword
        '$2b$12$yzT3UX5RIvoDE3DEgwxalO',
        1
    ),
    (
        'Seller2',
        'Account',
        'SS2@shopper.com',
        '$2b$12$yzT3UX5RIvoDE3DEgwxalOqb6TfhYmgyjyCXSHWEG63ox2PqNEady', --sellerPassword
        '$2b$12$yzT3UX5RIvoDE3DEgwxalO',
        1
    ),
    (
        'User',
        'Account',
        'UU@shopper.com',
        '$2b$12$CbKglL8TWzwjSRPf1QiZH.BgWn3i2OMsZkhKJbQRXoXnsTuH67DTu', --userPassword
        '$2b$12$CbKglL8TWzwjSRPf1QiZH.',
        2
    ),
    (
        'User2',
        'Account',
        'UU2@shopper.com',
        '$2b$12$CbKglL8TWzwjSRPf1QiZH.BgWn3i2OMsZkhKJbQRXoXnsTuH67DTu', --userPassword
        '$2b$12$CbKglL8TWzwjSRPf1QiZH.',
        2
    );

INSERT INTO Category (
    category_name,
    image_path
) VALUES
    (
        'Beauty',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/beauty.jpg'
    ),
    (
        'Stationary',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/stationary.jpg'
    ),
    (
        'Toy',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/toy.jpg'
    ),
    (
        'Cloth',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/cloth.jpg'
    ),
    (
        'Collectable',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/collectable.jpg'
    ),
    (
        'Developer',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/developer.jpg'
    ),
        (
        'Computer',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/computer.jpg'
    ),
    (
        'Kitchenware',
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/category_image/kitchenware.jpg'
    );

INSERT INTO Item (
    seller_id,
    product_name,
    price,
    image_path,
    description,
    quantity
) VALUES
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller'),
        'Bear',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/bear_starry_night',
        'Cute bear for kid',
        7
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller'),
        'BlueEye',
        6969,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/blueeye.jpeg',
        'rare Yu-gi-oh card',
        2
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller'),
        'BlueEye2',
        9696,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/blueeye2.jpeg',
        'rare Yu-gi-oh card',
        3
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Charizard',
        999999,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/charizard.jpeg',
        'rare Pokemon card',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Cam',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/comcam.jpeg',
        'Computer camera',
        3
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Eyelash',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/eyelash.jpeg',
        'Pretty+100',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Hat',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/hat.jpeg',
        'just a hat',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Jean',
        999,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/jean.jpeg',
        'limited jean from Supreme',
        1
    ),
        (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Knife',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/knife.png',
        'tool for cut food',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Lipstick',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/lipstick.jpeg',
        'Pretty+500',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Keyboard',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/magickeyboard.jpeg',
        'Bluetooth keyboard for apple product',
        1
    ),
        (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Monopoly',
        56,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/monopoly.jpeg',
        'classic board game',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Mouse',
        1,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/mouse.jpeg',
        'Meme',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Pan',
        20,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/pan.jpeg',
        'Just a pan',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Pen',
        10,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/pen.jpeg',
        'common pen',
        1
    ),
        (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Pencil',
        3,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/pencil.png',
        'common pencil',
        100
    ),
        (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Plate',
        20,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/plate.jpeg',
        'common plate',
        1
    ),
        (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Pot',
        33,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/pot.jpeg',
        'common Pot',
        1
    ),
        (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Silly Roman',
        999999,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/roman.png',
        'Web developer',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Lazy Toby',
        999999,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/toby.png',
        'Mobile developer',
        1
    ),
            (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'RTX4090',
        5000,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/rtx4090.jpg',
        'New generation GPU card',
        1
    ),
        (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Stardew',
        70,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/stardew.jpeg',
        'Stardew valley board game',
        1
    ),
            (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Sunglasses',
        100,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/sunglasses.jpeg',
        'Cool sun glasses',
        1
    ),
            (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'T-shirt',
        999999,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/tshirt.jpeg',
        'simple T-shit',
        1
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        'Charizard2',
        42.80,
        'https://soft3888storage.s3.ap-southeast-2.amazonaws.com/item_image/charizard2.jpeg',
        'rare Pokemon card',
        1
    );

INSERT INTO Tag(
    item_id,
    tag_name
) VALUES
    (
        (SELECT item_id from Item WHERE product_name = 'Lipstick'),
        'Lipstick'
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Lipstick'),
        'Makeup'
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Lipstick'),
        'Green'
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Pen'),
        'Stationary'
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Pen'),
        'Creativity'
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Pen'),
        'Writing'
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Pen'),
        'Green'
    );




INSERT INTO ItemCategory (
    item_id,
    category_id
)
VALUES
    (
        (SELECT item_id from Item WHERE product_name = 'Bear'),
        (SELECT category_id from Category WHERE category_name = 'Toy')
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'BlueEye'),
        (SELECT category_id from Category WHERE category_name = 'Collectable')
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'BlueEye2'),
        (SELECT category_id from Category WHERE category_name = 'Collectable')
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Charizard'),
        (SELECT category_id from Category WHERE category_name = 'Collectable')
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Charizard2'),
        (SELECT category_id from Category WHERE category_name = 'Collectable')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Eyelash'),
        (SELECT category_id from Category WHERE category_name = 'Beauty')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Hat'),
        (SELECT category_id from Category WHERE category_name = 'Cloth')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Jean'),
        (SELECT category_id from Category WHERE category_name = 'Cloth')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Knife'),
        (SELECT category_id from Category WHERE category_name = 'Kitchenware')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Lipstick'),
        (SELECT category_id from Category WHERE category_name = 'Beauty')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Keyboard'),
        (SELECT category_id from Category WHERE category_name = 'Computer')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Monopoly'),
        (SELECT category_id from Category WHERE category_name = 'Toy')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Mouse'),
        (SELECT category_id from Category WHERE category_name = 'Computer')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Pan'),
        (SELECT category_id from Category WHERE category_name = 'Kitchenware')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Pencil'),
        (SELECT category_id from Category WHERE category_name = 'Stationary')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Pen'),
        (SELECT category_id from Category WHERE category_name = 'Stationary')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Plate'),
        (SELECT category_id from Category WHERE category_name = 'Kitchenware')
    ),  
      (
        (SELECT item_id from Item WHERE product_name = 'Pot'),
        (SELECT category_id from Category WHERE category_name = 'Kitchenware')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Silly Roman'),
        (SELECT category_id from Category WHERE category_name = 'Developer')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Lazy Toby'),
        (SELECT category_id from Category WHERE category_name = 'Developer')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'RTX4090'),
        (SELECT category_id from Category WHERE category_name = 'Computer')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Stardew'),
        (SELECT category_id from Category WHERE category_name = 'Toy')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'Sunglasses'),
        (SELECT category_id from Category WHERE category_name = 'Cloth')
    ),
        (
        (SELECT item_id from Item WHERE product_name = 'T-shirt'),
        (SELECT category_id from Category WHERE category_name = 'Cloth')
    ),
    (
        (SELECT item_id from Item WHERE product_name = 'Cam'),
        (SELECT category_id from Category WHERE category_name = 'Computer')
    );

INSERT INTO Wishlist(
    user_id,
    item_id 
) VALUES (
    (SELECT user_id from UserAccount WHERE first_name = 'User'),
    (SELECT item_id from Item WHERE product_name = 'Charizard')
);

INSERT INTO Cart(
    user_id,
    item_id,
    quantity 
) VALUES (
    (SELECT user_id from UserAccount WHERE first_name = 'User'),
    (SELECT item_id from Item WHERE product_name = 'Pen'),
    5
);

INSERT INTO UserOrder(
    seller_id,
    buyer_id,
    order_status
)
VALUES 
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller'),
        (SELECT user_id from UserAccount WHERE first_name = 'User2'),
        0
    ),
    (
        (SELECT user_id from UserAccount WHERE first_name = 'Seller2'),
        (SELECT user_id from UserAccount WHERE first_name = 'User2'),
        3
    );

INSERT INTO OrderItem(
    order_id,
    item_id,
    quantity
) VALUES
    (
        (SELECT order_id from UserOrder WHERE seller_id = (SELECT user_id from UserAccount WHERE first_name = 'Seller')),
        (SELECT item_id from Item WHERE product_name = 'Bear'),
        1
    ),
    (
        (SELECT order_id from UserOrder WHERE seller_id = (SELECT user_id from UserAccount WHERE first_name = 'Seller2')),
        (SELECT item_id from Item WHERE product_name = 'Charizard2'),
        2
    ),
    (
        (SELECT order_id from UserOrder WHERE seller_id = (SELECT user_id from UserAccount WHERE first_name = 'Seller2') AND buyer_id = (SELECT user_id from UserAccount WHERE first_name = 'User2')),
        (SELECT item_id from Item WHERE product_name = 'Stardew'),
        3
    );


