/**
 * Crime Controller
 * Defines and implements private (not exposed to client) methods
 * that are called by the user-facing GET requests for crimes.
 */

const mongoose = require('mongoose')
const CrimeDB = mongoose.model('Crime')


/**
 * Return all crimes in the database.
 */
exports.get_all_crimes = (req, res) =>
{
	CrimeDB.find({}, (error, crime) =>
	{
		if(error) res.send(error)
		res.json(crime)
	})
}