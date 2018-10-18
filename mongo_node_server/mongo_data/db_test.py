from pymongo import MongoClient
client = MongoClient("localhost", 3000)

db = client['caveat-staging']

crime_collection = db['crimes']

cc = crime_collection

crimes = cc.find()

types = []

for c in crimes:
	if c['genericType'] not in types: types.append(c['genericType'])

print(types)


