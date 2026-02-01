import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../domain/models/recipe.dart';
import '../../config/app_colors.dart';

class CookingModeScreen extends StatefulWidget {
  final List<Recipe> recipes;
  final int initialIndex;

  const CookingModeScreen({
    super.key,
    required this.recipes,
    this.initialIndex = 0,
  });

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

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

    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    // Tablet layout sync logic
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

  Future<void> _onPopInvoked(bool didPop) async {
    if (didPop) return;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('調理モードを終了しますか？'),
          content: const Text('調理モードを終了して前の画面に戻ります。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('終了する', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldPop == true && mounted) {
      setState(() {
        _shouldPop = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _shouldPop,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Hide default back button
          title: const Text(
            '調理モード',
            style: TextStyle(color: AppColors.stoxText, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
               if (_shouldPop) {
                 Navigator.of(context).pop();
               } else {
                 _onPopInvoked(false);
               }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.stoxText),
        ),
        body: Column(
          children: [
            if (widget.recipes.length > 1)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFE7E5E4))), // stone-200
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
      ),
    );
  }

  Widget _buildMobileLayout() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: widget.recipes.map((recipe) => _RecipeWebView(recipe: recipe)).toList(),
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
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    color: const Color(0xFFF5F5F4), // stone-100
                    child: Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stoxText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: _RecipeWebView(recipe: recipe)),
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

  const _RecipeWebView({required this.recipe});

  @override
  State<_RecipeWebView> createState() => _RecipeWebViewState();
}

class _RecipeWebViewState extends State<_RecipeWebView> with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  bool _isLoading = true;

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
      ..loadRequest(Uri.parse(widget.recipe.pageUrl));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
