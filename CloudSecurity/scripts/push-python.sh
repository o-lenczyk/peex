pip install twine
gcloud config set artifacts/repository python-repository 
gcloud config set artifacts/location us-central1
python3 -m twine upload --repository-url us-central1-docker.pkg.dev/gcp101713-michalpiasecki/python-repository/ dist/*
