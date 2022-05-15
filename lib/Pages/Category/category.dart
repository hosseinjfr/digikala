import 'dart:ui';

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

  @override
  void initState() {
    super.initState();
    _getCatList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          children: catList,
        ),
      ),
    );
  }

  void _getCatList() {
    var url = Uri.parse(Lib.getApiUrl('getCategory'));
    http.get(url).then((response) {
      if (response.statusCode == 200) {
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                    Text(
                      cat[i]['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            _getChildCat(context, index, child),
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
        } else {
          return const Center(
            child: Text(
              'هیچ دسته بندی موجود نمی باشد',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          );
        }
        setState(() {});
      } else {}
    });
  }

  Widget _getChildCat(BuildContext context, int index, List child) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          child[index]['img'] == null
              ? Image.asset(
                  'assets/images/img.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : FadeInImage.assetNetwork(
                  placeholder: 'assets/images/img.png',
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
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
