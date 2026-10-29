import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/network/env.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/settings_header.dart';

/// What [WebPage] shows; passed as the route's `extra`.
class WebPageArgs {
  const WebPageArgs({required this.title, required this.url});

  final String title;
  final String url;

  /// `GET /privacy-policy` on the server.
  static WebPageArgs get privacyPolicy => WebPageArgs(
    title: AppStrings.settingsPrivacyPolicy,
    url: _onServer('/privacy-policy'),
  );

  /// `GET /help-center` on the server.
  static WebPageArgs get helpCenter => WebPageArgs(
    title: AppStrings.settingsHelpCenter,
    url: _onServer('/help-center'),
  );

  /// [path] on [Env.baseUrl], so it follows the `.env` server.
  static String _onServer(String path) =>
      Uri.parse(Env.baseUrl).resolve(path).toString();
}

/// A page from our server (Privacy Policy, Help Center) in a web view,
/// under the same header as Settings, with a progress bar while loading
/// and a retry message if it fails.
class WebPage extends StatefulWidget {
  const WebPage({super.key, required this.args});

  final WebPageArgs args;

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Matches the page while it loads instead of flashing white.
    _controller.setBackgroundColor(context.appColors.background);
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => _failed = false);
          },
          onWebResourceError: (error) {
            // Only the page itself failing matters, not an image on it.
            if (error.isForMainFrame != false && mounted) {
              setState(() => _failed = true);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.args.url));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SettingsHeader(
              title: widget.args.title,
              showGear: false,
              onBack: () async {
                // Back steps through pages opened inside the web view first.
                if (await _controller.canGoBack()) {
                  await _controller.goBack();
                } else if (context.mounted) {
                  Navigator.of(context).maybePop();
                }
              },
            ),
            if (_progress < 100 && !_failed)
              LinearProgressIndicator(
                value: _progress / 100,
                minHeight: 2,
                color: AppColors.toggleOn,
                backgroundColor: Colors.transparent,
              ),
            Expanded(
              child: _failed
                  ? _LoadFailed(
                      onRetry: () {
                        setState(() {
                          _failed = false;
                          _progress = 0;
                        });
                        _controller.reload();
                      },
                    )
                  : WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.webPageLoadFailed,
              textAlign: TextAlign.center,
              style: AppTextStyles.authSubtitle.copyWith(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retryLabel,
                style: AppTextStyles.viewAll.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
