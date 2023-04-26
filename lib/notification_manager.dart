import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rxdart/rxdart.dart'; // for on click

import 'dart:typed_data';


import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;


class NotificationManager{

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>(); // for click

  Future<void> initNotification() async{                                                                    // "flutter_logo"
    // AndroidInitializationSettings initializationAndroid = const AndroidInitializationSettings("@mipmap/ic_launcher");
    AndroidInitializationSettings initializationAndroid = const AndroidInitializationSettings("@mipmap/apple");
    DarwinInitializationSettings initializationIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,

      onDidReceiveLocalNotification: (id,title ,body ,payload){
        var a = 5;
      }
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android:initializationAndroid , iOS: initializationIos
    );

    await notificationsPlugin.initialize(
        initializationSettings,
       onDidReceiveNotificationResponse: (detail) async{
         var a = 5;
         var title = detail.payload;
         onNotifications.add(title); // for click
       }
    );



    // for delay by timezone
    // if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    // }

  }


  // simple notification
  Future<void> simpleNotification() async{
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
        "channel_id",
        "channel_title" ,
      priority: Priority.high,
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher")
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails()
    );

    await notificationsPlugin.show(0, "Simple Notification", "new user sent message", notificationDetails ,payload: "simple notif");
  }


  // big picture notification
  Future<void> bigPictureNotification(String image) async{
    final  ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(await _getByteArrayFromUrl(image));
    final  ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(await _getByteArrayFromUrl(image));

    BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
       bigPicture,
      // DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
      contentTitle: "content title",
      // largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
      summaryText: "this is a summary text ",
      largeIcon: largeIcon,
      hideExpandedLargeIcon: false,
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        "big_picture_channel_id",
        "big_picture_channel_title" ,
        priority: Priority.high,
        importance: Importance.max,
        styleInformation: bigPictureStyleInformation,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails(),

    );

    await notificationsPlugin.show(1, "big picture Notification", "new big picture message", notificationDetails ,payload: "big picture notif");
  }


  Future<void> repeatNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.periodicallyShow(
      // id++,
        0,
        'repeating title',
        'repeating body',
        RepeatInterval.everyMinute,
        notificationDetails,
        payload: "repeat notif"
      // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }



  Future<void> delay10secNotification() async {

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        "channel_id",
        "channel_title" ,
        priority: Priority.high,
        importance: Importance.max,
        icon: "@mipmap/ic_launcher",
        channelShowBadge: true,
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher")
    );
    NotificationDetails notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );


    await notificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        // tz.TZDateTime.from(scheduledDate, tz.local),
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 20)),
        notificationDetails,
        androidAllowWhileIdle: false,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,

        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        payload: "Scheduled",);
  }


  /*****************************daily***********************************/
  Future<void> dailyNotification() async {

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        "channel_id",
        "channel_title" ,
        priority: Priority.high,
        importance: Importance.max,
        icon: "@mipmap/ic_launcher",
        channelShowBadge: true,
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher")
    );
    NotificationDetails notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );


    await notificationsPlugin.zonedSchedule(
      0,
      'daily title',
      'daily body',
      // _scheduleDaily(Time(12, 05, 00)), //8:30:45  AM
      _daily_weekly_schedule(Time(10, 30, 45)),
      notificationDetails,
      androidAllowWhileIdle: false,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,

      matchDateTimeComponents: DateTimeComponents.time,
      payload: "Daily",);
  }







  /*****************************weekly***********************************/
  Future<void> weeklyNotification() async {

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        "channel_id",
        "channel_title" ,
        priority: Priority.high,
        importance: Importance.max,
        icon: "@mipmap/ic_launcher",
        channelShowBadge: true,
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher")
    );
    NotificationDetails notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );


    await notificationsPlugin.zonedSchedule(
      0,
      'scheduled weekly title',
      'scheduled weekly body',
      // _scheduleWeekly(Time(8, 30, 45),
      //     days: [DateTime.monday, DateTime.tuesday]),

      _daily_weekly_schedule(Time(12, 33, 00)),

      //8:30:45  AM
      notificationDetails,
      androidAllowWhileIdle: false,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,

      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,  //weekly
      payload: "Weekly",);
  }


  // static tz.TZDateTime _scheduleWeekly(Time time, {List<int>? days}) {
  //   tz.TZDateTime scheduleDate = _scheduleDaily(time);
  //
  //   while (!days!.contains(scheduleDate.weekday)) {
  //     scheduleDate = scheduleDate.add(Duration(days: 1));
  //   }
  //   return scheduleDate;
  // }



  tz.TZDateTime _daily_weekly_schedule(Time time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour ,time.minute ,time.second);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }





  // speriodically notification
  Future<void> periodicallyEveryMinuteNotification() async{
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
        "channel_id",
        "channel_title" ,
        priority: Priority.high,
        importance: Importance.max,
        icon: "@mipmap/ic_launcher",
        channelShowBadge: true,
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher")
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails()
    );


    await notificationsPlugin.periodicallyShow(
        0,
        'periodically title',
        'periodically body',
        RepeatInterval.everyMinute,
        payload: "periodically",
        androidAllowWhileIdle: false,
        notificationDetails);

  }










  static Future<Uint8List> _getByteArrayFromUrl(String? url) async {
    final http.Response response = await http.get(Uri.parse(url!));
    return response.bodyBytes;
  }



  Future<void> cancelAllNotif() async {
    await notificationsPlugin.cancelAll();
  }

}