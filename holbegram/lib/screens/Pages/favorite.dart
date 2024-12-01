import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Widget Favorite, displaying the user's favorite posts
class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Adding space at the top of the screen
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          // Custom app bar
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            automaticallyImplyLeading: false,
            title: Container(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorites',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Billabong',
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          // Remaining part of the screen filled by the StreamBuilder
          SliverFillRemaining(
            child: StreamBuilder(
              // Listening to the data from the user's 'favorites' collection
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Error handling
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                // Displaying a loading circle if data is loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Retrieving favorite documents
                final favoriteDocs = snapshot.requireData.docs;

                // Displaying favorite posts as a list
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: favoriteDocs.length,
                  itemBuilder: (context, index) {
                    var favoriteDoc = favoriteDocs[index];

                    // FutureBuilder to retrieve details of the favorite post
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(favoriteDoc['postId'])
                          .get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> postSnapshot) {
                        // Error handling
                        if (postSnapshot.hasError) {
                          return Center(child: Text('Error: ${postSnapshot.error}'));
                        }
                        // Displaying a loading circle if data is loading
                        if (postSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        // Checking if the post exists
                        if (!postSnapshot.hasData || !postSnapshot.data!.exists) {
                          return Container();
                        }

                        // Retrieving post data
                        var post = postSnapshot.data!;

                        // Displaying the favorite post image
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(post['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
