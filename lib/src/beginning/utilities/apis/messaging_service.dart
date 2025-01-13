import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'app_config.dart';

class MessagingService {
  MessagingService._();

  static const String SERVER_KEY = "8e840cfcd37d52d955d322073836d981d94a18c5";
  static final MessagingService instance = MessagingService._();

  void setupFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request for notification permissions (for iOS)
    messaging.requestPermission();

    // Get the device FCM token
    messaging.getToken().then((token) {
      //print('Device token: $token');
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    setupForegroundMessageHandler();
  }

  Future<AuthClient> obtainAuthenticatedClient() async {
    var config = AppConfig.instance.config;
    var accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": config['private_key_id'],
      "private_key": config["private_key"],
      "client_email": config["client_email"],
      "client_id": config["client_id"],
      "type": "service_account"
    });
    var scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);

    return client; // Remember to close the client when you are finished with it.
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  void setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground: ');
      Fluttertoast.showToast(
          msg: "${message.notification?.title}: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Subscribe to a topic
    await messaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  Future<void> sendNotificationToDevices({
    required List<String> deviceTokens,
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    final client = await obtainAuthenticatedClient();
    var accessToken = client.credentials.accessToken.data;
    client.close();
    for (String token in deviceTokens) {
      sendNotificationToDevice(
          token: token, title: title, body: body, serverKey: accessToken);
    }
  }

  Future<void> sendNotificationToDevice({
    required String token,
    required String title,
    required String body,
    required String serverKey,
    String? imageUrl,
  }) async {
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/grouphrm-c1236/messages:send';

    final Map<String, dynamic> notificationData = {
      "message": {
        "notification": {
          "body": body,
          "title": title,
          "image": imageUrl ??
              "https://tamducgroup.com/wp-content/uploads/2022/08/BIA-SO-MI-VIET-ANH.png"
        },
        "token": token
      }
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
      // Add the Authorization header with the server key
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: json.encode(notificationData),
    );
    if (kDebugMode) {
      print('Notification sent successfully!');
      if (response.statusCode == 200) {
      } else {
        print('Ducky Failed to send notification: ${response.body}');
      }
    }
  }
}
