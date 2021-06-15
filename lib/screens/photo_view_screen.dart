import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

@override
class PhotoViewScreen extends StatelessWidget {
  final String url;
  PhotoViewScreen(this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Hero(
            tag: 'image',
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => PhotoView(
                imageProvider: imageProvider,
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )));
  }
}
