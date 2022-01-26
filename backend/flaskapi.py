from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello World!"

@app.route('/get_items')
def get_users():
    return {}

app.run(host='0.0.0.0', port=5000)