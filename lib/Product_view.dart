import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/model/product.dart';

class ProductView extends StatefulWidget {
  final Product product;

  const ProductView({Key key, this.product}) : super(key: key);
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  TextEditingController _qtyController, _priceController, _totalController;
  Product get product => widget.product;
  StreamSubscription<DocumentSnapshot> data;
  final DocumentReference _documentReference =
      Firestore.instance.document("mydata/dummy");


  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController();
    _priceController = TextEditingController();
    _totalController = TextEditingController();

     data = _documentReference.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _priceController.text = snapshot.data['egg'];
        });
      }
    });
  }

   @override
  void dispose() {
    data?.cancel();
    super.dispose();
  }

  void updateTotal(String val) {
    _totalController.text =
        (int.parse(_qtyController.text) * double.parse(_priceController.text)).toString();
  }

  @override
  Widget build(BuildContext context) {
    _priceController.text = product.price.toString();
    _qtyController.text = product.qty.toString();
    _totalController.text = (product.qty * product.price).toString();
    return Card(
            child: SizedBox(
              height: 90,
              child: ListTile(
                  leading: Container(
                    height: 35,
                    width: 40,
                    child: TextField(
                      onChanged: updateTotal,
                      controller: _qtyController,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                          border:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.green[100]),
                    ),
                  ),
                  title: Text(product.name),
                  subtitle: Text("${product.mrp.toString()}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        height: 20,
                        width: 80,
                        child: TextField(
                          controller: _priceController,
                          onChanged: updateTotal,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              fillColor: Colors.green[100]),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        height: 20,
                        width: 100,
                        child: TextField(
                          controller: _totalController,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              fillColor: Colors.blue[100]),
                        ),
                      ),
                    ],
                  )),
            ),
    );
  }
}
