class Subscription {
  int? id;
  String subscribe_package, subscribe_fee, start_date, end_date;

  Subscription({this.id, required this.subscribe_package, required this.subscribe_fee, required this.start_date, required this.end_date});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
        id: json['id'],
        subscribe_package: json['subscribe_package'] as String,
        subscribe_fee: json['subscribe_fee'] as String,
        start_date: json['start_date'] as String,
        end_date: json['end_date'] as String);
  }
}
