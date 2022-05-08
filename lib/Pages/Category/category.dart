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
  List Cat = [];
  String status = 'load_data';
  _CategoryState() {
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
        status = 'load data';
        Cat = convert.jsonDecode(response.body);
        for (int i = 0; i < Cat.length; i++) {
          List child = Cat[i]['get_child'];
          if (child.length > 0) {
            Widget widget = Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                  Text(
                    Cat[i]['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      itemBuilder: (context, index) =>
                          _getChildCat(context, index, child),
                      itemCount: child.length,
                      scrollDirection: Axis.horizontal,
                    ),
                    height: 150,
                  ),
                ],
              ),
            );
            catList.add(widget);
          }
        }
        setState(() {});
      }
    });
  }

  Widget _getChildCat(BuildContext context, int index, List child) {
    return Container(
      margin: EdgeInsets.only(left: 10),
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
          SizedBox(height: 15.0,),
          Text(child[index]['name'] ,
          style: TextStyle(
            fontSize: 14.0,
          ),),
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
