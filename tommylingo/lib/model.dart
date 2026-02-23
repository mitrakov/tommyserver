import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class MyModel extends Model {
  // variables
  static final Random _random = Random(DateTime.now().millisecondsSinceEpoch);
  final Set<String> _allCodes = {};
  final List<TokenPair> _data = [];
  var _langCode = "";
  var _currentToken = 0;

  // getters
  Future<Iterable<String>> get allCodes async {
    if (_allCodes.isNotEmpty) return _allCodes;

    _allCodes.addAll(await _loadAllLangCodes());
    _langCode = _allCodes.firstOrNull ?? "";
    return _allCodes;
  }
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
    if (_data.isNotEmpty) {
      _currentToken = (_currentToken + 1) % _data.length;
      notifyListeners();
    }
  }

  /// sets internal counter to previous token; all changes will be propagated by ScopedModel
  void prevToken() {
    if (_currentToken > 0) {
      _currentToken--;
      notifyListeners();
    }
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

  /// loads all language codes
  Future<Iterable<TokenPair>> _loadAll() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/lingo/all/$langCode"));
    if (response.statusCode == 200) {
      return XmlDocument
        .parse(response.body)
        .findAllElements("item")
        .map((e) => TokenPair(e.getAttribute("key")!, e.text, bool.tryParse(e.getAttribute("hide") ?? "") ?? false))
        .where((t) => !t.isDeleted);
    }
    else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  /// loads all keys and translations from server
  Future<Iterable<String>> _loadAllLangCodes() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/lingo/all"));
    if (response.statusCode == 200)
      return XmlDocument.parse(response.body).findAllElements("key").map((e) => e.text);
    return Future.error("Error: ${response.statusCode}; ${response.body}");
  }
}

class TokenPair {
  final String key;
  final String translation;
  final bool isDeleted;
  TokenPair(this.key, this.translation, [this.isDeleted = false]);
}
