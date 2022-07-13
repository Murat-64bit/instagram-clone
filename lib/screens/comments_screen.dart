import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final post;

  CommentsScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  void postComment(
      String description, String username, profImage, postId) async {
    try {
      String res = await FirestoreMethods()
          .addComment(_descriptionController.text, username, profImage, postId);
      if (res == "succes") {
        showSnackBar("Posted!", context);
      } else {
        showSnackBar(res, context);
      }
    } catch (er) {
      showSnackBar(er.toString(), context);
    }
    
      setState(() {
        _descriptionController.text="";
      });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post['postId'])
            .collection('comments')
            .orderBy('datePublished',descending: true)
            .snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(itemCount: (snapshot.data as dynamic).docs.length,itemBuilder: ((context, index) => CommentCard(
            snap: (snapshot.data as dynamic).docs[index].data(),
          )));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Comment as username",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(_descriptionController.text,
                    user.username, user.photoUrl, widget.post['postId']),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: blueColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
