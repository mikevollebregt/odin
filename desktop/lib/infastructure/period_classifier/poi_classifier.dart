class POIClassifier {
  POIClassifier();

  bool IsClusterInteresting(List<String> points) {
    var filters = ["route", "locality", "political"];

    for (var filter in filters) {
      points.remove(filter);
    }

    return points.isNotEmpty;
  }
}
