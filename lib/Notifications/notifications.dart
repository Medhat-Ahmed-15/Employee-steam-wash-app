import 'package:awesome_notifications/awesome_notifications.dart';

class Notifications {
  //App is under  Maintenance Notification**************************************************************************
  static Future<void> createAppIsUnderMaintenanceNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(
            100000), //If you want to be able to display multiple instances of a specific notification, then you must provide a unique id.
        channelKey: 'App_Is_Under_Maintenance_Channel',
        title: 'SteamWash is currently down for maintenance',
        body: 'we expect to be back in a couple hours. chill out 😴',
        bigPicture: 'asset://assets/images/maintenance.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  //App is under  Maintenance Notification**************************************************************************
  static Future<void> createAppIsDoneFromMaintenanceNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(
            100000), //If you want to be able to display multiple instances of a specific notification, then you must provide a unique id.
        channelKey: 'App_Is_Done_From_Maintenance_Channel',
        title: 'SteamWash is done from maintenance',
        body: 'You can get back to work now 🧼🧽',
        bigPicture: 'asset://assets/images/maintenance.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  //Customer cancelled the order Notification**************************************************************************

  static Future<void> createCustomercancelledOrderNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(
            100000), //If you want to be able to display multiple instances of a specific notification, then you must provide a unique id.
        channelKey: 'order_cancelled_Channel',
        title: 'Order has been cancelled',
        body: 'The customer has cancelled the order 😬',
      ),
    );
  }

  //New order Notification**************************************************************************

  static Future<void> createNewOrderNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(
            100000), //If you want to be able to display multiple instances of a specific notification, then you must provide a unique id.
        channelKey: 'new_order_Channel',
        title: 'You have got an order',
        body: 'order detatails',
      ),
    );
  }
}
