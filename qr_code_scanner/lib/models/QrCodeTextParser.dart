class QrCodeTextParser {
  static QrData parser(String qrText) {
    if (qrText.startsWith("tel:")) {
      return QrData(
          QrType.NUMBER, Number(qrText.replaceAll(RegExp('tel:'), '')));
    }
  }
}

enum QrType { NUMBER }

class QrData {
  QrType qrType;
  Number number;

  QrData(QrType qrType, Number number) {
    this.qrType = qrType;
    this.number = number;
  }

  @override
  String toString() {
    return 'QrData{qrType: $qrType, number: $number}';
  }
}

class Number {
  String number;
  String name = "Telephone";

  Number(String number) {
    this.number = number;
  }

  @override
  String toString() {
    return 'Number{number: $number, name: $name}';
  }
}
