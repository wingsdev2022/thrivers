import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_tree/flutter_tree.dart';


import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:thrivers/screens/addthriverscreen.dart';
import '../Network/FirebaseApi.dart';
import '../core/apphelper.dart';
import '../core/constants.dart';
import '../core/progress_dialog.dart';
import 'addthriverscreen.dart';

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
  List<Widget> nodes = [];

  List<String> categories = [];

  String? userAccountSearchErrorText;

  String searchText = '';

  List<String> mySelectedUsers = [];

  List<DocumentReference> challengesDocRefs = [];
  List<DocumentReference> solutionsDocRefs = [];

  bool showTreeView = false;

  static List<Animal> _animals = [];
  final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();
  //List<Animal> _selectedAnimals = [];
  List<Animal> _selectedAnimals2 = [];
  List<Animal> _selectedAnimals3 = [];
  //List<Animal> _selectedAnimals4 = [];
  List<Animal> _selectedAnimals5 = [];

  List<Map<String, dynamic>> treeListData = [];


  List<Map<String, dynamic>> initialTreeData = [];

  List<String> challanges = [];
  List<String> solutions = [];
  List<DocumentReference> challangeDocRefs = [];


  List<String> fieldNames = [];
  List<String> selectedFieldNames = [];
  List<String> categoriesStringList = [];
  List<String> subcategories = [];

  QuillController _controller = QuillController.basic();







  @override
  void initState() {
    super.initState();
    _fetchFieldNameFromFirebase();
    loadData();
    // Create a QuillController and set initial text
    _controller.document.insert(0, "Add Details here.");
  }





  void _fetchFieldNameFromFirebase() async {
    print("Fields Fetching");
    // Assuming you have a Firestore collection named 'challenge'
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Thrivers').limit(1).get();

    print("Fields Fetching");
    Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;

    List<String> fieldNamesList = data.keys.toList();
    print("Field Names: $fieldNamesList");

    fieldNamesList.forEach((element) {
      fieldNames.add(element);
    });
    setState(() {});
    print("Fields Fetched");
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
        backgroundColor: Colors.grey.withOpacity(0.2),
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Wrap(
            children: [
              HeaderWidget(),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        margin:EdgeInsets.only(left: 20),
                        width: MediaQuery.of(context).size.width*0.5,
                        child: TextField(
                          onChanged: (val){
                            searchText = val;
                          },
                          onSubmitted: (v){
                            setState(() {

                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            hintText: 'Search Thriver By Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      /*Padding(
                        child: MultiSelectDialogField(
                          buttonText: Text(
                            "Select Fields to Hide",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 16,
                            ),
                          ),
                          title: Text("Select Fields to Hide"),
                          items: fieldNames
                              .map((e) => MultiSelectItem(e, e))
                              .toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            selectedFieldNames = values;
                            setState(() {});
                          },
                        ),
                        padding: EdgeInsets.only(top: 25, bottom: 20, right: 20),
                      ),*/
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
                      Container(width: MediaQuery.of(context).size.width*0.01,)
                    ],
                  )
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
            //  backgroundColor: Colors.grey.withOpacity(0.2),


              showTreeView?StreamBuilder(
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



                  return  Container(
                    child: ListView.separated(

                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      physics: BouncingScrollPhysics(),
                      itemCount: documents.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        //print('Images ${documents[index]['Images'].length}');
                        //todo Pass this time

                        return ThriversListTile(documents[index]);

                      },
                    ),
                  );
                },
              ):FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Reset the list of nodes
                  // nodes.clear();

                  print("Hola");
                  print(nodes.length);

                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: nodes.length,
                      itemBuilder: (context, index) {
                        return nodes[index];
                      },
                    ),
                  );
                },
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Define an async function to fetch data from Firestore
  Future<void> fetchData() async {

    //Fetch Categories Fetch Subcategories and then make a tree



    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Categories').get();

    // Return the list of documents
    List<DocumentSnapshot> categories = querySnapshot.docs;



    for (DocumentSnapshot categoryDocument in categories) {
      String categoryName = categoryDocument['Name'];
      print("Category Name"+categoryName);

      // Fetch data from "Thrivers" where category matches
      var thriversSnapshot = await FirebaseFirestore.instance
          .collection('Thrivers')
          .where('Category', isEqualTo: categoryName)
          .get();

      List<Widget> thriverNodes = [];

      for (QueryDocumentSnapshot thriverDocument in thriversSnapshot.docs) {
        String thriverName = thriverDocument['Name'];
        print("category name"+thriverName);
        thriverNodes.add(ListTile(title: Text(thriverName,style: TextStyle(color: Colors.black),)));
      }



      // Create a parent node with child nodes
      Widget categoryNode = ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(categoryName,style: TextStyle(color: Colors.black),),
        children: thriverNodes,
      );


      if(!categoriesStringList.contains(categoryName)){
        categoriesStringList.add(categoryName);
        // Add the parent node to the list
        nodes.add(categoryNode);
      }


    }

    // Trigger a rebuild by calling setState
    /*if (mounted) {
      setState(() {});
    }*/
  }

  Widget ThriversListTile(DocumentSnapshot<Object?> thriversDetails) {
    print("thriversDetails");
    print(thriversDetails.data());
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.2,
            child:Row(
              children: [
                SizedBox(width: 10,),
                Text(thriversDetails.id,style: Theme.of(context).textTheme.bodySmall),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !selectedFieldNames.contains("Name")?Text(thriversDetails['Name'],style: Theme.of(context).textTheme.titleMedium):Container(),
                    !selectedFieldNames.contains("Description")?Text(thriversDetails['Description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey)):Container(),
                  ],
                ),
              ],
            ),
          ),
          !selectedFieldNames.contains("Country")?Container(
            width: MediaQuery.of(context).size.width*0.1,
            child: Row(
              children: [
                Icon(Icons.circle,size: 10,),
                SizedBox(width: 10,),
                Expanded(child: Text(thriversDetails["Country"],style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,)),
                SizedBox(width: 10,),
              ],
            ),
          ):Container(),
          !selectedFieldNames.contains("JobRoles")?Container(
            width: MediaQuery.of(context).size.width*0.1,
            child: Row(
              children: [
                Icon(Icons.circle,size: 10,),
                SizedBox(width: 10,),
                Expanded(child:Text(thriversDetails["JobRoles"],style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,),),
                SizedBox(width: 10,),
              ],
            ),
          ):Container(),
          !selectedFieldNames.contains("Industry")?Container(
            width: MediaQuery.of(context).size.width*0.1,
            child: Row(
              children: [
                Icon(Icons.circle,size: 10,),
                SizedBox(width: 10,),
                Expanded(child:Text(thriversDetails["Industry"],style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,),
                )
              ],
            ),
          ):Container(),
          !selectedFieldNames.contains("Industry")?Container(
            width: MediaQuery.of(context).size.width*0.1,
            child: Row(
              children: [
                Icon(Icons.circle,size: 10,),
                SizedBox(width: 10,),
                Expanded(child: Text(thriversDetails["Industry"],style: Theme.of(context).textTheme.bodySmall),)
              ],
            ),
          ):Container(),
          Container(

            child: Row(
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
                IconButton(
                    iconSize: 30,
                    color: primaryColorOfApp,
                    onPressed: () async {
                      showEditThriverDialogBox((fn) { });
                    },
                    icon: Icon(Icons.edit,)),
                SizedBox(width: 30,),
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

                IconButton(
                    iconSize: 30,
                    color: primaryColorOfApp,
                    onPressed: () async {
                      ProgressDialog.show(context, "Deleting Users",Icons.person);
                      await ApiRepository().DeleteSectionPreset(thriversDetails.reference);
                      ProgressDialog.hide();
                    },
                    icon: Icon(Icons.delete,)),
                SizedBox(width: 20,),
              ],
            ),
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


   /* detail - field like Slack input ‪field
    link a chal - dialogbox with searchable tree with Multiselect checkbox

    At Bottom Non Required
    country and roles , industry
    Add a challenge same fields as thriver

    Edit Thriver just like add thriver but fields
    Thriver Details Page - Like AXS*/


    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(

        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
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
                          width: 1.0),
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
                      color:Colors.blue,
                      border: Border.all(
                          color:Colors.blue,
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
                    child: Text("Add A Thriver",style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                    color: Colors.black)),
                  ),
                  //Text("(ID:TH0010) ",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                //height: MediaQuery.of(context).size.height*0.5,
                child: SingleChildScrollView(
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
                              labelText: "Name",
                              hintText: "Name",
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
                                  color: Colors.black),
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
                              labelText: "Description",
                              hintText: "Description",
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
                                  color: Colors.black),
                            ),
                          ),
                        ),

                        //Details
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black,width: 1)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                    maxHeight: 200,
                                    padding: EdgeInsets.only(left: 10,top: 10),
                                    controller: _controller,
                                    readOnly: false,
                                    sharedConfigurations: const QuillSharedConfigurations(
                                      locale: Locale('de'),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(),
                              QuillToolbar.simple(
                                configurations: QuillSimpleToolbarConfigurations(
                                  controller: _controller,
                                  sharedConfigurations: const QuillSharedConfigurations(
                                    locale: Locale('de'),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        //Solution List

                        //SHow a dialog on checks with TREE
                        //On Selection Show them on with CHips

                        ///Category & Subcategory
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDropDown.network(
                            padding: EdgeInsets.all(20),
                            hint: "Select Categories",
                            borderColor: Colors.black,
                            borderRadius: 15,
                            hintStyle:Theme.of(context).textTheme.bodyLarge,
                            backgroundColor: Colors.transparent,
                            onOptionSelected: (options) {
                              print(options.first.value);
                              categories.clear();
                              options.forEach((element) {
                                categories.add(element.label);
                                //  challangeDocRefs.add(element.value);
                              });

                              challanges.addAll(options as Iterable<String>);
                            },
                            networkConfig: NetworkConfig(
                              url: 'https://firestore.googleapis.com/v1/projects/thrivers-8aa27/databases/(default)/documents/Categories',
                              method: RequestMethod.get,
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            ),
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            responseParser: (response) {
                              print("Yeh Response Aaya hjai");
                              print(response);

                              // Check if the response is a Map and contains the 'documents' key
                              if (response is Map<String, dynamic> && response.containsKey('documents')) {
                                final List<dynamic> documents = response['documents'];
                                print(documents);

                                final list = documents.map((e) {
                                  final item = e['fields'] as Map<String, dynamic>;
                                  return ValueItem(
                                    label: item['Name']['stringValue'],
                                    value: item['Name']['stringValue'],
                                  );
                                }).toList();

                                return Future.value(list);
                              } else {
                                // Handle error or unexpected response format
                                print("Error: Unexpected response format");
                                return Future.error("Unexpected response format");
                              }
                            },
                            responseErrorBuilder: ((context, body) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Error fetching the data'),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDropDown.network(
                            padding: EdgeInsets.all(20),
                            borderColor: Colors.black,
                            hintStyle:Theme.of(context).textTheme.bodyLarge,
                            borderRadius: 15,
                            hint: "Select Subcategories",
                            backgroundColor: Colors.transparent,
                            onOptionSelected: (options) {
                              print(options.first.value);
                              subcategories.clear();
                              options.forEach((element) {
                                subcategories.add(element.label);
                                //  challangeDocRefs.add(element.value);
                              });

                              //subcategoriesDocRefs.addAll(options as Iterable<String>);
                            },
                            networkConfig: NetworkConfig(
                              url: 'https://firestore.googleapis.com/v1/projects/thrivers-8aa27/databases/(default)/documents/Subcategories',
                              method: RequestMethod.get,
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            ),
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            responseParser: (response) {
                              print("Yeh Response Aaya hjai");
                              print(response);

                              // Check if the response is a Map and contains the 'documents' key
                              if (response is Map<String, dynamic> && response.containsKey('documents')) {
                                final List<dynamic> documents = response['documents'];
                                print(documents);

                                final list = documents.map((e) {
                                  final item = e['fields'] as Map<String, dynamic>;
                                  return ValueItem(
                                    label: item['Name']['stringValue'],
                                    value: item['Name']['stringValue'],
                                  );
                                }).toList();

                                return Future.value(list);
                              } else {
                                // Handle error or unexpected response format
                                print("Error: Unexpected response format");
                                return Future.error("Unexpected response format");
                              }
                            },
                            responseErrorBuilder: ((context, body) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Error fetching the data'),
                              );
                            }),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDropDown.network(
                            padding: EdgeInsets.all(20),
                            hint: "Select Challenges",
                            borderColor: Colors.black,
                            borderRadius: 15,
                            hintStyle:Theme.of(context).textTheme.bodyLarge,
                            backgroundColor: Colors.transparent,
                            onOptionSelected: (options) {
                              print(options.first.value);
                              challanges.clear();
                              options.forEach((element) {
                                challanges.add(element.label);
                              //  challangeDocRefs.add(element.value);
                              });

                              challanges.addAll(options as Iterable<String>);
                            },
                            networkConfig: NetworkConfig(
                              url: 'https://firestore.googleapis.com/v1/projects/thrivers-8aa27/databases/(default)/documents/Challenges',
                              method: RequestMethod.get,
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            ),
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            responseParser: (response) {
                              print("Yeh Response Aaya hjai");
                              print(response);

                              // Check if the response is a Map and contains the 'documents' key
                              if (response is Map<String, dynamic> && response.containsKey('documents')) {
                                final List<dynamic> documents = response['documents'];
                                print(documents);

                                final list = documents.map((e) {
                                  final item = e['fields'] as Map<String, dynamic>;
                                  return ValueItem(
                                    label: item['ChallengeName']['stringValue'],
                                    value: item['ChallengeName']['stringValue'],
                                  );
                                }).toList();

                                return Future.value(list);
                              } else {
                                // Handle error or unexpected response format
                                print("Error: Unexpected response format");
                                return Future.error("Unexpected response format");
                              }
                            },
                            responseErrorBuilder: ((context, body) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Error fetching the data'),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDropDown.network(
                            padding: EdgeInsets.all(20),
                            borderColor: Colors.black,
                            hintStyle:Theme.of(context).textTheme.bodyLarge,
                            borderRadius: 15,
                            hint: "Select Solutions",
                            backgroundColor: Colors.transparent,
                            onOptionSelected: (options) {
                              print(options.first.value);
                              solutions.clear();
                              options.forEach((element) {
                                solutions.add(element.label);
                                //  challangeDocRefs.add(element.value);
                              });

                              solutions.addAll(options as Iterable<String>);
                            },
                            networkConfig: NetworkConfig(
                              url: 'https://firestore.googleapis.com/v1/projects/thrivers-8aa27/databases/(default)/documents/Solutions',
                              method: RequestMethod.get,
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            ),
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            responseParser: (response) {
                              print("Yeh Response Aaya hjai");
                              print(response);

                              // Check if the response is a Map and contains the 'documents' key
                              if (response is Map<String, dynamic> && response.containsKey('documents')) {
                                final List<dynamic> documents = response['documents'];
                                print(documents);

                                final list = documents.map((e) {
                                  final item = e['fields'] as Map<String, dynamic>;
                                  return ValueItem(
                                    label: item['Name']['stringValue'],
                                    value: item['Name']['stringValue'],
                                  );
                                }).toList();

                                return Future.value(list);
                              } else {
                                // Handle error or unexpected response format
                                print("Error: Unexpected response format");
                                return Future.error("Unexpected response format");
                              }
                            },
                            responseErrorBuilder: ((context, body) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Error fetching the data'),
                              );
                            }),
                          ),
                        ),


                        /*  Padding(
                          child: Container(
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: solutionsTextEditingController,
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
                                  value: solutions.contains(suggestion.get("Name")),
                                  title: Text(suggestion.get("Name")),
                                  onChanged: (value){
                                    if(solutions.contains(suggestion.get("Name"))){
                                      solutions.remove(suggestion.get("Name"));
                                      solutionsDocRefs.remove(suggestion.reference);
                                    }else{
                                      solutions.add(suggestion.get("Name"));
                                      solutionsDocRefs.add(suggestion.reference);
                                    }
                                    print("solutions");
                                    print(solutions);
                                  },
                                  //subtitle: Text("Add Some Details Here"),
                                );
                              },

                              onSuggestionSelected: (suggestion) {
                                print("Im selected");
                                print(suggestion);
                                solutions.forEach((element) {
                                  solutionsTextEditingController.text +=element + ",";
                                });
                                //  challanges
                                // textEditingController.clear();
                                //mySelectedUsers.add(suggestion.toString());
                                //innerState((){});
                              },
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                          child: Text("Optional Fields",style: GoogleFonts.montserrat(
                              color: Colors.black)),
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
                                  color: Colors.black),
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
                                  color: Colors.black),
                            ),
                          ),
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
              ),
            ),
          );
        }
    );
  }


  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Thriver',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void showEditThriverDialogBox(StateSetter innerState,) {


    /* detail - field like Slack input ‪field
    link a chal - dialogbox with searchable tree with Multiselect checkbox

    At Bottom Non Required
    country and roles , industry
    Add a challenge same fields as thriver

    Edit Thriver just like add thriver but fields
    Thriver Details Page - Like AXS*/


    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(

        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
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
                          width: 1.0),
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
                      color:Colors.blue,
                      border: Border.all(
                          color:Colors.blue,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
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
                    child: Text("Edit A Thriver",style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        color: Colors.black)),
                  ),
                  Text("(ID:TH0010) ",style: GoogleFonts.montserrat(textStyle:
                  Theme.of(context).textTheme.titleSmall,)),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                //height: MediaQuery.of(context).size.height*0.5,
                child: SingleChildScrollView(
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
                                  color: Colors.black),
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
                                  color: Colors.black),
                            ),
                          ),
                        ),

                        //Solution List

                        //SHow a dialog on checks with TREE
                        //On Selection Show them on with CHips

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDropDown.network(
                            padding: EdgeInsets.all(20),
                            hint: "Select Challenges",
                            borderColor: Colors.black,
                            borderRadius: 15,
                            hintStyle:Theme.of(context).textTheme.bodyLarge,
                            backgroundColor: Colors.transparent,
                            onOptionSelected: (options) {
                              print(options.first.value);
                              challanges.clear();
                              options.forEach((element) {
                                challanges.add(element.label);
                                //  challangeDocRefs.add(element.value);
                              });

                              challanges.addAll(options as Iterable<String>);
                            },
                            networkConfig: NetworkConfig(
                              url: 'https://firestore.googleapis.com/v1/projects/thrivers-8aa27/databases/(default)/documents/Challenges',
                              method: RequestMethod.get,
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            ),
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            responseParser: (response) {
                              print("Yeh Response Aaya hjai");
                              print(response);

                              // Check if the response is a Map and contains the 'documents' key
                              if (response is Map<String, dynamic> && response.containsKey('documents')) {
                                final List<dynamic> documents = response['documents'];
                                print(documents);

                                final list = documents.map((e) {
                                  final item = e['fields'] as Map<String, dynamic>;
                                  return ValueItem(
                                    label: item['ChallengeName']['stringValue'],
                                    value: item['ChallengeName']['stringValue'],
                                  );
                                }).toList();

                                return Future.value(list);
                              } else {
                                // Handle error or unexpected response format
                                print("Error: Unexpected response format");
                                return Future.error("Unexpected response format");
                              }
                            },
                            responseErrorBuilder: ((context, body) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Error fetching the data'),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDropDown.network(
                            padding: EdgeInsets.all(20),
                            borderColor: Colors.black,
                            hintStyle:Theme.of(context).textTheme.bodyLarge,
                            borderRadius: 15,
                            hint: "Select Solutions",
                            backgroundColor: Colors.transparent,
                            onOptionSelected: (options) {
                              print(options.first.value);
                              solutions.clear();
                              options.forEach((element) {
                                solutions.add(element.label);
                                //  challangeDocRefs.add(element.value);
                              });

                              solutions.addAll(options as Iterable<String>);
                            },
                            networkConfig: NetworkConfig(
                              url: 'https://firestore.googleapis.com/v1/projects/thrivers-8aa27/databases/(default)/documents/Solutions',
                              method: RequestMethod.get,
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            ),
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            responseParser: (response) {
                              print("Yeh Response Aaya hjai");
                              print(response);

                              // Check if the response is a Map and contains the 'documents' key
                              if (response is Map<String, dynamic> && response.containsKey('documents')) {
                                final List<dynamic> documents = response['documents'];
                                print(documents);

                                final list = documents.map((e) {
                                  final item = e['fields'] as Map<String, dynamic>;
                                  return ValueItem(
                                    label: item['Name']['stringValue'],
                                    value: item['Name']['stringValue'],
                                  );
                                }).toList();

                                return Future.value(list);
                              } else {
                                // Handle error or unexpected response format
                                print("Error: Unexpected response format");
                                return Future.error("Unexpected response format");
                              }
                            },
                            responseErrorBuilder: ((context, body) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Error fetching the data'),
                              );
                            }),
                          ),
                        ),


                        /*  Padding(
                          child: Container(
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: solutionsTextEditingController,
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
                                  value: solutions.contains(suggestion.get("Name")),
                                  title: Text(suggestion.get("Name")),
                                  onChanged: (value){
                                    if(solutions.contains(suggestion.get("Name"))){
                                      solutions.remove(suggestion.get("Name"));
                                      solutionsDocRefs.remove(suggestion.reference);
                                    }else{
                                      solutions.add(suggestion.get("Name"));
                                      solutionsDocRefs.add(suggestion.reference);
                                    }
                                    print("solutions");
                                    print(solutions);
                                  },
                                  //subtitle: Text("Add Some Details Here"),
                                );
                              },

                              onSuggestionSelected: (suggestion) {
                                print("Im selected");
                                print(suggestion);
                                solutions.forEach((element) {
                                  solutionsTextEditingController.text +=element + ",";
                                });
                                //  challanges
                                // textEditingController.clear();
                                //mySelectedUsers.add(suggestion.toString());
                                //innerState((){});
                              },
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                          child: Text("Optional Fields",style: GoogleFonts.montserrat(
                              color: Colors.black)),
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
                                  color: Colors.black),
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
                                  color: Colors.black),
                            ),
                          ),
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
              ),
            ),
          );
        }
    );
  }

}


