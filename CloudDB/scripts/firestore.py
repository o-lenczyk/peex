from google.cloud import firestore

# The `project` parameter is optional and represents which project the client
# will act on behalf of. If not supplied, the client falls back to the default
# project inferred from the environment.
db = firestore.Client(project="gcp101713-michalpiasecki")

data = {"name": "Los Angeles", "state": "CA", "country": "USA"}

# Add a new doc in collection 'cities' with ID 'LA'
db.collection("cities").document("LA").set(data)

###
doc_ref = db.collection("cities").document("LA")

doc = doc_ref.get()
if doc.exists:
    print(f"Document data: {doc.to_dict()}")
else:
    print("No such document!")