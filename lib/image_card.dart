import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_app/image_card_notifier.dart';
import 'package:provider_app/image_list_model.dart';

class ImageCard extends ConsumerWidget {
  final ImageListModel imageData;
  final bool isSelected;

  const ImageCard({
    super.key,
    required this.imageData,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageCardNotifierProvider(imageData));

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        SizedBox(
          height: isSelected
              ? MediaQuery.of(context).size.width * 0.70
              : MediaQuery.of(context).size.width * 0.47,
          width: isSelected
              ? MediaQuery.of(context).size.width * 0.70
              : MediaQuery.of(context).size.width * 0.47,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageState.when(
              data: (imageUrl) => CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                fadeOutDuration: Duration.zero,
                fadeInDuration: Duration.zero,
                placeholder: (context, _) => Image.asset(
                  "assets/catPlaceHolder.png",
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
                errorWidget: (context, _, __) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(height: 10),
                      const Text('Failed to load image',
                          style: TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(imageCardNotifierProvider(imageData).notifier)
                              .retryImage();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.error, color: Colors.red),
                    // SizedBox(height: 10),
                    // Text('Failed to load image',
                    //     style: TextStyle(color: Colors.red)),
                    // SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     ref
                    //         .read(imageCardNotifierProvider(imageData).notifier)
                    //         .retryImage();
                    //   },
                    //   child: const Text('Retry'),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
