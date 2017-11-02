const functions = require('firebase-functions');
const admin = require('firebase-admin')
const uuidV1 = require('uuid/v1');

admin.initializeApp(functions.config().firebase)

const udataRef = admin.database().ref().child('usersdev')
const uPbDataRef = admin.database().ref().child('public-user-data-dev')

exports.addToDatabase = functions.auth.user().onCreate(event => {
	const uid = event.data.uid
	const email = event.data.email

	const pr1 = udataRef.child(uid).set({
		uid: uid
	})
	const pr2 = uPbDataRef.child(uid).set({
		email: email,
		uid: uid
	})


})

exports.demoFunc = functions.https.onRequest((req, res) => {
	const winner = req.body.winner
	const loser = req.body.loser
	const amount = Number(req.body.amount)

	res.send('success!')
})

exports.addSession = functions.https.onRequest((req, res) => {
	const user = req.body.user
	const opponent = req.body.opponent
	const amount = Number(req.body.amount)

	console.log("user = " + user)
	console.log("opponent = " + opponent)
	console.log("amount = " + amount)
	updateUserAmount(user, opponent, amount)
	updateUserAmount(opponent, user, -amount)

	res.send(true)
})

function updateUserAmount(p1, p2, amount) {
	const p1Ref = udataRef.child(p1)
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
		p2Ref.update({
			uid: p2,
			amount: newAmount
		})
	})

	p1Ref.child('sessions').child(uuidV1()).set({
		opponent: p2,
		amount: amount
	})
}

exports.newUser = functions.https.onRequest((req, res) => {
const uid = req.body.uid
const email = req.body.email
const amount = parseInt(req.body.amount)

	udataRef.child(uid).set({
		uid: uid,
		email: email,
		amount: amount
	}).then(value => {
		console.log('user with uid: ' + uid + 'was added to the database')
		res.send(true)
	 })
})