import 'package:digikala/Lib/error.dart';
import 'package:digikala/Lib/loading.dart';
import 'package:digikala/Pages/Category/category_child.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:digikala/Lib/Lib.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Widget> catList = [];
  List cat = [];
  String state = 'load_data';

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return state == 'load_data'
        ? Loading()
        : state == 'get_data'
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: catList,
                  ),
                ),
              )
            : Error();
  }

  void getCategory() {
    var url = Uri.parse(Lib.getApiUrl('getCategory'));
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          state = 'get_data';
          cat = convert.jsonDecode(response.body);
          if (cat.isNotEmpty) {
            for (int i = 0; i < cat.length; i++) {
              List child = cat[i]['get_child'];
              if (child.isNotEmpty) {
                Widget widget = SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10)),
                      Text(
                        cat[i]['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        child: ListView.builder(
                          itemBuilder: (context, index) =>
                              getCategoryChild(context, index, child),
                          itemCount: child.length,
                          scrollDirection: Axis.horizontal,
                        ),
                        height: 150,
                        width: double.infinity,
                      ),
                    ],
                  ),
                );
                catList.add(widget);
              }
            }
          }
        });
      } else {
        setState(() {
          state = 'error';
        });
      }
    }).catchError((onError) {
      setState(() {
        state = 'error';
      });
    });
  }

  Widget getCategoryChild(BuildContext context, int index, List child) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  CategoryChild(child[index]['id'], child[index]['name']),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                opacity: animation,
                child: child,
              ),
              transitionDuration: Duration(milliseconds: 300),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            child[index]['img'] == null
                ? Image.asset(
                    'assets/images/whites.png',
                    width: 150,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: 'assets/images/whites.png',
                    image: Lib.getSiteUrl(
                      'files/upload/' + child[index]['img'],
                    ),
                    width: 150,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              child[index]['name'],
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
