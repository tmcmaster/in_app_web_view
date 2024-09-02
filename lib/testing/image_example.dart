import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_web_view/utils/log.dart';

class ImageExample extends StatelessWidget {
  static final log = Log.d();

  final bool cache;

  const ImageExample({super.key, this.cache = false});

  @override
  Widget build(BuildContext context) {
    return cache
        ? CachedNetworkImage(
            imageUrl:
                'https://d2j6dbq0eux0bg.cloudfront.net/images/91265507/3962209852.jpg',
            httpHeaders: const {'Access-Control-Allow-Origin': '*'},
            imageBuilder: (context, image) => Image(
              image: image,
              fit: BoxFit.cover,
            ),
            errorWidget: (_, url, error) {
              print('Could not log Image($url): Error($error)');
              return Center(
                child: Icon(
                  FontAwesomeIcons.solidImage,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
              );
            },
            errorListener: (error) {
              print('COULD NOT RENDER IMAGE: $error');
            },
          )
        : Image.network(
            'https://d2j6dbq0eux0bg.cloudfront.net/images/91265507/3962209852.jpg',
            errorBuilder: (_, error, __) {
              return Text(error.toString());
            },
          );
  }
}
