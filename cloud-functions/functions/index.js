const functions = require('firebase-functions');
const admin = require('firebase-admin')
const uuidV1 = require('uuid/v1');

admin.initializeApp(functions.config().firebase)

const privData = admin.database().ref().child('private-data')
const pubData = admin.database().ref().child('public-data')

exports.addToDatabase = functions.auth.user().onCreate(event => {
	const uid = event.data.uid
	const email = event.data.email

	privData.child(uid).set({
	})
	pubData.child(uid).set({
		email: email
	})
})

exports.demoFunc = functions.https.onRequest((req, res) => {
	const winner = req.body.winner
	const loser = req.body.loser
	const amount = Number(req.body.amount)
	var json = JSON.stringify({winner: winner,
						looser: loser,
						amount: amount})
	
	console.log('req = ' + JSON.stringify(req.body))
	console.log('res = ' + json)
	res.json(json)
	//res.send('Success!')
})

function updateAmounts(p1, p2, amount){
	const ref = privData.child(p1 + '/opponents/' + p2 +' /amount').once('value').then(snap => {
		var newAmount = amount
		// console.log('newAmount = ' + newAmount)
		//is run if snap is defined
		if (snap.val()){
			// console.log('snap.val = ' + snap.val() )
			newAmount = parseInt(snap.val()) + amount
		}
	})
	p1Ref.update({
		amount: newAmount
	})

}

exports.gamePlayed = functions.https.onRequest((req, res) => {
	const sender = req.body.sender
	const opponent = req.body.opponent
	const amount = Number(req.body.amount)
	console.log("sender = " + sender)
	console.log("opponent = " + opponent)
	console.log("amount = " + amount)

	updateUserAmount(sender, opponent, amount)
	updateUserAmount(opponent, sender, -amount)

	res.statusCode = 200
	res.send('Success!')
})

function updateUserAmount(p1, p2, amount) {
	const p1Ref = privData.child(p1)
	const p2Ref = p1Ref.child('opponents').child(p2)

	p1Ref.child('amount').once('value').then(snap => {
		// console.log('amount = ' + amount)
		var newAmount = amount
		// console.log('newAmount = ' + newAmount)
		//is run if snap is defined
		if (snap.val()){
			// console.log('snap.val = ' + snap.val() )
			newAmount = parseInt(snap.val()) + amount
			// console.log('newAmount = ' + newAmount)
		}

		p1Ref.update({
			amount: newAmount
		})

		// console.log('snap.val = ' + snap.val() )
		pubData.child(p2).child('email').once('value').then(snap => {
			console.log('email = ' + snap.val())
			p2Ref.update({ 
				email: snap.val(),
				uid: p2,
				amount: newAmount
			})
		})
		
	})

	p1Ref.child('sessions').child(uuidV1()).set({
		opponent: p2,
		amount: amount
	})
}
