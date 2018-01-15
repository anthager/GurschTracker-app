res=$(curl -s -X POST "https://us-central1-gurschtracker.cloudfunctions.net/demoFunc" -d "@data.json" -H "Content-Type: application/json")
echo "$res" 
# curl -d -v "username=antonhagermalm&password=slosenord1&submit=Login" --dump-header headers https://twitter.com/login
#curl -L -b headers https://twitter.com