class Formatters {
  // Sayıları formatla (1000 -> 1K, 1000000 -> 1M)
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Sayıları binlik ayırıcı ile formatla (7542 -> 7,542)
  static String formatNumberWithCommas(int number) {
    final String numberStr = number.toString();
    final StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < numberStr.length; i++) {
      if (i > 0 && (numberStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(numberStr[i]);
    }
    
    return buffer.toString();
  }
}

