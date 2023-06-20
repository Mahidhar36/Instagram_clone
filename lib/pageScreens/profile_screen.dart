import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  String username = "";
  String userbio = "";
   int followers=0;
   int following=0;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  Future<void> fetchUserData() async {
    try {
      final userDoc =
      await FirebaseFirestore.instance.collection("users").doc(userid).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        username = userData['username'];
        userbio = userData['Bio'];
        following=userData['following'].length;
        followers=userData['followers'].length;
      });
    } catch (error) {
      // Handle error if the user data retrieval fails
    }
  }
  int _currentTabIndex = 0;
 int posts=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black45,
          title: Text("Profile"),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: ListView(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(children: [
                      GestureDetector(
                        onTap: () {},
                        child: const CircleAvatar(

                          radius: 40,
                        ),
                      ),
                      Text(username),
                      Text(userbio),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(children: [
                      buildStatColumn(posts, "posts"),
                      const SizedBox(
                        width: 20,
                      ),
                      buildStatColumn(followers, "followers"),
                      const SizedBox(
                        width: 20,
                      ),
                      buildStatColumn(following, "following"),
                    ]),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Text("Edit Profile"),
                    color: Colors.grey,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Text("Share Profile"),
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              initialIndex: _currentTabIndex,
              child: Column(
                children: [
                  TabBar(
                    onTap: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                    tabs: const [
                      Tab(
                        text: 'Posts',
                        icon: Icon(Icons.grid_on_rounded),
                      ),
                      Tab(
                          text: 'Videos',
                          icon: Icon(Icons.slow_motion_video_sharp)),
                    ],
                  ),
                  SizedBox(
                    height: 300, // Set the height as per your requirement
                    child: TabBarView(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .where('userId', isEqualTo: userid)
                                .snapshots(),
                            builder: (dontext,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisExtent: 300,
                                    mainAxisSpacing: 2.0,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                  // Replace 'images' with your list of image URLs
                                  itemBuilder: (context, index) {

                                      posts=snapshot.data!.docs.length;

                                    final doc = snapshot.data!.docs[index];
                                    String url = doc['imageUrl'];
                                    return Image.network(url);
                                  },
                                );
                              }
                            }),
                        // Other content goes here for the 'Other Tab'
                        Container(
                          color: Colors
                              .black38, // Example container for demonstration
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ]));
  }
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}
