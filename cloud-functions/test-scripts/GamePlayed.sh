#curl -v -X POST https://us-central1-gurschtracker.cloudfunctions.net/gamePlayed -d "@data.json" --header "Content-Type:application/json"
curl -d -v "username=antonhagermalm&password=slosenord1&submit=Login" --dump-header headers https://twitter.com/login
#curl -L -b headers https://twitter.com