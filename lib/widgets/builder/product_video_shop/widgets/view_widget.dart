import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:flutter/material.dart';

class ViewProductVideoShop extends StatelessWidget {
  const ViewProductVideoShop({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 15.0),
        width: 85.0,
        height: 60.0,
        child: Column(children: [
          InkWell(
            onTap: () {
              _navigate(context);
            },
            child: const Icon(Icons.remove_red_eye_outlined, size: 30.0, color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text("View Product",
                maxLines: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11.0)),
          )
        ]));
  }

  void _navigate(BuildContext context) {
    if (product.id == null) return;
    Navigator.pushNamed(context, '${ProductScreen.routeName}/${product.id}/${product.slug}',
        arguments: {'product': product});
  }
}
