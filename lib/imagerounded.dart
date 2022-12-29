import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class ImageRounded extends StatelessWidget {
  const ImageRounded({super.key, required this.imageurl});

  final String imageurl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageurl,
      imageBuilder: (context, imageProvider) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(
              imageurl,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
        color: Colors.deepOrangeAccent,
      ),
    );
  }
}
