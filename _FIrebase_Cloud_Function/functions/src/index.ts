import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const fcm = admin.messaging();
const db = admin.firestore();

export const coffeeRequest = functions.firestore
.document('coffee/{id}')
.onCreate(async snapshot => {

    const values = snapshot.data();

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: `There's a coffee request!`,
      body: `${values.sender} asks that you please make them a ${values.type}! They\'d really appreciated if you could quickly do that.`,
      icon: 'http://http://conielle.co.za/coffee/icon.png',
      sound: 'default'
    }
  };

  console.log('Payload Deployed');
  return fcm.sendToTopic('coffee', payload);
});

export const coffeeComplete = functions.firestore
.document('coffee/{id}')
.onDelete(async snapshot => {


  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: 'Your coffee is made!',
      body: `Sit back and relax! The coffee is coming now! It\'s either standing on the counter, on its way to where you are or your barista has forgotten. If you don't get it soon buzz them.`,
      icon: 'http://http://conielle.co.za/coffee/icon.png',
      sound: 'default'
    }
  };

  console.log('Payload Deployed');
  return fcm.sendToTopic('coffee', payload);
});

    export const sendToDevice = functions.firestore
  .document('hurryup/{id}')
  .onCreate(async snapshot => {

let receiver;
const tokenRef = db.collection('tokens');
const snapshots = await tokenRef.where('barista', '==', true).get();
if (snapshots.empty) {
  console.log('No matching documents.');
}  

snapshots.forEach(doc => {receiver = doc.data();});
const tokens = receiver.token;

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Oh Boy! You\'re In Trouble!',
        body: `It seems you are taking quite some time with these coffee requests, shout for more time or hurry up! `,
        icon: 'http:\\conielle.co.za\coffee\icon.png'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });