#Parsing Part

class Crime:

	def __init__(self, date, time, address, primaryType, secondaryType, locationType, lat, long):
		self.date = date
		self.time = time
		self.address = address
		self.primaryType = primaryType
		self.secondaryType = secondaryType
		self.locationType = locationType
		self.lat = lat
		self.long = long

dataFile = open('Crimes2017.csv', 'r')


crimes = []
data = dataFile.readlines()

print(data[100])

for i in range(len(data)):
	crimeData = data[i].split(',')
	datetime = crimeData[2]

	datetime = datetime.split(' ')
	date = datetime[0]
	time = datetime[1] + ' ' + datetime[2]
	
	address = crimeData[3]
	primaryType = crimeData[5]
	secondaryType = crimeData[6]
	locationType = crimeData[7]

	lat = crimeData[19]
	long = crimeData[20]

	c = Crime(date, time, address, primaryType, secondaryType, locationType, lat, long)
	crimes.append(c)

	#print("{}, {}, {}, {}, {}, {}, {}, {}".format(date, time, address, primaryType, secondaryType, locationType, lat, long))

#crimes[]

from pymongo import MongoClient
client = MongoClient("localhost", 3000)


DB_NAME = 'ayylmao'

db = client[DB_NAME]

crime_collection = db.crime_collection

for crime in crimes:
	crime_doc = {
		'date': crime.date,
		'time': crime.time,
		'address': crime.address,
		'primaryType': crime.primaryType,
		'secondaryType': crime.secondaryType,
		'locationType': crime.locationType,
		'lat': crime.lat,
		'long': crime.long
	}
	#print(crime_doc)
	crime_collection.insert_one(crime_doc)
	