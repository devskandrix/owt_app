import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/countries.dart';
import '../../../../core/data/country.dart';

/// The country list filtered by the picker sheet's search field.
class CountrySearchCubit extends Cubit<List<Country>> {
  CountrySearchCubit() : super(Countries.all);

  void search(String query) {
    final normalized = query.trim().toLowerCase();
    emit(
      normalized.isEmpty
          ? Countries.all
          : Countries.all
                .where(
                  (country) =>
                      country.name.toLowerCase().contains(normalized) ||
                      country.dialCode.contains(normalized),
                )
                .toList(),
    );
  }
}
