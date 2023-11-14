
class DensityThresholdClassifier {
  DensityThresholdClassifier();

  int calculateDensityThreshhold(String sensor) {
    switch (sensor) {
      case "normal":
        return 5;
      case "fused":
        return 10;
      case "balanced":
        return 10;
    }

    return 0;
  }
}
