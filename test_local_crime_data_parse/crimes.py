#<3 Ivan
import json
#Load up the JSON file containing the crime data
dataFile = open('crimes.json')
#Load the data from the JSON format
jsonData = json.load(dataFile)
#The crime array is called 'crimes'
crimes = jsonData['crimes']


for crime in crimes:
	#Do whatever
	
	print(crime)


