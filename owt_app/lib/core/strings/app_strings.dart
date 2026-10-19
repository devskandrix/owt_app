/// Centralized user-facing copy, grouped by the screen that owns it.
///
/// Shared copy (reused across more than one screen) lives in its own
/// section at the top.
abstract final class AppStrings {
  // ---------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------
  static const String tagline = 'WHO‘S OUT TONIGHT?';
  static const String continueLabel = 'Continue';
  static const String legalNoticeAnd = ' and ';
  static const String termsOfUse = 'Terms of Use';
  static const String privacyPolicy = 'Privacy Policy';
  static const String googleSignInFailed =
      'Google sign-in failed. Please try again.';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';

  // ---------------------------------------------------------------------
  // Splash screen
  // ---------------------------------------------------------------------
  static const String continueWithGoogle = 'Continue with Google';
  static const String continueWithFacebook = 'Continue with Facebook';
  static const String newHere = 'New Here ?';
  static const String createAccount = 'Create Account';
  static const String legalNoticePrefix = 'By continuing. You agree to our \n';

  // ---------------------------------------------------------------------
  // Phone number screen
  // ---------------------------------------------------------------------
  static const String enterYourNumberHeadline = 'Enter Your  Number';
  static const String enterYourNumberSubtitle =
      'Your phone number stays private and is only used for account verification.';
  static const String enterPhoneNumberHint = 'Enter Phone Number';
  static const String selectCountryTitle = 'Select Country';
  static const String searchCountryHint = 'Search country or code';
  static const String noCountryFound = 'No country found';

  // ---------------------------------------------------------------------
  // Verification screen
  // ---------------------------------------------------------------------
  static const String verifyYourNumberHeadline = 'Verify Your Number';
  static const String verifyYourNumberSubtitle =
      'We’ve  just send you 4 digits code\nto your number';
  static const String didntReceiveCode = 'Did’t receive code ? ';
  static const String resendCode = 'Resend Code';
  static const String otpEmptyPlaceholder = '-';
  static const String codeResent = 'Code resent successfully.';

  // ---------------------------------------------------------------------
  // Create Account screen
  // ---------------------------------------------------------------------
  static const String createAccountHeadline = 'Create Your Account';
  static const String createAccountSubtitle = 'Let’s get you in';
  static const String fullNameLabel = 'Full Name';
  static const String fullNamePlaceholder = 'Enter your full Name';
  static const String dateOfBirthLabel = 'Date of Birth';
  static const String dateOfBirthPlaceholder = 'DD / MM / YYYY';
  static const String genderLabel = 'Gender';
  static const String genderMale = 'Male';
  static const String genderFemale = 'Female';
  static const String genderOther = 'Other';
  static const String termsConfirmPrefix = 'I confirm that I am agree to the\n';
  static const String createAccountTermsOfUse = 'terms of use';
  static const String createAccountPrivacyPolicy = 'privacy policy';
  static const String missingRequiredFields =
      'Please select your date of birth and gender.';

  // ---------------------------------------------------------------------
  // Interests screen
  // ---------------------------------------------------------------------
  static const String interestsHeadline = 'What are you into?';
  static const String interestsSubtitle =
      'Add at least 3 Select your interests';
  static const String maxInterestsReached =
      'You can not select up to 5 interests.';

  // ---------------------------------------------------------------------
  // Add Photos screen
  // ---------------------------------------------------------------------
  static const String addPhotosHeadline = 'Add your photos';
  static const String addPhotosSubtitle = 'Add at least 3 photos to continue';
  static const String beYourselfTitle = 'Be Yourself';
  static const String beYourselfDesc = 'Use clear, recent\nphotos of yourself';
  static const String showVibesTitle = 'Show your vibes';
  static const String showVibesDesc = 'Let your photos\nreflect your lifestyle';
  static const String keepSafeTitle = 'We keep it safe';
  static const String keepSafeDesc = 'Your photos are secure & private';
  static const String choosePhotoSourceTitle = 'Add Photo';
  static const String takePhoto = 'Take Photo';
  static const String chooseFromGallery = 'Choose from Gallery';
  static const String unsupportedPhotoFormat = 'Please choose a JPEG, PNG, or WEBP photo.';
  static const String photoTooLarge = 'Photo must be smaller than 8MB.';
  static const String tipsTitle = 'Tips for great photos';
  static const String tipsDescription = 'Use good lighting, show different angles, and let your personality shine.';

