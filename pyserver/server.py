from firebase import firebase
import requests
import os
import hashlib
import base64
import math

firebase = firebase.FirebaseApplication('https://project-***REMOVED***.firebaseio.com/', None)
result = firebase.get('/dubwars', None)
#print result

URL = 'https://dubhack.dubsmash.com'

CLIENT_ID = '***REMOVED***'
CLIENT_SECRET = '***REMOVED***'
USERNAME = '***REMOVED***'
PASSWORD = '***REMOVED***'



def get_dubs():
    login_data = {
        'username': USERNAME,
        'password': PASSWORD,
        'grant_type': 'password',
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET
    }

    # Login to get access token
    login_response = requests.post('{0}/me/login'.format(URL), json=login_data)
    access_token = login_response.json()['access_token']

    # Creating the Authorization header for following requests
    headers = {
        'Authorization': 'Bearer {0}'.format(access_token),
        'Content-Type': 'application/json'
    }
    group_uuid = '***REMOVED***'
    get_dubs = requests.get('{0}/groups/{1}/dubs'.format(URL, group_uuid), headers=headers).json()
    print get_dubs
    return get_dubs

def newElo(Ra, countA, Rb, countB, result):
    Ea = 1/(1 + math.pow(10, ((Rb-Ra)/400)))
    Eb = 1 - Ea

    if result == 0:
        Sa = 1
        Sb = 0
    elif result == 1:
        Sa = 0
        Sb = 1
    else:
        Sa = 0.5
        Sb = 0.5

    if countA < 30:
        ka = 40
    elif Ra > 2400:
        ka = 10
    else:
        ka = 20

    if countB < 30:
        kb = 40
    elif Rb > 2400:
        kb = 10
    else:
        kb = 20

    newRa = Ra + ka * (Sa - Ea)
    newRb = Rb + kb * (Sb - Eb)

    return int(round(newRa)), int(round(newRb))
