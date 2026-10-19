import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// The real, editable search field on the Search screen: same bordered
/// layout as the dashboard's tappable search bar, but with a live
/// [TextField] and the filter icon inset at the trailing edge.
class SearchInputField extends StatelessWidget {
  const SearchInputField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: colors.inputBorder)),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.icons.search,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(colors.textPrimary, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: AppTextStyles.searchQueryText,
              cursorColor: colors.textPrimary,
              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
            ),
          ),
          SvgPicture.asset(
            Assets.icons.filter,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(colors.textPrimary, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
