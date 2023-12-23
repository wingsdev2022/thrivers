import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/apphelper.dart';
import '../core/constants.dart';
import 'addthriverscreen.dart';



class HomeScreenTabs extends StatefulWidget {



  const HomeScreenTabs({Key? key,}) : super(key: key);

  @override
  State<HomeScreenTabs> createState() => _HomeScreenTabsState();
}

class _HomeScreenTabsState extends State<HomeScreenTabs> {

  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppHelper().CustomAppBar(context),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              itemBorderRadius: BorderRadius.circular(0),
              // showTooltip: false,
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: primaryColorOfApp.withAlpha(50),
                selectedColor: primaryColorOfApp,
                selectedTitleTextStyle: const TextStyle(color: Colors.black),
                selectedIconColor: Colors.black,
                backgroundColor: Colors.black,
                unselectedIconColor: primaryColorOfApp,
                unselectedTitleTextStyle: TextStyle(color: primaryColorOfApp)
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                SizedBox(height: 20,),
                /*ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),*/
                SizedBox(height: 20,),
                Text("Admin Panel" , style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.headlineMedium,

                    color: primaryColorOfApp)),
                Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Wings Co Pvt Ltd',
                style: TextStyle(fontSize: 15),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.home),
                //badgeColor: Colors.amber,
                //badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                //tooltipContent: "Dashboard Is Under Construction!",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Add A Thriver',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.event_note),
              ),
              /*SideMenuItem(
                priority: 2,
                title: 'Profiles',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.supervisor_account),
                *//*trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )),*//*
              ),*/

              SideMenuItem(
                priority: 2,
                title: 'Add a Challenge',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Add A Challenge",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.book_online_sharp),
              ),

              SideMenuItem(
                priority: 3,
                title: 'Add A Solution',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Add A Solution",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.article),
              ),
              SideMenuItem(
                priority: 4,
                title: 'User Listing',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "User Listing",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.people_alt_outlined),
              ),
              // SideMenuItem(
              //   priority: 5,
              //   onTap:(page){
              //     sideMenu.changePage(5);
              //   },
              //   icon: const Icon(Icons.image_rounded),
              // ),
              // SideMenuItem(
              //   priority: 6,
              //   title: 'Only Title',
              //   onTap:(page){
              //     sideMenu.changePage(6);
              //   },
              // ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                DashBoardScreen(),
                AddThriversScreen(),
                AddThriversScreen(),
                AddThriversScreen(),
                /*AddChallenges(),
                AddSolutionsScreen,
                UserListingScreen()*/
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget DashBoardScreen(){
    return Scaffold(
      //appBar:AppHelper().CustomAppBarForRetailHub(context),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://e0.pxfuel.com/wallpapers/1/408/desktop-wallpaper-expo-2020-dubai-live-from-the-opening-ceremony.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 470,
            height: 300,
            child: Card(
              color: Colors.black,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Let's Create ,",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: primaryColorOfApp,
                        fontWeight: FontWeight.bold,

                      ),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0,bottom: 10),
                      child: Text("What would you like to create Today",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300

                      ),),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(1);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: primaryColorOfApp,
                                    border: Border.all(color:primaryColorOfApp, width: 2.0),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.event,color: Colors.black,size: 30,),
                                      Text(
                                        'Thrivers',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(2);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: primaryColorOfApp,
                                    border: Border.all(color:primaryColorOfApp, width: 2.0),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.book_online_sharp,color: Colors.black,size: 30,),
                                      Text(
                                        'Challanges',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(4);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: primaryColorOfApp,
                                    border: Border.all(color:primaryColorOfApp, width: 2.0),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.person_outline_outlined,color: Colors.black,size: 30,),
                                      Text(
                                        'User',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(4);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: primaryColorOfApp,
                                    border: Border.all(color:primaryColorOfApp, width: 2.0),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.article,color: Colors.black,size: 30,),
                                      Text(
                                        'Solutions',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}



