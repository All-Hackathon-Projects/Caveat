
import sys
import json
from pymongo import MongoClient
from sklearn import tree

inputArray = []
outputArray = []
reverseTable = { "-1" : "Invalid Inputs" }

def getValueOfStr (text):
    total = 0
    for char in text:
        total += ord(char)
    return total

with open(sys.argv[1], "r") as data_file:
    data = json.load(data_file)
    for crime in data:
        inputArray.append([float(crime['lat']), float(crime['long'])])
        valueOfString = getValueOfStr(crime['genericType'])
        outputArray.append([valueOfString, crime['clockStamp']])
        if(str(valueOfString) not in reverseTable):
            reverseTable[str(valueOfString)] = crime['genericType']
            

clf = tree.DecisionTreeClassifier()
clf = clf.fit(inputArray, outputArray)

try:
    resultArr = clf.predict([[float(sys.argv[2]), float(sys.argv[3])]])[0]
except Exception:
    resultArr = [-1]

output = [reverseTable[str(int(resultArr[0]))], resultArr[1]]


print(output, end='')