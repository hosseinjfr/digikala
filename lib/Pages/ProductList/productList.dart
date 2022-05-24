import 'dart:convert';

import 'package:digikala/Lib/Lib.dart';
import 'package:digikala/Lib/error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Lib/loading.dart';

class ProductList extends StatefulWidget {
  int cat_id = 0;
  String cat_name = '';

  ProductList(int catId, String catName) {
    this.cat_id = catId;
    this.cat_name = catName;
  }

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int _currentIndex = 1;
  bool showTabBody = false;

  List category = [];
  List newProduct = [];
  List bestSelling = [];
  String state = 'load_data';

  late Map<String, dynamic> serverData;
  List productList = [];

  @override
  void initState() {
    super.initState();
    getProductList();
    // getBestSellingProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          showTabBody ? 'فروشگاه اینترنتی من' : widget.cat_name,
          style: const TextStyle(
            fontSize: 17.0,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
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
      onTap: onTab,
      items: Lib.bnItems(),
    );
  }

  void onTab(int index) {
    setState(() {
      _currentIndex = index;
      showTabBody = true;
    });
  }

  Widget getScreenBody() {
    if (showTabBody) {
      return Lib.getBodyView(_currentIndex);
    } else {
      return state == 'load_data' ? const Loading() : getContent();
    }
  }

  Widget getContent() {
    if (state == 'get_data') {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: productView,
                itemCount: productList.length,
              ),
            ),
          ],
        ),
      );
    } else {
      return const Error();
    }
  }

  void getProductList() {
    var url = Uri.parse(Lib.getApiUrl('product/getList'));
    http.post(url, body: {'cat_id': widget.cat_id.toString()}).then((response) {
      if (response.statusCode == 200) {
        state = 'get_data';
        setState(() {
          serverData = convert.jsonDecode(response.body);
          productList = serverData['product']['data'];
          print(productList);
        });
      }
    });
  }

  Widget productView(BuildContext context, int index) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              productList[index]['image_url'] == null
                  ? Image.asset(
                      'assets/images/whites.png',
                      width: 150,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: 'assets/images/whites.png',
                      image: Lib.getSiteUrl(
                        'files/thumbnails/' + productList[index]['image_url'],
                      ),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showProduct(BuildContext context, int index, List list) {
    String title = list[index]['title'];
    title = title.length > 36 ? title.substring(0, 36) + '...' : title;
    int price2 = list[index]['price'];
    int price1 = 0;
    int percantage = 0;

    if (list[index]['discount_price'] != null &&
        list[index]['discount_price'] != 0) {
      price1 = price2 + int.parse(list[index]['discount_price'].toString());

      percantage = ((price2 / price1) * 100).floor();
      percantage = 100 - percantage;
    }

    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                list[index]['image_url'] == null
                    ? Image.asset(
                        'assets/images/whites.png',
                        width: 150,
                        height: 140,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/whites.png',
                        image: Lib.getSiteUrl(
                          'files/thumbnails/' + list[index]['image_url'],
                        ),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: 200.0,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    percantage > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              child: Text(
                                '%' + Lib.getPercentage(percantage),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        : Container(),
                    Column(
                      children: [
                        Text(
                          Lib.getPrice(price2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        price1 != 0
                            ? Text(
                                Lib.getPrice(price1),
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 13.0,
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget showBestSellingProduct(BuildContext context, int index, List list) {
    String title = list[index]['title'];
    title = title.length > 36 ? title.substring(0, 36) + '...' : title;
    int price2 = list[index]['price'];
    int price1 = 0;
    int percantage = 0;

    if (list[index]['discount_price'] != null &&
        list[index]['discount_price'] != 0) {
      price1 = price2 + int.parse(list[index]['discount_price'].toString());

      percantage = ((price2 / price1) * 100).floor();
      percantage = 100 - percantage;
    }

    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                list[index]['image_url'] == null
                    ? Image.asset(
                        'assets/images/whites.png',
                        width: 150,
                        height: 140,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/whites.png',
                        image: Lib.getSiteUrl(
                          'files/thumbnails/' + list[index]['image_url'],
                        ),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: 200.0,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    percantage > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              child: Text(
                                '%' + Lib.getPercentage(percantage),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        : Container(),
                    Column(
                      children: [
                        Text(
                          Lib.getPrice(price2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        price1 != 0
                            ? Text(
                                Lib.getPrice(price1),
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 13.0,
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
