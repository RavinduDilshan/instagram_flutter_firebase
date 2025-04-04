import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(label: Text('search for a user')),
          onFieldSubmitted: (_) {
            isShowUsers = true;
            setState(() {});
          },
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: searchController.text)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return isShowUsers
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        uid: snapshot.data!.docs[index]['uid'],
                                      )));
                        },
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[index]['photoUrl'])),
                        title: Text(snapshot.data!.docs[index]['username']),
                      );
                    })
                : FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection('posts').get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return StaggeredGridView.countBuilder(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Image.network(
                              snapshot.data!.docs[index]['postUrl']),
                          staggeredTileBuilder: (index) => StaggeredTile.count(
                              (index % 7 == 0) ? 2 : 1,
                              (index % 7 == 0) ? 2 : 1));
                    });
          }),
    );
  }
}
