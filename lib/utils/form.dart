class FormUtils {
  static bool haveContainerunderline(int watermarkId, [String? tableKey]) {
    if (watermarkId == 1698049456677 ||
        watermarkId == 1698049855544 ||
        watermarkId == 1698049553311 ||
        watermarkId == 1698049457777 ||
        watermarkId == 1698049811111 ||
        watermarkId == 1698317868899 ||
        watermarkId == 1698049354422) {
      return false;
    }

    if (watermarkId == 16982153599988) {
      if (tableKey == "table2") {
        return false;
      }
    }
    return true;
  }

  static bool haveColon(int watermarkId) {
    if (watermarkId == 1698049456677 ||
        watermarkId == 1698049855544 ||
        watermarkId == 1698049457777 ||
        watermarkId == 1698049811111) {
      return true;
    }
    return false;
  }

  static bool haveBlack(int watermarkId) {
    if (watermarkId == 16982153599988) {
      return true;
    }
    return false;
  }
}
