const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendChatNotification = functions.firestore
    .document("conversations/{convId}/messages/{msgId}")
    .onCreate(async (snap, context) => {
        const data = snap.data();

        const sender = data.sender;
        const parts = context.params.convId.split("_");

        const userId = parts[2];
        const ownerId = parts[3];

        const receiverCollection = sender === "owner" ? "users" : "owners";
        const receiverId = sender === "owner" ? userId : ownerId;

        const receiverDoc = await admin.firestore()
            .collection(receiverCollection)
            .doc(receiverId)
            .get();

        const token = receiverDoc.data()?.fcmToken;
        if (!token) return;

        await admin.messaging().send({
            token: token,
            notification: {
                title: "New message",
                body: data.text,
            },
        });
    });
