import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../dashboard/presentation/widgets/venue.dart';
import '../widgets/search_input_field.dart';
import '../widgets/search_result_tile.dart';

/// Search screen, reached by tapping the search field on the dashboard.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController(text: AppStrings.searchQueryPrefill);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = Venue.searchResults();
    return Scaffold(
      backgroundColor: context.appColors.background,
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppTopBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchInputField(controller: _controller),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: results.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) =>
                    SearchResultTile(venue: results[index], matchLength: AppStrings.searchQueryPrefill.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
