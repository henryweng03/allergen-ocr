import 'package:allergyapp/pages/scan.dart';
import 'package:allergyapp/services/allergen_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllergenList extends StatefulWidget {
  final List<String> allergenList;
  final List<String> compList;
  AllergenList({Key key, this.allergenList, this.compList}) : super(key:key);
  @override
  _AllergenListState createState() => _AllergenListState();
}

class _AllergenListState extends State<AllergenList> {
  List<String> allergenList;
  List<String> compList;
  TextEditingController addController = TextEditingController();
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    allergenList=widget.allergenList;
    compList = widget.compList;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        centerTitle: true,
        title: Text(
          "Allergen List",
          style: TextStyle(
            fontFamily: "Proxima",
            fontWeight: FontWeight.w100, color: Colors.grey[200],
            fontSize: 22, letterSpacing: .5
          )
        ),
        actions: [
          IconButton(
            onPressed:  () {
              Widget okButton = FlatButton(
                child: Text("Add", style: TextStyle(fontFamily: "Proxima", fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    String tempString = addController.text.toUpperCase();
                    allergenList.add(tempString);
                    compList.add(tempString);
                    compList.add(tempString + "S");
                    compList.add(tempString + ",");
                    compList.add(tempString + "S,");
                  });
                  addController.clear();
                },
              );
              Widget cancelButton = FlatButton(
                child: Text("Cancel", style: TextStyle(fontFamily: "Proxima", fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context).pop();
                  addController.clear();
                },
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Add allergen",
                      style: TextStyle(
                        fontFamily: "Proxima",
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    content: TextField(
                      maxLength: 60,
                      controller: addController,
                      decoration: InputDecoration(
                        hintText: "Input allergen name", hintStyle: TextStyle(fontFamily: "Proxima"),
                        suffixIcon: IconButton(
                          onPressed: () => addController.clear(),
                          icon: Icon(Icons.cancel)
                        )
                      ),
                    ),
                    actions: [
                      okButton,
                      cancelButton
                    ],
                  );;
                },
              );
            },
            icon: Icon(Icons.add, color: Colors.grey[200],),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: allergenList.map((allergen) => AllergenCard(
          allergenName: allergen.toUpperCase(),
          delete: () {
            setState(() {
              allergenList.remove(allergen);
            });
            print(allergenList);
          },
       )).toList()
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        elevation: 3,
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
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
              builder: (BuildContext context) => new Scan(allerList: allergenList, cList: compList,)
          );
          var routeList = new MaterialPageRoute(
              builder: (BuildContext context) => new AllergenList(allergenList: allergenList, compList: compList,)
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
