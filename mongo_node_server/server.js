/**
 * Server.js
 * Starts the node (web) server with the appropiate controllers, models, and routes.
 */

//Get server-wide settings
const settings = require('./settings.js')

//Get instance of express server
const express = require('express')
const app = express()

//Server port
const port = settings.NODE_SERVER_PORT

//Get the MongoDB interface
const mongoose = require('mongoose')
const bodyParser = require('body-parser')
mongoose.Promise = global.Promise

//Connect to the caveat database
mongoose.connect(settings.MONGO_DB_URL)

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

//Initialize the crime model
const crimeModel = require('./api/models/crimeModel.js')

//Get the application routes and tie them to the server
const markerRoutes = require('./api/routes/markerRoutes.js')
markerRoutes(app)
const crimeRoutes = require('./api/routes/crimeRoutes.js')
crimeRoutes(app)


//Start the server on the appropiate port.
app.listen(port, () => 
{
	console.log('Started node server on port ' + port)
})
