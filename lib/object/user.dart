class Dealer {
  String dealerId, email, name;

  Dealer({required this.name, required this.email, required this.dealerId});

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(dealerId: json['dealer_id'] as String, email: json['email'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() => {'dealer_id': dealerId, 'email': email, 'name': name};
}
