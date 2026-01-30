import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class WisataImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const WisataImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:image')) {
      final base64Str = imageUrl.split(',').last;
      final Uint8List bytes = base64Decode(base64Str);
      return Image.memory(
        bytes,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
