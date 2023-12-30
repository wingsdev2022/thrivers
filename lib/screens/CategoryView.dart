import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryTreeView extends StatefulWidget {
  @override
  _CategoryTreeViewState createState() => _CategoryTreeViewState();
}

class _CategoryTreeViewState extends State<CategoryTreeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category TreeView'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final List<Widget> nodes = [];

          for (QueryDocumentSnapshot categoryDocument in snapshot.data!.docs) {
            String categoryName = categoryDocument['name'];

            // Fetch data from "Thrivers" where category matches
            FirebaseFirestore.instance
                .collection('Thrivers')
                .where('category', isEqualTo: categoryName)
                .get()
                .then((thriversSnapshot) {
              List<Widget> thriverNodes = [];

              for (QueryDocumentSnapshot thriverDocument in thriversSnapshot.docs) {
                String thriverName = thriverDocument['name'];
                thriverNodes.add(ListTile(title: Text(thriverName)));
              }

              // Create a parent node with child nodes
              Widget categoryNode = ExpansionTile(
                title: Text(categoryName),
                children: thriverNodes,
              );

              // Add the parent node to the list
              nodes.add(categoryNode);

              // Notify the stream builder to rebuild
              if (mounted) {
                setState(() {});
              }
            });
          }

          return ListView(children: nodes);
        },
      ),
    );
  }
}
