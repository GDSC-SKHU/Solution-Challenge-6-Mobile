import 'package:flutter/material.dart';

class userProfile extends StatelessWidget {
  userProfile(this.userName);
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Text(
          userName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
