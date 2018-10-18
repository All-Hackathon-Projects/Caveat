/**
 * Crime Routes
 * Routes user-facing requests to methods in the controller for crimes
 */

module.exports = (app) =>
{
	const controller = require('../controllers/crimeController.js')

	app.route('/allcrimes')
		.get(controller.get_all_crimes)
	
}