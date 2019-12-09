import 'package:flutter/material.dart';

class HashTagsStructure {
  String name;
  List<bool> days = new List(7);
}

class TagsPage extends StatelessWidget {
  Widget buttonDay(String day, {bool selected = false}) {
    return Column(children: <Widget>[
      Text(day[0]),
      IconButton(
        color: selected ? Colors.blue : Colors.black,
        icon: Icon(selected ? Icons.today : Icons.calendar_today),
        tooltip: day,
        onPressed: () {
          // Perform some action
        },
      )
    ]);
  }

  Widget week(List<bool> selectedDays) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buttonDay("Lundi", selected: selectedDays[0]),
          buttonDay("Mardi", selected: selectedDays[1]),
          buttonDay("Mercredi", selected: selectedDays[2]),
          buttonDay("Jeudi", selected: selectedDays[3]),
          buttonDay("Vendredi", selected: selectedDays[4]),
          buttonDay("Samedi", selected: selectedDays[5]),
          buttonDay("Dimanche", selected: selectedDays[6])
        ]);
  }

  Widget card(HashTagsStructure myTags) {
    return Card(
        child: ExpansionTile(
      title: Text('#:' + myTags.name),
      children: <Widget>[week(myTags.days)],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        tooltip: "'Ajouter",
        onPressed: () {},
      ),
    );
  }
}
