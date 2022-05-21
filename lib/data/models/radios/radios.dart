import 'package:equatable/equatable.dart';

class Radios extends Equatable {
  final String name;
  final String url;
  const Radios({
    required this.name,
    required this.url,
  });

  @override
  List<Object> get props => [name, url];

  @override
  String toString() => 'Radios(name: $name, url: $url)';

  Map<String, dynamic> toMap() {
    return {
      "Name": name,
      "URL": url,
    };
  }

  factory Radios.fromJson(Map<String, dynamic> map) {
    return Radios(
      name: map['Name'].toString(),
      url: map['URL'] ?? '',
    );
  }
}
