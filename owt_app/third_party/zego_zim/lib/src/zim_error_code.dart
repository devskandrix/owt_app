class ZIMErrorCode {
  /// Success without exception.
  static const int success = 0;

  /// Failed, the guarantee is wrong.
  static const int failed = 1;

  /// The incoming parameter is invalid. <br>Use case: Used to protect the bottom strategy when the interface call fails due to incorrect parameters.
  static const int commonModuleParamsInvalid = 6000001;

  /// The SDK is not initialized. <br>Use case: Used for error return when the ZIM SDK is not initialized successfully.
  static const int commonModuleEngineNotInit = 6000002;

  /// Invalid AppID. <br>Use case: Used for error return of failure due to invalid AppID.
  static const int commonModuleInvalidAppID = 6000003;

  /// Trigger SDK internal frequency limit.
  static const int commonModuleTriggerSDKFrequencyLimit = 6000004;

  /// Trigger background service frequency limit.
  static const int commonModuleTriggerServerFrequencyLimit = 6000005;

  /// The Switch server reported an error.
  static const int commonModuleSwitchServerError = 6000006;

  /// ZIM service internal error.
  static const int commonModuleIMServerError = 6000007;

  /// ZIM internal database error.
  static const int commonModuleIMDatabaseError = 6000008;

  /// Disconnected while sending request.
  static const int commonModuleIMServerDisconnect = 6000009;

  /// Failed to upload log.
  static const int commonModuleUploadLogError = 6000010;

  /// Illegal param.
  static const int commonModuleUserIsNotExist = 6000011;

  /// User background query frequency limit.
  static const int commonModuleUserInfoQueriedLimit = 6000012;

  /// User background query frequency limit. The current package does not support this operation.
  static const int commonModuleUnsupportedRequest = 6000013;

  /// The ZIM service is not activated. Please enable it on the ZEGO console first.
  static const int commonModuleUnactivatedIMServer = 6000014;

  /// The upper limit of daily active users of the AppID was exceeded. Procedure.
  static const int commonModuleExceedDauLimit = 6000015;

  /// The upper limit of the monthly active users of the AppID is exceeded. Procedure.
  static const int commonModuleExceedMauLimit = 6000016;

  /// Failed for blacklist limit.
  static const int commonModuleBlacklistLimit = 6000021;

  /// Login failed due to internal reasons.
  static const int networkModuleCommonError = 6000101;

  /// Login failed due to internal reasons.
  static const int networkModuleServerError = 6000102;

  /// Token is invalid.
  static const int networkModuleTokenInvalid = 6000103;

  /// Network error.
  static const int networkModuleNetworkError = 6000104;

  /// The request to the background timed out.
  static const int networkModuleRequestTimeout = 6000105;

  /// Token expired.
  static const int networkModuleTokenExpired = 6000106;

  /// Token version number is wrong.
  static const int networkModuleTokenVersionError = 6000107;

  /// Token duration is too short.
  static const int networkModuleTokenTimeIsTooShort = 6000108;

  /// rsp_proto_parse_error.
  static const int networkModuleRspProtoParseError = 6000109;

  /// Logging in to multiple accounts on the current device.
  static const int networkModuleUserHasAlreadyLogged = 6000111;

  /// User is not logged.
  static const int networkModuleUserIsNotLogged = 6000121;

  /// The user has logged out.
  static const int networkModuleUserHasAlreadyLoggedOut = 6000122;

  /// The user is offline. Procedure.
  static const int networkModuleUserOffline = 6000123;

  /// The userID passed in for the offline login does not match the userID from the last successful login.
  static const int networkModuleUserIDError = 6000124;

  /// Internal error sending message.
  static const int messageModuleCommonError = 6000201;

  /// Error sending message background service.
  static const int messageModuleServerError = 6000202;

  /// Message sending failed.
  static const int messageModuleSendMessageFailed = 6000203;

  /// The message target does not exist.
  static const int messageModuleTargetDoesNotExist = 6000204;

  /// The message edited failed.
  static const int messageModuleEditMessageFailed = 6000205;

  /// Message sending failed because the user actively canceled it.
  static const int messageModuleSendMessageFailedForCancelled = 6000206;

  /// Failed to cancel the message being sent.
  static const int messageModuleCancelSendingMessageFailed = 6000207;

  /// the message is not pinned.
  static const int messageModuleMessageIsNotPinned = 6000208;

  /// File generic error.
  static const int messageModuleFileError = 6000210;

  /// There are no errors in the file.
  static const int messageModuleFileNotExist = 6000211;

  /// File operation background error.
  static const int messageModuleFileServerError = 6000212;

  /// The file type is not supported. Procedure.
  static const int messageModuleFileTypeUnsupported = 6000213;

  /// The file size is invalid.
  static const int messageModuleFileSizeInvalid = 6000214;

  /// The duration of the audio and video files is invalid.
  static const int messageModuleFileDurationInvalid = 6000215;

  /// File permission error.
  static const int messageModuleFilePermissionDenied = 6000216;

  /// File size download exceeds limit.
  static const int messageModuleFileDownloadLimit = 6000218;

  /// An error occurred while sending an HTTP request to the server.
  static const int messageModuleFileHttpRequestServerError = 6000220;

  /// The message did not pass the review.
  static const int messageModuleAuditRejected = 6000221;

  /// Message auditing failed.
  static const int messageModuleAuditFailed = 6000222;

  /// The message custom pre-callback business audit did not pass.
  static const int messageModuleAuditCustomSentRejected = 6000230;

  /// Unable to send messages because the user has been muted.
  static const int messageModuleMessageMuted = 6000231;

  /// The cache file failed to open.
  static const int messageModuleCacheFileOpenFailed = 6000240;

  /// The cache file export or import is in progress.
  static const int messageModuleCacheFileExportOrImportIsInProgressCurrently =
      6000241;

  /// The cache file can only import its own cache.
  static const int messageModuleCacheFileOnlyCanImportCacheOfOneself = 6000242;

  /// The cache file export failed.
  static const int messageModuleCacheFileExportFailed = 6000243;

  /// The cache file import failed.
  static const int messageModuleCacheFileImportFailed = 6000244;

  /// The cache file JSON parsing failed.
  static const int messageModuleCacheFileJsonParseFailed = 6000245;

  /// File request short connection error.
  static const int messageModuleFileConnectError = 6000251;

  /// File request encountered an HTTP error.
  static const int messageModuleFileHttpError = 6000252;

  /// File request encountered a certificate error.
  static const int messageModuleFileVerificationError = 6000253;

  /// Client file request error.
  static const int messageModuleFileClientError = 6000254;

  /// Url resource not found.
  static const int messageModuleFileUrlNotFound = 6000255;

  /// The server rejected the request, possibly due to insufficient permissions or unauthenticated identity.
  static const int messageModuleFileServerRejected = 6000256;

  /// The server has not implemented the requested capability, or the request protocol version is incompatible.
  static const int messageModuleFileServerUnsupported = 6000257;

  /// Call invitation error.
  static const int messageModuleCallError = 6000270;

  /// Call cancellation error.
  static const int messageModuleCancelCallError = 6000271;

  /// Call invitation background error.
  static const int messageModuleCallServerError = 6000272;

  /// User uninviter operation error.
  static const int messageModuleIsNotInvitor = 6000273;

  /// User non-invitee operation error.
  static const int messageModuleIsNotInvitee = 6000274;

  /// The call already has an error.
  static const int messageModuleCallAlreadyExists = 6000275;

  /// There is no error in the call.
  static const int messageModuleCallDoesNotExist = 6000276;

  /// Set the receipt message to read error.
  static const int messageModuleReceiptReadError = 6000277;

  /// I want to withdraw the message but the time limit has expired.
  static const int messageModuleMessageExceedsRevokeTime = 6000278;

  /// Tried to retract the message but it's been retracted.
  static const int messageModuleMessageHasBeenRevoked = 6000279;

  /// When a user sets or deletes a key in a message, the key has been set or deleted by the user. <br> Processing: Developers can pop-up prompt, or no special processing.
  static const int messageModuleMessageReactionTypeExisted = 6000280;

  /// When you initiate a call invitation, all invitees are not registered. <br> Solution: 1. Please check the registration status of the invitee. If the user to be invited has not yet registered, please register first. 2. If the user is registered, check whether the UserID in the invitee list is correct.
  static const int messageModuleCallInviteUserDoesNotExist = 6000281;

  /// Call the sendMessageReceiptsRead interface to set more than 10 messages to read at a time. Please reduce the number of incoming messages to less than 10.
  static const int messageModuleMessageReceiptLimit = 6000282;

  /// Note: The device that invokes the callJoin interface has called in advanced mode and is the primary device. No action is required.
  static const int messageModuleUserAlreadyInTheCall = 6000283;

  /// The sender has been added to the blacklist.
  static const int messageModuleSenderInBlacklist = 6000284;

  /// No corresponding operation authority.
  static const int messageModuleEditNoCorrespondingOperationAuthority = 6000285;

  /// The message has exceeded the edit time limit.
  static const int messageModuleMessageExceedsEditTime = 6000286;

  /// The number of pinned messages exceeds the limit.
  static const int messageModulePinMessageLimitExceeded = 6000287;

  /// Deleting the message for everyone exceeds the allowed valid time.
  static const int messageModuleDeleteMessageForEveryoneExceedsValidTime =
      6000288;

  /// Room related operation error.
  static const int roomModuleCommonError = 6000301;

  /// Room operation background failed.
  static const int roomModuleServerError = 6000302;

  /// Room creation failed.
  static const int roomModuleCreateRoomError = 6000303;

  /// Room entry failed.
  static const int roomModuleJoinRoomError = 6000304;

  /// Failed to leave the room.
  static const int roomModuleLeaveRoomError = 6000306;

  /// Failed to query a room member.
  static const int roomModuleRoomMemberQueryFailed = 6000310;

  /// Failed to query room members.
  static const int roomModuleRoomMemberQueryFailedCompletely = 6000311;

  /// User has error in room.
  static const int roomModuleUserIsAlreadyInTheRoom = 6000320;

  /// User not in room error.
  static const int roomModuleUserIsNotInTheRoom = 6000321;

  /// The room does not exist.
  static const int roomModuleTheRoomDoesNotExist = 6000322;

  /// There are no errors in the room.
  static const int roomModuleTheRoomAlreadyExists = 6000323;

  /// The number of existing rooms has reached its limit.
  static const int roomModuleTheNumberOfExistingRoomsHasReachedLimit = 6000324;

  /// The number of added rooms reached the upper limit.
  static const int roomModuleTheNumberOfJoinedRoomsHasReachedLimit = 6000325;

  /// Try an interface such as createRoom, joinRoom, or enterRoom repeatedly, or perform an action on a room that is being connected. Please wait for return of room connection result returned by onRoomStateChanged before performing operations.
  static const int roomModuleTheRoomIsConnecting = 6000326;

  /// Room property operation failed.
  static const int roomModuleRoomAttributesCommonError = 6000330;

  /// The room properties operation failed completely.
  static const int roomModuleRoomAttributesOperationFailedCompletely = 6000331;

  /// The room properties operation part failed.
  static const int roomModuleRoomAttributesOperationFailedPartly = 6000332;

  /// Description Failed to query the room properties.
  static const int roomModuleRoomAttributesQueryFailed = 6000333;

  /// The number of room properties reached the upper limit.
  static const int roomModuleTheNumberOfRoomAttributesExceedsLimit = 6000334;

  /// The length of the room attribute Key reaches the upper limit. Procedure
  static const int roomModuleTheLengthOfRoomAttributeKeyExceedsLimit = 6000335;

  /// The length of the room attribute Value reached the upper limit. Procedure
  static const int roomModuleTheLengthOfRoomAttributeValueExceedsLimit =
      6000336;

  /// Total length of room attribute reached the upper limit.
  static const int roomModuleTheTotalLengthOfRoomAttributesValueExceedsLimit =
      6000337;

  /// Room room member attribute failed.
  static const int roomModuleRoomMemberAttributesCommonError = 6000350;

  /// The total length of the room member attribute reaches the upper limit.
  static const int roomModuleTheTotalLengthOfRoomMemberAttributesExceedsLimit =
      6000351;

  /// The length of the room user attribute Key reached the upper limit.
  static const int roomModuleTheLengthOfRoomMemberAttributesKeyExceedsLimit =
      6000352;

  /// The length of the room member attribute Value reached the upper limit. Procedure.
  static const int roomModuleTheLengthOfRoomMemberAttributesValueExceedsLimit =
      6000353;

  /// The number of room member attributes reached the upper limit.
  static const int roomModuleTheMemberNumberOfRoomMemberAttributesExceedsLimit =
      6000357;

  /// The push ID is invalid. Procedure.
  static const int zpnsModulePushIDInvalid = 6000401;

  /// An error occurred during group-related operations.
  static const int groupModuleCommonError = 6000501;

  /// The group related background reported an error.
  static const int groupModuleServerError = 6000502;

  /// Failed to create a group. Procedure.
  static const int groupModuleCreateGroupError = 6000503;

  /// Failed to dissolve the group.
  static const int groupModuleDismissGroupError = 6000504;

  /// Failed to join the group.
  static const int groupModuleJoinGroupError = 6000505;

  /// Failed to leave the group.
  static const int groupModuleLeaveGroupError = 6000506;

  /// Failed to kick out a group member.
  static const int groupModuleKickOutGroupMemberError = 6000507;

  /// Failed to invite users to join the group.
  static const int groupModuleInviteUserIntoGroupError = 6000508;

  /// Failed to transfer the group master.
  static const int groupModuleTransferOwnerError = 6000509;

  /// Failed to update group information.
  static const int groupModuleUpdateGroupInfoError = 6000510;

  /// Failed to query group information.
  static const int groupModuleQueryGroupInfoError = 6000511;

  /// Failed to manipulate the group attribute.
  static const int groupModuleGroupAttributesOperationFailed = 6000512;

  /// Failed to query group attributes. Procedure
  static const int groupModuleGroupAttributesQueryFailed = 6000513;

  /// Description Failed to update group member information.
  static const int groupModuleUpdateGroupMemberInfoError = 6000514;

  /// Description Failed to query group member information.
  static const int groupModuleQueryGroupMemberInfoError = 6000515;

  /// Failed to query the group list. Procedure
  static const int groupModuleQueryGroupListError = 6000516;

  /// Description Failed to query the group member list.
  static const int groupModuleQueryGroupMemberListError = 6000517;

  /// The user is not in the group.
  static const int groupModuleUserIsNotInTheGroup = 6000521;

  /// The user is already in the group.
  static const int groupModuleMemberIsAlreadyInTheGroup = 6000522;

  /// The group does not exist.
  static const int groupModuleGroupDoesNotExist = 6000523;

  /// The group already exists.
  static const int groupModuleGroupAlreadyExists = 6000524;

  /// The group membership reaches the upper limit.
  static const int groupModuleGroupMemberHasReachedLimit = 6000525;

  /// The group property does not exist.
  static const int groupModuleGroupAttributeDoesNotExist = 6000526;

  /// Note: Create a group with a destroyed group ID. Use a different ID.
  static const int groupModuleGroupWithDismissed = 6000527;

  /// The number of group attributes reaches the upper bound error.
  static const int groupModuleTheNumberOfGroupAttributesExceedsLimit = 6000531;

  /// The group attribute Key length has reached the upper limit.
  static const int groupModuleTheLengthOfGroupAttributeKeyExceedsLimit =
      6000532;

  /// The group attribute Value length has reached the upper limit.
  static const int groupModuleTheLengthOfGroupAttributeValueExceedsLimit =
      6000533;

  /// The group attribute Value length has reached the upper limit.
  static const int groupModuleTheTotalLengthOfGroupAttributeValueExceedsLimit =
      6000534;

  /// Group operation permission.
  static const int groupModuleGroupNoCorrespondingOperationAuthority = 6000541;

  /// Forbid to join the group.
  static const int groupModuleForbidJoinGroupError = 6000542;

  /// Need to apply to join the group.
  static const int groupModuleNeedApplyJoinGroupError = 6000543;

  /// Need to apply to invite to join the group.
  static const int groupModuleNeedApplyInviteGroupError = 6000544;

  /// Session operation error.
  static const int conversationModuleCommonError = 6000601;

  /// Session background error.
  static const int conversationModuleServerError = 6000602;

  /// There are no errors in the session.
  static const int conversationModuleConversationDoesNotExist = 6000603;

  /// The session top list has reached its limit.
  static const int conversationModuleConversationPinnedListReachedLimit =
      6000604;

  /// Error opening database.
  static const int databaseModuleOpenDatabaseError = 6000701;

  /// Error modifying database.
  static const int databaseModuleModifyDatabaseError = 6000702;

  /// Error deleting database.
  static const int databaseModuleDeleteDatabaseError = 6000703;

  /// Error selecting database.
  static const int databaseModuleSeleteDatabaseError = 6000704;

  /// The database is not open.
  static const int databaseModuleDbIsNotOpened = 6000710;

  /// The number of friends has reached the upper limit.
  static const int friendModuleFriendNumsLimit = 6000801;

  /// The friend application status is wrong.
  static const int friendModuleFriendApplicationStatusError = 6000802;

  /// The other party is already your friend.
  static const int friendModuleIsAlreadyYourFriend = 6000803;

  /// The other party is already in your blacklist.
  static const int friendModuleAlreadyAddToBlacklist = 6000804;

  /// Cannot add yourself to the blacklist.
  static const int friendModuleCannotAddSelfToBlacklist = 6000805;

  /// The other party has been removed from your blacklist.
  static const int friendModuleAlreadyDeleteFromBlacklist = 6000806;

  /// The other party is not in your blacklist.
  static const int friendModuleUserNotInBlacklist = 6000807;

  /// The blacklist list quantity has reached the upper limit.
  static const int friendModuleBlacklistListQuantityLimit = 6000808;

  /// The friend list has reached the upper limit.
  static const int friendModuleFriendOperationLimitExceeded = 6000809;

  /// Cannot add yourself to the friend list.
  static const int friendModuleCannotAddSelfToFriendList = 6000810;

  /// The other party is not registered.
  static const int friendModuleFriendAreUnregistered = 6000811;

  /// The other party is not your friend.
  static const int friendModuleNotYourFriend = 6000812;

  /// Cannot delete yourself.
  static const int friendModuleCannotDeleteSelf = 6000813;

  /// The friend application has expired.
  static const int friendModuleFriendApplicationExpired = 6000814;

  /// Failed to add to blacklist.
  static const int friendModuleAddBlacklistFail = 6000815;

  /// Failed to delete from blacklist.
  static const int friendModuleDelBlacklistFail = 6000816;

  /// The common error of the community operation.
  static const int communityModuleCommonError = 6001001;

  /// The community operation server error.
  static const int communityModuleServerError = 6001002;

  /// The community already exists.
  static const int communityModuleCommunityAlreadyExists = 6001003;

  /// The community does not exist.
  static const int communityModuleCommunityDoesNotExist = 6001004;

  /// The user is not in the community.
  static const int communityModuleUserIsNotInCommunity = 6001005;

  /// The user is already in the community.
  static const int communityModuleUserAlreadyInCommunity = 6001006;

  /// Community permission error.
  static const int communityModuleCommunityAuthorityError = 6001007;

  /// The number of community attributes exceeds the limit.
  static const int communityModuleCommunityAttributesSizeError = 6001008;

  /// The community attribute key length exceeds the limit.
  static const int communityModuleCommunityAttributesKeyLengthError = 6001009;

  /// The community attribute value length exceeds the limit.
  static const int communityModuleCommunityAttributesValueLengthError = 6001010;

  /// Cannot create a community that has already been dismissed.
  static const int communityModuleCanNotCreateHasBeenDismissedCommunity =
      6001011;

  /// The number of communities exceeds the limit.
  static const int communityModuleCommunityCountLimit = 6001012;

  /// The community owner cannot quit the community.
  static const int communityModuleCommunityOwnerCanNotQuitError = 6001031;

  /// The number of community members exceeds the limit.
  static const int communityModuleCommunityMemberCountLimit = 6001032;

  /// Cannot kick yourself out of the community.
  static const int communityModuleCommunityKickOutSelfError = 6001033;

  /// No permission to kick out community members.
  static const int communityModuleKickOutCommunityMemberNoPermission = 6001034;

  /// Insufficient permission to kick out community members.
  static const int communityModuleKickOutCommunityMemberInsufficientPermission =
      6001035;

  /// All invited users do not exist.
  static const int communityModuleCommunityInviteAllUsersNotExist = 6001036;

  /// This operation can only be performed by the community owner.
  static const int communityModuleCommunityOperationOwnerOnly = 6001037;

  /// Cannot set a member's role to community owner.
  static const int communityModuleSetCommunityMemberRoleOwnerInvalid = 6001038;

  /// Modifying your own community member role is not allowed.
  static const int communityModuleSetCommunityMemberRoleSelfNotAllowed =
      6001039;

  /// The channel already exists.
  static const int communityModuleChannelAlreadyExists = 6001061;

  /// The channel does not exist.
  static const int communityModuleChannelDoesNotExist = 6001062;

  /// Cannot create a channel that has already been dismissed.
  static const int communityModuleCanNotCreateHasBeenDismissedChannel = 6001063;

  /// The number of channels exceeds the limit.
  static const int communityModuleChannelCountLimit = 6001064;

  /// Cannot dismiss the general channel.
  static const int communityModuleCanNotDismissGeneralChannel = 6001065;

  /// The channel does not belong to this community.
  static const int communityModuleChannelIsNotInTheCommunity = 6001066;

  /// The muted member is not in this channel.
  static const int communityModuleTheMutedMemberIsNotOnThisChannel = 6001067;

  /// The user has been visitor.
  static const int communityModuleHasBeenVisitor = 6001081;

  /// The user is not visitor.
  static const int communityModuleUserIsNotVisitor = 6001082;

  /// The community application does not exist.
  static const int communityModuleApplyNotExists = 6001091;

  /// The community application has already been changed by another operation.
  static const int communityModuleApplyAlreadyChanged = 6001092;

  /// The community application state does not allow this operation.
  static const int communityModuleApplyStatusError = 6001093;

  /// Joining the community is forbidden (joinMode is Forbid).
  static const int communityModuleForbidJoinCommunityError = 6001094;

  /// An application is required to join the community (joinMode is Auth).
  static const int communityModuleNeedApplyJoinCommunityError = 6001095;

  /// The user's community application list is full.
  static const int communityModuleApplyListFull = 6001096;

  /// There is already a waiting community application.
  static const int communityModuleApplyDuplicatePending = 6001097;
}
