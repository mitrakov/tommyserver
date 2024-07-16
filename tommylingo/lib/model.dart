// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';
import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommylingo/json/verb.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

typedef TokenPair = Tuple3<String, String, Verb?>;

class MyModel extends Model {
  // variables
  static final Random _random = Random(DateTime.now().millisecondsSinceEpoch);
  final List<TokenPair> _data = [];
  String _langCode = "en-GB";
  int _currentToken = 0;

  // getters
  String get langCode => _langCode;
  Iterable<String> get keys => _data.map((e) => e.item1);
  Future<TokenPair> get token async {
    if (_data.isEmpty) {
      _data.addAll((await _loadAll()).toList()..shuffle(_random));
      _currentToken = 0;
    }
    return _data.isEmpty ? const TokenPair("", "", null) : _data[_currentToken];
  }

  // setters
  set langCode(String value) {
    _langCode = value;
    _data.clear();
    _currentToken = 0;
    notifyListeners();
  }

  // methods
  /// sets internal counter to next token; all changes will be propagated by ScopedModel
  void nextToken() {
    _currentToken++;
    notifyListeners();
  }

  String getValue(String key) {
    return _data.firstWhere((e) => e.item1 == key.trim(), orElse: () => TokenPair(key, "Not found", null)).item2;
  }

  /// returns empty string if OK, or error message in case of failure
  Future<String> upsertTranslation(String key, String translation) async {
    final xml = XmlDocument([XmlElement(XmlName("a"), [], [
      XmlElement(XmlName("langCode"), [], [XmlText(_langCode)]),
      XmlElement(XmlName("key"), [], [XmlText(key)]),
      XmlElement(XmlName("translation"), [], [XmlText(translation)]),
    ])]);

    final response = await http.post(Uri.parse("http://mitrakoff.com:9090/lingo"), body: xml.toXmlString());
    if (response.statusCode == 200) return "";
    else return "Error: ${response.statusCode}; ${response.body}";
  }

  /// returns empty string if OK, or error message in case of failure
  Future<String> deleteTranslation(String key) async {
    final xml = XmlDocument([XmlElement(XmlName("a"), [], [
      XmlElement(XmlName("langCode"), [], [XmlText(_langCode)]),
      XmlElement(XmlName("key"), [], [XmlText(key)]),
    ])]);

    final response = await http.delete(Uri.parse("http://mitrakoff.com:9090/lingo"), body: xml.toXmlString());
    if (response.statusCode == 200) return "";
    else return "Error: ${response.statusCode}; ${response.body}";
  }

  /// loads all keys and translations from server
  Future<Iterable<TokenPair>> _loadAll() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/lingo/all/$langCode"));
    if (response.statusCode == 200) {
      return XmlDocument
        .parse(response.body)
        .findAllElements("item")
        .map((e) {
          final conjugation = e.getAttribute("conjugation");
          final verb = conjugation != null ? Verb.fromJson(jsonDecode(conjugation)) : null;
          return TokenPair(e.getAttribute("key")!, e.text, verb);
        });
    }
    else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }
}
