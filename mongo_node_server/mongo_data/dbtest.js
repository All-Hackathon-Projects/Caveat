//Get the MongoDB interface
const mongoose = require('mongoose')
const bodyParser = require('body-parser')
mongoose.Promise = global.Promise
//Connect to the ccmdb database
mongoose.connect('mongodb://10.1.107.50:3000/caveat-staging')

const Schema = mongoose.Schema

const CrimeSchema = new Schema
(
	{
		date: { type: String },
		time: { type: String },
		address: { type: String },
		primaryType: { type: String },
		secondaryType: { type: String },
		genericType: { type: String },
		locationType: { type: String },
		lat: { type: Number },
		long: { type: Number },
		weight: { type: Number }
	},
	{
		collection: 'crimes'
	}
)

mongoose.model('Crime', CrimeSchema)

const CrimeDB = mongoose.model('Crime')


CrimeDB.find({}, (error, crimes) =>
	{
		//Do whatever with crimes here
		console.log(crimes)
	})