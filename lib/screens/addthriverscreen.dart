import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tree/flutter_tree.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../Network/FirebaseApi.dart';
import '../core/apphelper.dart';
import '../core/constants.dart';
import '../core/progress_dialog.dart';

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class AddThriversScreen extends StatefulWidget {
  const AddThriversScreen({Key? key}) : super(key: key);

  @override
  State<AddThriversScreen> createState() => _AddThriversScreenState();
}

class _AddThriversScreenState extends State<AddThriversScreen> {

  CollectionReference thriversCollection = FirebaseFirestore.instance.collection('Thrivers');

  List<Map> dataItems = [];
  List<DocumentSnapshot> documents = [];

  List<String> listOfUserToAdd = [];
  TextEditingController thriverNameTextEditingController = TextEditingController();
  TextEditingController thriverDescTextEditingController = TextEditingController();
  TextEditingController catergoryTextEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController subcategoryTextEditingController = TextEditingController();
  TextEditingController challangesTextEditingController = TextEditingController();
  TextEditingController solutionsTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController industryTextEditingController = TextEditingController();


  String? userAccountSearchErrorText;

  String searchText = '';

  List<String> mySelectedUsers = [];

  List<DocumentReference> challengesDocRefs = [];
  List<DocumentReference> solutionsDocRefs = [];

  bool showTreeView = false;

