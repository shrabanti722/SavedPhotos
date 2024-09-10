import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider_app/image_card.dart';
import 'package:provider_app/image_list_view_model.dart';

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final ScrollController _scrollController = ScrollController();
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    var imageListViewModel = ImageListViewModel.read(context);
    Future.delayed(Duration.zero, () async {
      await imageListViewModel.getImageListData();
    });
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        imageListViewModel.getMoreImageListData();
      }
    });
  }

    @override
  void dispose() {
  _scrollController.dispose();
  super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var imageViewModel = ImageListViewModel.watch(context);
    var imageViewModelRead = ImageListViewModel.read(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .3,
        title: const Text(
          'Saved Photos',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            GridView.builder(
              controller: _scrollController,
              itemCount: imageViewModel.imageListData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: () {
                    setState(() {
                      selectedIndex = index;
                      debugPrint("${imageViewModelRead.imageListData[selectedIndex!]}");
                    });
                  },
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      debugPrint("${imageViewModelRead.imageListData[selectedIndex!]}");
                    });
                  },
                  child: Stack(
                    children: [
                      ImageCard(
                        imageData: imageViewModel.imageListData[index],
                      ),
                      if (selectedIndex != null && selectedIndex != index)
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            if (selectedIndex != null)
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = null;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image.network(
                            //   "${imageViewModelRead.imageListData[selectedIndex!]}",
                            //   fit: BoxFit.cover,
                            // ),
                            CachedNetworkImage(
                              imageUrl:
                                  "${imageViewModelRead.imageListData[selectedIndex!].url}",
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (imageViewModel.isMoreLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
