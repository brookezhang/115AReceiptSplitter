from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello World!"

@app.route('/get_items')
def get_items():
    pass

@app.route('/post_picture')
def post_picture():
    pass

# @app.route('/get_items', methods=["POST"])
# def quiz(): 
#     subject= request.form.get('sub')
#     return render_template("quiz.html",subject=subject) 

app.run(host='0.0.0.0', port=5000)
