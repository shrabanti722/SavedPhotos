import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_app/image_card.dart';
import 'package:provider_app/image_list_controller.dart';
import 'package:provider_app/image_list_model.dart';

class ImageGrid extends ConsumerStatefulWidget {
  const ImageGrid({super.key});

  @override
  ConsumerState<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends ConsumerState<ImageGrid>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int? selectedIndex;
  GlobalKey? _selectedImageKey;
  Rect? _selectedImageRect;
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    var imageLisControllertNotifier =
        ref.read(imageListControllerProvider.notifier);

    Future.delayed(Duration.zero, () async {
      imageLisControllertNotifier.getImageListData();
    });
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        imageLisControllertNotifier.getMoreImageListData();
      }
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _blurAnimation =
        Tween<double>(begin: 0.0, end: 10.0).animate(_animationController);
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 0.1).animate(_animationController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateSelectedImageRect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedImageKey != null &&
          _selectedImageKey!.currentContext != null) {
        final RenderBox renderBox =
            _selectedImageKey!.currentContext!.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        setState(() {
          _selectedImageRect = Rect.fromLTWH(
              offset.dx, offset.dy - 115.0, size.width, size.height);
        });
      }
    });
  }

  Future<void> _handleSelectionChange() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _updateSelectedImageRect();
  }

  Future<void> _handleBlurAnimation() async {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final imageListState = ref.watch(imageListControllerProvider);
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: .3,
        title: const Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Saved Photos',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: imageListState.when(
              data: (imageState) {
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: imageState.images.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                        ),
                        itemBuilder: (context, index) {
                          bool isSelected = selectedIndex == index;
                          double scale = isSelected ? 1.2 : 1.0;

                          return GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                selectedIndex = index;
                                _selectedImageKey = GlobalKey();
                                _handleBlurAnimation();
                                _handleSelectionChange();
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                selectedIndex = null;
                                _selectedImageKey = null;
                                _selectedImageRect = null;
                                _animationController.reverse();
                              });
                            },
                            child: Stack(
                              children: [
                                if (selectedIndex != null)
                                  AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: _blurAnimation.value,
                                            sigmaY: _blurAnimation.value),
                                        child: Container(
                                          color: Colors.black.withOpacity(
                                              _opacityAnimation.value),
                                        ),
                                      );
                                    },
                                  ),
                                AnimatedScale(
                                  scale: scale,
                                  duration: const Duration(milliseconds: 300),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (selectedIndex == index) {
                                          selectedIndex = null;
                                          _selectedImageKey = null;
                                          _selectedImageRect = null;
                                          _animationController.reverse();
                                        } else {
                                          selectedIndex = index;
                                          _selectedImageKey = GlobalKey();
                                          _handleBlurAnimation();
                                          _handleSelectionChange();
                                        }
                                      });
                                    },
                                    child: ImageCard(
                                      imageData: imageState.images[index],
                                      isSelected: isSelected,
                                      key:
                                          isSelected ? _selectedImageKey : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          if (_selectedImageRect != null)
            Positioned(
              left: _selectedImageRect!.left,
              top: _selectedImageRect!.top,
              width: _selectedImageRect!.width * 1.2,
              height: _selectedImageRect!.height * 1.2,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = null;
                    _selectedImageKey = null;
                    _selectedImageRect = null;
                    _animationController.reverse();
                  });
                },
                child: ImageCard(
                  imageData: imageListState.maybeWhen(
                    data: (imageState) => imageState.images[selectedIndex!],
                    orElse: () => ImageListModel(),
                  ),
                  isSelected: true,
                ),
              ),
            ),
          if (imageListState.maybeWhen(data: (data) => data.isMoreLoading, orElse: () => false))
            const Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
