import 'package:equatable/equatable.dart';

import '../../domain/entities/home_clubs.dart';

enum DashboardLoadStatus { loading, loaded, failure }

class DashboardState extends Equatable {
  final DashboardLoadStatus loadStatus;
  final HomeClubs clubs;
  final String? errorMessage;

  const DashboardState({
    this.loadStatus = DashboardLoadStatus.loading,
    this.clubs = const HomeClubs(
      trending: [],
      topClubs: [],
      nearYou: [],
      recentlyViewed: [],
    ),
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardLoadStatus? loadStatus,
    HomeClubs? clubs,
    String? errorMessage,
  }) {
    return DashboardState(
      loadStatus: loadStatus ?? this.loadStatus,
      clubs: clubs ?? this.clubs,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [loadStatus, clubs, errorMessage];
}
