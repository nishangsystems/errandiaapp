
class NotificationItem {
  final String title;
  final String message;
  final String date;
  final bool? read;

  NotificationItem({required this.title, required this.message, this.date = "", this.read = false});
}