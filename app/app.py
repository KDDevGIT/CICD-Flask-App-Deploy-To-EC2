from flask import Flask, jsonify

def create_app():
    """
    Factory pattern so we can import app in tests without side effects.
    """
    app = Flask(__name__)

    @app.get("/health")
    def health():
        # Simple health endpoint for load balancers and CI tests.
        return jsonify(status="ok"), 200

    @app.get("/")
    def index():
        # Minimal route that proves the app is running.
        return jsonify(message="Hello from Week 20 CI/CD!"), 200

    return app
