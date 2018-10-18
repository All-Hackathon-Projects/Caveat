exports.predict = (crimes, lat, long, callback) =>
{
	
const jsonfile = require('jsonfile')
			const file = './api/ml/crimes.json'
			jsonfile.writeFileSync(file, crimes)

	const exec = require('child_process').exec

			python_process = exec('python ./api/ml/ml.py ./api/ml/crimes.json ' +  lat + ' ' + long)
			python_process.stdout.on('data', (stdout) =>
			{
				console.log(stdout)
				array = eval(stdout)
				callback(array)
			})
			python_process.stderr.on('data', (err) =>
			{
				console.log(err)
			})

}