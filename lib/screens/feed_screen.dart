import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/ic_instagram.svg',
            colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            height: 32),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.messenger_outline))
        ],
      ),
    );
  }
}
