import pytest
from app.app import create_app

@pytest.fixture
def client():
    # Create a test client from our factory app (no server needed).
    app = create_app()
    app.config.update(TESTING=True)
    with app.test_client() as client:
        yield client

def test_health(client):
    # Basic smoke test for the /health endpoint.
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.get_json()["status"] == "ok"

def test_index(client):
    # Ensure the root endpoint returns the expected payload.
    resp = client.get("/")
    assert resp.status_code == 200
    assert "message" in resp.get_json()
