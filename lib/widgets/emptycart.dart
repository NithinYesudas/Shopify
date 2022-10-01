import 'package:flutter/material.dart';
class EmptyCard extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Cart is Empty...!',
            style: TextStyle(
                fontFamily: 'dmsansregular',
                fontSize: mediaquery.height * .035),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(
                      Colors.orange[700])),
              onPressed: () {
                Navigator.of(context).pushNamed('home');
              },
              child: Text('   Add   ' ,style: TextStyle(
                  fontFamily: 'dmsansregular',
                  fontSize: 20
              ),))
        ],
      ),
    );
  }
}
