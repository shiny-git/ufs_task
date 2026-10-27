import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ufstech/product_model.dart';
import 'package:ufstech/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final searchController = TextEditingController();
  bool loading = false;
  bool error = false;
  final formkey = GlobalKey<FormState>();
  Future<void> loadData() async {
    try {
      setState(() {
        error = false;
        loading = true;
      });
      List<ProductModel> data = await NetworkServices().loadService();
      if (data != []) {
        products = data;
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      log('error at loaddata:$e');
      error = true;
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  List<ProductModel> products = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: error
          ? FloatingActionButton(
              onPressed: () {
                loadData();
              },
              child: Icon(Icons.replay_outlined),
            )
          : SizedBox.shrink(),
      appBar: AppBar(
        title: Text(
          'UFS Technologies',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
        ),

        // backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                controller: searchController,
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Enter a text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  //  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search Products',
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (!formkey.currentState!.validate()) {
                        //complete the search
                      }
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : products.isEmpty
                  ? Center(child: Text('no data'))
                  : ListView.builder(
                      itemCount: products.length,

                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // padding: EdgeInsets.all(5),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: Container(
                                height: 90,
                                width: 70,
                                child: Image.network(products[index].image),
                              ),
                              //   SizedBox(height: 10),
                              title: Text(
                                products[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // SizedBox(height: 10),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$ ${products[index].price.toString()}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  FilledButton(
                                    onPressed: () {},
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
