import 'package:flutter_bloc/flutter_bloc.dart';

/// The trending carousel's current (possibly fractional) scroll page,
/// used to scale neighboring cards as the user drags between pages.
class CarouselPageCubit extends Cubit<double> {
  CarouselPageCubit(super.initialPage);

  void updatePage(double page) => emit(page);
}
