extension DateTimeExtension on DateTime {
  String formatTime(DateTime now) {
    List<String> monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    String formattedMonth = monthNames[now.month - 1];
    final format =
        "${now.day} $formattedMonth ${now.year.toString().substring(now.year.toString().length - 2)}";
    return format;
  }
}
