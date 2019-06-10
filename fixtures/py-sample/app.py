#!/usr/bin/env python3
from flask import Flask
import os

# Initialize the Flask application
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"


# start flask app
port = os.getenv('PORT', 8080)
app.run(host="0.0.0.0", port=port)
