import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String url;
  final double size;

  const ProfileImage({
    Key key,
    @required this.url,
    this.size = kToolbarHeight / 1.5,
  }) : super(key: key);

  Widget get placeholderImage => Icon(
        Icons.account_circle,
        color: Colors.black26,
        size: size,
      );

  @override
  Widget build(BuildContext context) {
    return url == null || url.trim().isEmpty
        ? placeholderImage
        : CachedNetworkImage(
            imageUrl: url,
            width: size,
            height: size,
            placeholder: (context, url) => placeholderImage,
            placeholderFadeInDuration: const MediumDuration(),
            errorWidget: (context, url, error) => placeholderImage,
          );
  }
}
