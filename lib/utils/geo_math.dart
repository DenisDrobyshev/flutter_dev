import 'dart:math';

class GeoMath {
  // ──────────────────────────────────────────────
  // Метод 1. ГМС → десятичные градусы
  // ──────────────────────────────────────────────
  static double gmsToDeg(int gg, int mm, double ss) {
    double sign = gg < 0 ? -1.0 : 1.0;
    return sign * (gg.abs() + mm / 60.0 + ss / 3600.0);
  }

  // ──────────────────────────────────────────────
  // Метод 2. Десятичные градусы → ГМС
  // Возвращает [градусы, минуты, секунды]
  // ──────────────────────────────────────────────
  static List<double> degToGms(double deg) {
    double absDeg = deg.abs();
    int gg = absDeg.floor();
    double minFull = (absDeg - gg) * 60.0;
    int mm = minFull.floor();
    double ss = (minFull - mm) * 60.0;

    // Округление до 2 знаков для устранения артефактов double
    ss = (ss * 100).round() / 100.0;

    // Обработка переполнения после округления
    if (ss >= 60.0) {
      ss -= 60.0;
      mm += 1;
    }
    if (mm >= 60) {
      mm -= 60;
      gg += 1;
    }

    double sign = deg < 0 ? -1.0 : 1.0;
    return [sign * gg, mm.toDouble(), ss];
  }

  // ──────────────────────────────────────────────
  // Метод 3. Прямая геодезическая задача (ПГЗ)
  // ──────────────────────────────────────────────
  static Map<String, double> directProblem(
    double xa,
    double ya,
    double d,
    int degAlpha,
    int minAlpha,
    double secAlpha,
  ) {
    double alphaDeg = gmsToDeg(degAlpha, minAlpha, secAlpha);
    double alphaRad = alphaDeg * pi / 180.0;

    double deltaX = d * cos(alphaRad);
    double deltaY = d * sin(alphaRad);

    return {
      'Xb': xa + deltaX,
      'Yb': ya + deltaY,
      'deltaX': deltaX,
      'deltaY': deltaY,
    };
  }

  // ──────────────────────────────────────────────
  // Метод 4. Обратная геодезическая задача (ОГЗ)
  // ──────────────────────────────────────────────
  static Map<String, dynamic> inverseProblem(
    double xa,
    double ya,
    double xb,
    double yb,
  ) {
    double deltaX = xb - xa;
    double deltaY = yb - ya;
    double d = sqrt(deltaX * deltaX + deltaY * deltaY);

    // Совпадающие точки
    if (d < 1e-10) {
      return {
        'd': 0.0,
        'deltaX': 0.0,
        'deltaY': 0.0,
        'rDeg': 0.0,
        'alphaDeg': 0.0,
        'direction': '—',
        'rGms': [0.0, 0.0, 0.0],
        'alphaGms': [0.0, 0.0, 0.0],
      };
    }

    double rDeg;
    double alphaDeg;
    String direction;

    if (deltaX.abs() < 1e-10) {
      rDeg = 90.0;
      alphaDeg = deltaY > 0 ? 90.0 : 270.0;
      direction = deltaY > 0 ? 'В' : 'З';
    } else if (deltaY.abs() < 1e-10) {
      rDeg = 0.0;
      alphaDeg = deltaX > 0 ? 0.0 : 180.0;
      direction = deltaX > 0 ? 'С' : 'Ю';
    } else {
      rDeg = atan(deltaY.abs() / deltaX.abs()) * 180.0 / pi;

      if (deltaX > 0 && deltaY > 0) {
        alphaDeg = rDeg;
        direction = 'СВ';
      } else if (deltaX < 0 && deltaY > 0) {
        alphaDeg = 180.0 - rDeg;
        direction = 'ЮВ';
      } else if (deltaX < 0 && deltaY < 0) {
        alphaDeg = 180.0 + rDeg;
        direction = 'ЮЗ';
      } else {
        alphaDeg = 360.0 - rDeg;
        direction = 'СЗ';
      }
    }

    return {
      'd': d,
      'deltaX': deltaX,
      'deltaY': deltaY,
      'rDeg': rDeg,
      'alphaDeg': alphaDeg,
      'direction': direction,
      'rGms': degToGms(rDeg),
      'alphaGms': degToGms(alphaDeg),
    };
  }
}