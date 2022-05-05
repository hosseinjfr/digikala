import 'package:digikala/Pages/Category/category.dart';
import 'package:digikala/Pages/Home/home_page.dart';
import 'package:digikala/Pages/MyDigikala/my_digikala.dart';
import 'package:digikala/Pages/ShoppingCard/shopping_card.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  int count = 0;
  final screens = [
    HomePage(),
    Category(),
    ShoppingCard(),
    MyDigikala(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'دیجیکالا',
          style: TextStyle(
            fontSize: 17.0,
          ),
        ),
        elevation: 0.0,
      ),
      bottomNavigationBar: getBottomNavigationBar(),
      body: screens[_currentIndex],
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
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'خانه',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.category,
          ),
          label: 'دسته بندی',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Icon(
                Icons.shopping_cart,
              ),
              count > 0
                  ? Container(
                      width: 16.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(left: 15, top: 10),
                    )
                  : Container(),
            ],
          ),
          label: 'سبد خرید',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          label: 'دیجی کالای من',
        ),
      ],
    );
  }

  void OnTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
