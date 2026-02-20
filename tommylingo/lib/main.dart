import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  runApp(ScopedModel(model: MyModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: "Tommylingo",
      home: ScopedModelDescendant<MyModel>(builder: (context, child, model) =>
        FutureBuilder(future: model.token, builder: (context, snapshot) =>
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(model.langCode.isEmpty ? "Tommylingo" : "Tommylingo (${model.langCode})",
                  style: TextStyle(fontWeight: .bold)),
              actions: [
                IconButton(icon: const Icon(Icons.arrow_back_ios),    onPressed: model.prevToken),
                IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: model.nextToken),
                IconButton(icon: const Icon(Icons.info_outline), onPressed: () async {
                  final i = await PackageInfo.fromPlatform();
                  final copyright = "Copyright © 2024-2026\nmitrakov-artem@yandex.ru\nAll rights reserved.";
                  Utils.showMessage(context, i.appName, "v${i.version} (build: ${i.buildNumber})\n\n$copyright");
                }),
              ],
            ),
            body: snapshot.hasData
              ? GestureDetector(
                  onTap: () {
                    if (snapshot.data!.key.isNotEmpty)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(snapshot.data!.key),
                        duration: const Duration(milliseconds: 1300),
                        behavior: SnackBarBehavior.floating,
                        margin: const .only(top: 1),
                      ));
                    model.nextToken();
                  },
                  child: Container(
                    alignment: .center,
                    decoration: BoxDecoration(), // to detect gestures outside the Text
                    child: Column(
                      children: [
                        SizedBox(height: 160),
                        Text(
                          snapshot.data!.translation.isNotEmpty ? snapshot.data!.translation : "Press ☰ and choose language...",
                          textAlign: .center,
                          style: TextStyle(fontSize: 30),
                        ),
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
                  child: FutureBuilder(future: model.allCodes, builder: (context, snp) =>
                    snp.hasData
                      ? ListView(children: snp.data!.map((langCode) => ListTile(title: Text(langCode), onTap: () {
                          model.langCode = langCode;
                          Navigator.pop(context);
                        })).toList())
                      : CircularProgressIndicator()),
                ),
              ]),
            ),
            floatingActionButton: Column(
              spacing: 10,
              mainAxisSize: .min,
              children: [
                FloatingActionButton(
                  heroTag: "showHint",
                  tooltip: "Show hint",
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.help_rounded),
                  onPressed: () {
                    if (snapshot.hasData && snapshot.data!.key.isNotEmpty)
                      Utils.showMessage(context, snapshot.data!.translation, snapshot.data!.key);
                  },
                ),
                FloatingActionButton(
                  heroTag: "add",
                  tooltip: "Add translation key",
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.add_circle_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewKey())),
                ),
                FloatingActionButton(
                  heroTag: "edit",
                  tooltip: "Edit translation key",
                  backgroundColor: Colors.brown[400],
                  child: const Icon(Icons.edit_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewKey(token: snapshot.data))),
                ),
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
                          duration: const Duration(milliseconds: 1500), backgroundColor: error.isEmpty ? Colors.green : Colors.red
                        );
                        ScaffoldMessenger.of(context).showSnackBar(bar);
                        if (error.isEmpty) model.nextToken();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
