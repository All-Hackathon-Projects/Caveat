/**
 * Marker Controller
 * Defines and implements private (not exposed to client) methods
 * that are called by the user-facing GET requests for markers.
 */

const mongoose = require('mongoose')
const CrimeDB = mongoose.model('Crime')

//Get the ML model
const mlModel = require('../ml/ml.js')

//Gets a prediction based on crime data and location
function getPrediction(crimes, lat, long, callback)
{
	mlModel.predict(crimes, lat, long, (predictedCrime) =>
	{
		//ML returns type and clock stamp
		genericType = predictedCrime[0]
		clockStamp = predictedCrime[1]

		//Get human readable time
		let hours = Math.floor( (clockStamp / 60) / 60 )
		let minutes = Math.floor( clockStamp / 60) - hours*60
		let seconds = clockStamp - hours*60*60 - minutes*60
		if(seconds < 10) seconds = '0' + seconds
		let ampm = 'AM'
		if(minutes < 10) minutes = '0' + minutes
		if(hours > 12)
		{
			hours -= 12
			ampm = 'PM'
		}
		if(hours < 10) hours = '0' + hours
		const time = hours + ':' + minutes + ':' + seconds + ' ' + ampm

		//Return the predicted crime in JSON format
		let pCrime = 
		{
			genericType: genericType,
			clockStamp: clockStamp,
			time: time
		}
		callback(pCrime)
	})
}

//Finds crimes in the area based on location
function getAreaCrimes(lat, long, callback)
{
	const coordThreshold = 0.035 //Look within lat/longs +- 0.035

	//Find crimes whose lat/long fall within the defined threshold
	CrimeDB.find
	(
		{
			'lat': 
			{
				$gt: lat - coordThreshold,
				$lt: lat + coordThreshold
			},
			'long':
			{
				$gt: long - coordThreshold,
				$lt: long + coordThreshold
			}
		},
		//Return the crime set
		(error, crimes) =>
		{
			callback(crimes)
		})
}

//Gets the severity of a crime region based on crime data
function getSeverity(crimes, callback)
{
	let severity = 0.0
	for(let crime of crimes)
		severity += crime.weight

	severity /= crimes.length

	callback(severity)
}


exports.get_ios_markers = (req, res) =>
{
	const lat = parseFloat(req.query.lat)
	const long = parseFloat(req.query.long)

	//Setup a basic data structure to return
	data =
	{
		severity: null,
		predictedCrime: null,
		crimesInArea: null,
	}

	getAreaCrimes(lat, long, (crimes) =>
	{
		data.crimesInArea = crimes
		
		getSeverity(crimes, (severity) =>
		{
			data.severity = severity

			getPrediction(crimes, lat, long, (prediction) =>
			{
				data.predictedCrime = prediction

				res.json(data)
			})

		})

	})
}

//Get predicted crime
exports.get_prediction = (req, res) =>
{
	const lat = parseFloat(req.query.lat)
	const long = parseFloat(req.query.long)
	
	getAreaCrimes(lat, long, (crimes) =>
	{
		getPrediction(crimes, lat, long, (prediction) => 
		{
			res.json(prediction)
		})
	})

}

//Get iOS client severity only
exports.get_ios_severity = (req, res) =>
{
	const lat = parseFloat(req.query.lat)
	const long = parseFloat(req.query.long)
	
	getAreaCrimes(lat, long, (crimes) =>
	{
		getSeverity(crimes, (severity) =>
		{
			res.json
			({
				severity: severity
			})
		})
	})
}


exports.get_sevpred = (req, res) =>
{
	const lat = parseFloat(req.query.lat)
	const long = parseFloat(req.query.long)

	getAreaCrimes(lat, long, (crimes) =>
	{
		getSeverity(crimes, (severity) =>
		{
			getPrediction(crimes, lat, long, (predictedCrime) =>
			{
				res.json
				({
					severity: severity,
					predictedCrime: predictedCrime
				})
			})
		})
	})
}