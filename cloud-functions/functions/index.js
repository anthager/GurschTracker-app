const functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase)

const ref = admin.database().ref().child('usersdev')

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.addToDatabase = functions.auth.user().onCreate(event => {
	const uid = event.data.uid
	const email = event.data.email

	return ref.child(uid).set({
		email: email,
		uid: uid
	})
})

exports.demoFunc = functions.https.onRequest((req, res) => {
	const winner = req.body.winner
	const loser = req.body.loser
	const amount = Number(req.body.amount)

	console.log('winner = ' + winner)
	console.log('loser = ' + loser)
	console.log('amouunt = ' + amount)

	res.send('success!')
})

exports.addSession = functions.https.onRequest((req, res) => {
	const winner = req.body.winner
	const loser = req.body.loser
	const amount = Number(req.body.amount)
	updateUserAmount(winner, loser, amount)
	updateUserAmount(loser, winner, -amount)

	res.send(true)
})

function updateUserAmount(user, opponent, amount) {
	const uRef = ref.child(user)
	const oRef = uRef.child('opponents').child(opponent)

	uRef.child('amount').once('value').then(snap => {
		var newAmount = amount
		//is run if snap is defined
		if (snap.val()){
			newAmount = parseInt(snap.val()) + amount
		}
		oRef.set({
			uid: opponent,
			amount: newAmount
		})
	})

	oRef.child('amount').once('value').then(snap => {
		var newAmount = amount
		//is run if snap is defined
		if (snap.val()){
			newAmount = parseInt(snap.val()) + amount
		}

		oRef.set({
			uid: opponent,
			amount: newAmount
		})
	})

	uRef.child('sessions').child('asdfsjkhkljsdkldsfkl1').set({
		opponent: opponent,
		amount: amount
	})
}

exports.newUser = functions.https.onRequest((req, res) => {
const uid = req.body.uid
const email = req.body.email
const amount = parseInt(req.body.amount)

	ref.child(uid).set({
		uid: uid,
		email: email,
		amount: amount
	}).then(value => {
		console.log('user with uid: ' + uid + 'was added to the database')
		res.send(true)
	 })
})