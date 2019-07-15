class Bill {
  int nominal;
  int count;

  Bill(this.nominal, [this.count = 1]);

  factory Bill.fromJson(Map<dynamic, dynamic> bill) =>
      Bill(_toInt(bill['nominal']));

  Map toJson() => {'nominal': nominal, 'count': count};
}

int _toInt(nominal) => nominal is int ? nominal : int.parse(nominal);