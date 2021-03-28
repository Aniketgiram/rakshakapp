class Covid {
  final int Confirmed;
  final int Recovered;
  final int Deaths;
  final int Active;
  String Date;

  Covid({this.Confirmed, this.Recovered, this.Deaths, this.Active, this.Date});

  factory Covid.fromJson(Map<String, dynamic> json) {
    return Covid(
        Confirmed: json['Confirmed'],
        Recovered: json['Recovered'],
        Deaths: json['Deaths'],
        Active: json['Active'],
        Date: json["Date"]);
  }
}
