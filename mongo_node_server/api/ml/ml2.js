/**
 * ML.js
 * Uses machine learning algorithms to predict crimes.
 */

//Match each crime to its weight, since the features have to be numbers.
const typeWeightMap =
{
	1: 'Other', //1
	2: 'Theft', //2
	3: 'Personal Affront', //3
	4: 'Property Related Offenses', //4
	5: 'Substance Related Offenses', //5
	7: 'Weapons Violations', //7
	8: 'Human Trafficking', //8
	9: 'Violence', //9
	10: 'Homicide' //10
}

const round = Math.round

const smr = require('smr')
const model = new smr.Regression({numX: 3, numY: 1})

//Train 
exports.train = (crimes) =>
{

	const t1 = new Date().getTime()

	for(let crime of crimes)
		model.push
		({
			x: [crime.lat, crime.long, crime.clockStamp],
			y: [crime.weight]
		})

	model.calculateCoefficients()

	console.log('ML model trained in ' + (new Date().getTime() - t1) + ' ms')
}

exports.predict = (lat, long, clockStamp, callback) =>
{
	const prediction = model.hypothesize
	({
		x: [lat, long, clockStamp]
	})

	let rawWeight = prediction[0]
	let weight = round(rawWeight) //First element is the weight

	//Correct for a weight of 6
	if(weight == 6)
	{
		if(rawWeight < 6) weight = 5
		else 		      weight = 7
	}

	const genericType = typeWeightMap[weight] //Get the type of the crime

	//const time = round(prediction[1]) //Get the predicted time, in seconds from midnight

	const crime = {genericType: genericType} //clockStamp: time}
	
	callback(crime)

}