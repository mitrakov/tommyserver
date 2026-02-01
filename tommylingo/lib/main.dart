import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommylingo/model.dart';
import 'package:tommylingo/widgets/new_key.dart';
import 'package:tommylingo/widgets/utils.dart';

/*
Build for iOS:
  bump version in pubspec.yaml
  flutter build ios
  xCode: Product -> Destination -> Any iOS Device (arm64)
  xCode: Product -> Archive -> Distribute App -> Release Testing
  rename and move *.ipa file to _dist
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // allow "async" in main() method
  runApp(ScopedModel(model: MyModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tommylingo",
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: ScopedModelDescendant<MyModel>(builder: (context, child, model) {
        return FutureBuilder(future: model.token, builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tommylingo"),
            ),
            body: snapshot.hasData
              ? GestureDetector(
                  onTap: () {
                    if (snapshot.data!.key.isNotEmpty)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(snapshot.data!.key),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(top: 1),
                      ));
                    model.nextToken();
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          snapshot.data!.translation.isNotEmpty ? snapshot.data!.translation : "Press ☰ and choose language...",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 120) // to make a text a bit higher
                      ],
                    ),
                  ),
                )
              : const Center(child: RefreshProgressIndicator()),
            drawer: Drawer(
              child: Column(children: [
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.lightGreen),
                    child: Text("Languages", style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ),
                Expanded(
                  child: ListView(children: [
                    ListTile(
                      title: const Text("en-GB"), // https://www.oracle.com/java/technologies/javase/java8locales.html
                      onTap: () {
                        model.langCode = "en-GB";
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text("es-ES"),
                      onTap: () {
                        model.langCode = "es-ES";
                        Navigator.pop(context);
                      },
                    ),
                  ]),
                ),
              ]),
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "showHint",
                  tooltip: "Show hint",
                  backgroundColor: Colors.lightBlue,
                  child: const Icon(Icons.help_rounded),
                  onPressed: () {
                    if (snapshot.hasData && snapshot.data!.key.isNotEmpty) {
                      Utils.showMessage(context, snapshot.data!.translation, snapshot.data!.key);
                    }
                  },
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "add",
                  tooltip: "Add translation key",
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Icon(Icons.add_circle_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewKey())),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "edit",
                  tooltip: "Edit translation key",
                  backgroundColor: Colors.brown,
                  child: const Icon(Icons.edit_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewKey(token: snapshot.data))),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "delete",
                  tooltip: "Delete translation key",
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.delete_forever_rounded),
                  onPressed: () {
                    if (snapshot.hasData && snapshot.data!.key.isNotEmpty) {
                      final ask = "Are you sure you want to remove '${snapshot.data!.key}'?";
                      Utils.showYesNoDialog(context, "Delete translation", ask, () async {
                        final error = await model.deleteTranslation(snapshot.data!.key);
                        final bar = SnackBar(content: Text(error.isEmpty ? "Deleted!" : error),
                            duration: const Duration(seconds: 3), backgroundColor: error.isEmpty ? Colors.green : Colors.red
                        );
                        ScaffoldMessenger.of(context).showSnackBar(bar);
                        if (error.isEmpty) model.nextToken();
                      });
                    }
                  },
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
