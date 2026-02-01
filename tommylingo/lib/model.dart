import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class MyModel extends Model {
  // variables
  static final Random _random = Random(DateTime.now().millisecondsSinceEpoch);
  final List<TokenPair> _data = [];
  String _langCode = "en-GB";
  int _currentToken = 0;

  // getters
  String get langCode => _langCode;
  Iterable<String> get keys => _data.map((e) => e.key);
  Future<TokenPair> get token async {
    if (_data.isEmpty) {
      _data.addAll((await _loadAll()).toList()..shuffle(_random));
      _currentToken = 0;
    }
    return _data.isEmpty ? TokenPair("", "") : _data[_currentToken];
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
    return _data.firstWhere((e) => e.key == key.trim(), orElse: () => TokenPair(key, "Not found")).translation;
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

  /// loads all keys, translations and optional conjugations from server
  Future<Iterable<TokenPair>> _loadAll() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/lingo/all/$langCode"));
    if (response.statusCode == 200) {
      return XmlDocument
        .parse(response.body)
        .findAllElements("item")
        .map((e) => TokenPair(e.getAttribute("key")!, e.text));
    }
    else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }
}

class TokenPair {
  final String key;
  final String translation;

  TokenPair(this.key, this.translation);
}
