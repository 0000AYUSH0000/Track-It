import 'bar_data_item.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  List<BarDataItem> barData = [];

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
  }) {
    initializeBarData();
  }

  void initializeBarData() {
    barData = [
      BarDataItem(x: 0, y: sunAmount),
      BarDataItem(x: 1, y: monAmount),
      BarDataItem(x: 2, y: tueAmount),
      BarDataItem(x: 3, y: wedAmount),
      BarDataItem(x: 4, y: thuAmount),
      BarDataItem(x: 5, y: friAmount),
      BarDataItem(x: 6, y: satAmount),
    ];
  }
}
