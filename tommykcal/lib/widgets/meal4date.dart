import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommykcal/json/meal.dart';
import 'package:tommykcal/model.dart';
import 'package:tommykcal/widgets/trixcontainer.dart';

class MealForDateViewer extends StatelessWidget {
  final DateTime date;

  const MealForDateViewer(this.date);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ElModelo>(builder: (context, child, model) =>
      FutureBuilder(future: model.getForDate(date), builder: (context, snapshot) {
        if (snapshot.hasError) return Text("ERROR: ${snapshot.error}");
        if (!snapshot.hasData) return Text("Ningún dato para: $date");
        final list = snapshot.data!;
        final total = list.map((meal) => meal.kcalTotal).sum;
        return Column(
          crossAxisAlignment: .center,
          spacing: 10,
          children: [
            const Text("La comida", style: TextStyle(fontWeight: .bold, fontSize: 20)),
            Row(
              mainAxisAlignment: .center,
              spacing: 10,
              children: [
                Text("En total: $total kcal"),
                Container(height: 20, width: total * 0.07, decoration: 
                  BoxDecoration(color: _kcal2colour(total), border: .all(color: Colors.grey))),
              ],
            ),
            Expanded(child: ListView(children: list.map((meal) => _createTile(model, meal)).toList())),
          ],
        );
      }));
  }

  Widget _createTile(ElModelo model, Meal item) {
    return TrixContainer(child: ListTile(
      dense: true,
      minVerticalPadding: 0,
      minTileHeight: 0,
      title: Text(item.name, style: TextStyle(fontWeight: .w700)),
      subtitle: Text("${json.encode(item.kcalTotal)} kcal"),
      onLongPress: () async {
        if (await FlutterPlatformAlert.showAlert(
            windowTitle: "Borrar comida",
            text: "¿Estás seguro que quieres borrar: '${item.name}' (${item.date})?",
            alertStyle: AlertButtonStyle.yesNo,
            iconStyle: IconStyle.stop) == AlertButton.yesButton) {
          model.remove(date, item.id);
        }
      },
    ));
  }
  
  Color _kcal2colour(int kcal) {
    if (kcal < 1600) return Colors.green;
    if (kcal < 1700) return Colors.lightGreen;
    if (kcal < 1800) return Colors.lightGreenAccent;
    if (kcal < 1900) return Colors.yellow;
    if (kcal < 2000) return Colors.yellowAccent;
    if (kcal < 2100) return Colors.orangeAccent;
    if (kcal < 2200) return Colors.orange;
    if (kcal < 2300) return Colors.deepOrangeAccent;
    if (kcal < 2400) return Colors.deepOrange;
    return Colors.red;
  }
}
