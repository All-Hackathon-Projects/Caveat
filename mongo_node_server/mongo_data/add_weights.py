from pymongo import MongoClient
client = MongoClient("localhost", 3000)

db = client.ccmdb

crime_collection = db.crime_collection

cc = crime_collection

crimes = cc.find()


def c_type(types, test):
	for t in types:
		if t in test: return True
	return False

for c in crimes:

	ptype = c['primaryType'].upper()
	weight = None
	#print(ptype)

	if  c_type(["HOMICIDE", "MURDER"], ptype):
		ptype = "Homicide"
		weight = 10

	elif c_type(["BATTERY", "ABUSE", "SEXUAL", "RAPE"], ptype):
		ptype = "Violence"
		weight = 9

	elif c_type(["HUMAN TRAFFICKING", "KIDNAP"], ptype):
		ptype = "Human Trafficking"
		weight = 8

	elif c_type(["CONCEALED CARRY", "WEAPON", "FIREARM"], ptype):
		ptype = "Unlawful Firearm"
		weight = 7
	elif c_type(["DRUG", "LIQOUR", "NARCOTIC", "MARIJUANA", "ALCOHOL"], ptype):
		ptype = "Drug or Alcohol Offense"
		weight = 5
	elif c_type(["ARSON", "BURGLARY", "CRIMINAL DAMAGE", "TRESPASS", "VANDALISM", "DRIVING"], ptype):
		ptype = "Property Offense"
		weight = 4
	elif c_type(["ASSAULT", "INTIMIDATION", "OFFENSE", "STALK"], ptype):
		ptype = "Personal Affront"
		weight = 3
	elif c_type(["DECEPTIVE PRACTICE", "THEFT", "ROBBERY", "LARCENY"], ptype):
		ptype = "Theft"
		weight = 2
	elif c_type(["GAMBLING", "PUBLIC", "NON-CRIMINAL", "OBSCENITY", "OTHER", "PROSTITUTION", "INDECENCY", "VIOLATION", "NATURAL"], ptype):
		ptype = "Other"
		weight = 1

	if weight is None: print("rekt")

	c['weight'] = weight
	c['genericType'] = ptype

	cc.save(c)
