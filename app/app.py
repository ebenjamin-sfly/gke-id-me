# import flask

from flask import Flask, request, render_template
from pymongo import MongoClient

# Import Geocoder
import geocoder
import datetime

mydict = {}

# app = flask.Flask(__name__)
app = Flask(__name__, static_folder='/custompath')
# app = flask.Flask(__name__, static_folder='/custompath')
app.config["DEBUG"] = True

try:
    # Set up MongoDB connection and collection
    # client = MongoClient("mongodb://ebenjamin:devops123@127.0.0.1:27017/admin?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.1.5")
    client = MongoClient("mongodb://ebenjamin:devops123@my-mongodb-0.my-mongodb-svc.mongodb.svc.cluster.local:27017/admin?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.1.5")
    # With TLS cert and key
    # client = MongoClient("mongodb://ebenjamin:devops123@my-mongodb-0.my-mongodb-svc.mongodb.svc.cluster.local:27017/admin?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.1.5")
    # print("User ebenjamin connected to MongoDB successfully!!!")

    # Create database named demo if they don't exist already
    db = client['store']

    # Create collection named data if it doesn't exist already
    collection = db['strings']
    # print(collection.find())

    def find_collections_data():
        for x in collection.find():
            for k in x:
                if k == "index":
                    index_string = x["index"]
        return index_string

    index_string = find_collections_data()
    print(index_string)

except:
    print("Could not connect to MongoDB")
    index_string = None
    print(index_string)

@app.route('/', methods=['GET'])
def home():
    # return render_template('index.html')
    index_string = find_collections_data()
    return '<h1>' + index_string

@app.route('/index.html', methods=['GET'])
def index():
    # return '<h1>' + index_string
    return render_template('index.html')

# Get data from MongoDB route
@app.route('/get_data', methods=['GET'])
def get_data():
    now = datetime.datetime.now()
    try:
        index_string = find_collections_data()
    except:
        return '<h1> Could not connect to MongoDB'
    return '<h1>' + index_string + "  " + str(now)
@app.route('/get_ip')
def get_ip():
    ip_addr = request.environ.get('HTTP_X_FORWARDED_FOR', request.remote_addr)
    now = datetime.datetime.now()
    return '<h1> Your IP address is:' + ip_addr + "  " +str(now)

# Add data to MongoDB route
@app.route('/post_data', methods=['GET','POST'])
def post_data():
    if request.method == 'GET':
        user_input = request.args.get('text', '')

        for x in collection.find():
            myquery = {"index": x['index']}
            newvalues = {"$set": {"index": user_input}}
            collection.update_one(myquery, newvalues)
    now = datetime.datetime.now()
    return '<h1> Data added to MongoDB: ' + user_input + "  " +str(now)

@app.route('/client')
def client():
    ip_addr = request.environ.get('HTTP_X_FORWARDED_FOR', request.remote_addr)
    return '<h1> Your IP address is:' + ip_addr

@app.route('/echo')
def api_echo():
    if request.method == 'GET':
        echo_text = request.environ.get('HTTP_X_FORWARDED_FOR', request.remote_addr)
        user_ip = echo_text.split()[0]
        # '''
        # The following block needs to be enabled if running this locally.
        # '''
        # if user_ip == '127.0.0.1' or '192.168.65.1':
        #     user_ip = "3.13.145.11"

        # Assign IP address to a variable
        ip = geocoder.ip(user_ip)

        # Obtain the location
        ip_location = ip.city + ',  ' + ip.state + ',  ' + ip.country
        user_input=request.args.get('text', '')

        return_string = "<h1> ECHO: " + user_input + ' IP: '+ user_ip + '   ' + '   Location: ' + ip_location
        return return_string

if __name__ == '__main__':
    app.run()
