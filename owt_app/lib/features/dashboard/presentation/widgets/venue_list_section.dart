import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_route.dart';
import 'dashboard_section_header.dart';
import 'venue.dart';
import 'venue_card.dart';

/// A titled horizontal row of [VenueCard]s (Top Clubs / Near You /
/// Recently Viewed).
class VenueListSection extends StatelessWidget {
  const VenueListSection({
    super.key,
    required this.title,
    required this.venues,
  });

  final String title;
  final List<Venue> venues;

  @override
  Widget build(BuildContext context) {
    if (venues.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(title: title),
        const SizedBox(height: 12),
        SizedBox(
          height: 225,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: venues.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => context.pushNamed(
                AppRoute.match.name,
                extra: venues[index].club,
              ),
              child: VenueCard(venue: venues[index], width: 137),
            ),
          ),
        ),
      ],
    );
  }
}
