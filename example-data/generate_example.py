#!/usr/bin/env python3
# Generates a FILENAME, named after today (i.e. "2021-01-05.json" with the
# prettified JSON output of the remote store data.
import requests
import json
from datetime import datetime

URL = 'https://www.vinbudin.is/addons/origo/module/ajaxwebservices/search.asmx/GetAllShops'
FILENAME = '%s.json' % datetime.now().strftime('%Y-%m-%d')

print('Fetching data...', end='', flush=True)
response = requests.get(URL, headers={'Content-Type': 'application/json; charset=utf-8'})
print(' done')

print('Decoding JSON...', end='', flush=True)
stores = json.loads(json.loads(response.text)['d'])
pretty_json = json.dumps(stores, indent=2, ensure_ascii=False).encode('utf8').decode()
print(' done')

print('Writing file %s...' % FILENAME, end='', flush=True)
with open(FILENAME, 'w') as f:
    f.write(pretty_json)
print(' done')
