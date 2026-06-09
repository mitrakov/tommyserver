import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommykcal/json/meal.dart';
import 'package:tommykcal/model.dart';
import 'package:tommykcal/widgets/trixcontainer.dart';

class EventsForDateViewer extends StatelessWidget {
  final DateTime date;

  const EventsForDateViewer(this.date);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ElModelo>(builder: (context, child, model) {
      return FutureBuilder(future: model.getForDate(date), builder: (context, snapshot) {
        if (snapshot.hasError) return Text("ERROR: ${snapshot.error}");
        if (!snapshot.hasData) return Text("Ningún dato para: $date");

        final children = snapshot.data!.map((item) => _createTile(model, item)).toList();
        return ListView(children: children);
      });
    });
  }

  Widget _createTile(ElModelo model, Meal item) {
    return TrixContainer(child: ListTile(
      title: Text(item.name, textScaler: TextScaler.linear(1.2)),
      subtitle: Text("json.encode(item.params)", textScaler: TextScaler.linear(0.85)),
      onLongPress: () async {
        if (await FlutterPlatformAlert.showAlert(
            windowTitle: "Borrar evento",
            text: "¿Estás seguro que quieres borrar: '${item.name}' (${item.date})?",
            alertStyle: AlertButtonStyle.yesNo,
            iconStyle: IconStyle.stop) == AlertButton.yesButton) {
          model.removeByChronicleId(date, item.id);
        }
      },
    ));
  }
}
