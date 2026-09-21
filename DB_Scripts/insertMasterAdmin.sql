INSERT INTO UserAccount (
    first_name,
    last_name,
    email,
    hashed_pw,
    salt,
    user_type
) VALUES 
    (
        'Master',
        'Admin',
        'MA@shopper.com',
        '$2b$12$KOdaNHPCjgjWEzNJ/tqObOlwtaItglumcLfCGNC/Zv0HKI94sBpay', --adminPassword
        '$2b$12$KOdaNHPCjgjWEzNJ/tqObO', 
        3
    );