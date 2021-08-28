import "package:flutter/material.dart";
import 'package:allergyapp/pages/allergen_list.dart';


class AllergenCard extends StatefulWidget {

  final String allergenName;
  final Function delete;
  AllergenCard({this.allergenName, this.delete});

  @override
  _AllergenCardState createState() => _AllergenCardState();
}

class _AllergenCardState extends State<AllergenCard> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        color: Color.fromARGB(255, 23, 23, 23),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 300,
                child: Text(
                  widget.allergenName,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontFamily: "Proxima",
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5
                  ),
                ),
              ),
              Align(
                child: IconButton(
                  onPressed: () {
                    widget.delete();
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.grey[200],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

