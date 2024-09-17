import requests

#URLS:
FRONTEND_URL = "http://localhost:8080"
BACKEND_URL = "http://localhost:3000/greet"
EXPECTED_MESSAGE = "Hello from the Backend!"

def test_backend():
    try:

        response = requests.get(BACKEND_URL)
        response.raise_for_status()  # Raise an HTTPError for bad responses


        if response.json().get('message') == EXPECTED_MESSAGE:
            print("Backend Test Passed: The backend message is correct.")
            backend_test_passed = True
        else:
            print("Backend Test Failed: The message from the backend is incorrect.")
            backend_test_passed = False

    except requests.RequestException as e:
        print(f"Backend Test Failed: An error occurred - {e}")
        backend_test_passed = False

    return backend_test_passed

def test_frontend():
    try:

        response = requests.get(FRONTEND_URL)


        if EXPECTED_MESSAGE in response.text:
            print("Frontend Test Passed: The frontend displays the correct message from the backend.")
            return True
        else:
            print("Frontend Test Failed: The message from the backend is not displayed correctly.")
            return False

    except requests.RequestException as e:
        print(f"Frontend Test Failed: An error occurred - {e}")
        return False

if __name__ == "__main__":
    backend_test_passed = test_backend()
    frontend_test_passed = test_frontend()

    if backend_test_passed and frontend_test_passed:
        print("All Tests Passed")
    else:
        print("Some Tests Failed")
