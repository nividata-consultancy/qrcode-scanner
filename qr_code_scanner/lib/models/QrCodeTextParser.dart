class QrCodeTextParser {
  static QrData parser(String qrText) {
    print(qrText);
    if (qrText.startsWith("tel:")) {
      return QrData(QrType.NUMBER,
          number: Number(qrText.replaceAll(RegExp('tel:'), '')));
    } else if (qrText.startsWith("https://")) {
      return QrData(QrType.URL, url: Url(qrText));
    } else if (qrText.startsWith("http://")) {
      return QrData(QrType.URL, url: Url(qrText));
    } else if (qrText.startsWith("URLTO:")) {
      return QrData(QrType.URL,
          url: Url(qrText.replaceAll(RegExp('URLTO:'), '')));
    } else if (qrText.startsWith("WIFI:")) {
      String x = qrText.replaceFirst(RegExp("WIFI:"), "");
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
    } else if (qrText.startsWith("mailto:")) {
      if (!qrText.contains("?")) {
        return QrData(QrType.EMAIL,
            email: Email(qrText.replaceAll("mailto:", ""), "", ""));
      } else {
        String x = qrText.replaceFirst(RegExp("mailto:"), "");
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
    } else if (qrText.toLowerCase().startsWith("smsto:")) {
      String x = qrText.toLowerCase().replaceFirst(RegExp("smsto:"), "");
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
      qrText.toLowerCase().split(";").forEach((text) {
        if (text.toLowerCase().contains("n:")) {
          n = text.replaceAll("n:", "");
        }
        if (text.toLowerCase().contains("fn:")) {
          fn = text.replaceAll("fn:", "");
        }
        if (text.toLowerCase().contains("title:")) {
          title = text.replaceAll("title:", "");
        }
        if (text.toLowerCase().contains("tel:")) {
          tel = text.replaceAll("tel:", "");
        }
        if (text.toLowerCase().contains("adr:")) {
          adr = text.replaceAll("adr:", "");
        }
        if (text.toLowerCase().contains("email:")) {
          email = text.replaceAll("email:", "");
        }
        if (text.toLowerCase().contains("url:")) {
          url = text.replaceAll("url:", "");
        }
        if (text.toLowerCase().contains("org:")) {
          org = text.replaceAll("org:", "");
        }
        if (text.toLowerCase().contains("note:")) {
          note = text.replaceAll("note:", "");
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
        list.add(QrDisplayData("Uel", qrData.url.url));
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
    }
    return list;
  }
}

enum QrType { NUMBER, URL, WIFI, EMAIL, SMS, VCARD }

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

  QrData(QrType qrType,
      {Number number, Url url, Wifi wifi, Email email, Sms sms, VCard vcard}) {
    this.qrType = qrType;
    this.number = number;
    this.url = url;
    this.wifi = wifi;
    this.email = email;
    this.sms = sms;
    this.vcard = vcard;
  }

  @override
  String toString() {
    return 'QrData{qrType: $qrType, number: $number, url: $url, wifi: $wifi, email: $email, sms: $sms, vcard: $vcard}';
  }
}

class Number {
  String number = "";
  String name = "Telephone";

  Number(String number) {
    this.number = number;
  }

  @override
  String toString() {
    return 'Number{number: $number, name: $name}';
  }
}

class Url {
  String url = "";
  String name = "Url";

  Url(String url) {
    this.url = url;
  }

  @override
  String toString() {
    return 'url{url: $url, name: $name}';
  }
}

class Wifi {
  String ssid = "";
  String type = "";
  String password = "";
  String name = "Wifi";

  Wifi(String ssid, String type, String password) {
    this.ssid = ssid;
    this.type = type;
    this.password = password;
  }

  @override
  String toString() {
    return 'Wifi{ssid: $ssid, type: $type, password: $password, name: $name}';
  }
}

class Email {
  String address = "";
  String subject = "";
  String body = "";
  String name = "Email";

  Email(String address, String subject, String body) {
    this.address = address;
    this.subject = subject;
    this.body = body;
  }

  @override
  String toString() {
    return 'EMAIL{address: $address, subject: $subject, body: $body, name: $name}';
  }
}

class Sms {
  String to = "";
  String msg = "";
  String name = "Sms";

  Sms(String to, String msg) {
    this.to = to;
    this.msg = msg;
  }

  @override
  String toString() {
    return 'SMS{to: $to, msg: $msg, name: $name}';
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
  String name = "VCard";

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
    return 'VCard{n: $n, fn: $fn, title: $title, tel: $tel, adr: $adr, email: $email, url: $url, org: $org, note: $note, name: $name}';
  }
}
