import 'package:bep/PopupView/popupView.dart';
import 'package:flutter/material.dart';

Widget donateBtn(
    context, int id, String category, Future<void> Function() getPoint) {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: ElevatedButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => popupView(
              id: id,
              category: category,
              getPoint: getPoint,
            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                width: 23,
                height: 30,
                child: Image.asset('assets/images/donation.png')),
            SizedBox(width: 8.0),
            Text('Donate', style: TextStyle(color: Colors.white, fontSize: 20)),
          ]),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 60.0),
            backgroundColor: Color.fromRGBO(54, 123, 183, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    ),
  );
}
