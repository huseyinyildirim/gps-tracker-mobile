class TryParse {
  String getLocaleDatetime(DateTime value) {
    if (null != value) {
      return "${value.day.toString()}/${value.month.toString()}/${value.year.toString()} ${value.hour.toString()}:${value.minute.toString()}";
    } else {
      return null;
    }
  }
}