import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_route.dart';
import '../cubit/carousel_page_cubit.dart';
import 'trending_card.dart';
import 'venue.dart';

/// Horizontal carousel of [TrendingCard]s. The active page renders at full
/// size; neighboring pages peek in at a slightly smaller scale, matching
/// the Figma source where the two side cards are narrower than the center
/// one.
class TrendingCarousel extends StatelessWidget {
  const TrendingCarousel({super.key, required this.venues});

  final List<Venue> venues;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarouselPageCubit(venues.length > 1 ? 1 : 0),
      child: _TrendingCarouselView(venues: venues),
    );
  }
}

class _TrendingCarouselView extends StatefulWidget {
  const _TrendingCarouselView({required this.venues});

  final List<Venue> venues;

  @override
  State<_TrendingCarouselView> createState() => _TrendingCarouselViewState();
}

class _TrendingCarouselViewState extends State<_TrendingCarouselView> {
  late final PageController _controller = PageController(
    viewportFraction: 0.84,
    initialPage: widget.venues.length > 1 ? 1 : 0,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final cubit = context.read<CarouselPageCubit>();
      cubit.updatePage(_controller.page ?? cubit.state);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venues = widget.venues;
    if (venues.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      // A few pixels above TrendingCard's own measured content height, as a
      // buffer against font-metric rounding differences between platforms
      // (its text is otherwise pinned to a fixed size — see TrendingCard).
      height: 424,
      child: BlocBuilder<CarouselPageCubit, double>(
        builder: (context, page) {
          return PageView.builder(
            controller: _controller,
            itemCount: venues.length,
            itemBuilder: (context, index) {
              final delta = (index - page).abs().clamp(0.0, 1.0);
              final scale = 1 - delta * 0.08;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Transform.scale(
                  scale: scale,
                  child: GestureDetector(
                    onTap: () => context.pushNamed(AppRoute.match.name),
                    child: TrendingCard(venue: venues[index]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
