class Bill {
  int nominal;

  Bill(this.nominal);

  factory Bill.fromJson(Map<String, dynamic> bill) =>
      Bill(_toInt(bill['nominal']));

  Map toJson() => {'nominal': nominal};
}

int _toInt(nominal) => nominal is int ? nominal : int.parse(nominal);