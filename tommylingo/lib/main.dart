// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommylingo/model.dart';
import 'package:tommylingo/settings.dart';
import 'package:tommylingo/widgets/conjugation_esp.dart';
import 'package:tommylingo/widgets/new_key.dart';
import 'package:tommylingo/widgets/progress_widget.dart';
import 'package:tommylingo/widgets/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // allow "async" in main() method
  await Settings.instance.init();
  runApp(ScopedModel(model: MyModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  final progressKey = GlobalKey();
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
              actions: [TotalProgressWidget(key: progressKey)],
            ),
            body: snapshot.hasData
              ? GestureDetector(
                  onTap: () {
                    if (snapshot.data!.item1.isNotEmpty)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(snapshot.data!.item1),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(top: 1),
                      ));
                    (progressKey.currentState as TotalProgressWidgetState).addOne();
                    model.nextToken();
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          snapshot.data!.item2.isNotEmpty ? snapshot.data!.item2 : "Press ☰ and choose language...",
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
                Visibility(
                  visible: snapshot.hasData && snapshot.data!.item3 != null,
                  child: FloatingActionButton(
                    heroTag: "conjugations", // must be present for multiple FA Buttons (https://stackoverflow.com/questions/51125024)
                    tooltip: "Show conjugations",
                    backgroundColor: Colors.limeAccent,
                    child: const Icon(Icons.change_circle_rounded),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConjugationsEsp(snapshot.data!.item3!))),
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "showHint",
                  tooltip: "Show hint",
                  backgroundColor: Colors.lightBlue,
                  child: const Icon(Icons.help_rounded),
                  onPressed: () {
                    if (snapshot.hasData && snapshot.data!.item1.isNotEmpty) {
                      Utils.showMessage(context, snapshot.data!.item2, snapshot.data!.item1);
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
                    if (snapshot.hasData && snapshot.data!.item1.isNotEmpty) {
                      Utils.showYesNoDialog(context, "Delete translation", "Are you sure you want to remove '${snapshot.data!.item1}'?", () async {
                        final error = await model.deleteTranslation(snapshot.data!.item1);
                        final bar = SnackBar(content: Text(error.isEmpty ? "Deleted!" : error), duration: const Duration(seconds: 3), backgroundColor: error.isEmpty ? Colors.green : Colors.red);
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
