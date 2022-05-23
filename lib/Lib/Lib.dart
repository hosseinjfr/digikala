import 'package:digikala/Pages/Root/root_page.dart';
import 'package:flutter/material.dart';

import '../Pages/Category/category.dart';
import '../Pages/Home/home_page.dart';
import '../Pages/MyDigikala/my_digikala.dart';
import '../Pages/ShoppingCard/shopping_card.dart';
import 'package:intl/intl.dart';

class Lib {
  static String getApiUrl(String url) {
    return 'https://shop.mihanflutter.ir/public/api/' + url;
  }

  static String getSiteUrl(String url) {
    return 'https://shop.mihanflutter.ir/public/' + url;
  }

  static List<Widget> screens = [
    HomePage(),
    Category(),
    ShoppingCard(),
    MyDigikala(),
  ];

  static Widget getBodyView(_currentIndex) {
    switch (_currentIndex) {
      case 1:
        {
          return Category();
        }
        break;
      case 2:
        {
          return ShoppingCard();
        }
        break;
      case 3:
        {
          return MyDigikala();
        }
        break;
      default:
        {
          return HomePage();
        }
    }
  }

  static List<BottomNavigationBarItem> bnItems() {
    int count = 0;
    return [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: 'خانه',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.category,
        ),
        label: 'دسته بندی',
      ),
      BottomNavigationBarItem(
        icon: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const Icon(
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
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
        ),
        label: 'فروشگاه من',
      ),
    ];
  }

  static String getPrice(int price) {
    var formatter = NumberFormat('###,###', 'fa');
    return formatter.format(price).toString() + ' تومان';
  }

  static String getPercentage(int percentage) {
    var formatter = NumberFormat('###', 'fa');
    return formatter.format(percentage).toString() + ' تخفیف';
  }
}