  static List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];
  final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();
  //List<Animal> _selectedAnimals = [];
  List<Animal> _selectedAnimals2 = [];
  List<Animal> _selectedAnimals3 = [];
  //List<Animal> _selectedAnimals4 = [];
  List<Animal> _selectedAnimals5 = [];

  List<Map<String, dynamic>> treeListData = [];

  //默认数据
  List<Map<String, dynamic>> initialTreeData = [
    {"parentId": 1063, "value": "牡丹江市", "id": 1314},
    {"parentId": 1063, "value": "齐齐哈尔市", "id": 1318},
    {"parentId": 1063, "value": "佳木斯市", "id": 1320},
    {"parentId": 1066, "value": "长春市", "id": 1323},
    {"parentId": 1066, "value": "通化市", "id": 1325},
    {"parentId": 1066, "value": "白山市", "id": 1328},
    {"parentId": 1066, "value": "辽源市", "id": 1330},
    {"parentId": 1066, "value": "松原市", "id": 1332},
    {"parentId": 1009, "value": "南京市", "id": 1130},
    {"parentId": 1009, "value": "无锡市", "id": 1132},
    {"parentId": 1009, "value": "常州市", "id": 1133},
    {"parentId": 1009, "value": "镇江市", "id": 1134},
  ];

  List<String> challanges = [];
  List<DocumentReference> challangeDocRefs = [];

  Future<List<TreeNodeData>> _load(TreeNodeData parent) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = [
      TreeNodeData(
        title: 'Load node 1',
        expaned: false,
        checked: true,
        children: [],
        extra: null,
      ),
      TreeNodeData(
        title: 'Load node 2',
        expaned: false,
        checked: false,
        children: [],
        extra: null,
      ),
    ];

    return data;
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
   /// var response = await rootBundle.loadString('assets/data.json');
    setState(() {
      initialTreeData.forEach((item) {
        treeListData.add(item);
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Material(

      child: Scaffold(
        //backgroundColor: Colors.black,
        body: Wrap(
          children: [
            HeaderWidget(),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Padding(
                      child: Container(
                        width: size.width * 0.2,
                        child: TypeAheadField(
                          noItemsFoundBuilder: (BuildContext context) {

                            return ListTile(

                              title: Text("Enter a Valid Email Address",style: TextStyle(color: Colors.redAccent),),
                              //subtitle: Text("Add Some Details Here"),
                            );
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: catergoryTextEditingController,
                            //autofocus: true,

                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.w400,
                                ///color: Colors.white
                            ),



                            decoration: InputDecoration(
                              //errorText: firstNameErrorText,

                              contentPadding: EdgeInsets.all(0),
                              hintText:  "Type & Search",
                              labelText: "Select Category",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              //hintText: "e.g Abouzied",
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
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
                           // textEditingController.clear();
                            catergoryTextEditingController.text = suggestion;
                            //innerState((){});
                          },
                        ),
                      ),
                      padding: EdgeInsets.only(top: 20,bottom: 20),
                    ),

                    Padding(
                      child: Container(
                        width: size.width * 0.2,
                        child: TypeAheadField(
                          noItemsFoundBuilder: (BuildContext context) {

                            return ListTile(

                              title: Text("Enter a Valid Email Address",style: TextStyle(color: Colors.redAccent),),
                              //subtitle: Text("Add Some Details Here"),
                            );
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: subcategoryTextEditingController,
                            //autofocus: true,

                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.w400,
                                //color: Colors.white
                            ),



                            decoration: InputDecoration(
                              //errorText: firstNameErrorText,

                              contentPadding: EdgeInsets.all(0),
                              hintText:  "Select Subcategory",
                              labelText: "Select Subcategory",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),

                              //hintText: "e.g Abouzied",
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
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
                            subcategoryTextEditingController.text = suggestion;
                            //innerState((){});
                          },
                        ),
                      ),
                      padding: EdgeInsets.only(top: 20,bottom: 20),
                    ),

                    Padding(
                      child: MultiSelectDialogField(
                        buttonText: Text(
                          "Select Colums to Display",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 16,
                          ),
                        ),
                        title: Text("Columns to Display"),
                        items: _animals.map((e) => MultiSelectItem(e, e.name)).toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          _selectedAnimals2 = values;
                        },
                      ),
                      padding: EdgeInsets.only(top: 25,bottom: 20,right: 20),
                    ),
                    Center(child: InkWell(
                        onTap: (){
                          showTreeView = !showTreeView;
                          setState(() {});
                        },
                        child: (!showTreeView)?FaIcon(FontAwesomeIcons.folderTree):FaIcon(FontAwesomeIcons.list))),

                    Center(child: InkWell(
                        onTap: (){
                          showAddThriverDialogBox(setState);
                        },
                        child: FaIcon(FontAwesomeIcons.add))),

                  ],
                )
            ),
            Container(child:
            StreamBuilder(
                // FirebaseFirestore.instance
                //     .collection('users')
                //     .where('age', isGreaterThan: 20)
                //     .get()
                //     .then(...);
                //
                // .where('age', isGreaterThan: 20)
                // .get()
              stream: thriversCollection
                  .where('Name', isGreaterThanOrEqualTo: textEditingController.text)
                  .where('Name', isLessThanOrEqualTo: textEditingController.text + '\uf8ff').snapshots(),
              builder: (ctx,AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                        //color: primaryColorOfApp,
                      ));
                }

                documents =(streamSnapshot.data?.docs)??[];

                print("documents.toList().toString()");
                print(documents.first.data());

                //todo Documents list added to filterTitle
                if (searchText.length > 0) {
                  documents = documents.where((element) {
                    return element
                        .get('Name')
                        .toString()
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();
                }

                return !showTreeView? ListView.separated(
                  reverse: true,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: documents.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    //print('Images ${documents[index]['Images'].length}');
                    //todo Pass this time

                    int ind = 1;
                    if(documents.length==0){
                      ind = 0;
                    }

                    if(index==ind){
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: TextField(
                              onChanged: (val){
                                searchText = val;
                              },
                              onSubmitted: (v){
                                setState(() {

                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          ThriversListTile(documents[index])
                        ],
                      );
                    }

                    else{
                      return ThriversListTile(documents[index]);
                    }

                  },
                ):Container(
                  child: TreeView(
                    data: treeData,
                    lazy: true,
                    load: _load,
                    showActions: true,
                    showCheckBox: true,
                    showFilter: true,
                    append: (parent) {
                      print(parent.extra);
                      return TreeNodeData(
                        title: 'Appended',
                        expaned: true,
                        checked: true,
                        children: [],
                      );
                    },
                    onLoad: (node) {
                      print('onLoad');
                      print(node);
                    },
                    onAppend: (node, parent) {
                      print('onAppend');
                      print(node);
                    },
                    onCheck: (checked, node) {
                      print('checked');
                      print('onCheck');
                      print(node);
                    },
                    onCollapse: (node) {
                      print('onCollapse');
                      print(node);
                    },
                    onExpand: (node) {
                      print('onExpand');
                      print(node);
                    },
                    onRemove: (node, parent) {
                      print('onRemove');
                      print(node);
                    },
                    onTap: (node) {
                      print('onTap');
                      print(node);
                    },
                  ),
                );
              },
            ),),
          ],
        ),
      ),
    );
  }

  Widget ThriversListTile(DocumentSnapshot<Object?> thriversDetails) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 10,),
              Text(thriversDetails.id,style: Theme.of(context).textTheme.bodySmall),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(thriversDetails['Name'],style: Theme.of(context).textTheme.titleMedium),
                  Text(thriversDetails['Description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey)),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(Icons.circle,size: 10,),
                      SizedBox(width: 10,),
                      Text(thriversDetails["Country"],style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(width: 10,),
                      Icon(Icons.circle,size: 10,),
                      SizedBox(width: 10,),
                      Text(thriversDetails["JobRoles"],style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(width: 10,),
                      Icon(Icons.circle,size: 10,),
                      SizedBox(width: 10,),
                      Text(thriversDetails["Industry"],style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              /*Row(
                children: [

                  *//*Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card_outlined),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("credits",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 1.5,),
                          ),
                        ],
                      ),
                      Text("Credits",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 0.8,),

                    ],
                  ),*//*

                ],
              ),*/
              SizedBox(width: 40,),
              /*Row(
                children: [

                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.note_alt_sharp),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(thriversDetails['ListOfBoughtTests'].length.toString(),style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 1.5,),
                          ),
                        ],
                      ),
                      Text("Tests Bought",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 0.8,),

                    ],
                  ),

                ],
              ),*/
              SizedBox(width: 40,),
              IconButton(
                  iconSize: 30,
                  color: primaryColorOfApp,
                  onPressed: () async {
                    ProgressDialog.show(context, "Deleting Users",Icons.person);
                    await ApiRepository().DeleteSectionPreset(thriversDetails.reference);
                    ProgressDialog.hide();
                  },
                  icon: Icon(Icons.delete,)),
              SizedBox(width: 40,),
            ],
          ),
        ],
      ),
    );
  }

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: []);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        listOfUserToAdd = results;
      });
    }
  }


  Future<DocumentSnapshot> fetchEventDetails(DocumentReference docRef) async {
    //Fetch List of All the tickets
    return await docRef.get();
  }

  void showAddThriverDialogBox(StateSetter innerState) {
    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200,

                  height: 60,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border.all(
                        //color:primaryColorOfApp ,
                        width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                          textStyle:
                          Theme.of(context).textTheme.titleSmall,
                          fontWeight: FontWeight.bold,
                          //color: primaryColorOfApp
          ),
                    ),
                  ),
                ),

              ),
              InkWell(
                onTap: () async {
                  ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);

                  ProgressDialog.show(context, "Creating a Thriver", Icons.chair);
                  await ApiRepository().createThriver({
                      'Name': thriverNameTextEditingController.text,
                      'Description': thriverDescTextEditingController.text,
                      'JobRoles':thriverDescTextEditingController.text,
                      'Industry':industryTextEditingController.text,
                      'Country':countryTextEditingController.text,
                      'Challenges':challangeDocRefs,
                      'Solutions':solutionsDocRefs
                       // Add more fields as needed
                   }
                  );
                  ProgressDialog.hide();
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200,
                  height: 60,
                  decoration: BoxDecoration(
                    color:Colors.deepPurple,
                    border: Border.all(
                        color:Colors.deepPurple,
                         width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      'Add',
                      style: GoogleFonts.montserrat(
                          textStyle:
                          Theme.of(context).textTheme.titleSmall,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),

              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Add A Thriver",style: GoogleFonts.montserrat(
                  color: Colors.black)),
                ),
                Text("(ID:TH0010) ",style: GoogleFonts.montserrat(textStyle:
                Theme.of(context).textTheme.titleSmall,)),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              //height: MediaQuery.of(context).size.height*0.5,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: thriverNameTextEditingController,
                       // cursorColor: primaryColorOfApp,
                        onChanged: (value) {

                        },
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        decoration: InputDecoration(
                          //errorText: userAccountSearchErrorText,
                          contentPadding: EdgeInsets.all(25),
                          labelText: "Thriver Name",
                          hintText: "Thriver Name",
                          /*prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.question_mark_outlined,
                             // color: primaryColorOfApp
                              ),
                          ),*/
                          errorStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15)),
                          //hintText: "e.g Abouzied",
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: null,
                        controller: thriverDescTextEditingController,
                        //cursorColor: primaryColorOfApp,
                        onChanged: (value) {

                        },
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        decoration: InputDecoration(
                          //errorText: userAccountSearchErrorText,
                          contentPadding: EdgeInsets.all(25),
                          labelText: "Thriver Description",
                          hintText: "Thriver Description",
                          /*prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.question_mark_outlined,
                              //color: primaryColorOfApp
                              ),
                          ),*/
                          errorStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15)),
                          //hintText: "e.g Abouzied",
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                      ),
                    ),
                    //Country
                    Padding(
                      child: Container(
                        //width: size.width * 0.9,
                        child: TypeAheadField(
                          noItemsFoundBuilder: (BuildContext context) {

                            return ListTile(

                              title: Text("Enter a Valid Email Address",style: TextStyle(color: Colors.redAccent),),
                              //subtitle: Text("Add Some Details Here"),
                            );
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: countryTextEditingController,
                            //autofocus: true,

                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.w400,),

                         //   cursorColor: primaryColorOfApp,

                            decoration: InputDecoration(
                              //errorText: firstNameErrorText,

                              contentPadding: EdgeInsets.all(25),
                              hintText:  "Type & Search",
                              labelText: "Select Country",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              enabledBorder:OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              //hintText: "e.g Abouzied",
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            List<String> itemList = [];
                            await getAllCountries().then((value) {
                              value.forEach((element) {
                                if(element.name.contains(pattern)){
                                  itemList.add(element.name);
                                }
                              });
                            });
                            return itemList;
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
                            countryTextEditingController.text = suggestion;
                            // textEditingController.clear();
                            //mySelectedUsers.add(suggestion.toString());
                            //innerState((){});
                          },
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                    ),
                    //Job Roles
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                       // maxLines: null,
                        controller: textControllers[0],
                        //cursorColor: primaryColorOfApp,
                        onChanged: (value) {

                        },
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        decoration: InputDecoration(
                          //errorText: userAccountSearchErrorText,
                          contentPadding: EdgeInsets.all(25),
                          labelText: "Job Roles",
                          hintText: "Job Roles",
                          /*prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.question_mark_outlined,
                             // color: primaryColorOfApp
                              ),
                          ),*/
                          errorStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15)),
                          //hintText: "e.g Abouzied",
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                      ),
                    ),
                    //Industry
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        // maxLines: null,
                        controller: industryTextEditingController,
                        //cursorColor: primaryColorOfApp,
                        onChanged: (value) {

                        },
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        decoration: InputDecoration(
                          //errorText: userAccountSearchErrorText,
                          contentPadding: EdgeInsets.all(25),
                          labelText: "Industry",
                          hintText: "Industry",
                          /*prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.question_mark_outlined,
                              // color: primaryColorOfApp
                            ),
                          ),*/
                          errorStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),

                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15)),
                          //hintText: "e.g Abouzied",
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                      ),
                    ),
                    //Solution List

                    //SHow a dialog on checks with TREE
                    //On Selection Show them on with CHips


                    Padding(
                      child: Container(
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: challangesTextEditingController,
                            style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(25),
                              hintText:  "Type & Search",
                              labelText: "Select Challenges",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              enabledBorder:OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            List<DocumentSnapshot> itemList = [];
                            await FirebaseFirestore.instance.collection('Challenges')
                                .where('ChallengeName', isGreaterThanOrEqualTo: pattern)
                                .where('ChallengeName', isLessThanOrEqualTo: pattern + '\uf8ff')
                                .get().then((value) {
                              itemList.addAll(value.docs);
                            });
                            return itemList;
                          },
                          itemBuilder: (context, suggestion) {
                            return CheckboxListTile(
                              value: challanges.contains(suggestion.get("ChallengeName")),
                              title: Text(suggestion.get("ChallengeName")),
                              onChanged: (value){
                                if(challanges.contains(suggestion.get("ChallengeName"))){
                                  challanges.remove(suggestion.get("ChallengeName"));
                                  challangeDocRefs.remove(suggestion.reference);
                                }else{
                                  challanges.add(suggestion.get("ChallengeName"));
                                  challangeDocRefs.add(suggestion.reference);
                                }
                                print("challanges");
                                print(challanges);
                              },
                              //subtitle: Text("Add Some Details Here"),
                            );
                          },

                          onSuggestionSelected: (suggestion) {
                            print("Im selected");
                            print(suggestion);
                          //  challanges
                            // textEditingController.clear();
                            //mySelectedUsers.add(suggestion.toString());
                            //innerState((){});
                          },
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Padding(
                      child: Container(
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: challangesTextEditingController,
                            style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(25),
                              hintText:  "Type & Search",
                              labelText: "Select Solutions",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              enabledBorder:OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            List<DocumentSnapshot> itemList = [];
                            await FirebaseFirestore.instance.collection('Solutions')
                                .where('Name', isGreaterThanOrEqualTo: pattern)
                                .where('Name', isLessThanOrEqualTo: pattern + '\uf8ff')
                                .get().then((value) {
                              itemList.addAll(value.docs);
                            });
                            return itemList;
                          },
                          itemBuilder: (context, suggestion) {
                            return CheckboxListTile(
                              value: challanges.contains(suggestion.get("Name")),
                              title: Text(suggestion.get("Name")),
                              onChanged: (value){
                                if(challanges.contains(suggestion.get("Name"))){
                                  challanges.remove(suggestion.get("Name"));
                                  challangeDocRefs.remove(suggestion.reference);
                                }else{
                                  challanges.add(suggestion.get("Name"));
                                  challangeDocRefs.add(suggestion.reference);
                                }
                                print("challanges");
                                print(challanges);
                              },
                              //subtitle: Text("Add Some Details Here"),
                            );
                          },

                          onSuggestionSelected: (suggestion) {
                            print("Im selected");
                            print(suggestion);
                            //  challanges
                            // textEditingController.clear();
                            //mySelectedUsers.add(suggestion.toString());
                            //innerState((){});
                          },
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                    ),
                   /* Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextButton(onPressed: (){
                            showSelectChallengesWidget();
                      }, child: Row(
                        children: [
                          Icon(Icons.arrow_drop_down_sharp),
                          Text("Select Challenges",
                                style: TextStyle(fontSize: 20),

                          ),
                        ],
                      )),
                    ),*/
                    false?Wrap(
                      spacing: 5,
                      children: List.generate(
                        10,
                            (index) {
                          return Chip(
                            label: Text(_animals[index].name),
                            onDeleted: () {
                              setState(() {
                                _animals.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                    ):Container(),
                   /* Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextButton(onPressed: (){
                        showSelectChallengesWidget();
                      }, child: Row(
                        children: [
                          Icon(Icons.arrow_drop_down_sharp),
                          Text("Select Solutions",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                    ),*/
                    false?Wrap(
                      spacing: 5,
                      children: List.generate(
                        10,
                            (index) {
                          return Chip(
                            label: Text(_animals[index].name),
                            onDeleted: () {
                              setState(() {
                                _animals.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                    ):Container(),
                  ]
              ),
            ),
          );
        }
    );
  }

  void showSelectChallengesWidget() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200,

                  height: 60,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border.all(
                        //color:primaryColorOfApp
                    width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                          textStyle:
                          Theme.of(context).textTheme.titleSmall,
                          fontWeight: FontWeight.bold,
                          //color: primaryColorOfApp
                      ),
                    ),
                  ),
                ),

              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200,
                  height: 60,
                  decoration: BoxDecoration(
                    color:Colors.deepPurple,
                    border: Border.all(
                        color:Colors.deepPurple,
                        width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      'Okay',
                      style: GoogleFonts.montserrat(
                          textStyle:
                          Theme.of(context).textTheme.titleSmall,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),

              ),
            ],
            title:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select Challenges",style: GoogleFonts.montserrat(
                  color: Colors.black)),
            ),
            content: SizedBox(
              width: double.maxFinite*0.7,
              child: TreeView(
                data: treeData,
                lazy: true,
                load: _load,
              //  showActions: true,
                showCheckBox: true,
                showFilter: true,
                append: (parent) {
                  print(parent.extra);
                  return TreeNodeData(
                    title: 'Appended',
                    expaned: true,
                    checked: true,
                    children: [],
                  );
                },
                onLoad: (node) {
                  print('onLoad');
                  print(node);
                },
                onAppend: (node, parent) {
                  print('onAppend');
                  print(node);
                },
                onCheck: (checked, node) {
                  print('checked');
                  print('onCheck');
                  print(node);
                },
                onCollapse: (node) {
                  print('onCollapse');
                  print(node);
                },
                onExpand: (node) {
                  print('onExpand');
                  print(node);
                },
                onRemove: (node, parent) {
                  print('onRemove');
                  print(node);
                },
                onTap: (node) {
                  print('onTap');
                  print(node);
                },
              ),
            ),
          );
        }
    );
  }

  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.deepPurple, // Change the color to your desired background color
      child: Center(
        child: Text(
          'Welcome to Thriver Dashboard',
          style: TextStyle(
            color: Colors.white, // Change the text color to your desired color
            fontSize: 24.0, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
