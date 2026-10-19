import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The swipeable card's current drag/animation offset. Emits at animation
/// frame rate while a swipe is in progress or animating; see
/// [SwipeableCard] for why this still needs a [TickerProvider] (from
/// [TickerProviderStateMixin]) even though the value itself lives here.
class DragOffsetCubit extends Cubit<Offset> {
  DragOffsetCubit() : super(Offset.zero);

  void update(Offset offset) => emit(offset);
}
