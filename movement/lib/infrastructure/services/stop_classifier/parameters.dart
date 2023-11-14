DateTime getReferenceDateMin() => DateTime.now().subtract(const Duration(hours: 12));

DateTime getReferenceDateMax() => DateTime.now().subtract(const Duration(minutes: 1));

const int distanceTreshholdInMeters = 75;

const int noiseTreshhold = 50;
