//var express = require('express');
//var Promise = require("bluebird");
var firebase = require('firebase');
//var request = require("request-promise");

URL = 'https://dubhack.dubsmash.com';
FIREBASE_URL = 'https://project-***REMOVED***.firebaseio.com/';

CLIENT_ID = '***REMOVED***';
CLIENT_SECRET = '***REMOVED***';
USERNAME = '***REMOVED***';
PASSWORD = '***REMOVED***';

login_data = {
    'username': USERNAME,
    'password': PASSWORD,
    'grant_type': 'password',
    'client_id': CLIENT_ID,
    'client_secret': CLIENT_SECRET
};

firebase.initializeApp({
    databaseURL: 'https://project-***REMOVED***.firebaseio.com/',
    serviceAccount: 'dubwarsCredentials.json'
});

// Get a database reference to our posts
var db = firebase.database();
var ref = db.ref("dubwars");

function initDB() {
  contest = {
      name: 'Really Cool Name',
      snipId: 'test',
      dubs: {
        test: {
          elo: 1200,
          video: {}
        }
      }
  };

  
  contestsRef = ref.child('contests');
  contestsRef.child('tests').set(contest);
}

// function updateFirebase(login_data) {
//     // get token
//     request({
//         url: URL + '/me/login',
//         method: 'POST',
//         headers: {
//             'Content-Type': 'application/json'
//         },
//         json: login_data
//     }).then(function(body) {
//         token = body.access_token;
//         console.log('Access token: ' + token + '\n');
//
//         // get videos from group
//         return request({
//             url: URL + '/groups/***REMOVED***/dubs',
//             auth: {
//                 'bearer': token
//             },
//             headers: {
//                 'Content-Type': 'application/json'
//             }
//         });
//         // update firebase
//     }).then(function(body) {
//         dubs = JSON.parse(body).results;
//
//         return request({
//             url: FIREBASE_URL + 'dubwars/contests.json',
//             headers: {
//                 'Content-Type': 'application/json'
//             }
//         });
//     }).then(function(db_contests) {
//         db_contests = JSON.parse(db_contests);
//
//         for (var i = 0; i < dubs.length; i++) {
//
//             var video = dubs[i].video;
//             console.log('Adding: ', video);
//
//             if (video.snip in db_contests) {
//                 // contest exists
//                 db_contest = db_contests[video.snip];
//
//                 if (db_contest.dubs[video.creator]) {
//                   // user already uploaded a video
//                     updated_entry = {
//                         elo: db_contest.dubs[video.creator].elo,
//                         video
//                     };
//                     dubs = ref.child('contests/' + video.snip);
//                     dubs.child(video.creator).update(updated_entry);
//                 } else {
//                     entry = {
//                         elo: 1200,
//                         video
//                     };
//                     dubs = ref.child('contests/' + video.snip);
//                     dubs.child(video.creator).set(entry);
//                 }
//             } else {
//                 // add new contest
//                 contest = {
//                     name: 'Really Cool Name',
//                     snipId: video.snip,
//                     dubs: {}
//                 };
//
//                 contest.dubs[video.creator] = {
//                     elo: 1200,
//                     video
//                 };
//                 contestsRef = ref.child('contests');
//                 contestsRef.child(video.snip).update(contest);
//             }
//         }
//     });
// }

//updateFirebase(login_data);
initDB();
