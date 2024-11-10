import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedImageWidget({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10), // Optional border radius
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover, // Default to BoxFit.cover
        placeholder: (context, url) => placeholder ??
            const Center(
              child: CircularProgressIndicator(), // Default loading indicator
            ),
        errorWidget: (context, url, error) => errorWidget ??
            const Center(
              child: Icon(Icons.error, color: Colors.red), // Default error icon
            ),
      ),
    );
  }
}
