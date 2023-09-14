class RecordBooking {
  DateTime? date;
  int? duration;
  int? available;
  int? booked;
  int? productId;

  /// This property use for custom duration booking
  int? fieldDuration;

  RecordBooking({
    this.date,
    this.duration,
    this.available,
    this.booked,
    this.productId,
    this.fieldDuration,
  });

  RecordBooking.fromJson(Map<String, dynamic> json) {
    date = DateTime.tryParse(json['date']);
    duration = json['duration'];
    available = json['available'];
    booked = json['booked'];
    productId = json['product_id'];
  }
}
