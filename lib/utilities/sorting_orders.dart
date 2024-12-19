/// For sorting the order names
Map<String, dynamic> sortingOrders({required Map<String, dynamic> orders}) {
  List<MapEntry<String, dynamic>> unsorted = [];

  unsorted.addAll(orders.entries);
  unsorted.sort((a, b) => a.key.compareTo(b.key));

  return Map.fromEntries(unsorted);
}
