import functions_framework
import requests
from requests.auth import HTTPBasicAuth
from google.cloud import secretmanager

@functions_framework.http
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """

    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/1082841050410/secrets/password/versions/1"

    # Access the secret version.
    response = client.access_secret_version(request={"name": name})

    password = response.payload.data.decode("UTF-8")

    request_json = request.get_json(silent=True)
    request_args = request.args

    r = requests.get('http://10.128.0.8',auth=HTTPBasicAuth('sammy', password)) 
    return str(r.content)