import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_collage/src/models/image.dart';
import 'package:image_collage/src/models/image_layout.dart';
import 'package:image_collage/src/models/image_source.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ShowImage extends StatelessWidget {
  // Widget that render each image
  const ShowImage(
      {Key? key,
      required this.image,
      required this.margin,
      required this.width,
      required this.noImageText,
      required this.noImageBackgroundColor,
      required this.callBack,
      required this.layout,
      this.customCacheManager,
      this.isLast = false})
      : super(key: key);
  // image object
  final Img image;
  // layout:  full, half, quarter
  final ImageLayout layout;
  // margin
  final EdgeInsets margin;
  // no Image Background Color
  final Color noImageBackgroundColor;
  // no Image Text
  final String noImageText;
  // width & height are linked to each other width = height = valueBelow
  final double width;
  // call back with the image
  final Function(Img) callBack;
  // is last to show the showmore
  final bool isLast;
  // cache manager
  final BaseCacheManager? customCacheManager;

  @override
  Widget build(BuildContext context) {
    late double size;
    if (width == 0) {
      size = MediaQuery.of(context).size.width - margin.left - margin.right;
    } else {
      size = width;
    }
    switch (image.source) {
      case ImageSource.assets:
        return GestureDetector(
          onTap: () => callBack(image),
          child: Image.asset(
            image.image,
            height: layout == ImageLayout.full
                ? size
                : layout == ImageLayout.half
                    ? size
                    : size / 2,
            width: layout == ImageLayout.full
                ? size
                : layout == ImageLayout.half
                    ? size / 2
                    : size / 2,
            fit: BoxFit.cover,
          ),
        );
      case ImageSource.network:
        final height = layout == ImageLayout.full
            ? size
            : layout == ImageLayout.half
                ? size
                : size / 2;
        final width = layout == ImageLayout.full
            ? size
            : layout == ImageLayout.half
                ? size / 2
                : size / 2;
        return GestureDetector(
          onTap: () => callBack(image),
          child: CachedNetworkImage(
            cacheManager: customCacheManager,
            imageUrl: image.image,
            placeholder: (context, url) {
              return Container(
                width: width,
                height: height,
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            },
            imageBuilder: (context, imageProvider) => Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => Container(
                width: width,
                height: height,
                color: Colors.black,
                child: const Text(
                  "⚠️",
                )),
          ),
        );
      default:
        return GestureDetector(
          onTap: () => callBack(image),
          child: Container(
            color: noImageBackgroundColor,
            height: layout == ImageLayout.full
                ? size
                : layout == ImageLayout.half
                    ? size
                    : size / 2,
            width: layout == ImageLayout.full
                ? size
                : layout == ImageLayout.half
                    ? size / 2
                    : size / 2,
            child: Text(noImageText),
          ),
        );
    }
  }
}
