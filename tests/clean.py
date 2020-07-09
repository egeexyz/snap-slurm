import requests
import json
import os

if __name__ == "__main__":
  orphans = []
  list_url = 'https://api.vultr.com/v1/server/list'
  headers = {'API-Key': os.environ['VULTR_API_KEY']}

  vultur_servers = requests.get(list_url, headers=headers).text
  server_blob = json.loads(vultur_servers)

  for key, value in server_blob.items():
    if value['tag'] == 'slurmci':
      orphans.append(value)

  for server in orphans:
    destroy_url = 'https://api.vultr.com/v1/server/destroy'
    data = {'SUBID':server["SUBID"]}

    destroy_request = requests.post(destroy_url, headers=headers, data=data)
    print(destroy_request.status_code)
