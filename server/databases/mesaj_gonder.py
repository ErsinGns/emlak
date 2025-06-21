import requests
import json
from google.oauth2 import service_account
from google.auth.transport.requests import Request
from bilgi_model import Users


service_account_file = ".json"

fcm_url = ''

project_id = ''

credentials = service_account.Credentials.from_service_account_file(
    service_account_file,
    scopes=[""]
)

credentials.refresh(Request())

def send_fcm_message(token, title, body):
    access_token = credentials.token

    message = {
        "message": {
            "token": token,  
            "notification": {
                "title": title,  
                "body": body    
            }
        }
    }

    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json; UTF-8',
    }

    response = requests.post(fcm_url, headers=headers, data=json.dumps(message))

    if response.status_code == 200:
        print('Bildirim başarıyla gönderildi.')
    else:
        print('Bir hata oluştu:', response.text)

users = Users.get_all_user()
print(users)

device_token = "b"
send_fcm_message(device_token, "merhaba dunya")
