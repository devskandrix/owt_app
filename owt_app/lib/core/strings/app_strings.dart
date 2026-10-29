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
  static const String unsupportedPhotoFormat =
      'Please choose a JPEG, PNG, or WEBP photo.';
  static const String photoTooLarge = 'Photo must be smaller than 8MB.';
  static const String tipsTitle = 'Tips for great photos';
  static const String tipsDescription =
      'Use good lighting, show different angles, and let your personality shine.';

  // ---------------------------------------------------------------------
  // Dashboard screen
  // ---------------------------------------------------------------------
  static const String searchClubHint = 'Search Club';
  static const String searchNoResults = 'No clubs match your search.';
  static const String searchRecentTitle = 'Recent';
  static const String searchClearAll = 'Clear All';
  static const String searchAllClubsTitle = 'All Clubs';
  static const String searchRemoveRecent = 'Remove from recent';
  static const String searchClearConfirmTitle = 'Clear recent searches?';
  static const String searchClearConfirmMessage =
      'This removes all clubs from your recent searches.';
  static const String trendingSectionTitle = 'Trending';
  static const String topClubsSectionTitle = 'Top Clubs';
  static const String nearYouSectionTitle = 'Near You';
  static const String recentlyViewSectionTitle = 'Recently View';
  static const String viewAllLabel = 'View All';
  static const String dashboardLocationMessage =
      'We use your location to show clubs near you and how far away they are.';
  static const String dashboardAllowLocation = 'Allow Location';
  static const String trendingEmptyMessage =
      'No clubs are trending right now. Check back later tonight.';
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
  static const String profileFriends = 'Friends';
  static const String friendsEmpty = 'No friends yet';
  static const String friendProfile = 'Profile';
  static const String interestsLabel = 'Interests';
  static const String editInterestsHeadline = 'Edit your interests';
  static const String yourPhotosLabel = 'Your Photos';
  static const String editLabel = 'Edit';
  static const String editPhotosLabel = 'Edit Photos';
  static const String editPhotosHeadline = 'Edit your photos';
  static const String editPhotosSubtitle =
      'Keep at least 3 photos on your profile';
  static const String doneLabel = 'Done';
  static const String minPhotosReached =
      'Keep at least 3 photos. Add another before removing this one.';
  static const String photoOptionsTitle = 'Photo';
  static const String replacePhoto = 'Replace Photo';
  static const String deletePhoto = 'Delete Photo';
  static const String saveLabel = 'Save';

  // ---------------------------------------------------------------------
  // Match (swipeable profile) screen
  // ---------------------------------------------------------------------
  static const String matchVenueChipName = 'lord of drinks...';
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
  static const String matchQueueEmptyTitle = 'You’re all caught up';
  static const String matchQueueEmptyMessage =
      'No one new at this club right now. Check back in a bit.';
  static const String matchLoadFailedTitle = 'Couldn’t load people';
  static const String matchBadgeAtOtherClub =
      'Your Going Tonight badge is for another club. Head to this club and verify again to see who’s here.';
  static String matchItsAMatch(String name) =>
      'It’s a match! You and $name like each other.';
  static const String matchAlreadyMatched =
      'Already matched — sent them a note 💛';
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
      'once, and your badge stays active until 7:00 AM.';
  static const String goingTonightVerifyingTitle =
      'Verifying your location ....';
  static String goingTonightCheckingNear(String venue) =>
      'Checking you’re near $venue';
  static const String goingTonightTakesSeconds =
      'This usually takes 3-5 second';
  static const String goingTonightKeepLocationOn = 'Please keep location on';
  static const String goingTonightSuccessTitle = 'You’re Going Tonight';
  static const String goingTonightSuccessBody =
      'Your Badge is now active.\nOthers can see that you’re going tonight.';
  static const String goingTonightVerifiedFor = 'Verified for';
  static const String goingTonightValidUntil = 'Valid until 7:00AM';
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
  static const String webPageLoadFailed =
      'Couldn’t load this page. Check your connection and try again.';
  static const String settingsAboutApp = 'About App';
  static const String settingsDeactivateAccount = 'Delete Account';
  static const String settingsLogOut = 'Log out';
  static const String logOutConfirmTitle = 'Log out?';
  static const String logOutConfirmMessage =
      'You’ll need to sign in again to see who’s going tonight.';
  static const String cancelLabel = 'Cancel';
  static const String deactivateConfirmTitle = 'Delete account?';
  static const String deactivateConfirmMessage =
      'Your profile will be hidden and you’ll be signed out.';
  static const String deactivateConfirmLabel = 'Delete';

  // ---------------------------------------------------------------------
  // About App screen
  // ---------------------------------------------------------------------
  static const String aboutTitle = 'About App';
  static const String aboutVersionPrefix = 'Version ';
  static const String aboutIntro =
      'OWT shows you who’s really going out tonight. Pick a club, let people '
      'know you’re heading there, and match with others who’ll be in the '
      'same room — so the night starts before you walk in.';

  static const String aboutHowItWorksTitle = 'How it works';
  static const String aboutStep1Title = 'Find your club';
  static const String aboutStep1Desc =
      'Browse trending spots, top clubs and venues near you.';
  static const String aboutStep2Title = 'Tap “Going Tonight”';
  static const String aboutStep2Desc =
      'Let people know where you’ll be and unlock that club’s crowd.';
  static const String aboutStep3Title = 'Swipe & match';
  static const String aboutStep3Desc =
      'Like the people heading to the same place. A like back is a match.';
  static const String aboutStep4Title = 'Chat & meet up';
  static const String aboutStep4Desc =
      'Message or call your matches and meet them on the night.';

  static const String aboutWhyTitle = 'Why OWT';
  static const String aboutWhyRealTitle = 'Real plans';
  static const String aboutWhyRealDesc =
      'Everyone you see is heading out tonight, not just browsing.';
  static const String aboutWhyLiveTitle = 'Live club vibes';
  static const String aboutWhyLiveDesc =
      'See how many people are going and what’s trending right now.';
  static const String aboutWhyVerifiedTitle = 'Verified members';
  static const String aboutWhyVerifiedDesc =
      'Phone-verified accounts and Going Tonight badges.';
  static const String aboutWhyNearbyTitle = 'Near you';
  static const String aboutWhyNearbyDesc =
      'Clubs sorted by distance so the best night is close by.';

  static const String aboutSafetyTitle = 'Your safety comes first';
  static const String aboutSafety1 =
      'OWT is for adults 18+ only. Please drink responsibly.';
  static const String aboutSafety2 =
      'Your exact location is never shown to other members.';
  static const String aboutSafety3 =
      'Your phone number stays private and is only used for verification.';
  static const String aboutSafety4 =
      'Meet matches at the venue or in public places, and tell a friend '
      'where you’re going.';

  static const String aboutPartnerTitle = 'Own a club or venue?';
  static const String aboutPartnerDesc =
      'Partner with OWT to feature your venue, promote events and reach '
      'people who are going out tonight.';
  static const String aboutPartnerAction = 'Connect';

  static const String aboutContactUs = 'Contact Us';
  static const String aboutEmailCopied = 'Email copied to clipboard.';

  // TODO: replace with the real partnership address.
  static const String aboutSupportEmail = 'support@owt.app';
  static const String aboutPartnerEmail = 'partners@owtapp.com';

  static const String aboutFooter = 'Made for nights out';
  static const String aboutCopyrightSuffix = ' OWT. All rights reserved.';

  // ---------------------------------------------------------------------
  // Notification screen
  // ---------------------------------------------------------------------
  static const String notificationScreenTitle = 'Notification';
  static const String notificationsEmpty = 'No notifications yet';

  // ---------------------------------------------------------------------
  // Chat (messages over our backend; calls over ZEGOCLOUD)
  // ---------------------------------------------------------------------
  static const String messagesTitle = 'Messages';
  static const String messageFriend = 'Message';
  static const String voiceCallPermissionNeeded =
      'Microphone access is needed for voice calls.';
  static const String videoCallPermissionNeeded =
      'Camera and microphone access are needed for video calls.';
  static const String enableInSettings = 'Turn it on in Settings.';
  static const String callFailed = 'Couldn’t start the call. Try again.';
  static const String videoCallTooltip = 'Video call';
  static const String voiceCallTooltip = 'Voice call';
  static const String messagesEmpty =
      'No messages yet. Open a friend’s profile to start chatting.';
  static const String chatUnavailable = 'Chat isn’t available right now.';
  static const String messagesSectionTitle = 'Message';
  static const String chatNewMessages = 'New Message';
  static const String chatYouPrefix = 'You: ';
  static const String chatPhoto = 'Photo';
  static const String chatVideo = 'Video';
  static const String chatVoiceMessage = 'Voice message';
  static const String chatFile = 'File';
  static const String chatInputHint = 'Type Something..';
  static const String chatCopied = 'Message copied';
  static const String chatSendFailed = 'Not sent · Tap to retry';
  static const String chatTyping = 'typing…';
  static const String chatLoadFailed = 'Couldn’t load this chat.';
  static const String chatSlideToCancel = 'Slide to cancel';
  static const String chatHoldToRecord = 'Hold the mic to record';
  static const String chatMicDenied =
      'Microphone access is needed to send voice messages.';
  static const String chatMediaSourceTitle = 'Send';
  static const String chatChooseMedia = 'Photo or video from library';
  static const String chatPlaybackFailed = 'Couldn’t play this message.';
  static const String notificationQueueRemovedTitle = 'Removed from queue';
  static const String notificationDefaultTitle = 'Notification';

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
  static const String pendingRequestTitle = 'Pending Request';
  static const String pendingRequestSubtitle =
      'Kindly accept or reject Request';

  // ---------------------------------------------------------------------
  // Todo screen (example feature scaffold)
  // ---------------------------------------------------------------------
  static const String todosTitle = 'Todos';
  static const String whatNeedsDoingHint = 'What needs doing?';
  static const String genericError = 'Error';
  static const String noTodosYet = 'No todos yet';
}
