import 'dart:io';

class Booking {
  final String userId;
  final String petName;
  final String vetName;
  final String package;
  final int duration;
  final int totalPrice;
  File? paymentProof;

  Booking({
    required this.userId,
    required this.petName,
    required this.vetName,
    required this.package,
    required this.duration,
    required this.totalPrice,
    this.paymentProof,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'pet': petName,
      'vet': vetName,
      'package': package,
      'duration': duration,
      'total_price': totalPrice.toString(),
    };
  }
}
