import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tommykcal/inputbox.dart';
import 'package:tommykcal/model.dart';
import 'package:tommykcal/tommylogger.dart';
import 'package:tommykcal/widgets/events4date.dart';
import 'package:tommykcal/widgets/new_event.dart';

/*
Build for iOS:
  bump version in pubspec.yaml
  flutter build ios
  xCode: Product -> Destination -> Any iOS Device (arm64)
  xCode: Product -> Archive -> Distribute App -> Custom -> Release Testing -> include manifest for installation
  rename and move *.ipa file to dist/
  upload *.ipa, and manifest.plist to your https-server for further distribution

Build for Android:
  bump version in pubspec.yaml
  flutter build apk
  AndroidStudio: Build -> Generate Signed Bundle -> APK -> choose android/keystore.jks -> release
  rename and move *.apk file to dist/
 */
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // rm error: Binding has not yet been initialized.
  initializeDateFormatting(); // to load locales for TableCalendar
  runApp(ScopedModel(model: ElModelo()..products, child: MaterialApp(
    title: "Tommy Kcal",
    theme: ThemeData(primarySwatch: Colors.orange),
    home: MyApp(),
  )));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    TommyLogger.logger.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tommy Annals"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.info_outlined), onPressed: _showVersion),
          IconButton(icon: const Icon(Icons.key_outlined),  onPressed: _setPassword),
        ],
      ),
      body: Column(
        children: [
          // https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/pages/basics_example.dart
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday, // Sunday by default
            locale: "es_ES", // make sure to call initializeDateFormatting() from import 'package:intl/date_symbol_data_local.dart';
            firstDay: DateTime.utc(2000),
            lastDay: DateTime.utc(2040),
            focusedDay: _focusedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onPageChanged: (focusedDay) { _focusedDate = focusedDay; },   // no need to "setState()" here
            onDaySelected: (selectedDate, focusedDate) {
              if (!isSameDay(_selectedDate, selectedDate)) {
                setState(() {
                  _selectedDate = selectedDate;
                  _focusedDate = focusedDate;
                });
              }
            },
          ),
          const Text("Eventos", textScaler: TextScaler.linear(1.4)),
          Expanded(child: EventsForDateViewer(_focusedDate)),
        ],
      ),
      floatingActionButton: Builder( // to fix error "Navigator operation requested with a context that does not include a Navigator"
        builder: (context) {
          return FloatingActionButton(
            tooltip: "Crear nuevo evento",
            child: const Icon(Icons.add, size: 40),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventWidget(_focusedDate))),
          );
        },
      ),
    );
  }

  void _showVersion() async {
    final PackageInfo? _info = await PackageInfo.fromPlatform();
    TommyLogger.logger.info("${_info!.appName} v${_info.version} compilación ${_info.buildNumber}", 2000);
  }

  void _setPassword() async {
    final pass = await showInputBox(context, "Introduzca contraseña", hint: "Contraseña", obscure: true);
    if (pass != null)
      (await SharedPreferences.getInstance()).setString("_PASS", pass);
  }
}
