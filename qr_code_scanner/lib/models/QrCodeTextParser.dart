class QrCodeTextParser {
  static QrData parser(String qrText) {
    print(qrText);
    if (qrText.startsWith(RegExp("tel:", caseSensitive: false))) {
      return QrData(QrType.NUMBER,
          number: Number(
              qrText.replaceAll(RegExp('tel:', caseSensitive: false), '')));
    } else if (qrText.startsWith(RegExp("https://", caseSensitive: false))) {
      return QrData(QrType.URL, url: Url(qrText));
    } else if (qrText.startsWith(RegExp("http://", caseSensitive: false))) {
      return QrData(QrType.URL, url: Url(qrText));
    } else if (qrText.startsWith(RegExp("URLTO:", caseSensitive: false))) {
      return QrData(QrType.URL,
          url: Url(
              qrText.replaceAll(RegExp('URLTO:', caseSensitive: false), '')));
    } else if (qrText.startsWith(RegExp("WIFI:", caseSensitive: false))) {
      String x = qrText.replaceFirst(RegExp("WIFI:", caseSensitive: false), "");
      String S = "";
      String T = "";
      String P = "";
      x.substring(0, x.length - 1).split(";").forEach((text) {
        if (text.contains("S:")) {
          S = text.replaceAll("S:", "");
        }
        if (text.contains("T:")) {
          T = text.replaceAll("T:", "");
        }

        if (text.contains("P:")) {
          P = text.replaceAll("P:", "");
        }
      });
      return QrData(QrType.WIFI, wifi: Wifi(S, T, P));
    } else if (qrText.startsWith(RegExp("mailto:", caseSensitive: false))) {
      if (!qrText.contains("?")) {
        return QrData(QrType.EMAIL,
            email: Email(
                qrText.replaceAll(RegExp("mailto:", caseSensitive: false), ""),
                "",
                ""));
      } else {
        String x =
            qrText.replaceFirst(RegExp("mailto:", caseSensitive: false), "");
        String address = x.substring(0, x.indexOf("?"));
        String subject = "";
        String body = "";
        x.substring(x.indexOf("?") + 1, x.length).split("&").forEach((text) {
          if (text.contains("subject=")) {
            subject = text.replaceAll("subject=", "");
          }
          if (text.contains("body=")) {
            body = text.replaceAll("body=", "");
          }
        });
        return QrData(QrType.EMAIL, email: Email(address, subject, body));
      }
    } else if (qrText.startsWith(RegExp("smsto:", caseSensitive: false))) {
      String x = qrText.replaceFirst(RegExp("smsto:", caseSensitive: false), "");
      String to = "";
      String msg = "";
      List<String> list = x.split(":");
      if (list.length >= 1) {
        to = list[0];
        msg = list[1];
      } else if (list.length == 0) {
        to = list[0];
      }
      return QrData(QrType.SMS, sms: Sms(to, msg));
    } else if (!qrText.contains(";")) {
      return QrData(QrType.TEXT, text: TextT(qrText));
    } else {
      String n = "";
      String fn = "";
      String title = "";
      String tel = "";
      String adr = "";
      String email = "";
      String url = "";
      String org = "";
      String note = "";
      qrText
          .replaceAll(RegExp("MECARD:", caseSensitive: false), "")
          .split(";")
          .forEach((text) {
        if (text.contains(RegExp("n:", caseSensitive: false))) {
          n = text.replaceAll(RegExp("n:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("fn:", caseSensitive: false))) {
          fn = text.replaceAll(RegExp("fn:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("title:", caseSensitive: false))) {
          title = text.replaceAll(RegExp("title:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("tel:", caseSensitive: false))) {
          tel = text.replaceAll(RegExp("tel:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("adr:", caseSensitive: false))) {
          adr = text.replaceAll(RegExp("adr:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("email:", caseSensitive: false))) {
          email = text.replaceAll(RegExp("email:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("url:", caseSensitive: false))) {
          url = text.replaceAll(RegExp("url:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("org:", caseSensitive: false))) {
          org = text.replaceAll(RegExp("org:", caseSensitive: false), "");
        }
        if (text.contains(RegExp("note:", caseSensitive: false))) {
          note = text.replaceAll(RegExp("note:", caseSensitive: false), "");
        }
      });
      return QrData(QrType.VCARD,
          vcard: VCard(n, fn, title, tel, adr, email, url, org, note));
    }
  }

  static List<QrDisplayData> getDisplayData(String qrText) {
    QrData qrData = parser(qrText);
    List<QrDisplayData> list = List<QrDisplayData>();
    switch (qrData.qrType) {
      case QrType.NUMBER:
        list.add(QrDisplayData("Telephone", qrData.number.number));
        break;
      case QrType.URL:
        list.add(QrDisplayData("Url", qrData.url.url));
        break;
      case QrType.WIFI:
        if (qrData.wifi.ssid.isNotEmpty)
          list.add(QrDisplayData("SSID", qrData.wifi.ssid));
        if (qrData.wifi.type.isNotEmpty)
          list.add(QrDisplayData("Type", qrData.wifi.type));
        if (qrData.wifi.password.isNotEmpty)
          list.add(QrDisplayData("Password", qrData.wifi.password));
        break;
      case QrType.EMAIL:
        if (qrData.email.address.isNotEmpty)
          list.add(QrDisplayData("Email", qrData.email.address));
        if (qrData.email.subject.isNotEmpty)
          list.add(QrDisplayData("Subject", qrData.email.subject));
        if (qrData.email.body.isNotEmpty)
          list.add(QrDisplayData("Body", qrData.email.body));
        break;
      case QrType.SMS:
        if (qrData.sms.to.isNotEmpty)
          list.add(QrDisplayData("Telephone", qrData.sms.to));
        if (qrData.sms.msg.isNotEmpty)
          list.add(QrDisplayData("Message", qrData.sms.msg));
        break;
      case QrType.VCARD:
        if (qrData.vcard.n.isNotEmpty)
          list.add(QrDisplayData("Name", qrData.vcard.n));
        if (qrData.vcard.fn.isNotEmpty)
          list.add(QrDisplayData("Full Name", qrData.vcard.fn));
        if (qrData.vcard.title.isNotEmpty)
          list.add(QrDisplayData("Title", qrData.vcard.title));
        if (qrData.vcard.tel.isNotEmpty)
          list.add(QrDisplayData("Telephone", qrData.vcard.tel));
        if (qrData.vcard.adr.isNotEmpty)
          list.add(QrDisplayData("Address", qrData.vcard.adr));
        if (qrData.vcard.email.isNotEmpty)
          list.add(QrDisplayData("Email", qrData.vcard.email));
        if (qrData.vcard.url.isNotEmpty)
          list.add(QrDisplayData("Url", qrData.vcard.url));
        if (qrData.vcard.org.isNotEmpty)
          list.add(QrDisplayData("Organization", qrData.vcard.org));
        if (qrData.vcard.note.isNotEmpty)
          list.add(QrDisplayData("Note", qrData.vcard.note));
        break;
      case QrType.TEXT:
        list.add(QrDisplayData("", qrData.text.text));
        break;
    }
    return list;
  }
}

enum QrType { NUMBER, URL, WIFI, EMAIL, SMS, VCARD, TEXT }

class QrDisplayData {
  String name;
  String value;

  QrDisplayData(String name, String value) {
    this.name = name;
    this.value = value;
  }
}

class QrData {
  QrType qrType;
  Number number;
  Url url;
  Wifi wifi;
  Email email;
  Sms sms;
  VCard vcard;
  TextT text;

  QrData(QrType qrType,
      {Number number,
      Url url,
      Wifi wifi,
      Email email,
      Sms sms,
      VCard vcard,
      TextT text}) {
    this.qrType = qrType;
    this.number = number;
    this.url = url;
    this.wifi = wifi;
    this.email = email;
    this.sms = sms;
    this.vcard = vcard;
    this.text = text;
  }

  @override
  String toString() {
    return 'QrData{qrType: $qrType, number: $number, url: $url, wifi: $wifi, email: $email, sms: $sms, vcard: $vcard, text: $text}';
  }
}

class Number {
  String number = "";

  Number(String number) {
    this.number = number;
  }

  @override
  String toString() {
    return 'Number{number: $number}';
  }
}

class TextT {
  String text = "";

  TextT(String text) {
    this.text = text;
  }

  @override
  String toString() {
    return 'Text{text: $text}';
  }
}

class Url {
  String url = "";

  Url(String url) {
    this.url = url;
  }

  @override
  String toString() {
    return 'url{url: $url}';
  }
}

class Wifi {
  String ssid = "";
  String type = "";
  String password = "";

  Wifi(String ssid, String type, String password) {
    this.ssid = ssid;
    this.type = type;
    this.password = password;
  }

  @override
  String toString() {
    return 'Wifi{ssid: $ssid, type: $type, password: $password}';
  }
}

class Email {
  String address = "";
  String subject = "";
  String body = "";

  Email(String address, String subject, String body) {
    this.address = address;
    this.subject = subject;
    this.body = body;
  }

  @override
  String toString() {
    return 'EMAIL{address: $address, subject: $subject, body: $body}';
  }
}

class Sms {
  String to = "";
  String msg = "";

  Sms(String to, String msg) {
    this.to = to;
    this.msg = msg;
  }

  @override
  String toString() {
    return 'SMS{to: $to, msg: $msg}';
  }
}

class VCard {
  String n = "";
  String fn = "";
  String title = "";
  String tel = "";
  String adr = "";
  String email = "";
  String url = "";
  String org = "";
  String note = "";

  VCard(String n, String fn, String title, String tel, String adr, String email,
      String url, String org, String note) {
    this.n = n;
    this.fn = fn;
    this.title = title;
    this.tel = tel;
    this.adr = adr;
    this.email = email;
    this.url = url;
    this.org = org;
    this.note = note;
  }

  @override
  String toString() {
    return 'VCard{n: $n, fn: $fn, title: $title, tel: $tel, adr: $adr, email: $email, url: $url, org: $org, note: $note}';
  }
}
