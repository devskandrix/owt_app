import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_controller.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(
        SettingsState(
          notificationsEnabled: true,
          darkModeEnabled: ThemeController.mode.value == ThemeMode.dark,
        ),
      );

  void setNotificationsEnabled(bool enabled) =>
      emit(state.copyWith(notificationsEnabled: enabled));

  void setDarkMode(bool enabled) {
    emit(state.copyWith(darkModeEnabled: enabled));
    ThemeController.mode.value = enabled ? ThemeMode.dark : ThemeMode.light;
  }
}
