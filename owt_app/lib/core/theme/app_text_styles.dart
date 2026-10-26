import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens extracted from the OWT Figma design system.
///
/// Font files are bundled locally under assets/fonts (see pubspec.yaml)
/// rather than fetched via google_fonts.
///
/// Styles below that carry a fixed color are for the Splash screen, which
/// only has a dark-themed design. Styles without a color are shared across
/// the light/dark "Numbet" and "Verification" screens — apply
/// `context.appColors` at the call site.
abstract final class AppTextStyles {
  /// "WHO'S OUT TONIGHT?" splash tagline.
  static const TextStyle tagline = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 1.47,
    shadows: [Shadow(color: Colors.black, blurRadius: 25)],
  );

  /// Bold label used on the primary (Google) social button.
  static const TextStyle socialButtonBold = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  /// Semi-bold label used on the secondary (Facebook) social button.
  static const TextStyle socialButtonSemiBold = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// "New Here ?" prompt above the create-account link.
  static const TextStyle prompt = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Color(0xFFFCFCFD),
  );

  /// "Create Account" link label.
  static const TextStyle link = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  /// Legal disclaimer body text.
  static const TextStyle legal = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.75,
    color: Color(0xFFFCFCFD),
  );

  /// Small "WHO'S OUT TONIGHT?" tag used under the compact logo badge on
  /// secondary auth screens (phone number / verification).
  static const TextStyle logoBadgeTagline = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 8,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.84,
  );

  /// "Enter Your Number" / "Verify Your Number" headline.
  static const TextStyle authHeadline = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.14,
  );

  /// Helper copy under an auth headline.
  static const TextStyle authSubtitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.3,
    letterSpacing: 0.08,
  );

  /// Phone number / OTP input placeholder text.
  static const TextStyle inputPlaceholder = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  /// Gradient "Continue" button label. White on both themes.
  static const TextStyle primaryButton = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// A filled or placeholder digit inside an OTP box.
  static const TextStyle otpDigit = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  /// "Did't receive code ?" / "Resend Code" row.
  static const TextStyle resendPrompt = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 16 / 14,
  );

  /// "Create Your Account" / "What are you into?" headline.
  static const TextStyle onboardingHeadline = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.12,
  );

  /// Helper copy under an onboarding headline.
  static const TextStyle onboardingSubtitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w300,
    height: 1.2,
    letterSpacing: 0.09,
  );

  /// Field / section label ("Full Name", "Gender", "Music", ...).
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Unselected interest chip label.
  static const TextStyle chipLabel = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  /// Selected interest chip label. The chip's inner fill matches the
  /// screen background (the gradient only shows as a border), so this
  /// needs a theme-aware color at the call site rather than a fixed one.
  static const TextStyle chipLabelSelected = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// "Be Yourself" / "Show your vibes" / "We keep it safe" blurb title.
  static const TextStyle featureBlurbTitle = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// Feature blurb description line.
  static const TextStyle featureBlurbDesc = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 10,
    fontWeight: FontWeight.w300,
  );

  /// "Tips for great photos" box title.
  static const TextStyle tipsTitle = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// "Tips for great photos" box description.
  static const TextStyle tipsDescription = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 11,
    fontWeight: FontWeight.w200,
  );

  /// "Search Club" placeholder. Apply [AppColors.neutralGray] at the call
  /// site; it's theme-invariant and legible on both scaffold backgrounds.
  static const TextStyle searchHint = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  /// "Trending" / "Top Clubs" / "Near You" / "Recently View" section title.
  /// Apply `context.appColors.textPrimary` at the call site.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// "View All" link. Painted through [AppGradients.button] via GradientText.
  static const TextStyle viewAll = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Venue title on the large trending carousel card. Sits below the photo
  /// on the page background, so apply `context.appColors.textPrimary` at
  /// the call site rather than a fixed color.
  static const TextStyle trendingCardTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  /// Venue title on a Top Clubs / Near You / Recently Viewed list card.
  /// Apply `context.appColors.textPrimary` at the call site.
  static const TextStyle venueCardTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Venue location line under a card title. Identical in both themes;
  /// this muted gray already reads fine on both scaffold backgrounds.
  static const TextStyle venueLocation = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w200,
    color: Color(0xFF98A1B2),
  );

  /// "X Going tonight" / "X out tonight" row. Apply
  /// `context.appColors.textPrimary` at the call site.
  static const TextStyle venueGoingText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  /// Live viewer count inside the green-dot badge overlay ("52k", "5255").
  static const TextStyle liveBadgeCount = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFCFCFD),
  );

  /// Search query typed into the search field. Theme-invariant (matches
  /// the muted placeholder gray, per Figma).
  static const TextStyle searchQueryText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Color(0xFFA2A2A2),
  );

  /// Search result row title. Sits on the page background (not a photo),
  /// so apply `context.appColors.textPrimary` at the call site rather than
  /// a fixed color. The matched substring is painted with
  /// [AppGradients.brand] instead (see [SearchResultTile]).
  static const TextStyle searchResultTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  /// Search result row location line.
  static const TextStyle searchResultLocation = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w200,
    color: Color(0xFF98A1B2),
  );

  /// Profile name ("Alex"). Page-level content; apply
  /// `context.appColors.textPrimary` at the call site.
  static const TextStyle profileName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  /// Interest tag chip label ("Ibiza Lover"). Page-level content; apply
  /// `context.appColors.textPrimary` at the call site.
  static const TextStyle profileTagLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  /// Profile tagline under the name/tag row. Page-level content; apply
  /// `context.appColors.textPrimary` at the call site.
  static const TextStyle profileTagline = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  /// Profile stat number ("23" above "Friends"). Sizes estimated from the
  /// Figma layer heights. Apply `context.appColors.textPrimary` at the
  /// call site.
  static const TextStyle profileStatValue = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Profile stat label ("Friends").
  static const TextStyle profileStatLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Color(0xFF98A1B2),
  );

  /// "About Me" / "Your Photos" section title on the Profile screen.
  /// Apply `context.appColors.textPrimary` at the call site.
  static const TextStyle profileSectionTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Purple "Edit" / "Edit Photos" link on the Profile screen.
  static const TextStyle profileEditLink = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.toggleOn,
  );

  /// Profile bio paragraph. Page-level content; apply
  /// `context.appColors.textPrimary` at the call site.
  static const TextStyle profileBio = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.5,
  );

  // ---------------------------------------------------------------------
  // Match (swipeable profile) screen — fixed dark styling, no light Figma
  // frame exists for this screen (it's a full-bleed photo card like the
  // Trending carousel), so colors are hardcoded rather than theme-applied.
  // ---------------------------------------------------------------------

  /// Venue chip name ("lord of drinks...").
  static const TextStyle matchVenueChipName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  /// Venue chip online / fire counts.
  static const TextStyle matchVenueChipCount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  /// Card header name ("Alvin Fritsch").
  static const TextStyle matchCardName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  /// "Going Tonight" pill label.
  static const TextStyle matchGoingTonight = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFFF2F4F7),
  );

  /// "Interested In" / "About Me" section label.
  static const TextStyle matchSectionLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Color(0xFF898989),
  );

  /// Interest tag chip label ("House Music", "Techno", ...).
  static const TextStyle matchTagLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Color(0xFFEAEAEA),
  );

  /// "About Me" quote body text.
  static const TextStyle matchAboutMeText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: Color(0xFFD9D9D9),
  );

  /// "Setting" header title. Apply `context.appColors.textPrimary` at the
  /// call site.
  static const TextStyle settingsTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// A settings row label ("Notification", "Privacy & Policy", ...). Apply
  /// `context.appColors.textPrimary` at the call site.
  static const TextStyle settingsRowLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  /// "Log out" label. Fixed danger red in both themes (see
  /// [AppColors.dangerRed]), and a different font (Mulish) than the other
  /// settings rows.
  static const TextStyle settingsLogOut = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.dangerRed,
  );

  /// A notification row's bold title. Apply `context.appColors.textPrimary`
  /// at the call site.
  static const TextStyle notificationItemTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// A notification row's description. Apply
  /// `context.appColors.textSecondary` at the call site.
  static const TextStyle notificationItemBody = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w200,
    height: 1.5,
  );

  /// A notification row's timestamp. Apply `context.appColors.textMuted` at
  /// the call site.
  static const TextStyle notificationItemDate = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w200,
  );

  // ---------------------------------------------------------------------
  // Going Tonight verification flow. Always shown on the dark match
  // screen, so colors are fixed like the match styles above.
  // ---------------------------------------------------------------------

  /// Bottom-sheet / dialog title ("This is Going Tonight").
  static const TextStyle goingTonightTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: Colors.white,
  );

  /// Light body copy in the sheet and dialogs.
  static const TextStyle goingTonightBody = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.5,
    color: Color(0xFFD0D5DD),
  );

  /// Venue name in the "Verified for …" block.
  static const TextStyle goingTonightVenue = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: Color(0xFFD0D5DD),
  );

  /// "Maybe Later" / "Try Again" text button. Painted through [AppGradients.brand].
  static const TextStyle goingTonightSecondaryAction = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Label on the location-permission dialog's pill buttons. White on all
  /// three variants.
  static const TextStyle goingTonightPillButton = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// Large title on the Going Tonight badge card ("Going Tonight").
  static const TextStyle goingTonightHeadline = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: Colors.white,
  );

  /// Subtitle under [goingTonightHeadline].
  static const TextStyle goingTonightSubtitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: Color(0xFFD0D5DD),
  );

  /// Badge card benefit title ("Real Conversations").
  static const TextStyle goingTonightBenefitTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: Color(0xFFEAECF0),
  );

  /// Badge card benefit description.
  static const TextStyle goingTonightBenefitBody = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFFEAECF0),
  );

  /// "How i get this badge ?" link. Painted through [AppGradients.brand].
  static const TextStyle goingTonightLink = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ---------------------------------------------------------------------
  // Likes screen. Apply `context.appColors.textPrimary` at the call site
  // where no color is set.
  // ---------------------------------------------------------------------

  /// Row name / "Liked You" / "It’s Match" / "+23".
  static const TextStyle likesName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.08,
  );

  /// Small gray secondary line ("Mumbai, India", card descriptions).
  static const TextStyle likesCaption = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w300,
    height: 1.2,
    letterSpacing: 0.05,
    color: Color(0xFF98A1B2),
  );

  /// Club name next to its icon ("Hi ibiza").
  static const TextStyle likesClub = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.07,
  );

  /// "Confirm" button label.
  static const TextStyle likesConfirm = TextStyle(
    fontFamily: 'Mulish',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // ---------------------------------------------------------------------
  // Messages + Chat screens. Apply `context.appColors.textPrimary` at the
  // call site where no color is set.
  // ---------------------------------------------------------------------

  /// "Message" section heading on the Messages screen.
  static const TextStyle messagesSection = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// Person's name in a conversation row.
  static const TextStyle conversationName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// Second line of a conversation row ("4 New Message • 4h").
  static const TextStyle conversationPreview = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.2,
  );

  /// Person's name in the chat header.
  static const TextStyle chatHeaderName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// Text inside a chat bubble and the chat input.
  static const TextStyle chatBubble = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// "09:25 AM" under a group of chat bubbles.
  static const TextStyle chatTime = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.2,
    color: Color(0xFF98A1B2),
  );

  // ---------------------------------------------------------------------
  // About App screen. Apply theme colors at the call site.
  // ---------------------------------------------------------------------

  /// "Version 1.0.0 (1)" under the logo.
  static const TextStyle aboutVersion = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  /// Intro paragraph and other long-form body copy.
  static const TextStyle aboutBody = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.5,
  );

  /// Title inside a step row or feature card.
  static const TextStyle aboutItemTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Description under a step row or feature card title.
  static const TextStyle aboutItemDesc = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.4,
  );

  /// Step number inside the gradient circle.
  static const TextStyle aboutStepNumber = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Footer lines at the bottom of the screen.
  static const TextStyle aboutFooter = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: Color(0xFF98A1B2),
  );
}
