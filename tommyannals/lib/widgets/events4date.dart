import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyannals/chronicle/chronicle.dart';
import 'package:tommyannals/model.dart';
import 'package:tommyannals/widgets/trixcontainer.dart';

class EventsForDateViewer extends StatelessWidget {
  final DateTime date;

  const EventsForDateViewer(this.date);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(builder: (context, child, model) {
      return FutureBuilder(future: model.getForDate(date), builder: (context, snapshot) {
        if (snapshot.hasError) return Text("ERROR: ${snapshot.error}");
        if (!snapshot.hasData) return Text("Ningún dato para: $date");

        final children = snapshot.data!.map((item) => _createTile(model, item)).toList();
        return ListView(children: children);
      });
    });
  }

  Widget _createTile(MyModel model, Chronicle item) {
    return TrixContainer(child: ListTile(
      title: Text(item.eventName, textScaler: TextScaler.linear(1.2)),
      subtitle: Text(json.encode(item.params), textScaler: TextScaler.linear(0.85)),
      onLongPress: () async {
        if (await FlutterPlatformAlert.showAlert(
            windowTitle: "Borrar evento",
            text: "¿Estás seguro que quieres borrar: '${item.eventName}' (${item.date})?",
            alertStyle: AlertButtonStyle.yesNo,
            iconStyle: IconStyle.stop) == AlertButton.yesButton) {
          model.removeByChronicleId(date, item.id ?? 0);
        }
      },
    ));
  }
}
