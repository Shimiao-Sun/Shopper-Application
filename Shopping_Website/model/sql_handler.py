from distutils.command.upload import upload
import psycopg2, logging, boto3, os
from botocore.exceptions import ClientError
s3_storage = "https://soft3888storage.s3.ap-southeast-2.amazonaws.com"

class SqlDatabase:

    #get the database running
    def __init__(self):
        self.conn = psycopg2.connect(dbname="shopper", host="database-1.cywhmv98ew17.ap-southeast-2.rds.amazonaws.com", port=5432, user="postgres", password="admin8888")
        self.curs = self.conn.cursor()
        

    def addUser(self, firstname, lastname, email, password, salt, userType):

        #check exists username
        if self.user_exists(email):
            return False
        else: 
            sql_cmd = """
                INSERT INTO shopper.useraccount (first_name, last_name, email, hashed_pw, salt, user_type)
                VALUES(%s, %s, %s, %s, %s, %s) 
            """
            self.curs.execute(sql_cmd, (firstname, lastname, email, password, salt, userType))
            self.conn.commit()
            return True

    def authenticate(self, email, hashed_pw):
        sql_cmd = """
            SELECT 1 
            FROM shopper.useraccount
            WHERE email = %s AND hashed_pw = %s
        """
        
        self.curs.execute(sql_cmd, (email, hashed_pw))
        records = self.curs.fetchall()
        if len(records) == 1:
            return True
        else:
            return False

    def get_salt(self, email):
        sql_cmd = """
            SELECT salt
            FROM shopper.useraccount
            WHERE email = %s
        """
        self.curs.execute(sql_cmd, (email,))
        records = self.curs.fetchall()
        if len(records) == 1:
            return records[0][0]
        else:
            return None
        
    
    def user_exists(self, email):
        sql_cmd = """
            SELECT 1
            FROM shopper.useraccount
            WHERE email = %s
        """
        
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()
        if self.curs.fetchone():
            return True
        else:
            return False
    
    def list_orders(self):
        sql_cmd = """
            SELECT * FROM shopper.UserOrder
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchall()
        self.conn.commit()
        return res

    def list_admins(self):
        sql_cmd = """
            SELECT first_name, last_name, email FROM shopper.UserAccount
            WHERE user_type = 0
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchall()
        self.conn.commit()
        return res

    def list_items(self):
        sql_cmd = """
            SELECT * FROM shopper.item
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchall()
        self.conn.commit()
        return res

    def add_item(self, product_name, seller_id, price, image, description, category, quantity):
        
        
        sql_cmd1 = """
            INSERT INTO shopper.item (product_name, seller_id, price, description, quantity)
            VALUES(%s, %s, %s, %s, %s) 
        """
        
        self.curs.execute(sql_cmd1, (product_name, seller_id, price, description, quantity))

        # find the item id of the inserted item
        sql_cmd2 = """
            SELECT MAX(item_id)
            FROM shopper.item
        """
        self.curs.execute(sql_cmd2)
        res_item_id = self.curs.fetchone()[0]

        image_url = self.upload_item_image(image, str(res_item_id))

        #update the image url

        sql_cmd1 = """
        UPDATE shopper.item
        SET image_path = %s
        WHERE item_id = %s
        """

        self.curs.execute(sql_cmd1, (image_url, res_item_id))
            
        # find the category id
        sql_cmd3 = """
            SELECT category_id
            FROM shopper.category
            WHERE category_name = %s
        """
    
        self.curs.execute(sql_cmd3, (category,))
        res_category_id = self.curs.fetchone()[0]

        # insert id into item_category
        sql_cmd4 = """
            INSERT INTO shopper.itemcategory (item_id, category_id)
            VALUES(%s, %s)
        """
        
        self.curs.execute(sql_cmd4, (res_item_id, res_category_id))
        self.conn.commit()

        return True

    def add_category(self, name, image):
        #Check if category exists. 
        sql_cmd = """
            SELECT * FROM Category
            WHERE category_name = %s
        """
        self.curs.execute(sql_cmd, (name,))
        if self.curs.fetchone() != None:
            return False

        #Category is new, upload picture to s3.
        image_url = self.upload_category_image(image, name)


        #Add category name and link to picture to database. 
        sql_cmd = """
            INSERT INTO shopper.Category (category_name, image_path)
            VALUES(%s, %s) 
        """

        self.curs.execute(sql_cmd, (name, image_url))
        self.conn.commit()

        return True

    def delete_category(self, id):
        sql_cmd = """
            DELETE FROM shopper.Category 
            WHERE category_name=%s
        """
        
        self.curs.execute(sql_cmd, (id,))
        self.conn.commit()

        self.remove_category_image(id)

        return True

    def delete_item(self, id):
        sql_cmd = """
            DELETE FROM shopper.itemcategory
            WHERE item_id=%s 
        """
        self.curs.execute(sql_cmd, (id, ))
        sql_cmd = """
            DELETE FROM shopper.wishlist
            WHERE item_id=%s 
        """
        self.curs.execute(sql_cmd, (id, ))
        sql_cmd = """
            DELETE FROM shopper.orderitem
            WHERE item_id=%s 
        """
        self.curs.execute(sql_cmd, (id, ))
        sql_cmd = """
            DELETE FROM shopper.item 
            WHERE item_id=%s 
        """
        self.curs.execute(sql_cmd, (id, ))
        self.conn.commit()

        return True

    def show_categories(self):
        sql_cmd = """
            SELECT category_name
            FROM shopper.category
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchall()
        res = list(map(lambda x: x[0], res))
        return res
    
    def show_category(self, id):
        sql_cmd = """
            SELECT *
            FROM shopper.category
            WHERE category_id = %s
        """
        self.curs.execute(sql_cmd, (id, ))
        self.conn.commit()
        res = self.curs.fetchall()
        return res

    def list_categories(self):
        sql_cmd = """
            SELECT * FROM shopper.category
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchall()
        #We would like to know if these categories contain items. 
        to_return = []
        for entry in res:
            to_return.append((entry[0], entry[1], entry[2], self.category_size(entry[2])))
        return to_return

    def search_user_id(self, email):
        sql_cmd = """
            SELECT user_id
            FROM shopper.useraccount
            WHERE email = %s
        """
        
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()
        res = self.curs.fetchone()
        return res[0]
    
    def show_all_users(self):
        sql_cmd = """
            SELECT email
            FROM shopper.useraccount
            WHERE user_type <> 0
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchall()
        res = list(map(lambda x: x[0], res))
        return res

    def list_items_for_seller(self, email):
        sql_cmd = """
            SELECT product_name, image_path, item_id
            FROM shopper.item INNER JOIN shopper.useraccount ON shopper.item.seller_id = shopper.useraccount.user_id
            WHERE shopper.useraccount.email = %s
        """
        
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()
        res = self.curs.fetchall()
        return res

    def list_items_for_admin(self):
        sql_cmd = """
            SELECT product_name, image_path, item_id
            FROM shopper.item
        """
        self.curs.execute(sql_cmd)
        res = self.curs.fetchall()
        return res

    def get_user_type(self, email):
        sql_cmd = """
            SELECT user_type
            FROM shopper.useraccount
            WHERE email = %s
        """
        
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()
        res = self.curs.fetchone()[0]
        return res

    def get_user_first_name(self, email):
        sql_cmd = """
            SELECT first_name
            FROM shopper.useraccount
                WHERE email = %s
        """
        
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()
        res = self.curs.fetchone()[0]
        return res

    def get_order_details_for_seller(self, email):
        sql_cmd = """
            SELECT shopper.userorder.order_id, count(shopper.userorder.order_id)
            FROM shopper.userorder INNER JOIN shopper.orderitem ON shopper.userorder.order_id = shopper.orderitem.order_id
            INNER JOIN shopper.item on shopper.orderitem.item_id = shopper.item.item_id
            INNER JOIN shopper.useraccount on shopper.userorder.seller_id = shopper.useraccount.user_id
            WHERE email = %s
            GROUP BY shopper.userorder.order_id
            ORDER BY shopper.userorder.order_id
        """
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()
        res = self.curs.fetchall()
        return res

    def get_order_details_for_admin(self):
        sql_cmd = """
            SELECT shopper.userorder.order_id, count(shopper.userorder.order_id)
            FROM shopper.userorder INNER JOIN shopper.orderitem ON shopper.userorder.order_id = shopper.orderitem.order_id
            INNER JOIN shopper.item on shopper.orderitem.item_id = shopper.item.item_id
            INNER JOIN shopper.useraccount on shopper.userorder.seller_id = shopper.useraccount.user_id
            GROUP BY shopper.userorder.order_id
            ORDER BY shopper.userorder.order_id
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchall()
        return res

    def get_order_id_for_seller(self, email, id):
        sql_cmd = """
            SELECT product_name, shopper.orderitem.quantity, price, shopper.userorder.order_id
            FROM shopper.userorder INNER JOIN shopper.orderitem ON shopper.userorder.order_id = shopper.orderitem.order_id
            INNER JOIN shopper.item on shopper.orderitem.item_id = shopper.item.item_id
            INNER JOIN shopper.useraccount on shopper.userorder.seller_id = shopper.useraccount.user_id
            WHERE email = %s AND shopper.userorder.order_id = %s
        """
        
        self.curs.execute(sql_cmd, (email, id))
        self.conn.commit()
        res = self.curs.fetchall()
        return res

    def get_order_id_for_admin(self, id):
        sql_cmd = """
            SELECT product_name, shopper.orderitem.quantity, price, shopper.userorder.order_id
            FROM shopper.userorder INNER JOIN shopper.orderitem ON shopper.userorder.order_id = shopper.orderitem.order_id
            INNER JOIN shopper.item on shopper.orderitem.item_id = shopper.item.item_id
            INNER JOIN shopper.useraccount on shopper.userorder.seller_id = shopper.useraccount.user_id
            WHERE shopper.userorder.order_id = %s
        """
        
        self.curs.execute(sql_cmd, (id, ))
        self.conn.commit()
        res = self.curs.fetchall()
        return res

    def delete_admin(self, email):
        sql_cmd = """
            DELETE FROM shopper.useraccount WHERE email = %s AND user_type = 0
        """
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()

    def reset_password(self, email, new_password, salt):
        sql_cmd = """
            UPDATE shopper.useraccount
            SET hashed_pw = %s, salt = %s
            WHERE email = %s
        """       
        self.curs.execute(sql_cmd, (new_password, salt, email))
        self.conn.commit()
        return True 

    def getApiKey(self):
        sql_cmd = """
            SELECT apikey
            FROM shopper.apikey
            WHERE api = 'SendGrid'
        """
        self.curs.execute(sql_cmd)
        self.conn.commit()
        res = self.curs.fetchone()
        return res[0]


    # only for test use
    def delete_user(self, email):
        sql_cmd = """
            DELETE FROM shopper.useraccount WHERE email = %s
        """
        
        self.curs.execute(sql_cmd, (email,))
        self.conn.commit()


    def upload_file(self, file, bucket, object_name):
        """Upload a file to an S3 bucket

        :param file_name: File to upload
        :param bucket: Bucket to upload to
        :param object_name: S3 object name. If not specified then file_name is used
        :return: True if file was uploaded, else False"""

        # Upload the file
        s3_client = boto3.resource(
            's3',
            aws_access_key_id= 'AKIA5F2O7YGTCXNHUCHK',
            aws_secret_access_key= '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',
            #aws_session_token=SESSION_TOKEN
        )
        
        bucket = s3_client.Bucket(bucket)

        bucket.Object(object_name).put(Body=file.read())

        

        # After upload to S3 please add "<folder>/<image_name>" to url field of item database too.

    def remove_file(self, bucket, object_name):
        s3_client = boto3.resource(
            's3',
            aws_access_key_id= 'AKIA5F2O7YGTCXNHUCHK',
            aws_secret_access_key= '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',
            #aws_session_token=SESSION_TOKEN
        )

        bucket = s3_client.Bucket(bucket)

        bucket.Object(object_name).delete()
    
    def upload_item_image(self, file_name, object_name):
        self.upload_file(file_name, "soft3888storage", 'item_image/{}'.format(object_name))
        return s3_storage + "/item_image/" + object_name

    def upload_category_image(self, file_name, object_name):
        self.upload_file(file_name, "soft3888storage", 'category_image/{}'.format(object_name))
        return s3_storage + "/category_image/" + object_name

    def remove_category_image(self, name):
        self.remove_file("soft3888storage", 'category_image/{}'.format(name))

    def category_size(self, category):
        command = """ Select count(*) 
        From shopper.ItemCategory inner join shopper.category on shopper.ItemCategory.category_id = shopper.Category.category_id WHERE shopper.Category.category_name = %s ;
        """
        self.curs.execute(command, (category,))
        response = self.curs.fetchone()
        return response[0]

    def order_status_update(self, status, order_id):
        command = """
            UPDATE shopper.userorder
            SET order_status = %s
            WHERE order_id = %s
        """
        self.curs.execute(command, (status, order_id))
        self.conn.commit()
        return True 
