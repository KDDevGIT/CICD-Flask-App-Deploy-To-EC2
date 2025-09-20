# Docker Gunicorn will import this module and look for a variable named 'app'.
from app.app import create_app
app = create_app()