  // ---------------------------------------------------------------------
  // Dashboard screen
  // ---------------------------------------------------------------------
  static const String searchClubHint = 'Search Club';
  static const String trendingSectionTitle = 'Trending';
  static const String topClubsSectionTitle = 'Top Clubs';
  static const String nearYouSectionTitle = 'Near You';
  static const String recentlyViewSectionTitle = 'Recently View';
  static const String viewAllLabel = 'View All';
  static const String dashboardErrorTitle = "Couldn't load clubs";
  static const String dashboardEmptyTitle = 'No clubs out tonight';
  static const String dashboardEmptyMessage =
      'Nothing to show around you yet. Pull down to refresh or search for a club.';
  static const String retryLabel = 'Try Again';
  static const String goingTonightSuffix = 'Going tonight';
  static const String outTonightSuffix = 'out tonight';

  static const String venueUshuaiaName = 'Ushuaia Ibiza';
  static const String venueUshuaiaLocation = 'Xjiijid, Germany';
  static const String venueUshuaiaGoingCount = '62';
  static const String venueUshuaiaLiveCount = '52k';

  static const String venueLordOfDrinksName =
      'lord of the drinks - worli mumbai';
  static const String venueLordOfDrinksLocationTrending = 'Xjiijid, Germany';
  static const String venueLordOfDrinksLocationListing = 'Mumbai, India';
  static const String venueLordOfDrinksGoingCount = '624';
  static const String venueLordOfDrinksGoingCountTrending = '6,247';
  static const String venueLordOfDrinksLiveCount = '5255';

  // ---------------------------------------------------------------------
  // Search screen
  // ---------------------------------------------------------------------
  static const String searchQueryPrefill = 'Lord';

  // ---------------------------------------------------------------------
  // Profile screen
  // ---------------------------------------------------------------------
  static const String profileTitle = 'My Profile';
  static const String profileName = 'Alex';
  static const String profileTag = 'Ibiza Lover';
  static const String profileTagline =
      'Always down for good music, greate people and unforgettable nights';
  static const String profileBio =
      'Non nobis quod asperiores est animi blanditiis velit nesciunt. Praesentium nihil dignissimos nihil quasi. '
      'Amet non quia ut rerum nesciunt. Est accusantium debitis perferendis neque aut est.';

  // ---------------------------------------------------------------------
  // Match (swipeable profile) screen
  // ---------------------------------------------------------------------
  static const String matchVenueChipName = 'lord of drinks...';
  static const String matchOnlineCount = '75400';
  static const String matchFireCount = '7005';
  static const String matchProfileName = 'Alvin Fritsch';
  static const String matchGoingTonight = 'Going Tonight';
  static const String interestedInLabel = 'Interested In';
  static const String aboutMeLabel = 'About Me';
  static const String matchAboutMeQuote =
      '“Error molestiae ex itaque eveniet ut doloremque. Deserunt et et sunt. “';
  static const String tagHouseMusic = 'House Music';
  static const String tagTechno = 'Techno';
  static const String tagVipTables = 'VIP Tables';
  static const String tagBeachClub = 'Beach Club';
  static const String matchVenueName = 'Lord of Drinks Ibiza';
  static const String matchVenueCity = 'Ibiza';

