import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image/image.dart' as img;
import '../../domain/models/recipe.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../config/app_colors.dart';
import '../../infrastructure/services/cooking_mode_service.dart';
import '../widgets/ingredient_pip_view.dart';
import '../widgets/crop_selection_overlay.dart';

class CookingModeScreen extends ConsumerStatefulWidget {
  final List<Recipe> recipes;
  final int initialIndex;

  const CookingModeScreen({
    super.key,
    required this.recipes,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends ConsumerState<CookingModeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late AnimationController _headerController;
  late Animation<Offset> _headerOffsetAnimation;
  
  Uint8List? _pipImageData;
  Uint8List? _pipThumbnailData;
  bool _isProcessing = false;
  bool _isSelectingArea = false;
  Uint8List? _fullScreenshotData;
  double _lastScrollY = 0;
  late List<GlobalKey<_RecipeWebViewState>> _recipeWebViewKeys;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.recipes.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _pageController = PageController(
      initialPage: widget.initialIndex ~/ 3,
    );
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _headerOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.2),
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeInOut,
    ));

    _recipeWebViewKeys = List.generate(
      widget.recipes.length,
      (index) => GlobalKey<_RecipeWebViewState>(),
    );

    _tabController.addListener(_handleTabSelection);
    
    // Set initial state for cooking mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cookingModeServiceProvider.notifier).setCookingMode(true);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _pageController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (MediaQuery.of(context).size.width >= 600) {
      if (_tabController.indexIsChanging) {
        final targetPage = _tabController.index ~/ 3;
        if (_pageController.hasClients && _pageController.page?.round() != targetPage) {
          _pageController.animateToPage(
            targetPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  bool _shouldPop = false;

  String _truncateTitle(String title) {
    if (title.length <= 23) {
      return title;
    }
    return '${title.substring(0, 10)}...${title.substring(title.length - 10)}';
  }

  Future<void> _exitCookingMode() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.cookingModeExitConfirm),
          content: Text(AppLocalizations.of(context)!.cookingModeExitDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.actionCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.actionFinish, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldPop == true && mounted) {
      await ref.read(cookingModeServiceProvider.notifier).setCookingMode(false);
      setState(() {
        _shouldPop = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  void _onScroll(int x, int y) {
    // Webview reports scroll position in pixels. 
    // Swipe up (scroll down) -> Close header
    // Swipe down (scroll up) -> Open header
    final delta = y - _lastScrollY;
    
    if (delta > 10) { // Scrolling down significantly
      if (!_headerController.isAnimating && _headerController.value == 0) {
        _headerController.forward();
      }
    } else if (delta < -10 || y <= 0) { // Scrolling up significantly or reached top
      if (!_headerController.isAnimating && _headerController.value == 1) {
        _headerController.reverse();
      }
    }
    _lastScrollY = y.toDouble();
  }

  void _handleCropSelection(Rect rect) async {
    if (_fullScreenshotData == null) return;
    
    setState(() {
      _isSelectingArea = false;
      _isProcessing = true;
    });

    try {
      final img.Image? decoded = img.decodeImage(_fullScreenshotData!);
      if (decoded == null) return;

      // The rect is in logical pixels. We need to map it to the screenshot pixels.
      // RepaintBoundary was captured with pixelRatio: 3.0
      const double captureRatio = 3.0;
      
      final int x = (rect.left * captureRatio).toInt().clamp(0, decoded.width);
      final int y = (rect.top * captureRatio).toInt().clamp(0, decoded.height);
      final int w = (rect.width * captureRatio).toInt().clamp(0, decoded.width - x);
      final int h = (rect.height * captureRatio).toInt().clamp(0, decoded.height - y);

      if (w <= 10 || h <= 10) return;

      final img.Image cropped = img.copyCrop(decoded, x: x, y: y, width: w, height: h);
      
      // Memory management: Resize if too large
      img.Image resized = cropped;
      if (cropped.width > 800) {
        resized = img.copyResize(cropped, width: 800);
      }
      
      final Uint8List croppedBytes = Uint8List.fromList(img.encodePng(resized));
      setState(() {
        _pipImageData = croppedBytes;
      });
    } catch (e) {
      debugPrint('Error cropping manual selection: $e');
    } finally {
      setState(() {
        _isProcessing = false;
        _fullScreenshotData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _shouldPop,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _exitCookingMode();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: widget.recipes.length > 1 ? kToolbarHeight + 48 : kToolbarHeight),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 600) {
                        return _buildTabletLayout();
                      } else {
                        return _buildMobileLayout();
                      }
                    },
                  ),
                ),
              ],
            ),
            if (!_isSelectingArea)
              SlideTransition(
                position: _headerOffsetAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      title: null,
                      actions: [
                        if (_pipThumbnailData != null || _pipImageData != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (_pipThumbnailData != null) {
                                  setState(() {
                                    _pipImageData = _pipThumbnailData;
                                    _pipThumbnailData = null;
                                  });
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.stoxBorder),
                                    color: Colors.grey[200],
                                  ),
                                  child: Image.memory(
                                    (_pipThumbnailData ?? _pipImageData)!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.sticky_note_2),
                            onPressed: () {
                              final currentIndex = _tabController.index;
                              _recipeWebViewKeys[currentIndex].currentState?.initManualSelection();
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: OutlinedButton(
                            onPressed: _exitCookingMode,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.actionFinishShort,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      backgroundColor: Colors.white,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: AppColors.stoxText),
                      shape: const Border(bottom: BorderSide(color: AppColors.stoxBorder)),
                    ),
                    if (widget.recipes.length > 1)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: AppColors.stoxBorder)),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: AppColors.stoxPrimary,
                          unselectedLabelColor: AppColors.stoxSubText,
                          indicatorColor: AppColors.stoxPrimary,
                          tabs: widget.recipes.map((r) => Tab(text: _truncateTitle(r.title))).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            if (_pipImageData != null)
              IngredientPipView(
                imageData: _pipImageData!,
                onClose: () {
                  setState(() {
                    _pipThumbnailData = _pipImageData;
                    _pipImageData = null;
                  });
                },
              ),
            if (_isSelectingArea)
              CropSelectionOverlay(
                onCancel: () => setState(() {
                  _isSelectingArea = false;
                  _fullScreenshotData = null;
                }),
                onConfirm: _handleCropSelection,
              ),
            if (_isProcessing)
              Container(
                color: Colors.black26,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context)!.pipProcessing),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: widget.recipes.asMap().entries.map<Widget>((entry) {
        final index = entry.key;
        final recipe = entry.value;
        return _RecipeWebView(
          key: _recipeWebViewKeys[index],
          recipe: recipe,
          onScroll: _onScroll,
          onStartSelection: (data) => setState(() {
            _fullScreenshotData = data;
            _isSelectingArea = true;
          }),
          onProcessing: (val) => setState(() => _isProcessing = val),
        );
      }).toList(),
    );
  }

  Widget _buildTabletLayout() {
    final chunks = <List<Recipe>>[];
    for (var i = 0; i < widget.recipes.length; i += 3) {
      chunks.add(widget.recipes.sublist(
        i,
        i + 3 > widget.recipes.length ? widget.recipes.length : i + 3,
      ));
    }

    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: chunks.length,
      onPageChanged: (page) {
        final currentTab = _tabController.index;
        final currentTabPage = currentTab ~/ 3;
        if (currentTabPage != page) {
          final desiredTabIndex = page * 3;
          _tabController.animateTo(desiredTabIndex);
        }
      },
      itemBuilder: (context, index) {
        final chunk = chunks[index];
        return Row(
          children: chunk.map((recipe) => Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.stoxBorder),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    color: AppColors.stoxBannerBg,
                    child: Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stoxText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: _RecipeWebView(
                    key: _recipeWebViewKeys[widget.recipes.indexOf(recipe)],
                    recipe: recipe,
                    onScroll: _onScroll,
                    onStartSelection: (data) => setState(() {
                      _fullScreenshotData = data;
                      _isSelectingArea = true;
                    }),
                    onProcessing: (val) => setState(() => _isProcessing = val),
                  )),
                ],
              ),
            ),
          )).toList(),
        );
      },
    );
  }
}

