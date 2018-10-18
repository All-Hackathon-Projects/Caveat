/**
 * Crime Model
 * Defines a model for a crime
 */

const mongoose = require('mongoose')
const Schema = mongoose.Schema

const CrimeSchema = new Schema
(
	{
		date: { type: String },
		time: { type: String },
		clockStamp: { type: Number },
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

module.exports = mongoose.model('Crime', CrimeSchema)