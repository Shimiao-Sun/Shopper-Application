from flask import Flask, session
from routes import router
from model import sql_handler
# app = Flask(__name__)

# TODO, make secret key more secure
# app.config['SECRET_KEY'] = "uh091s28de341jxoqw09283"
# app.register_blueprint(router)
# if __name__ == "__main__":
#     app.run(debug = True)


def create_app(test_config=None):
    app = Flask(__name__, instance_relative_config=False)
    database = sql_handler.SqlDatabase()
    # database.setupTestUserAccountTable()
    app.config.from_mapping(
        SECRET_KEY='uh091s28de341jxoqw09283',
        DATABASE=database,
    )
    app.register_blueprint(router)
    return app