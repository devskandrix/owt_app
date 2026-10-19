import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/countries.dart';
import '../../../../core/data/country.dart';

class SelectedCountryCubit extends Cubit<Country> {
  SelectedCountryCubit() : super(Countries.defaultCountry);

  void select(Country country) => emit(country);
}
