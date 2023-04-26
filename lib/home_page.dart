
import 'package:flutter/material.dart';
import 'package:flutter_notifications/notification_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();


    // LocalSimpleNotificationApi.init(initScheduled: true);
    listenNotifications();    // for click notif
  }

  void listenNotifications() {
    NotificationManager.onNotifications.stream.listen(onclickNotification);
  }

  void onclickNotification(String? payload) {
    var a = payload;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ElevatedButton(
              child: Text("Simple Local Notification"), onPressed: () {NotificationManager().simpleNotification();

          }),
         const  SizedBox(
            height: 10,
          ),


          ElevatedButton(
              child: const Text("Big picture Local Notification"), onPressed: () {
            // NotificationManager().bigPictureNotification("https://freepngimg.com/thumb/star/22-star-png-image.png");
            NotificationManager().bigPictureNotification("https://ik.imagekit.io/ikmedia/backlit.jpg");
          }),
          SizedBox(
            height: 10,
          ),


          ElevatedButton(
              child: Text("Repeat every minute"), onPressed: () {
            NotificationManager().repeatNotification();
          }),

          SizedBox(
            height: 10,
          ),


          ElevatedButton(
              child: Text("Scheduled Notif after 5 sec"), onPressed: () {
            NotificationManager().delay10secNotification();
          }),

          SizedBox(
            height: 10,
          ),


          ElevatedButton(
              child: Text("Scheduled Notif Daily"), onPressed: () {
            NotificationManager().dailyNotification();
          }),



          SizedBox(
            height: 10,
          ),

          ElevatedButton(
              child: Text("Scheduled Notif Weekly"), onPressed: () {
              NotificationManager().weeklyNotification();
          }),


          SizedBox(
            height: 10,
          ),

          ElevatedButton(
              child: Text("Periodically every minute"), onPressed: () {
            NotificationManager().periodicallyEveryMinuteNotification();
          }),



          SizedBox(
            height: 10,
          ),

          ElevatedButton(
              child: Text("Cancel all notif"), onPressed: () {
            NotificationManager().cancelAllNotif();
          }),


        ],
      ),
    );
  }
}