class _RecipeWebView extends StatefulWidget {
  final Recipe recipe;
  final Function(int, int) onScroll;
  final Function(Uint8List) onStartSelection;
  final Function(bool) onProcessing;

  const _RecipeWebView({
    super.key,
    required this.recipe,
    required this.onScroll,
    required this.onStartSelection,
    required this.onProcessing,
  });

  @override
  State<_RecipeWebView> createState() => _RecipeWebViewState();
}

class _RecipeWebViewState extends State<_RecipeWebView> with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  bool _isLoading = true;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        ),
      )
      ..setOnScrollPositionChange((change) {
         widget.onScroll(change.x.toInt(), change.y.toInt());
      })
      ..loadRequest(Uri.parse(widget.recipe.pageUrl));
  }

  Future<void> initManualSelection() async {
    widget.onProcessing(true);
    try {
      // Take screenshot of the entire WebView area using RepaintBoundary
      final RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        widget.onProcessing(false);
        return;
      }
      
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List? fullImage = byteData?.buffer.asUint8List();
      
      if (fullImage != null) {
        widget.onStartSelection(fullImage);
      }
    } catch (e) {
      debugPrint('Error initiating manual selection: $e');
    } finally {
      widget.onProcessing(false);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: WebViewWidget(controller: _controller),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
