python3 -m venv .myvenv
source .myvenv/bin/activate
pip install -r requirements.txt
python init_db.py
export FLASK_APP=app
export FLASK_ENV=development
flask run
# Running the app in development mode will show a traceback both in console and the browser when there is an error. 
# Method 2 to run the app
python3 app.py
deactivate