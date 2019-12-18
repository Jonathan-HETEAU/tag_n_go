import 'package:flutter/material.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/screens/home/history/history.dart';
import 'package:tag_n_go/screens/home/tags/tags.dart';
import 'package:tag_n_go/screens/home/today/today.dart';
import 'package:provider/provider.dart';
import 'package:tag_n_go/models/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final PageController pageController = PageController(initialPage: _index);

    return StreamProvider<List<Tag>>.value(
        value: user.tags,
        child: Scaffold(
          body: PageView(
              onPageChanged: (int page) {
                setState(() {
                  _index = page;
                });
              },
              controller: pageController,
              scrollDirection: Axis.horizontal,
              children: <Widget>[TodayScreens(), TagsView(), History()]),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  title: Text("Today"), icon: Icon(Icons.home)),
              BottomNavigationBarItem(title: Text("#"), icon: Icon(Icons.edit)),
              BottomNavigationBarItem(
                  title: Text("History"), icon: Icon(Icons.history))
            ],
            onTap: (int tap) {
              pageController.jumpToPage(tap);
              setState(() {
                _index = tap;
              });
            },
            currentIndex: _index,
          ),
        ));
  }
}
