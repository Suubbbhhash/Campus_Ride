class BusModel {
  final String busNumber;
  final String route;

  BusModel({required this.busNumber, required this.route});
}

final List<BusModel> sampleBuses = [
  BusModel(busNumber: '4519', route: 'Siddharoodha Matha → SDMCET'),
  BusModel(busNumber: '4520', route: 'Keshwapur → SDMCET'),
  BusModel(busNumber: '0084', route: 'Old Hubli → SDMCET'),
  BusModel(busNumber: '0090', route: 'Navanagar → SDMCET'),
  BusModel(busNumber: '2897', route: 'Srinagar → CBT → SDMCET'),
  BusModel(busNumber: '1104', route: 'MG Bank Road → CBT → SDMCET'),
];