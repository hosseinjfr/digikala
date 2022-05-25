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
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemBuilder: productView,
                  itemCount: productList.length,
                ),
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
    String title = productList[index]['title'];
    title = title.length > 50 ? title.substring(0, 50) + '...' : title;

    double score = 0;
    if (productList[index]['score_count'] > 0) {
      score =
          ((productList[index]['score'] / productList[index]['score_count']) /
              6);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Column(
                children: [
                  productList[index]['image_url'] == null
                      ? Image.asset(
                          'assets/images/whites.png',
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          placeholder: 'assets/images/whites.png',
                          image: Lib.getSiteUrl(
                            'files/thumbnails/' +
                                productList[index]['image_url'],
                          ),
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                  Expanded(
                    child: getProductColor(productList[index]),
                  )
                ],
              ),
              Expanded(
                  child: Column(
                children: [
                  SizedBox(
                    width: 200.0,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  score > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              Lib.getNumber(score),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            )
                          ],
                        )
                      : Container(),
                  getProductPrice(productList[index]),
                ],
              )),
            ],
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Colors.grey.withOpacity(0.3), width: 1))),
      ),
    );
  }

  Widget getProductPrice(product) {
    if (product['status'] == 1) {
      int price1 = product['get_first_product_price']['price1'];
      int price2 = product['get_first_product_price']['price2'];

      int percantage = 0;
      if (price2 < price1) {
        percantage = ((price2 / price1) * 100).floor();
        percantage = 100 - percantage;
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            percantage > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Text(
                      '%' + Lib.getPercentage(percantage),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
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
                price2 < price1
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
      );
    }
    return Container();
  }

  Widget getProductColor(product) {
    List colors = product['get_product_color'];
    if (colors.length > 0) {
      List<Widget> children = [];

      for (int i = 0; i < colors.length; i++) {
        if (i < 3) {
          String color_code = '0xff' + colors[i]['get_color']['code'];
          Widget widget = Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(int.parse(color_code)),
              border: Border.all(),
            ),
            margin: EdgeInsets.only(left: 2.0),
          );
        }
      }
      children.add(widget);

      return Row(
        children: children,
      );
    }
    return Container();
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
}
