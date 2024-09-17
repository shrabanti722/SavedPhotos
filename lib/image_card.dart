import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider_app/image_list_model.dart';

class ImageCard extends StatelessWidget {
  final ImageListModel? imageData;
  final bool isSelected;
  const ImageCard({super.key, this.imageData, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        SizedBox(
          height: isSelected ?  MediaQuery.of(context).size.width * .70 : MediaQuery.of(context).size.width * .47 ,
          width: isSelected ?  MediaQuery.of(context).size.width * .70 : MediaQuery.of(context).size.width * .47,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: "${imageData!.url}",
              fit: BoxFit.cover,
              fadeOutDuration: Duration.zero,
              fadeInDuration: Duration.zero,
              placeholder: (context, _) => Image.asset(
                "assets/catPlaceHolder.png",
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
              errorWidget: (context, _, __) => Image.asset(
                "assets/catPlaceHolder.png",
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
              useOldImageOnUrlChange: true,
              placeholderFadeInDuration: Duration.zero,
            ),
          ),
        ),
      ],
    );
  }
}
