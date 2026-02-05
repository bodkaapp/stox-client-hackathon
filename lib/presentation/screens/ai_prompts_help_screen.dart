import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/app_colors.dart';

class AiPromptsHelpScreen extends StatefulWidget {
  const AiPromptsHelpScreen({super.key});

  @override
  State<AiPromptsHelpScreen> createState() => _AiPromptsHelpScreenState();
}

class _AiPromptsHelpScreenState extends State<AiPromptsHelpScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() { _isLoading = true; });
          },
          onPageFinished: (String url) {
            if (mounted) setState(() { _isLoading = false; });
          },
        ),
      )
      ..loadFlutterAsset('assets/html/ai_prompts_help.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(
        backgroundColor: AppColors.stoxBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.stoxText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AIへの指示テキスト例', // ユーザーリクエスト通りの文言。ローカライズが必要な場合は後で検討。
          style: TextStyle(
            color: AppColors.stoxText,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.stoxPrimary),
            ),
        ],
      ),
    );
  }
}
