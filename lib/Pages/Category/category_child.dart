import 'package:digikala/Lib/Lib.dart';
import 'package:flutter/material.dart';

class CategoryChild extends StatefulWidget {
  int cat_id = 0;
  String cat_name = '';




  CategoryChild(int catId, String catName) {
    this.cat_id = catId;
    this.cat_name = catName;
  }

  @override
  State<CategoryChild> createState() => _CategoryChildState();
}

class _CategoryChildState extends State<CategoryChild> {
  int _currentIndex = 1;
  bool showTabBody = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.cat_name,
          style: const TextStyle(
            fontSize: 17.0,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: !showTabBody,
      ),
      body: getScreenBody(),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      selectedFontSize: 12.0,
      fixedColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) => setState(() {
        _currentIndex = index;
      }),
      items: Lib.bnItems(),
    );
  }

  void OnTapped(int index) {
    setState(() {
      _currentIndex = index;
      showTabBody = true;
    });
  }

  Widget getScreenBody() {
    if (showTabBody) {
      return Lib.getBodyView(_currentIndex);
    } else {
      return Center(
        child: Text('Category Child'),
      );
    }
  }
}
