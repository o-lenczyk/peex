apt download apt-dpkg-ref
gcloud config set artifacts/repository debian-buster 
gcloud artifacts apt upload debian-buster --source=apt-dpkg-ref_5.3.1+nmu2_all.deb 