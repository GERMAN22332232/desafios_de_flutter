// DESAFÍO 4B — JSON desde cero  (probar en dartpad.dev o con: dart run user.dart)
// JSON de https://jsonplaceholder.typicode.com/users/1:
//  id → int | name, username, email → String | address → Object (city, zipcode → String)
import 'dart:convert';

class Address {
  final String city;
  final String zipcode;

  Address({required this.city, required this.zipcode});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json['city'] as String,
        zipcode: json['zipcode'] as String,
      );
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address? address; // EXTRA: objeto anidado

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        address: json['address'] != null
            ? Address.fromJson(json['address'] as Map<String, dynamic>)
            : null,
      );

  @override
  String toString() =>
      '#$id $name (@$username) <$email> - ${address?.city ?? "sin ciudad"} ${address?.zipcode ?? ""}';
}

void main() {
  // Un solo usuario (JSON de ejemplo, empieza con { )
  const jsonUno = '''
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": { "street": "Kulas Light", "city": "Gwenborough", "zipcode": "92998-3874" }
  }''';
  final user = User.fromJson(jsonDecode(jsonUno) as Map<String, dynamic>);
  print(user);

  // Lista de usuarios (JSON que empieza con [ )
  const jsonLista = '''
  [
    {"id":1,"name":"Leanne Graham","username":"Bret","email":"Sincere@april.biz",
     "address":{"city":"Gwenborough","zipcode":"92998-3874"}},
    {"id":2,"name":"Ervin Howell","username":"Antonette","email":"Shanna@melissa.tv",
     "address":{"city":"Wisokyburgh","zipcode":"90566-7771"}}
  ]''';
  final lista = (jsonDecode(jsonLista) as List)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList();
  for (final u in lista) {
    print(u);
  }

  // En una app real: final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  // final users = (jsonDecode(res.body) as List).map((e) => User.fromJson(e)).toList();
}