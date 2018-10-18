/**
 * Marker Routes
 * Routes user-facing requests to methods in the controller for Markers
 */

module.exports = (app) =>
{
	const controller = require('../controllers/markerController.js')

	app.route('/markers')
		.get(controller.get_ios_markers)

	app.route('/severity')
		.get(controller.get_ios_severity)

	app.route('/predict')
		.get(controller.get_prediction)

	app.route('/sevpred')
		.get(controller.get_sevpred)
}