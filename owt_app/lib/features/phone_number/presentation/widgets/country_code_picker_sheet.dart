import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/country.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/country_flag_badge.dart';
import '../cubit/country_search_cubit.dart';

/// Modal bottom sheet for picking a country (and its dial code) for the
/// phone number field. Returns the selected [Country] via `Navigator.pop`,
/// or null if dismissed without a selection.
class CountryCodePickerSheet extends StatelessWidget {
  const CountryCodePickerSheet({super.key});

  /// Shows the picker and returns the chosen [Country], or null if the
  /// sheet was dismissed without a selection.
  static Future<Country?> show(BuildContext context) {
    return showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CountryCodePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountrySearchCubit(),
      child: const _CountryCodePickerView(),
    );
  }
}

class _CountryCodePickerView extends StatefulWidget {
  const _CountryCodePickerView();

  @override
  State<_CountryCodePickerView> createState() => _CountryCodePickerViewState();
}

class _CountryCodePickerViewState extends State<_CountryCodePickerView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.selectCountryTitle,
                style: AppTextStyles.fieldLabel.copyWith(
                  color: colors.strongText,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.inputBorder),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 20, color: colors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: false,
                          onChanged: context.read<CountrySearchCubit>().search,
                          style: AppTextStyles.inputPlaceholder.copyWith(
                            color: colors.textSecondary,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: AppStrings.searchCountryHint,
                            hintStyle: AppTextStyles.inputPlaceholder.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<CountrySearchCubit, List<Country>>(
                  builder: (context, filtered) {
                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.noCountryFound,
                          style: AppTextStyles.inputPlaceholder.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final country = filtered[index];
                        return InkWell(
                          onTap: () => Navigator.of(context).pop(country),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                CountryFlagBadge(country: country, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    country.name,
                                    style: AppTextStyles.inputPlaceholder
                                        .copyWith(color: colors.textSecondary),
                                  ),
                                ),
                                Text(
                                  country.dialCode,
                                  style: AppTextStyles.inputPlaceholder
                                      .copyWith(color: colors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
