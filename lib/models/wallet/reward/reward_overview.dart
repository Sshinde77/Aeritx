import 'package:e_com/main.export.dart';

class RewardOverview {
  const RewardOverview({
    required this.total,
    required this.pending,
    required this.redeemed,
    required this.expired,
  });

  final num total;
  final num pending;
  final num redeemed;
  final num expired;

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'pending': pending,
      'redeemed': redeemed,
      'expired': expired,
    };
  }

  factory RewardOverview.fromMap(Map<String, dynamic> map) {
    return RewardOverview(
      total: map.parseNum('total'),
      pending: map.parseNum('pending'),
      redeemed: map.parseNum('redeemed'),
      expired: map.parseNum('expired'),
    );
  }
}
