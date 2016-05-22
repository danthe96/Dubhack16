from firebase import Firebase
import requests
import os
import hashlib
import base64
import math

firebase = Firebase('https://project-***REMOVED***.firebaseio.com/')
fb_contests = Firebase('https://project-***REMOVED***.firebaseio.com/dubwars/contests')
fb_votes = Firebase('https://project-***REMOVED***.firebaseio.com/dubwars/votes')

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
    return get_dubs['results']

def get_contests():
    contests = fb_contests.get()
    #print contests
    return contests

def get_votes():
    votes = fb_votes.get()
    #print votes
    return votes

def get_contest(snip, winner, loser):
    dubs = Firebase('https://project-***REMOVED***.firebaseio.com/dubwars/contests/{0}/dubs/'.format(snip)).get()
    return dubs[winner], dubs[loser]



def process_votes():
    print('=== Processing votes ===')
    contests = get_contests()
    votes = get_votes()

    if not votes:
        print('=== No votes to process ===')
        return

    for key, vote in votes.iteritems():
        #print vote
        snip = vote['snipID']
        winner, loser = get_contest(snip, vote['winner'], vote['loser'])
        winner_elo = winner['elo']
        loser_elo = loser['elo']
        winner_count = winner['count']
        loser_count = loser['count']
        eloW, eloL = newElo(winner_elo, winner_count, loser_elo, loser_count, 0)
        update_elo(snip, vote['winner'], eloW, winner_count+1)
        update_elo(snip, vote['loser'], eloL, loser_count+1)
        delete_vote(key)

    print('=== Finished processing votes ===')

def update_elo(snip, creator, elo, count):
    print('=== Update Elo ===')
    update = {'elo': elo, 'count': count}
    result = Firebase('https://project-***REMOVED***.firebaseio.com/dubwars/contests/{0}/dubs/{1}'.format(snip, creator)).update(update)

def delete_vote(key):
    print('=== Remove vote ===')
    result = Firebase('https://project-***REMOVED***.firebaseio.com/dubwars/votes/{0}'.format(key)).delete()

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

def add_dub(video):
    print('=== Add dub ===')
    creator = video['creator']
    snip = video['snip']

    entry = {
         'elo': 1000,
         'count': 0,
         'video': video
     }
    result = Firebase('https://project-***REMOVED***.firebaseio.com/dubwars/contests/{0}/dubs/{1}'.format(snip,creator)).set(entry)
    print result

def import_all_dubs():
    print('=== Importing all dubs ===')
    dubs = get_dubs()
    contests = get_contests()

    for dub in dubs:
       video = dub['video']

       if not video['snip'] in contests:
           print('No contest with this snip yet. Adding...')
           creator = video['creator']
           snip = video['snip']
           contest = {snip: {'snipId': snip,'dubs': {}}}
           result = Firebase('https://project-***REMOVED***.firebaseio.com/dubwars/contests/').update(contest)
           print result

       add_dub(video)
    print('=== Finished importing all dubs ===')

import_all_dubs()
process_votes()
