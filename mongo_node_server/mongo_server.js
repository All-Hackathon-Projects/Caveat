/**
 * Mongodb.js
 * Starts a local mongodb server with the crime data.
 */

const dbpath = 'db'
const port = 3000

//Spawn the process and attach listeners
console.log('Starting mongod in ' + dbpath +
			' on port ' + port)

const spawn = require('child_process').spawn
mongod_process = spawn('mongod', ['-port', port
								, '-dbpath', dbpath
								])

//Make the mongod write its output to the shell

mongod_process.stdout.on('data', (data) =>
{
	console.log(data.toString())
})
mongod_process.stderr.on('data', (data) =>
{
	console.log(data.toString())
})

