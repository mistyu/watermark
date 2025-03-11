class FormUtils {
  static bool haveContainerunderline(int watermarkId) {
    if (watermarkId == 1698049456677 ||
        watermarkId == 1698049855544 ||
        watermarkId == 1698049553311 ||
        watermarkId == 1698049457777) {
      return false;
    }
    return true;
  }

  static bool haveColon(int watermarkId) {
    if (watermarkId == 1698049456677 ||
        watermarkId == 1698049855544 ||
        watermarkId == 1698049457777) {
      return true;
    }
    return false;
  }
}
