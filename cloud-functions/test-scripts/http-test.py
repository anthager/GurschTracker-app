import requests
import json

f = open('data.json')
stri = f.read()
f.close()

js = json.loads(stri)

r = requests.post('https://us-central1-gurschtracker.cloudfunctions.net/gamePlayed', data=js)
print(r.status_code)