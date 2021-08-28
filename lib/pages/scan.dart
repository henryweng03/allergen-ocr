import 'dart:io';

import 'package:flutter/material.dart';
import 'package:allergyapp/services/allergen_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:allergyapp/pages/allergen_list.dart';


class Scan extends StatefulWidget {
  final List<String> allerList;
  final List<String> cList;
  Scan({Key key, this.allerList, this.cList}) : super(key:key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  int _currentNavIndex = 1;
  List<String> wordList = [];
  List<String> allerList = [];
  List<String> intersectList = [];
  File _image;

  Future pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      print("hello");
      print(widget.allerList);
    });
  }

  Future readText() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);

    for (TextBlock block in readText.blocks){
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements){
          print(word.text.toUpperCase());
          wordList.add(word.text.toUpperCase());
        }
      }
    }

    intersectList = wordList.toSet().intersection(widget.cList.toSet()).toList();
    setState(() {
      wordList = wordList;
      intersectList = intersectList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(
            "Scan Ingredient List",
            style: TextStyle(
                fontFamily: "Proxima",
                fontWeight: FontWeight.w100,
                fontSize: 20
            )
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 12,),
          _image != null ?Center(
            child: Container(
              height: 270,
              width: 270,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(_image), fit: BoxFit.cover,
                )
              ),
            ),
          ):Center(
            child: Container(
              height: 270,
              width: 270,
              color: Colors.grey[900],
              child: Center(child: Text(
                "Take a clear image of the ingredient list",
                style: TextStyle(
                  fontFamily: "Proxima",
                  color: Colors.grey[200]
                ),
              )),
            ),
          ),
          SizedBox(height: 12.0,),
          intersectList.length > 0? Center(child: Text(
            "Allergens Found (Not Safe)",
            style: TextStyle(
                fontFamily: "Proxima",
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          )): Center(child: Text(
            "No Allergens Found (Safe)",
            style: TextStyle(
                fontFamily: "Proxima",
                color: Colors.greenAccent[400],
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          )),
          SizedBox(height: 12.0,),
          Container(
            height: 150,
            width: 350,
            color: Colors.grey[900],
            child: ListView(
              children: intersectList.map((word) => word[word.length - 1] == ',' ? Container(
                height: 35,
                color: Colors.grey[900],
                child: Center(child: Text(word.substring(0, word.length - 1).toUpperCase(), style: TextStyle(fontFamily: "Proxima", color: Colors.redAccent),))
              ): Container(
                  height: 35,
                  color: Colors.grey[900],
                  child: Center(child: Text(word.toUpperCase(), style: TextStyle(fontFamily: "Proxima", color: Colors.redAccent),))
              )
              ).toList()
            ),
          ),
          SizedBox(height: 10,),
          RaisedButton(
            padding: EdgeInsets.all(12),
            color: Colors.grey[900],
            child: Icon(Icons.camera_alt, color: Colors.grey[200], size: 20,),
            onPressed: () async {
              await pickImage();
              readText();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        backgroundColor: Color.fromARGB(255, 18, 20, 20),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
              icon: _currentNavIndex==1?Icon(Icons.list, color: Colors.grey[200], size: 24): Icon(Icons.list, color: Colors.blue[300], size: 24),
              title: _currentNavIndex==1?Text("Allergen List", style: TextStyle(fontFamily: "Proxima", color: Colors.grey[200]),):
              Text("Allergen List", style: TextStyle(fontFamily: "Proxima", color: Colors.blue[300]),)
          ),
          BottomNavigationBarItem(
              icon: _currentNavIndex==0?Icon(Icons.camera_alt, color: Colors.grey[200], size: 24): Icon(Icons.camera_alt, color: Colors.blue[300], size: 24),
              title: _currentNavIndex==0?Text("Scan", style: TextStyle(fontFamily: "Proxima", color: Colors.grey[200]),):
              Text("Scan", style: TextStyle(fontFamily: "Proxima", color: Colors.blue[300]),)
          )
        ],
        onTap: (index){
          var routeScan = new MaterialPageRoute(
              builder: (BuildContext context) => new Scan(allerList: widget.allerList, cList: widget.cList,)
          );
          var routeList = new MaterialPageRoute(
              builder: (BuildContext context) => new AllergenList(allergenList: widget.allerList, compList: widget.cList,)
          );
          setState(() {
            _currentNavIndex = index;
            index==0?Navigator.of(context).pushReplacement(routeList):
            Navigator.of(context).pushReplacement(routeScan);
          });
        },
      ),
    );
  }
}
