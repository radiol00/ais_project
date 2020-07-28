String formatDate(DateTime date) {
  String day = date.day < 10 ? '0${date.day}' : '${date.day}';
  String month = date.month < 10 ? '0${date.month}' : '${date.month}';
  return '$day/$month/${date.year}';
}
