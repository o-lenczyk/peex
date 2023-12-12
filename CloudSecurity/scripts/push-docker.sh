gcloud auth configure-docker us-central1-docker.pkg.dev
docker tag my-docker-imaege us-central1-docker.pkg.dev/gcp101713-michalpiasecki/docker-repository/my-docker-image:1  
docker push us-central1-docker.pkg.dev/gcp101713-michalpiasecki/docker-repository/my-docker-image:1   