  // ---------------------------------------------------------------------
  // Going Tonight verification flow
  // ---------------------------------------------------------------------
  static const String goingTonightInfoTitle = 'This is Going Tonight';
  static const String goingTonightInfoBody =
      'This member has verified they’re attending lord of drinks tonight.\n'
      'You’re seeing people who are actually going tonight .!';
  static const String goingTonightVerifyMine = 'Verify Mine';
  static const String goingTonightHeadline = 'Going Tonight';
  static const String goingTonightSubtitle =
      'Meet People who are actually going tonight';
  static const String goingTonightBenefitConversationsTitle =
      'Real Conversations';
  static const String goingTonightBenefitLocationTitle =
      'Verified Using Live Location';
  static const String goingTonightBenefitPrivacyTitle = 'Your Privacy Is Safe';
  static const String goingTonightBenefitBody =
      'Higher Chances of replies and real meetups.';
  static const String goingTonightHowToGetBadge = 'How i get this badge ?';
  static const String goingTonightHowToGetBadgeAnswer =
      'Tap Verify Mine while you’re at the club. We check your live location '
      'once, and your badge stays active until 5:00 AM.';
  static const String goingTonightVerifyingTitle = 'Verifying your location ....';
  static String goingTonightCheckingNear(String venue) =>
      'Checking you’re near $venue';
  static const String goingTonightTakesSeconds =
      'This usually takes 3-5 second';
  static const String goingTonightKeepLocationOn = 'Please keep location on';
  static const String goingTonightSuccessTitle = 'You’re Going Tonight';
  static const String goingTonightSuccessBody =
      'Your Badge is now active.\nOthers can see that you’re going tonight.';
  static const String goingTonightVerifiedFor = 'Verified for';
  static String goingTonightValidUntil(String time) => 'Valid until $time';
  static const String goingTonightStartMatching = 'Start Matching';
  static const String goingTonightMaybeLater = 'Maybe Later';
  static const String goingTonightFailedTitle = 'Couldn’t verify your location';
  static const String goingTonightServiceDisabled =
      'Location services are turned off. Turn them on to get your badge.';
  static const String goingTonightPermissionDenied =
      'OWT needs your location to confirm you’re at the club.';
  static const String goingTonightPermissionDeniedForever =
      'Location access is off for OWT. Allow it in Settings to get your badge.';
  static const String goingTonightLocationUnavailable =
      'We couldn’t get your location. Move somewhere with better signal and try again.';
  static String goingTonightNotNearVenue(String venue) =>
      'It looks like you’re not at $venue yet. Try again once you arrive.';
  static const String goingTonightOpenSettings = 'Open Settings';
  static const String goingTonightLocationTitle =
    'Allow “OWT” To Use Your Location ?';
  static const String goingTonightLocationBody =
      'We use your location to verify that you’re near the club and activate '
      'your going tonight badge.';
  static const String goingTonightVerifyMyLocation = 'Verify My Location';
  static const String goingTonightNotNow = 'Not Now';

  // ---------------------------------------------------------------------
  // Settings screen
  // ---------------------------------------------------------------------
  static const String settingsTitle = 'Setting';
  static const String settingsNotification = 'Notification';
  static const String settingsDarkMode = 'Dark Mode';
  static const String settingsPrivacyPolicy = 'Privacy & Policy';
  static const String settingsHelpCenter = 'Help Center';
  static const String settingsAboutApp = 'About App';
  static const String settingsDeactivateAccount = 'De active Account';
  static const String settingsLogOut = 'Log out';

  // ---------------------------------------------------------------------
  // Notification screen
  // ---------------------------------------------------------------------
  static const String notificationScreenTitle = 'Notification';
  static const String notificationUnreadViewTitle = 'Notification Unread View';
  static const String notificationUnreadViewBody =
      'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.';
  static const String notificationTimestamp = '12 Jan 2022 | 12:00 PM';

  // ---------------------------------------------------------------------
  // Likes screen
  // ---------------------------------------------------------------------
  static const String likesTitle = 'Likes';
  static const String likedYouTitle = 'Liked You';
  static const String likedYouSubtitle =
      'People who liked your profile from different clubs.';
  static const String likesConfirm = 'Confirm';
  static const String likesMatchTitle = 'It’s Match';
  static const String likesMatchBody =
      'You both like each other now you can chat , and enjoy audio & video calls.';
  static const String likesEmpty = 'No new likes yet';

  // ---------------------------------------------------------------------
  // Todo screen (example feature scaffold)
  // ---------------------------------------------------------------------
  static const String todosTitle = 'Todos';
  static const String whatNeedsDoingHint = 'What needs doing?';
  static const String genericError = 'Error';
  static const String noTodosYet = 'No todos yet';
}
