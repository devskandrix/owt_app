import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/services/location_service.dart';
import 'cubit/going_tonight_cubit.dart';
import 'widgets/going_tonight_info_sheet.dart';
import 'widgets/going_tonight_location_dialog.dart';
import 'widgets/going_tonight_verify_dialog.dart';

export 'widgets/going_tonight_verify_dialog.dart' show GoingTonightOutcome;

/// Runs the whole Going Tonight flow from a profile's badge: the info
/// sheet, then [verifyGoingTonight].
///
/// Returns the user's choice on the success card, or null if they backed
/// out at any step or verification never succeeded.
Future<GoingTonightOutcome?> showGoingTonightFlow(
  BuildContext context, {
  required String venueName,
  required String venueCity,
  String? clubId,
}) async {
  final wantsToVerify = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: GoingTonightInfoSheet.background,
    shape: const RoundedRectangleBorder(),
    builder: (_) => const GoingTonightInfoSheet(),
  );
  if (wantsToVerify != true || !context.mounted) return null;
  return verifyGoingTonight(
    context,
    venueName: venueName,
    venueCity: venueCity,
    clubId: clubId,
  );
}

/// Location explainer -> OS prompt -> verification (check-in at [clubId])
/// -> success. The
/// explainer only shows when the OS prompt will follow it; if location is
/// already allowed, verification starts straight away, and if it's off or
/// denied, verification shows its Open Settings card.
///
/// Returns the user's choice on the success card (so non-null means the
/// badge is now active), or null if they backed out or it failed.
Future<GoingTonightOutcome?> verifyGoingTonight(
  BuildContext context, {
  required String venueName,
  required String venueCity,
  String? clubId,
}) async {
  if (await sl<LocationService>().canPromptForPermission()) {
    if (!context.mounted) return null;
    final allowed = await showDialog<bool>(
      context: context,
      builder: (_) => const GoingTonightLocationDialog(),
    );
    if (allowed != true) return null;
  }
  if (!context.mounted) return null;

  return showDialog<GoingTonightOutcome>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => GoingTonightCubit(sl(), sl(), clubId: clubId)..verify(),
      child: GoingTonightVerifyDialog(
        venueName: venueName,
        venueCity: venueCity,
      ),
    ),
  );
}
