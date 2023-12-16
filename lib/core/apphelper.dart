import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/core/constants.dart';

class AppHelper
{

}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items


  List<String> mySelectedUsers = [];

  TextEditingController textEditingController = TextEditingController();

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        mySelectedUsers.add(itemValue);
      } else {
        mySelectedUsers.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, mySelectedUsers);
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primaryColorOfApp),
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.black,
      title:  Text('Select Users to Sent Invites',style: TextStyle(color: primaryColorOfApp),),
      content: StatefulBuilder(
          builder: (context,innerState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Container(
                    width: size.width * 0.9,
                    child: TypeAheadField(
                      noItemsFoundBuilder: (BuildContext context) {

                        return ListTile(

                          title: Text("Enter a Valid Email Address",style: TextStyle(color: Colors.redAccent),),
                          //subtitle: Text("Add Some Details Here"),
                        );
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: textEditingController,
                        //autofocus: true,

                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),

                        cursorColor: primaryColorOfApp,

                        decoration: InputDecoration(
                          //errorText: firstNameErrorText,

                          contentPadding: EdgeInsets.all(25),
                          hintText:  "Search & Send Invites ...",
                          labelText: "Type/Tap On Name to Add",
                          errorStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                          enabledBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white12),
                              borderRadius: BorderRadius.circular(100)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white12),
                              borderRadius: BorderRadius.circular(100)),
                          //hintText: "e.g Abouzied",
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54),
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await AuthorityServices.getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.toString()),
                          //subtitle: Text("Add Some Details Here"),
                        );
                      },

                      onSuggestionSelected: (suggestion) {
                        print("Im selected");
                        print(suggestion);
                        textEditingController.clear();
                        mySelectedUsers.add(suggestion.toString());
                        innerState((){});
                      },
                    ),
                  ),
                  padding: EdgeInsets.only(top: 0,bottom: 20),
                ),
                Padding(padding: const EdgeInsets.all(8.0),child: Text("The Following people will be sent an email and a ticket will be generated for them for the event you are creating",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,fontWeight:FontWeight.w300,color: Colors.grey)),),
                SingleChildScrollView(
                  child: ListBody(
                    children: mySelectedUsers.map((item) => CheckboxListTile(
                      checkColor: Colors.black,
                      activeColor: primaryColorOfApp,
                      value: mySelectedUsers.contains(item),
                      title: Text(item,style: TextStyle(color: primaryColorOfApp),),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (isChecked) => _itemChange(item, isChecked!),
                    ))
                        .toList(),
                  ),
                ),
              ],
            );
          }
      ),
      actions: [
        InkWell(
          onTap: _cancel,
          child: Container(
            width: size.width*0.2,
            margin: EdgeInsets.all(10),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color:primaryColorOfApp, width: 2.0),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Center(
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                    textStyle:
                    Theme.of(context).textTheme.titleMedium,
                    color: primaryColorOfApp),
              ),
            ),
          ),

        ),
        InkWell(
          onTap: _submit,
          child: Container(
            width: size.width*0.2,
            margin: EdgeInsets.all(10),
            height: 60,
            decoration: BoxDecoration(
              color: primaryColorOfApp,
              border: Border.all(color:primaryColorOfApp, width: 2.0),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Center(
              child: Text(
                'Done',
                style: GoogleFonts.montserrat(
                    textStyle:
                    Theme.of(context).textTheme.titleMedium,
                    color: Colors.black),
              ),
            ),
          ),

        ),
      ],
    );
  }
}
class AuthorityServices {
  static Future<List<String>> getSuggestions(String query) async {
    print("Getting Suggestion For " + query);
    //List<String> matches =  await ApiRepository().GetAuthorityMaster(query);
    List<String> matches = [
      'john.doe@example.com',
      'nehme.doe@example.com',
      'ashraf.doe@example.com',
      'diana.doe@example.com',
      'anna.smith@example.com',
      'johndoe87@hotmail.com',
      'emily.jones@gmail.com',
      'markthompson@yahoo.com',
      'lisa.wilson@example.com',
      'michael.brown@gmail.com',
      'laura.carter@hotmail.com',
      'david.johnson@example.com',
      'amanda.miller@yahoo.com',
      'robert.davis@gmail.com',
      'jennifer.wilson@example.com',
      'william.roberts@hotmail.com',
      'elizabeth.clark@example.com',
      'matthew.jackson@gmail.com'
    ];
    //print(matches.toList());
    //matches.addAll(cities);
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(query);
    if(emailValid){
      matches.add(query);
    }

    //print(matches.toList());
    //matches.addAll(cities);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}