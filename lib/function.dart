import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

fetchCowinDistrict(String id) async {
  String urls =
      "https://cdn-api.co-vin.in/api/v2/admin/location/districts/${id}";
  final response = await http.get(Uri.parse(urls));
  var responseData = json.decode(response.body);
  List<String> disnamelist = [];
  List<int> idlist = [];

  try {
    for (var single in responseData["districts"]) {
      disnamelist.add(single['district_name']);
      idlist.add(single['district_id']);
    }
  } catch (e) {}
  List alllist = [];
  alllist.add(disnamelist);
  alllist.add((idlist));
  return alllist;
}

Future<List<String>> fetchCowinStates() async {
  String urls = "https://cdn-api.co-vin.in/api/v2/admin/location/states";
  final response = await http.get(Uri.parse(urls));
  var responseData = json.decode(response.body);
  List<String> cowlist = [];
  try {
    for (var single in responseData["states"]) {
      cowlist.add(single['state_name']);
    }
  } catch (e) {}
  return cowlist;
}

Future<List<CowinList>> fetchCowin(String date, int id) async {
  String urls =
      "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=${id}&date=${date}";
  final response = await http.get(Uri.parse(urls));
  var responseData = json.decode(response.body);
  List<CowinList> cowlist = [];
  try {
    for (var single in responseData["centers"]) {
      for (var item in single["sessions"]) {
        if (item["min_age_limit"] == 18 && item["available_capacity"] != 0) {
          CowinList place = CowinList(
              name: single["name"],
              vaccine: item["vaccine"],
              availableCapacity: item["available_capacity"].toString());
          cowlist.add(place);
          break;
        }
      }
    }
  } catch (e) {}
  return cowlist;
}

// class Coin {
//   String price;
//   Coin({this.price});
//   factory Coin.fromJson(Map<String, dynamic> json) {
//     return Coin(
//       price: (json["market_data"]["current_price"]["usd"]).toString(),
//     );
//   }
// }

class CowinList {
  final String name;
  final String vaccine;
  final String availableCapacity;

  CowinList({this.name, this.vaccine, this.availableCapacity});

  factory CowinList.fromJson(Map<String, dynamic> json) {
    return CowinList(
      name: json['name'].toString(),
      vaccine: json['vaccine'].toString(),
      availableCapacity: json['availableCapacity'].toString(),
    );
  }
}
