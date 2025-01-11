import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            //header section
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: ['Delete']
                                      .map((e) => InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList()),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),

          //image section
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
              ),
              LikeAnimation(
                isAnimating: isLikeAnimating,
                onEnd: () {
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                duration: const Duration(milliseconds: 400),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                ),
              )
            ]),
          ),

          //like,comment section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.comment_outlined,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                    color: Colors.red,
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
              ))
            ],
          ),

          //description and number of comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length.toString()} likes',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        )
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                      'view all 200 comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMEd()
                        .format(widget.snap['datePublished'].toDate())
                        .toString(),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
