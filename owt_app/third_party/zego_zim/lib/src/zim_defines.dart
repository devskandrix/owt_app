import 'dart:typed_data';

part 'internal/zim_defines_extension.dart';
part 'internal/zim_defines_utils.dart';

/// Connection state.
enum ZIMConnectionState {
  /// Unconnected state, enter this state before logging in and after logging out.
  disconnected,

  /// The state that the connection is being requested. It will enter this state after successful execution login function.
  connecting,

  /// The state that is successfully connected.
  connected,

  /// The connection is being reconnected.
  reconnecting,
}

/// The event that caused the connection status to change.
enum ZIMConnectionEvent {
  /// Success.
  success,

  /// The user actively logs in.
  activeLogin,

  /// Connection timed out.
  loginTimeout,

  /// The network connection is temporarily interrupted.
  interrupted,

  /// Being kicked out.
  kickedOut,

  /// Detail description: Disconnected due to expired login token.
  tokenExpired,

  /// The user account was unregistered.
  unregistered,
}

/// conversation changed event.
enum ZIMConversationEvent {
  /// A new conversation was added.
  added,

  /// The conversation was updated.
  updated,

  /// The conversation was disabled.
  disabled,

  /// The conversation was deleted.
  deleted,
}

/// Conversation list change action.
enum ZIMConversationListChangeAction {
  /// A conversation was added to the list.
  added,

  /// A conversation was deleted from the list.
  deleted,

  /// A conversation in the list was updated.
  updated,
}

/// Enumeration of conversation notification status.
enum ZIMConversationNotificationStatus {
  /// Message notifications are enabled.
  notify,

  /// Do not disturb mode is enabled.
  doNotDisturb,
}

/// Conversation type.
enum ZIMConversationType {
  /// Unknown conversation type.
  unknown,

  /// Conversation type peer.
  peer,

  /// Conversation type room.
  room,

  /// Conversation type group.
  group,

  /// Community channel conversation type.
  communityChannel,
}

/// Identifies the SDK's state in syncing conversation list from server.
enum ZIMConversationSyncState {
  /// Conversation list synchronization start status
  started,

  /// Conversation list synchronization completion status
  finished,

  /// The synchronization of the conversation list failed. The synchronization failure may be caused by network reasons.
  failed,
}

/// When a user queries the session list, it serves as a filter item for the top session of the query.
enum ZIMConversationPinnedFilter {
  /// Both pinned and unpinned conversations can be queried.
  all,

  /// Only pinned conversations can be queried.
  onlyPinned,

  /// Only unpinned conversations can be queried.
  onlyUnpinned,
}

/// Conversational search mode.
enum ZIMConversationSearchMode {
  /// Query the corresponding conversation by searching for messages that meet the criteria.
  matchMessage,

  /// Query the corresponding conversation by searching for the conversation name.
  matchConversationName,
}

/// Media file type
enum ZIMMediaFileType {
  /// Original file type, suitable for original images, audio files, and video files. After calling [downloadMediaFile], the SDK will update the fileLocalPath property in ZIMFileMessage.
  originalFile,

  /// Large image type. After calling [downloadMediaFile], the SDK will update the largeImageLocalPath property in [ZIMImageMessage].
  largeImage,

  /// Image thumbnail type. After calling [downloadMediaFile], the SDK will update the thumbnailLocalPath property in [ZIMImageMessage].
  thumbnail,

  /// The type of the first frame of the video. After calling [downloadMediaFile], the SDK will update the videoFirstFrameLocalPath property in [ZIMVideoMessage].
  videoFirstFrame,
}

/// the direction of the message.
enum ZIMMessageDirection {
  /// The message was sent by the local user.
  send,

  /// The message was received by the local user.
  receive,
}

/// Message order.
enum ZIMMessageOrder {
  /// Represents message list in descending order (message list order is from new to old).
  descending,

  /// Represents message list in ascending order (message list order is from old to new).
  ascending,
}

/// The priority of the message.
enum ZIMMessagePriority {
  /// Low priority.
  low,

  /// Medium priority.
  medium,

  /// High priority.
  high,
}

/// .
enum ZIMMessageQueryMode {
  /// General mode. In this mode, the SDK automatically determines whether it needs to request merged message data from the server. This mode is recommended for most common scenarios.
  general,

  /// Server-priority query mode.
  preferServer,

  /// Local-messages-only query mode.
  onlyLocal,
}

/// The status of the receipt
enum ZIMMessageReceiptStatus {
  /// Unknown receipt status.
  unknown,

  /// Not a receipt.
  none,

  /// Receipt in progress.
  processing,

  /// Receipt completed.
  done,

  /// Receipt has expired.
  expired,

  /// Receipt failed.
  failed,

  /// Receipt delivered.
  delivered,
}

/// Filter type for the message receipt member list.
enum ZIMMessageReceiptFilterType {
  /// Read members.
  read,

  /// Unread members.
  unread,

  /// Delivered members.
  delivered,
}

/// Message revoke status
enum ZIMMessageRevokeStatus {
  /// Unknown revoke status.
  unknown,

  /// The message was revoked by the sender.
  selfRevoke,

  /// The message was revoked by the system.
  systemRevoke,

  /// The message was revoked via the server API.
  serviceAPIRevoke,

  /// The message was revoked by a group administrator.
  groupAdminRevoke,

  /// The message was revoked by the group owner.
  groupOwnerRevoke,

  /// Revoked for audit reject.
  auditRejectRevoke,
}

/// The status of the message being sent.
enum ZIMMessageSentStatus {
  /// The message is being sent.
  sending,

  /// The message was sent successfully.
  success,

  /// The message failed to send.
  failed,
}

/// The type of the message.
enum ZIMMessageType {
  /// Unknown message.
  unknown,

  /// Normal text message.
  text,

  /// Custom binary message.
  command,

  /// Multiple messages can be used to send multiple messages of text, rich media files, and custom messages.
  multiple,

  /// Image message.
  image,

  /// File message.
  file,

  /// Audio message.
  audio,

  /// Video message.
  video,

  /// Barrage message.
  barrage,

  /// Reovked message.
  revoke,

  /// Tips message.
  tips,

  /// Combined message.
  combine,

  /// Custom message.
  custom,
}

/// The type of the revoke message.
enum ZIMRevokeType {
  /// Unknown revoke type.
  unknown,

  /// Two-way revoke: the message is deleted for both sender and recipient.
  twoWay,

  /// One-way revoke: the message is deleted for the sender only.
  oneWay,
}

/// Event of tips message.
enum ZIMTipsMessageEvent {
  /// Unknown tips message event.
  unknown,

  /// The group was created.
  groupCreated,

  /// The group was dismissed.
  groupDismissed,

  /// A member joined the group.
  groupJoined,

  /// A member was invited to join the group.
  groupInvited,

  /// A member left the group.
  groupLeft,

  /// A member was kicked out of the group.
  groupKickedOut,

  /// The group information was changed.
  groupInfoChanged,

  /// The group member information was changed.
  groupMemberInfoChanged,

  /// A group message was pinned.
  groupMessagePinned,

  /// The community was created.
  communityCreated,

  /// A member joined the community.
  communityJoined,

  /// A member was invited to join the community.
  communityInvited,

  /// A community channel was created.
  communityChannelCreated,
}

/// Type of additional information for tips messages.
enum ZIMTipsMessageChangeInfoType {
  /// Unknown change info type.
  unknown,

  /// Group name, group avatar, and group notice have multiple changes.
  groupDataChanged,

  /// Group notice change event.
  groupNoticeChanged,

  /// Group name change event.
  groupNameChanged,

  /// Group avatar change event.
  groupAvatarUrlChanged,

  /// Group mute info change event.
  groupMuteChanged,

  /// Group owner transfer event.
  groupOwnerTransferred,

  /// Group member role change event.
  groupMemberRoleChanged,

  /// The group member mute status changed.
  groupMemberMuteChanged,

  /// Group messages are pinned or unpinned event.
  groupMessagePinInfoChanged,
}

/// The type of the revoke message.
enum ZIMMessageMentionedType {
  /// Unknown mention type.
  unknown,

  /// mention me
  mentionMe,

  /// mention all user
  mentionAll,

  /// mention all user and mention me
  mentionAllAndMe,
}

/// Message deleted type
enum ZIMMessageDeleteType {
  /// User-initiated message deletion event.
  messageListDeleted,

  /// User-initiated event for deleting all messages in a conversation.
  conversationAllMessagesDeleted,

  /// User-initiated event for deleting all messages across all conversations.
  allConversationMessagesDeleted,

  /// Message deletion event triggered by scheduled message self-destruction.
  messagesDestructed,
}

/// The state of the source message to be replied.
enum ZIMMessageRepliedInfoState {
  /// normal state.
  normal,

  /// deleted state.
  deleted,

  /// Not found. The original message may have expired on the server or is not visible to the current user.
  notFound,
}

/// Enumeration of message pinned status.
enum ZIMMessagePinStatus {
  /// The message is not pinned.
  notPinned,

  /// The message is pinned.
  pinned,

  /// The message pin status was updated.
  updated,
}

/// User operation action for message reactions.
enum ZIMMessageReactionUserChangeAction {
  /// Add message reaction.
  added,

  /// Delete message reaction.
  deleted,
}

/// The event that caused the room connection status to change.
enum ZIMRoomEvent {
  /// Success.
  success,

  /// The network in the room is temporarily interrupted.
  interrupted,

  /// The network in the room is disconnected.
  disconnected,

  /// The room not exist.
  roomNotExist,

  /// The user actively creates a room.
  activeCreate,

  /// Failed to create room.
  createFailed,

  /// The user starts to enter the room.
  activeEnter,

  /// user failed to enter the room.
  enterFailed,

  /// user was kicked out of the room.
  kickedOut,

  /// The connection to the room timed out.
  connectTimeout,

  /// Multi-device logins into the same room will result in the user being kicked out of the room.
  kickedOutByOtherDevice,

  /// Switch room.
  activeSwitch,

  /// Switch room failed.
  switchFailed,
}

/// Used to indicate the user's connection status to the room.
enum ZIMRoomState {
  /// Indicates that the connection to the room is interrupted, and the [createRoom], [joinRoom], and [enterRoom] fails. If the network is disconnected for a long time, the heartbeat of the room times out, the background notifies the user that he has been kicked out of the room, or the logout will throw this status.
  disconnected,

  /// connecting indicates that the connection between a room and a room is in the connecting state. When the create, join, or enter room connection is not returned, this state is thrown when the network is disconnected.
  connecting,

  /// connected indicates that the device is properly connected to the room. If create, join, or enter room succeeds, the state will be thrown if the network is disconnected and the room heartbeat does not time out.
  connected,
}

/// Room attributes update action.
enum ZIMRoomAttributesUpdateAction {
  /// Set action.
  set,

  /// Delete the room attributes.
  delete,
}

/// The action type for room member attribute updates.
enum ZIMRoomMemberAttributesUpdateAction {
  /// Set the room member attributes.
  set,
}

/// group status.
enum ZIMGroupState {
  /// The local user has left the group.
  quit,

  /// The local user has entered the group.
  enter,
}

/// Group events.
enum ZIMGroupEvent {
  /// Unknown event.
  unknown,

  /// The group was created.
  created,

  /// The group was dismissed.
  dismissed,

  /// A member joined the group.
  joined,

  /// A member was invited to join the group.
  invited,

  /// A member left the group.
  left,

  /// A member was kicked out of the group.
  kickedOut,
}

/// Group member events.
enum ZIMGroupMemberEvent {
  /// Unknown event.
  unknown,

  /// A member joined the group.
  joined,

  /// A member left the group.
  left,

  /// A member was kicked out of the group.
  kickedOut,

  /// A member was invited to join the group.
  invited,
}

/// group membership status.
enum ZIMGroupMemberState {
  /// The member has left the group.
  quit,

  /// The member has entered the group.
  enter,
}

/// Enumeration of group notification status.
enum ZIMGroupMessageNotificationStatus {
  /// Message notifications are enabled.
  notify,

  /// Do not disturb mode is enabled.
  doNotDisturb,
}

/// Group attributes update action.
enum ZIMGroupAttributesUpdateAction {
  /// Set action.
  set,

  /// Delete the group attributes.
  delete,
}

/// Group mute mode.
enum ZIMGroupMuteMode {
  /// Unmute.
  none,

  /// Group normal members mute mode.
  normal,

  /// Group all members mute mode.
  all,

  /// Customize group mute mode
  custom,
}

/// Verification mode for joining the group.
enum ZIMGroupJoinMode {
  /// Anyone can join the group directly.
  any,

  /// Requires group owner or administrator approval.
  auth,

  /// Joining the group is prohibited.
  forbid,
}

/// Verification mode for invite to the group.
enum ZIMGroupInviteMode {
  /// Everyone in the group can invite.
  any,

  /// Only group owners or administrators can invite.
  admin,
}

/// Verification mode for being invited to the group.
enum ZIMGroupBeInviteMode {
  /// The invitees enter the group directly.
  none,

  /// The invitee's consent is required to join the group.
  auth,
}

/// Group enter type.
enum ZIMGroupEnterType {
  /// Unknown enter type.
  unknown,

  /// The user created the group.
  created,

  /// The user joined the group via an application.
  joinApply,

  /// The user actively joined the group.
  joined,

  /// The user was invited to join the group.
  invited,

  /// The user joined the group via invitation application.
  inviteApply,
}

/// Group application type.
enum ZIMGroupApplicationType {
  /// Unknown group application type.
  unknown,

  /// None.
  none,

  /// Join type.
  join,

  /// Invite type.
  invite,

  /// Be invite type.
  beInvite,
}

/// Group application state.
enum ZIMGroupApplicationState {
  /// Unknown group application state.
  unknown,

  /// Awaiting response.
  waiting,

  /// Accepted.
  accepted,

  /// Rejected.
  rejected,

  /// Expired.
  expired,

  /// Disabled
  disabled,
}

/// Group  application list update action.
enum ZIMGroupApplicationListChangeAction {
  /// Add action.
  added,
}

/// Group member role
class ZIMGroupMemberRole {
  /// Group Owner.
  static const int owner = 1;

  /// Group Admin.
  static const int admin = 2;

  /// Group Member.
  static const int member = 3;
}

/// The flag type for group data fields.
class ZIMGroupDataFlag {
  /// Group name data flag.
  static const int name = 1;

  /// Group notice data flag.
  static const int notice = 2;

  /// Group avatar URL data flag.
  static const int avatarUrl = 4;
}

/// Call invitation mode.
enum ZIMCallInvitationMode {
  /// Unknown type, as a guaranteed enumeration value.
  unknown,

  /// general.
  general,

  /// advanced
  advanced,
}

/// call status.
enum ZIMCallState {
  /// Unknown call state.
  unknown,

  /// The call has started.
  started,

  /// The call has ended.
  ended,
}

/// Call user status.
enum ZIMCallUserState {
  /// unknown
  unknown,

  /// inviting.
  inviting,

  /// accepted.
  accepted,

  /// rejected.
  rejected,

  /// cancelled.
  cancelled,

  /// received.
  received,

  /// timeout.
  timeout,

  /// quit.
  quit,

  /// ended.
  ended,

  /// Not received.
  notYetReceived,

  /// Be cancelled.
  beCancelled,
}

/// User type.
enum ZIMUserInfoType {
  /// Basic user type.
  basicUser,

  /// Room member type.
  roomMember,

  /// Group member type.
  groupMember,

  /// Group member brief info type.
  groupSimpleMember,

  /// Friend type.
  friend,

  /// Community member type.
  communityMember,

  /// Community member brief info type.
  communitySimpleMember,
}

/// friend list update action.
enum ZIMFriendListChangeAction {
  /// Add action.
  added,

  /// Delete action.
  deleted,
}

/// friend  application list update action.
enum ZIMFriendApplicationListChangeAction {
  /// Add action.
  added,

  /// Delete action.
  deleted,
}

/// Friend application type.
enum ZIMFriendApplicationType {
  /// Unknown friend application type.
  unknown,

  /// Friend application type none.
  none,

  /// Applications received.
  received,

  /// Application sent.
  sent,

  /// Both parties sent friend applications to each other.
  both,
}

/// Friend application state.
enum ZIMFriendApplicationState {
  /// Unknown friend application state.
  unknown,

  /// Awaiting response.
  waiting,

  /// Accepted.
  accepted,

  /// Rejected.
  rejected,

  /// The friend application has expired.
  expired,

  /// The friend application is disabled.
  disabled,
}

/// Check the friend relationship type.
enum ZIMFriendRelationCheckType {
  /// Check the friend relationship from both sides.
  both,

  /// Check the friend relationship from one side only.
  single,
}

/// Delete friend type.
enum ZIMFriendDeleteType {
  /// Delete the friend from both sides.
  both,

  /// Delete the friend from one side only.
  single,
}

/// Friend relationship type.
enum ZIMUserRelationType {
  /// Unknown relation type.
  unknown,

  /// No friendship from the user's perspective.
  singleNo,

  /// Friendship exists from the user's perspective.
  singleHave,

  /// No friendship from either side.
  bothAllNo,

  /// The user has added the other as a friend, but not vice versa.
  bothSelfHave,

  /// The other party has added the user as a friend, but not vice versa.
  bothOtherHave,

  /// Both parties are friends with each other.
  bothAllHave,
}

/// blacklist update action.
enum ZIMBlacklistChangeAction {
  /// Add action.
  added,

  /// Removed action.
  removed,
}

/// Type of contact information for the VoIP initiator.
enum ZIMCXHandleType {
  /// Generic handle type.
  generic,

  /// Phone number handle type.
  phoneNumber,

  /// Email address handle type.
  emailAddress,
}

/// Geofencing type.
enum ZIMGeofencingType {
  /// The default type.
  none,

  /// Federated mode.
  include,

  /// Exclusion mode.
  exclude,
}

/// Geofencing Area
class ZIMGeofencingArea {
  /// China
  static const int CN = 2;

  /// North America
  static const int NA = 3;

  /// Europe
  static const int EU = 4;

  /// Asia
  static const int AS = 5;

  /// India
  static const int IN = 6;
}

/// Platform on which the SDK runs.
enum ZIMPlatformType {
  /// Windows.
  win,

  /// iOS.
  iPhoneOS,

  /// Android.
  android,

  /// MacOS.
  macOS,

  /// Linux.
  linux,

  /// Web.
  web,

  /// Mini program.
  miniProgram,

  /// iPad.
  iPadOS,

  /// HarmonyOS (OHOS) platform.
  ohos,

  /// Platforms not mentioned above.
  unknown,
}

/// User online status.
enum ZIMUserOnlineStatus {
  /// Online. The user is in this state when the user is logged in and the network status is good.
  online,

  /// Offline. The user does not call logout to actively logout because the network is disconnected, the app is killed, the background is withdrawn, and the screen is locked. The user will be in this state after the long background link is disconnected.
  offline,

  /// Log out. User active logout will be in this state.
  logout,

  /// Unknown status. Guaranteed enumeration.
  unknown,
}

/// The action type for list changes.
enum ZIMListChangeAction {
  /// An item was added.
  added,

  /// An item was deleted.
  deleted,
}

/// The action type for community list changes.
enum ZIMCommunityListChangeAction {
  /// A community was added.
  added,

  /// A community was deleted.
  deleted,

  /// A community was updated.
  updated,
}

/// The enter type for community members.
enum ZIMCommunityMemberEnterType {
  /// Unknown enter type.
  unknown,

  /// The member joined when the community was created.
  communityCreated,

  /// The member actively joined the community.
  communityJoined,

  /// The member was invited to join the community.
  communityInvited,
}

/// The state change type for community members.
enum ZIMCommunityMemberChangeState {
  /// The member exited the community.
  exited,

  /// The member entered the community.
  entered,
}

/// The action type for community member status changes.
enum ZIMCommunityMemberChangeAction {
  /// Unknown action.
  unknown,

  /// The member actively joined the community.
  joined,

  /// The member was invited to join the community.
  invited,

  /// The member actively left the community.
  left,

  /// The member was kicked out of the community.
  kickedOut,
}

/// The type of community channel.
enum ZIMCommunityChannelType {
  /// Unknown channel.
  unknown,

  /// Default channel, automatically created when the community is created.
  general,

  /// Public channel, visible to all members of the community.
  public,

  /// Private channel, visible only to specific members.
  private,
}

/// The action type for community channel list changes.
enum ZIMCommunityChannelListChangeAction {
  /// A community channel was added.
  added,

  /// A community channel was deleted.
  deleted,

  /// A community channel was updated.
  updated,
}

/// The mute mode for community channels.
enum ZIMCommunityChannelMuteMode {
  /// No mute mode.
  none,

  /// Normal mute mode; only administrators and the owner can speak.
  normal,

  /// All members are muted.
  all,

  /// Custom mute mode.
  custom,
}

/// The mute type for community members.
enum ZIMCommunityMemberMuteType {
  /// Not muted.
  none,

  /// Muted at the community level.
  community,

  /// Muted at the community channel level.
  channel,
}

/// Verification mode for joining the community.
enum ZIMCommunityJoinMode {
  /// Anyone can join the community directly.
  any,

  /// Join requires approval from owner or admin.
  auth,

  /// Join and application are forbidden.
  forbid,
}

/// Community application type.
enum ZIMCommunityApplicationType {
  /// Unknown community application type.
  unknown,

  /// None.
  none,

  /// Join type.
  join,

  /// Invite type.
  invite,

  /// Be invite type.
  beInvite,
}

/// Community application state.
enum ZIMCommunityApplicationState {
  /// Unknown community application state.
  unknown,

  /// Awaiting response.
  waiting,

  /// Accepted.
  accepted,

  /// Rejected.
  rejected,

  /// Expired.
  expired,

  /// Disabled.
  disabled,

  /// Cancelled by the applicant.
  cancelled,

  /// The applicant has already joined the community in other ways (such as being invited), and the application is invalid.
  joined,
}

/// Community application list change action.
enum ZIMCommunityApplicationListAction {
  /// Add action.
  added,

  /// Delete action.
  deleted,

  /// Update action.
  updated,
}

/// The notification status for community messages.
enum ZIMCommunityMessageNotificationStatus {
  /// Message notifications are enabled.
  notify,

  /// Do not disturb mode is enabled.
  doNotDisturb,
}

/// Community member role
class ZIMCommunityMemberRole {
  /// Community Owner.
  static const int owner = 1;

  /// Community Admin.
  static const int admin = 2;

  /// Community Member.
  static const int member = 3;
}

/// Error infomation
///
/// Description: Error infomation.
class ZIMError {
  /// Description: The storage path of the log files. Refer to the official website document for the default path.
  int code;

  /// Description: Error infomation description.
  String message;

  ZIMError({required this.code, required this.message});

  ZIMError.fromMap(Map<dynamic, dynamic> map)
    : code = map['code']!,
      message = map['message']!;

  Map<String, dynamic> toMap() {
    return {'code': code, 'message': message};
  }
}

/// ZIM application configuration, including AppID and AppSign.
class ZIMAppConfig {
  /// Description:AppID, please go to the ZEGO official website console to apply for it. Required: Required.
  int appID;

  /// Description:AppSign, please go to the ZEGO official website console to apply for it. Required: Required.
  String appSign;

  ZIMAppConfig({this.appID = 0, this.appSign = ''});

  ZIMAppConfig.fromMap(Map<dynamic, dynamic> map)
    : appID = map['appID']!,
      appSign = map['appSign']!;

  Map<String, dynamic> toMap() {
    return {'appID': appID, 'appSign': appSign};
  }
}

/// Log configuration
///
/// Description: Configure the storage path of log files and the maximum log file size.
class ZIMLogConfig {
  /// The storage path of the log files. Refer to the official website document for the default path.
  String logPath;

  /// The maximum log file size (Bytes). The default maximum size is 5MB (5 * 1024 * 1024 Bytes)
  int logSize;

  /// Description: Log level, only used on the web platform. Required: Not required. Default value: 0.
  int? logLevel;

  ZIMLogConfig({this.logPath = '', this.logSize = 5242880, this.logLevel});

  ZIMLogConfig.fromMap(Map<dynamic, dynamic> map)
    : logPath = map['logPath']!,
      logSize = map['logSize']!,
      logLevel = map['logLevel'];

  Map<String, dynamic> toMap() {
    return {'logPath': logPath, 'logSize': logSize, 'logLevel': logLevel};
  }
}

/// Cache configuration
///
/// Description: Configure the storage path of cache files (such as chat records).
class ZIMCacheConfig {
  /// The storage path of the cache files. Refer to the official website document for the default path.
  String cachePath;

  ZIMCacheConfig({this.cachePath = ''});

  ZIMCacheConfig.fromMap(Map<dynamic, dynamic> map)
    : cachePath = map['cachePath']!;

  Map<String, dynamic> toMap() {
    return {'cachePath': cachePath};
  }
}

/// User information object.
///
/// Description: Identifies a unique user.
/// Caution: Note that the userID must be unique under the same appID, otherwise mutual kicks out will occur. It is strongly recommended that userID corresponds to the user ID of the business APP, that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID. Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems.
class ZIMUserInfo {
  /// User ID, a string with a maximum length of 32 bytes or less. It is customized by the developer. Only support numbers, English characters and  '!', '#', '$', '%', '&', '(', ')', '+', '-', ':', ';', '<', '=', '.', '>', '?', '@', '[', ']', '^', '_', '{', '}', '|', '~'.
  String userID;

  /// Description: User name, defined by you. For version 2.0.0 and onwards, the string has a maximum length of 256 bytes.Required: Not required.Privacy reminder: Please do not provide sensitive personal information, including but not limited to mobile phone numbers, ID card numbers, passport numbers, and real names.
  String userName;

  /// User avatar URL
  String userAvatarUrl;

  /// User extended data. This field is currently only available in room related interfaces.
  String userExtendedData;

  /// User Type. This field is used to identify which subclass the current entity belongs to.
  ZIMUserInfoType type;

  ZIMUserInfo({
    this.userID = '',
    this.userName = '',
    this.userAvatarUrl = '',
    this.userExtendedData = '',
    this.type = ZIMUserInfoType.basicUser,
  });

  ZIMUserInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      userName = map['userName']!,
      userAvatarUrl = map['userAvatarUrl']!,
      userExtendedData = map['userExtendedData']!,
      type =
          ZIMUserInfoTypeExtension.mapValue[map['type']] ??
          ZIMUserInfoType.basicUser;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'userExtendedData': userExtendedData,
      'type': type.value,
    };
  }
}

/// User full information object.
///
/// Description: Identifies a unique user.
/// Caution: Note that the userID must be unique under the same appID, otherwise mutual kicks out will occur. It is strongly recommended that userID corresponds to the user ID of the business APP, that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID. Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems.
class ZIMUserFullInfo {
  /// Description: User basic information.
  ZIMUserInfo baseInfo;

  ZIMUserFullInfo({required this.baseInfo});

  ZIMUserFullInfo.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMDataUtils.parseZIMUserInfoFromMap(map['baseInfo']);

  Map<String, dynamic> toMap() {
    return {'baseInfo': baseInfo.toMap()};
  }
}

/// Data class of the user's offline push rule.
///
/// Description: Data class of the user's offline push rule.
class ZIMUserOfflinePushRule {
  /// With the data in the class member variables notToReceiveOfflinePushPlatforms collocation is used. OnlinePlatforms specified platform, online notToReceiveOfflinePushPlatforms specified platform will not receive offline push.
  List<ZIMPlatformType> onlinePlatforms;

  /// With the data in the class member variables onlinePlatforms collocation is used. OnlinePlatforms specified platform, online notToReceiveOfflinePushPlatforms specified platform will not receive offline push.
  List<ZIMPlatformType> notToReceiveOfflinePushPlatforms;

  ZIMUserOfflinePushRule({
    List<ZIMPlatformType>? onlinePlatforms,
    List<ZIMPlatformType>? notToReceiveOfflinePushPlatforms,
  }) : onlinePlatforms = onlinePlatforms ?? [],
       notToReceiveOfflinePushPlatforms =
           notToReceiveOfflinePushPlatforms ?? [];

  ZIMUserOfflinePushRule.fromMap(Map<dynamic, dynamic> map)
    : onlinePlatforms =
          ((map['onlinePlatforms']!) as List)
              .map<ZIMPlatformType>(
                (item) =>
                    ZIMPlatformTypeExtension.mapValue[item] ??
                    ZIMPlatformType.unknown,
              )
              .toList(),
      notToReceiveOfflinePushPlatforms =
          ((map['notToReceiveOfflinePushPlatforms']!) as List)
              .map<ZIMPlatformType>(
                (item) =>
                    ZIMPlatformTypeExtension.mapValue[item] ??
                    ZIMPlatformType.unknown,
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'onlinePlatforms': onlinePlatforms.map((item) => item.value).toList(),
      'notToReceiveOfflinePushPlatforms':
          notToReceiveOfflinePushPlatforms.map((item) => item.value).toList(),
    };
  }
}

/// User rule configuration.
class ZIMUserRule {
  /// The user's current rule information.
  ZIMUserOfflinePushRule offlinePushRule;

  ZIMUserRule({required this.offlinePushRule});

  ZIMUserRule.fromMap(Map<dynamic, dynamic> map)
    : offlinePushRule = ZIMUserOfflinePushRule.fromMap(map['offlinePushRule']);

  Map<String, dynamic> toMap() {
    return {'offlinePushRule': offlinePushRule.toMap()};
  }
}

/// User status data
///
/// Description: Contains data about the user's online status.
class ZIMUserStatus {
  /// A unique identifier for a single user.
  String userID;

  /// Enumeration that represents the current online status of the user.
  ZIMUserOnlineStatus onlineStatus;

  /// The list of online platforms of the current user can be used to display the online platforms of the user, such as iPhone online and PC online. Please refer to ZIMPlatform for the meanings of the numbers.
  List<ZIMPlatformType> onlinePlatforms;

  /// User-defined status. The default maximum value is 64 bytes. The default expiration time is 1 day. At login, if the field is an empty string (which is the default), the current user's custom state is not modified.
  String customStatus;

  /// Expired timestamp of the custom status.
  int customStatusExpiredTime;

  /// Timestamp when user onlineStatus or customStatus was last changed, whichever is the greater.
  int lastUpdateTime;

  /// The timestamp of the last change of the user onlineStatus, which can be used to show that the user was offline/logged in before xxx minutes.
  int lastOnlineStatusUpdateTime;

  /// The timestamp when User customStatus was last changed, which can be used to show when the custom status was last changed.
  int lastCustomStatusUpdateTime;

  ZIMUserStatus({
    required this.userID,
    required this.onlineStatus,
    required this.onlinePlatforms,
    required this.customStatus,
    required this.customStatusExpiredTime,
    required this.lastUpdateTime,
    required this.lastOnlineStatusUpdateTime,
    required this.lastCustomStatusUpdateTime,
  });

  ZIMUserStatus.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      onlineStatus =
          ZIMUserOnlineStatusExtension.mapValue[map['onlineStatus']] ??
          ZIMUserOnlineStatus.unknown,
      onlinePlatforms =
          ((map['onlinePlatforms']!) as List)
              .map<ZIMPlatformType>(
                (item) =>
                    ZIMPlatformTypeExtension.mapValue[item] ??
                    ZIMPlatformType.unknown,
              )
              .toList(),
      customStatus = map['customStatus']!,
      customStatusExpiredTime = map['customStatusExpiredTime']!,
      lastUpdateTime = map['lastUpdateTime']!,
      lastOnlineStatusUpdateTime = map['lastOnlineStatusUpdateTime']!,
      lastCustomStatusUpdateTime = map['lastCustomStatusUpdateTime']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'onlineStatus': onlineStatus.value,
      'onlinePlatforms': onlinePlatforms.map((item) => item.value).toList(),
      'customStatus': customStatus,
      'customStatusExpiredTime': customStatusExpiredTime,
      'lastUpdateTime': lastUpdateTime,
      'lastOnlineStatusUpdateTime': lastOnlineStatusUpdateTime,
      'lastCustomStatusUpdateTime': lastCustomStatusUpdateTime,
    };
  }
}

/// User status subscription information. Contains the user's online status, a list of online platforms, subscription expiration time stamps, and more.
///
/// Available since: 2.18.0
/// Description: User status subscription information. Contains the user's online status, a list of online platforms, subscription expiration time stamps, and more.
class ZIMUserStatusSubscription {
  /// The online status of the user.
  ZIMUserStatus userStatus;

  /// The timestamp when the user's subscription expired.
  int subscribeExpiredTime;

  ZIMUserStatusSubscription({
    required this.userStatus,
    required this.subscribeExpiredTime,
  });

  ZIMUserStatusSubscription.fromMap(Map<dynamic, dynamic> map)
    : userStatus = ZIMUserStatus.fromMap(map['userStatus']),
      subscribeExpiredTime = map['subscribeExpiredTime']!;

  Map<String, dynamic> toMap() {
    return {
      'userStatus': userStatus.toMap(),
      'subscribeExpiredTime': subscribeExpiredTime,
    };
  }
}

/// Carry user information and rules of the current user.
///
/// Description: Carry user information and rules of the current user.
class ZIMSelfUserInfo {
  /// Personal information of the current user.
  ZIMUserFullInfo userFullInfo;

  /// Rules for the current user, setting information.
  ZIMUserRule userRule;

  /// The online status of the user.
  ZIMUserStatus userStatus;

  ZIMSelfUserInfo({
    required this.userFullInfo,
    required this.userRule,
    required this.userStatus,
  });

  ZIMSelfUserInfo.fromMap(Map<dynamic, dynamic> map)
    : userFullInfo = ZIMUserFullInfo.fromMap(map['userFullInfo']),
      userRule = ZIMUserRule.fromMap(map['userRule']),
      userStatus = ZIMUserStatus.fromMap(map['userStatus']);

  Map<String, dynamic> toMap() {
    return {
      'userFullInfo': userFullInfo.toMap(),
      'userRule': userRule.toMap(),
      'userStatus': userStatus.toMap(),
    };
  }
}

/// subscribeUsersStatus Configuration items of the online status interface for subscribing users in batches.
///
/// Description: subscribeUsersStatus Configuration items of the online status interface for subscribing users in batches.
class ZIMUserStatusSubscribeConfig {
  /// Subscription duration, in minutes.
  int subscriptionDuration;

  ZIMUserStatusSubscribeConfig({this.subscriptionDuration = 0});

  ZIMUserStatusSubscribeConfig.fromMap(Map<dynamic, dynamic> map)
    : subscriptionDuration = map['subscriptionDuration']!;

  Map<String, dynamic> toMap() {
    return {'subscriptionDuration': subscriptionDuration};
  }
}

/// QuerySubscribedUserStatusList query subscription list interface configuration items.
///
/// Description: QuerySubscribedUserStatusList query subscription list interface configuration items.
class ZIMSubscribedUserStatusQueryConfig {
  /// List of user IDs to query.
  List<String> userIDs;

  ZIMSubscribedUserStatusQueryConfig({List<String>? userIDs})
    : userIDs = userIDs ?? [];

  ZIMSubscribedUserStatusQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : userIDs =
          ((map['userIDs']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'userIDs': userIDs};
  }
}

/// User custom status update configuration.
///
/// Available since: 2.29.0 and above.
/// Description: Update user custom status parameters.
class ZIMUserCustomStatusUpdateConfig {
  /// Duration of user custom status.
  int duration;

  ZIMUserCustomStatusUpdateConfig({this.duration = 86400});

  ZIMUserCustomStatusUpdateConfig.fromMap(Map<dynamic, dynamic> map)
    : duration = map['duration']!;

  Map<String, dynamic> toMap() {
    return {'duration': duration};
  }
}

/// Error user information class.
///
/// Description: Used to show the failed user and the reason for the failure.
class ZIMErrorUserInfo {
  /// User ID, a string with a maximum length of 32 bytes or less. It is customized by the developer. Only support numbers, English characters and '!', '#', '$', '%', '&', '(', ')', '+', '-', ':', ';', '<', '=', '.', '>', '?', '@', '[', ']', '^', '_', '{', '}', '|', '~'.
  String userID;

  /// Description Reason for the query failure.
  int reason;

  ZIMErrorUserInfo({required this.userID, required this.reason});

  ZIMErrorUserInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      reason = map['reason']!;

  Map<String, dynamic> toMap() {
    return {'userID': userID, 'reason': reason};
  }
}

/// Configuration of login-related parameters.
///
/// Available since: 2.13.0 and above.
/// Description: Login-related parameters.
/// Use cases: Used to set different parameters during login.
class ZIMLoginConfig {
  /// Description: User name.Use cases: Used in the scenario where user nickname is modified during login, leave it blank if no change is needed.Required: No.
  String userName;

  /// Description: Token carried during login.Use cases: Only pass this parameter in the scenario where token is used for authentication.Required: No.
  String token;

  /// Description: Whether it is offline login.Use cases: Set this parameter to true when performing offline login.Required: No.Default value: false.
  bool isOfflineLogin;

  /// Description: Custom status.Use cases: Only pass this parameter when you need to customize the user status during login.Required: No.
  String customStatus;

  /// Description: Expired duration of the custom status.
  int customStatusDuration;

  ZIMLoginConfig({
    this.userName = '',
    this.token = '',
    this.isOfflineLogin = false,
    this.customStatus = '',
    this.customStatusDuration = 86400,
  });

  ZIMLoginConfig.fromMap(Map<dynamic, dynamic> map)
    : userName = map['userName']!,
      token = map['token']!,
      isOfflineLogin = map['isOfflineLogin']!,
      customStatus = map['customStatus']!,
      customStatusDuration = map['customStatusDuration']!;

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'token': token,
      'isOfflineLogin': isOfflineLogin,
      'customStatus': customStatus,
      'customStatusDuration': customStatusDuration,
    };
  }
}

/// User information query configuration.
///
/// Description: User information query configuration, you can choose to query from the local or from the server. Query the unlimited frequency constraints from the local, and query the limited frequency constraints from the server. You can only query the detailed configuration of 10 users within 10 s.
class ZIMUserInfoQueryConfig {
  /// Detail description: Whether to query user details from the server. Query the unlimited frequency constraints from the local, and query the limited frequency constraints from the server. You can only query the detailed configuration of 10 users within 10 s.Required: not required.Default: false.
  bool isQueryFromServer;

  ZIMUserInfoQueryConfig({this.isQueryFromServer = false});

  ZIMUserInfoQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : isQueryFromServer = map['isQueryFromServer']!;

  Map<String, dynamic> toMap() {
    return {'isQueryFromServer': isQueryFromServer};
  }
}

/// The private message template is currently only applicable to the OPPO manufacturer.
///
/// Description: According to [OPUSH DMS template check ability to access instructions](https://open.oppomobile.com/documentation/page/info?id=12391), OPPO in new message classification on the basis of the new push DMS templates, After you have configured the private message template in the OPPO console, if you need to apply the corresponding template during push notifications, you can assign a value to the privateMessageTemplate in ZIMPushConfig.
class ZIMOfflinePushPrivateMessageTemplate {
  /// Description: The private message template ID is currently only applicable to OPPO manufacturers. Please fill in the template ID preset in the OPPO Open Platform console.
  String templateID;

  /// Description: To replace the content of the preset title field in the template, a json string needs to be filled in, such as "{"user_name":" Li Hua "}".
  String titleParameters;

  /// Description: To replace the content of the preset fields in the template, a json string needs to be filled in, such as "{"city":" Shenzhen "}".
  String contentParameters;

  ZIMOfflinePushPrivateMessageTemplate({
    this.templateID = '',
    this.titleParameters = '',
    this.contentParameters = '',
  });

  ZIMOfflinePushPrivateMessageTemplate.fromMap(Map<dynamic, dynamic> map)
    : templateID = map['templateID']!,
      titleParameters = map['titleParameters']!,
      contentParameters = map['contentParameters']!;

  Map<String, dynamic> toMap() {
    return {
      'templateID': templateID,
      'titleParameters': titleParameters,
      'contentParameters': contentParameters,
    };
  }
}

/// Provides information about the iOS VoIP offline push.
///
/// Description: Provides information about the iOS VoIP offline push.
class ZIMVoIPConfig {
  /// Description: The type of contact information for the VoIP caller, by default, is generic.
  ZIMCXHandleType iOSVoIPHandleType;

  /// Description: The contact information of the VoIP caller. It is related to iOSVoIPHandleType. When iOSVoIPHandleType is PhoneNumber, the Value is a sequence of digits; when iOSVoIPHandleType is EmailAddress, the Value is an email address; when the contact information is of other types, the Value typically follows some domain-specific format, such as a username, numeric ID, or URL.
  String iOSVoIPHandleValue;

  /// Description: Video call or not. The default value is audio
  bool iOSVoIPHasVideo;

  ZIMVoIPConfig({
    this.iOSVoIPHandleType = ZIMCXHandleType.generic,
    this.iOSVoIPHandleValue = '',
    this.iOSVoIPHasVideo = false,
  });

  ZIMVoIPConfig.fromMap(Map<dynamic, dynamic> map)
    : iOSVoIPHandleType =
          ZIMCXHandleTypeExtension.mapValue[map['iOSVoIPHandleType']] ??
          ZIMCXHandleType.generic,
      iOSVoIPHandleValue = map['iOSVoIPHandleValue']!,
      iOSVoIPHasVideo = map['iOSVoIPHasVideo']!;

  Map<String, dynamic> toMap() {
    return {
      'iOSVoIPHandleType': iOSVoIPHandleType.value,
      'iOSVoIPHandleValue': iOSVoIPHandleValue,
      'iOSVoIPHasVideo': iOSVoIPHasVideo,
    };
  }
}

/// Description: Offline push configuration.
///
/// Description: Configuration before sending offline push.
class ZIMPushConfig {
  /// Description: Used to set the push title.Required: Not required.
  String title;

  /// Description: Used to set offline push content.Required: Not required.
  String content;

  /// Description: This parameter is used to set the pass-through field of offline push.Required: Not required.
  String payload;

  /// Description: Offline push advanced configuration for mapping console Settings, with the maximum of 32 characters and defined by yourself.Required: Not required.
  String resourcesID;

  /// Description: Used to set the thread ID of offline push.Required: Not required.
  String threadID;

  /// Description: Push whether to carry corner information switch.
  bool enableBadge;

  /// Description: The incremental index number carried by the push.
  int badgeIncrement;

  /// Description: If you use Flutter, RN ZPNs, offline push receiving device has iOS and uses VoIP push type, you can customize some VoIP options with this parameter.
  ZIMVoIPConfig? voIPConfig;

  /// Description: If you use OPPO Push, you can carry the push template through this field.
  ZIMOfflinePushPrivateMessageTemplate? privateMessageTemplate;

  ZIMPushConfig({
    this.title = '',
    this.content = '',
    this.payload = '',
    this.resourcesID = '',
    this.threadID = '',
    this.enableBadge = false,
    this.badgeIncrement = 0,
    this.voIPConfig,
    this.privateMessageTemplate,
  });

  ZIMPushConfig.fromMap(Map<dynamic, dynamic> map)
    : title = map['title']!,
      content = map['content']!,
      payload = map['payload']!,
      resourcesID = map['resourcesID']!,
      threadID = map['threadID']!,
      enableBadge = map['enableBadge']!,
      badgeIncrement = map['badgeIncrement']!,
      voIPConfig =
          (map['voIPConfig'] != null)
              ? ZIMVoIPConfig.fromMap(map['voIPConfig'])
              : null,
      privateMessageTemplate =
          (map['privateMessageTemplate'] != null)
              ? ZIMOfflinePushPrivateMessageTemplate.fromMap(
                map['privateMessageTemplate'],
              )
              : null;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'payload': payload,
      'resourcesID': resourcesID,
      'threadID': threadID,
      'enableBadge': enableBadge,
      'badgeIncrement': badgeIncrement,
      'voIPConfig': voIPConfig?.toMap(),
      'privateMessageTemplate': privateMessageTemplate?.toMap(),
    };
  }
}

/// Add configuration for message reactions.
///
/// Description: Configuration class for adding message reactions.
class ZIMMessageReactionAddConfig {
  /// Description: When this value is greater than 0, the same user is allowed to react multiple times with the same reaction type, and the counts from those reactions will be accumulated.
  int increaseCount;

  ZIMMessageReactionAddConfig({this.increaseCount = 0});

  ZIMMessageReactionAddConfig.fromMap(Map<dynamic, dynamic> map)
    : increaseCount = map['increaseCount']!;

  Map<String, dynamic> toMap() {
    return {'increaseCount': increaseCount};
  }
}

/// reaction user information.
///
/// Description: A class describing reaction user.
class ZIMMessageReactionUserInfo {
  /// Description: user ID
  String userID;

  ZIMMessageReactionUserInfo({required this.userID});

  ZIMMessageReactionUserInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'userID': userID};
  }
}

/// message reaction infos
///
/// Description: message reaction infos.
class ZIMMessageReaction {
  /// Description: Type of reaction, defined by you, with a maximum length of 32 bytes.
  String reactionType;

  /// Description: conversationID.
  String conversationID;

  /// Description: conversation type.
  ZIMConversationType conversationType;

  /// Detail description: reaction message ID.
  dynamic messageID;

  /// Detail description: message sequence.
  int messageSeq;

  /// Description: The reaction users number.
  int totalCount;

  /// Description:  The reaciton users if included myself.
  bool isSelfIncluded;

  /// Description:  Reaction user info list.
  List<ZIMMessageReactionUserInfo> userList;

  /// Detailed description: The sum count of reaction.
  int sumCount;

  ZIMMessageReaction({
    required this.reactionType,
    required this.conversationID,
    required this.conversationType,
    required this.messageID,
    this.messageSeq = 0,
    required this.totalCount,
    required this.isSelfIncluded,
    required this.userList,
    required this.sumCount,
  });

  ZIMMessageReaction.fromMap(Map<dynamic, dynamic> map)
    : reactionType = map['reactionType']!,
      conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      messageID = map['messageID']!,
      messageSeq = map['messageSeq']!,
      totalCount = map['totalCount']!,
      isSelfIncluded = map['isSelfIncluded']!,
      userList =
          ((map['userList']!) as List)
              .map<ZIMMessageReactionUserInfo>(
                (item) => ZIMMessageReactionUserInfo.fromMap(item),
              )
              .toList(),
      sumCount = map['sumCount']!;

  Map<String, dynamic> toMap() {
    return {
      'reactionType': reactionType,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'messageID': messageID,
      'messageSeq': messageSeq,
      'totalCount': totalCount,
      'isSelfIncluded': isSelfIncluded,
      'userList': userList.map((item) => item.toMap()).toList(),
      'sumCount': sumCount,
    };
  }
}

/// message reaction infos
///
/// Description: message reaction infos.
class ZIMMessageReactionSimpleInfo {
  /// Description: Type of reaction, defined by you, with a maximum length of 32 bytes.
  String reactionType;

  /// Detailed description: The sum count of reaction.
  int sumCount;

  ZIMMessageReactionSimpleInfo({this.reactionType = '', this.sumCount = 0});

  ZIMMessageReactionSimpleInfo.fromMap(Map<dynamic, dynamic> map)
    : reactionType = map['reactionType']!,
      sumCount = map['sumCount']!;

  Map<String, dynamic> toMap() {
    return {'reactionType': reactionType, 'sumCount': sumCount};
  }
}

/// message reaction user full information.
///
/// Description: A class describing reaction user.
class ZIMMessageReactionUserFullInfo {
  /// Description: user ID
  String userID;

  /// Description: A list of summary information for the current user’s reactions under this message.
  List<ZIMMessageReactionSimpleInfo> reactions;

  ZIMMessageReactionUserFullInfo({
    this.userID = '',
    List<ZIMMessageReactionSimpleInfo>? reactions,
  }) : reactions = reactions ?? [];

  ZIMMessageReactionUserFullInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      reactions =
          ((map['reactions']!) as List)
              .map<ZIMMessageReactionSimpleInfo>(
                (item) => ZIMMessageReactionSimpleInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'reactions': reactions.map((item) => item.toMap()).toList(),
    };
  }
}

/// User operation change information for message reactions.
///
/// Description: A class that describes reaction change information.
class ZIMMessageReactionUserChangeInfo {
  /// user ID.
  String userID;

  /// Type of reaction, defined by you, with a maximum length of 32 bytes.
  String reactionType;

  /// reaction change action.
  ZIMMessageReactionUserChangeAction action;

  /// Description: The sum count for the current reaction type.
  int sumCount;

  ZIMMessageReactionUserChangeInfo({
    this.userID = '',
    this.reactionType = '',
    this.action = ZIMMessageReactionUserChangeAction.added,
    this.sumCount = 0,
  });

  ZIMMessageReactionUserChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      reactionType = map['reactionType']!,
      action =
          ZIMMessageReactionUserChangeActionExtension.mapValue[map['action']] ??
          ZIMMessageReactionUserChangeAction.added,
      sumCount = map['sumCount']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'reactionType': reactionType,
      'action': action.value,
      'sumCount': sumCount,
    };
  }
}

/// Base class of message lite info object.
///
/// Description: Identifies the basic parameters of a message.
class ZIMMessageLiteInfo {
  /// Description: Message type.
  ZIMMessageType type;

  ZIMMessageLiteInfo({this.type = ZIMMessageType.unknown});

  ZIMMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMMessageTypeExtension.mapValue[map['type']] ??
          ZIMMessageType.unknown;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// Normal text message lite info object.
class ZIMTextMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Text message content.
  String message;

  ZIMTextMessageLiteInfo({this.message = ''})
    : super(type: ZIMMessageType.text);

  ZIMTextMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : message = map['message']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Custom message lite information.
class ZIMCustomMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Custom message content.
  String message;

  /// Description: Custom message search content.
  String searchedContent;

  /// Description: Custom message sub-type.
  int subType;

  ZIMCustomMessageLiteInfo({
    this.message = '',
    this.searchedContent = '',
    this.subType = 0,
  }) : super(type: ZIMMessageType.custom);

  ZIMCustomMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : message = map['message']!,
      searchedContent = map['searchedContent']!,
      subType = map['subType']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'message': message,
      'searchedContent': searchedContent,
      'subType': subType,
    });
    return baseMap;
  }
}

/// Base class for combine message lite info objects.
class ZIMCombineMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Combine message title.
  String title;

  /// Description: Combine message summary.
  String summary;

  ZIMCombineMessageLiteInfo({this.title = '', this.summary = ''})
    : super(type: ZIMMessageType.combine);

  ZIMCombineMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : title = map['title']!,
      summary = map['summary']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'title': title, 'summary': summary});
    return baseMap;
  }
}

/// Base class for revoke message lite info objects.
class ZIMRevokeMessageLiteInfo extends ZIMMessageLiteInfo {
  ZIMRevokeMessageLiteInfo() : super(type: ZIMMessageType.revoke);

  ZIMRevokeMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({});
    return baseMap;
  }
}

/// Base class for media message lite info objects.
class ZIMMediaMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Media file size.
  int fileSize;

  /// Description: Media file name.
  String fileName;

  /// Description: Media file local path.
  dynamic fileLocalPath;

  /// Description: Media file download address.
  String fileDownloadUrl;

  ZIMMediaMessageLiteInfo({
    ZIMMessageType? type,
    this.fileSize = 0,
    this.fileName = '',
    this.fileLocalPath = '',
    this.fileDownloadUrl = '',
  }) : super(type: type ?? ZIMMessageType.unknown);

  ZIMMediaMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : fileSize = map['fileSize']!,
      fileName = map['fileName']!,
      fileLocalPath = map['fileLocalPath']!,
      fileDownloadUrl = map['fileDownloadUrl']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'fileSize': fileSize,
      'fileName': fileName,
      'fileLocalPath': fileLocalPath,
      'fileDownloadUrl': fileDownloadUrl,
    });
    return baseMap;
  }
}

/// Image message lite information.
class ZIMImageMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  /// Description: Original image width.
  int originalImageWidth;

  /// Description: Original image height.
  int originalImageHeight;

  /// Description: Large image width.
  int largeImageWidth;

  /// Description: Large image height.
  int largeImageHeight;

  /// Description: Large image local path.
  String largeImageLocalPath;

  /// Description: Large image download address.
  String largeImageDownloadUrl;

  /// Description: Thumbnail image width.
  int thumbnailWidth;

  /// Description: Thumbnail image height.
  int thumbnailHeight;

  /// Description: Thumbnail image local path.
  String thumbnailLocalPath;

  /// Description: Thumbnail image download address.
  String thumbnailDownloadUrl;

  ZIMImageMessageLiteInfo({
    this.originalImageWidth = 0,
    this.originalImageHeight = 0,
    this.largeImageWidth = 0,
    this.largeImageHeight = 0,
    this.largeImageLocalPath = '',
    this.largeImageDownloadUrl = '',
    this.thumbnailWidth = 0,
    this.thumbnailHeight = 0,
    this.thumbnailLocalPath = '',
    this.thumbnailDownloadUrl = '',
  }) : super(type: ZIMMessageType.image);

  ZIMImageMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : originalImageWidth = map['originalImageWidth']!,
      originalImageHeight = map['originalImageHeight']!,
      largeImageWidth = map['largeImageWidth']!,
      largeImageHeight = map['largeImageHeight']!,
      largeImageLocalPath = map['largeImageLocalPath']!,
      largeImageDownloadUrl = map['largeImageDownloadUrl']!,
      thumbnailWidth = map['thumbnailWidth']!,
      thumbnailHeight = map['thumbnailHeight']!,
      thumbnailLocalPath = map['thumbnailLocalPath']!,
      thumbnailDownloadUrl = map['thumbnailDownloadUrl']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'originalImageWidth': originalImageWidth,
      'originalImageHeight': originalImageHeight,
      'largeImageWidth': largeImageWidth,
      'largeImageHeight': largeImageHeight,
      'largeImageLocalPath': largeImageLocalPath,
      'largeImageDownloadUrl': largeImageDownloadUrl,
      'thumbnailWidth': thumbnailWidth,
      'thumbnailHeight': thumbnailHeight,
      'thumbnailLocalPath': thumbnailLocalPath,
      'thumbnailDownloadUrl': thumbnailDownloadUrl,
    });
    return baseMap;
  }
}

/// File message lite information.
class ZIMFileMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  ZIMFileMessageLiteInfo() : super(type: ZIMMessageType.file);

  ZIMFileMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({});
    return baseMap;
  }
}

/// Audio message lite information.
class ZIMAudioMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  /// Description: Audio duration.
  int audioDuration;

  ZIMAudioMessageLiteInfo({this.audioDuration = 0})
    : super(type: ZIMMessageType.audio);

  ZIMAudioMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : audioDuration = map['audioDuration']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'audioDuration': audioDuration});
    return baseMap;
  }
}

/// Video message lite information.
class ZIMVideoMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  /// Description: Video duration.
  int videoDuration;

  /// Description: Video first frame width.
  int videoFirstFrameWidth;

  /// Description: Video first frame height.
  int videoFirstFrameHeight;

  /// Description: Video first frame local path.
  String videoFirstFrameLocalPath;

  /// Description: Video first frame download address.
  String videoFirstFrameDownloadUrl;

  ZIMVideoMessageLiteInfo({
    this.videoDuration = 0,
    this.videoFirstFrameWidth = 0,
    this.videoFirstFrameHeight = 0,
    this.videoFirstFrameLocalPath = '',
    this.videoFirstFrameDownloadUrl = '',
  }) : super(type: ZIMMessageType.video);

  ZIMVideoMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : videoDuration = map['videoDuration']!,
      videoFirstFrameWidth = map['videoFirstFrameWidth']!,
      videoFirstFrameHeight = map['videoFirstFrameHeight']!,
      videoFirstFrameLocalPath = map['videoFirstFrameLocalPath']!,
      videoFirstFrameDownloadUrl = map['videoFirstFrameDownloadUrl']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'videoDuration': videoDuration,
      'videoFirstFrameWidth': videoFirstFrameWidth,
      'videoFirstFrameHeight': videoFirstFrameHeight,
      'videoFirstFrameLocalPath': videoFirstFrameLocalPath,
      'videoFirstFrameDownloadUrl': videoFirstFrameDownloadUrl,
    });
    return baseMap;
  }
}

/// Multiple messages lite information.
class ZIMMultipleMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Message list.
  List<ZIMMessageLiteInfo> messageInfoList;

  ZIMMultipleMessageLiteInfo({List<ZIMMessageLiteInfo>? messageInfoList})
    : messageInfoList = messageInfoList ?? [],
      super(type: ZIMMessageType.multiple);

  ZIMMultipleMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
    : messageInfoList =
          ((map['messageInfoList']!) as List)
              .map<ZIMMessageLiteInfo>(
                (item) => ZIMDataUtils.parseZIMMessageLiteInfoFromMap(item),
              )
              .toList(),
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'messageInfoList': messageInfoList.map((item) => item.toMap()).toList(),
    });
    return baseMap;
  }
}

/// The reply message refers to the information of the source message.
class ZIMMessageRepliedInfo {
  /// Description: Message replied state.
  ZIMMessageRepliedInfoState state;

  /// Description: Replied message lite information.
  ZIMMessageLiteInfo messageInfo;

  /// Description: Sender user ID of the replied message.
  String senderUserID;

  /// Description: Sent time of the replied message.
  int sentTime;

  /// Description: ID of the replied message.
  dynamic messageID;

  /// Description: Sequence number of the replied message.
  int messageSeq;

  ZIMMessageRepliedInfo({
    required this.state,
    required this.messageInfo,
    required this.senderUserID,
    required this.sentTime,
    required this.messageID,
    required this.messageSeq,
  });

  ZIMMessageRepliedInfo.fromMap(Map<dynamic, dynamic> map)
    : state =
          ZIMMessageRepliedInfoStateExtension.mapValue[map['state']] ??
          ZIMMessageRepliedInfoState.normal,
      messageInfo = ZIMDataUtils.parseZIMMessageLiteInfoFromMap(
        map['messageInfo'],
      ),
      senderUserID = map['senderUserID']!,
      sentTime = map['sentTime']!,
      messageID = map['messageID']!,
      messageSeq = map['messageSeq']!;

  Map<String, dynamic> toMap() {
    return {
      'state': state.value,
      'messageInfo': messageInfo.toMap(),
      'senderUserID': senderUserID,
      'sentTime': sentTime,
      'messageID': messageID,
      'messageSeq': messageSeq,
    };
  }
}

/// Base class of message object
///
/// Description: Identifies the basic parameters of a message.
/// Caution: Some of the parameters, such as Message ID, only have values ​​during the callback. Developers do not need to assign values ​​to these parameters when they actively create this object for sending messages.
class ZIMMessage {
  /// Identifies the type of this message.
  ZIMMessageType type;

  /// Description: The unique ID that identifies this message.Use cases: Can be used to index other messages.Caution: When the developer actively creates a message, there is no need to modify this parameter.This parameter only has a value during callback.
  dynamic messageID;

  /// Description: SDK locally generated MessageID, developers do not need to pay attention to.
  dynamic localMessageID;

  /// Description: The sequence number of the message.
  int messageSeq;

  /// Description：Displays the userID of the sender of this message.
  String senderUserID;

  /// Description: Conversation ID. Ids of the same conversation type are unique.
  String conversationID;

  /// Description: The type of conversation to which the message belongs.
  ZIMConversationType conversationType;

  /// Description: Used to describe whether a message is sent or received.
  ZIMMessageDirection direction;

  /// Description: Describes the sending status of a message.
  ZIMMessageSentStatus sentStatus;

  /// Description: Identifies the sending time of a messageUse cases: Used to present the sending time of a message, and can be used for message sorting.Caution: This is a standard UNIX timestamp, in milliseconds.
  int timestamp;

  /// Description:The larger the orderKey, the newer the message, and can be used for ordering messages.
  int orderKey;

  /// Detail description: Describes whether the message is a message inserted by the developer through [insertMessageToLocalDB].Default: false.
  bool isUserInserted;

  /// Detailed Description: Describe the receipt status of the messageBusiness scenario: used to determine the status of the current message in the receipt message
  ZIMMessageReceiptStatus receiptStatus;

  /// Description: message extension field Use cases: You can add extended fields to the message and send it to the peer Required: no Caution:the length is 1k, you can contact technical support for configuration Available since: 2.6.0 or higher
  String extendedData;

  /// Description:  The expandable message field visible only on this end can store additional information locally, Through [updateMessageLocalExtendedData] change and currently has a length limit of 128K. If you have special requirements, please contact ZEGO technical support for configuration.
  String localExtendedData;

  /// Description: Message statement list, which can carry data strongly related to users such as emoji expressions and voting information.
  List<ZIMMessageReaction> reactions;

  /// Description: Whether the message is pushed by all employees. Required: Internal assignment.
  bool isBroadcastMessage;

  /// Description: Whether to mention everyone. It can be presented as "@User". Use cases: For example, it can be used in sending messages. Required: No. Caution: This value does not add the "@User" to the message text. Developers need to implement it themselves. Available since: 2.14.0 or above
  List<String> mentionedUserIDs;

  /// Description: Whether to mention everyone. It can be presented as "@Everyone". Use cases: For example, it can be used in groups or rooms. Required: No. Default value: false. Recommended value: Set to true if you need to mention everyone. Caution: This value does not add the "@Everyone" to the message text. Developers need to implement it themselves. Available since: 2.14.0 or above
  bool isMentionAll;

  /// Description: Message reply information.
  ZIMMessageRepliedInfo? repliedInfo;

  /// Description: Root replied count.
  int rootRepliedCount;

  /// Whether the message was sent by the server.
  bool isServerMessage;

  /// The internal callback ID of the message.
  String cbInnerID;

  /// Description: The userID of the message editor.
  String editorUserID;

  /// Description: The time of message editing.
  int editedTime;

  /// Indicates whether the message is a group-targeted message.
  bool isGroupTargetedMessage;

  /// Description: The userID of the message pinner.
  String pinnedUserID;

  /// Description: The time of message pinning.
  int pinnedTime;

  /// Description: The timestamp at which the message will be destroyed.
  int destructTime;

  ZIMMessage({
    this.type = ZIMMessageType.unknown,
    this.messageID = 0,
    this.localMessageID = 0,
    this.messageSeq = 0,
    this.senderUserID = '',
    this.conversationID = '',
    this.conversationType = ZIMConversationType.unknown,
    this.direction = ZIMMessageDirection.send,
    this.sentStatus = ZIMMessageSentStatus.sending,
    this.timestamp = 0,
    this.orderKey = 0,
    this.isUserInserted = false,
    this.receiptStatus = ZIMMessageReceiptStatus.none,
    this.extendedData = '',
    this.localExtendedData = '',
    List<ZIMMessageReaction>? reactions,
    this.isBroadcastMessage = false,
    List<String>? mentionedUserIDs,
    this.isMentionAll = false,
    this.repliedInfo,
    this.rootRepliedCount = 0,
    this.isServerMessage = false,
    this.cbInnerID = '',
    this.editorUserID = '',
    this.editedTime = 0,
    this.isGroupTargetedMessage = false,
    this.pinnedUserID = '',
    this.pinnedTime = 0,
    this.destructTime = 0,
  }) : reactions = reactions ?? [],
       mentionedUserIDs = mentionedUserIDs ?? [];

  ZIMMessage.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMMessageTypeExtension.mapValue[map['type']] ??
          ZIMMessageType.unknown,
      messageID = map['messageID']!,
      localMessageID = map['localMessageID']!,
      messageSeq = map['messageSeq']!,
      senderUserID = map['senderUserID']!,
      conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      direction =
          ZIMMessageDirectionExtension.mapValue[map['direction']] ??
          ZIMMessageDirection.send,
      sentStatus =
          ZIMMessageSentStatusExtension.mapValue[map['sentStatus']] ??
          ZIMMessageSentStatus.sending,
      timestamp = map['timestamp']!,
      orderKey = map['orderKey']!,
      isUserInserted = map['isUserInserted']!,
      receiptStatus =
          ZIMMessageReceiptStatusExtension.mapValue[map['receiptStatus']] ??
          ZIMMessageReceiptStatus.none,
      extendedData = map['extendedData']!,
      localExtendedData = map['localExtendedData']!,
      reactions =
          ((map['reactions']!) as List)
              .map<ZIMMessageReaction>(
                (item) => ZIMMessageReaction.fromMap(item),
              )
              .toList(),
      isBroadcastMessage = map['isBroadcastMessage']!,
      mentionedUserIDs =
          ((map['mentionedUserIDs']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      isMentionAll = map['isMentionAll']!,
      repliedInfo =
          (map['repliedInfo'] != null)
              ? ZIMMessageRepliedInfo.fromMap(map['repliedInfo'])
              : null,
      rootRepliedCount = map['rootRepliedCount']!,
      isServerMessage = map['isServerMessage']!,
      cbInnerID = map['cbInnerID']!,
      editorUserID = map['editorUserID']!,
      editedTime = map['editedTime']!,
      isGroupTargetedMessage = map['isGroupTargetedMessage']!,
      pinnedUserID = map['pinnedUserID']!,
      pinnedTime = map['pinnedTime']!,
      destructTime = map['destructTime']!;

  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'messageID': messageID,
      'localMessageID': localMessageID,
      'messageSeq': messageSeq,
      'senderUserID': senderUserID,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'direction': direction.value,
      'sentStatus': sentStatus.value,
      'timestamp': timestamp,
      'orderKey': orderKey,
      'isUserInserted': isUserInserted,
      'receiptStatus': receiptStatus.value,
      'extendedData': extendedData,
      'localExtendedData': localExtendedData,
      'reactions': reactions.map((item) => item.toMap()).toList(),
      'isBroadcastMessage': isBroadcastMessage,
      'mentionedUserIDs': mentionedUserIDs,
      'isMentionAll': isMentionAll,
      'repliedInfo': repliedInfo?.toMap(),
      'rootRepliedCount': rootRepliedCount,
      'isServerMessage': isServerMessage,
      'cbInnerID': cbInnerID,
      'editorUserID': editorUserID,
      'editedTime': editedTime,
      'isGroupTargetedMessage': isGroupTargetedMessage,
      'pinnedUserID': pinnedUserID,
      'pinnedTime': pinnedTime,
      'destructTime': destructTime,
    };
  }
}

/// Base class for media message objects.
///
/// Description: Identifies a media message.
/// Caution: This base class is the basis of all media messages and contains the properties required by media messages.
class ZIMMediaMessage extends ZIMMessage {
  /// Detail description: The local path of the media message. Required: If a local file is sent, this parameter must be set by the sender. Otherwise, the message fails to be sent.
  dynamic fileLocalPath;

  /// Detail description: The external download url of the media message is used for the developer to transparently transmit the media file to other users by filling in this URL when the developer uploads the media file to his own server.Required or not: If an external URL is sent, this parameter is mandatory on the sender end.
  String fileDownloadUrl;

  /// Detail description: The unique ID of the media file. Required or not: The sender does not need to fill in, this value is generated by the SDK.
  String fileUID;

  /// Detail description: The filename of the media file. Required or not: If you are sending an external URL, you need to fill in this value and include the file extension. If a local file is sent, the value is optional.
  String fileName;

  /// Detail description: The size of the media file. Required or not: The sender does not need to fill in, this value is generated by the SDK.
  int fileSize;

  ZIMMediaMessage({
    required ZIMMessageType type,
    required this.fileLocalPath,
    this.fileDownloadUrl = '',
    this.fileUID = '',
    this.fileName = '',
    this.fileSize = 0,
  }) : super(type: type);

  ZIMMediaMessage.fromMap(Map<dynamic, dynamic> map)
    : fileLocalPath = map['fileLocalPath']!,
      fileDownloadUrl = map['fileDownloadUrl']!,
      fileUID = map['fileUID']!,
      fileName = map['fileName']!,
      fileSize = map['fileSize']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'fileLocalPath': fileLocalPath,
      'fileDownloadUrl': fileDownloadUrl,
      'fileUID': fileUID,
      'fileName': fileName,
      'fileSize': fileSize,
    });
    return baseMap;
  }
}

/// Normal text message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is Text during callback, you can force the base class message object to be of this type.
class ZIMTextMessage extends ZIMMessage {
  /// The content of the text message.
  String message;

  ZIMTextMessage({required this.message}) : super(type: ZIMMessageType.text);

  ZIMTextMessage.fromMap(Map<dynamic, dynamic> map)
    : message = map['message']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Custom message object.
///
/// Available since: 2.8.0 and above.
/// Description: Identifies a custom message.
/// Caution: When calling back, if the Type parameter of the base class is Custom, the base class message object can be forcibly converted to this class.
class ZIMCustomMessage extends ZIMMessage {
  /// The content of the text message.
  String message;

  /// Description: The search content of the message.
  String searchedContent;

  /// Description: The subtype of the message, which is used by customers to customize the usage of different custom messages. Required: The sender is required, otherwise the message will fail to be sent.
  int subType;

  ZIMCustomMessage({
    required this.message,
    required this.searchedContent,
    this.subType = 0,
  }) : super(type: ZIMMessageType.custom);

  ZIMCustomMessage.fromMap(Map<dynamic, dynamic> map)
    : message = map['message']!,
      searchedContent = map['searchedContent']!,
      subType = map['subType']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'message': message,
      'searchedContent': searchedContent,
      'subType': subType,
    });
    return baseMap;
  }
}

/// Custom binary message object.
///
/// Description: Identifies a binary message.
/// Caution: If the Type parameter of the base class is Custom during callback, you can force the base class message object to be of this type.
class ZIMCommandMessage extends ZIMMessage {
  /// The content of the custom message.
  Uint8List message;

  ZIMCommandMessage({required this.message})
    : super(type: ZIMMessageType.command);

  ZIMCommandMessage.fromMap(Map<dynamic, dynamic> map)
    : message =
          map['message'] is Uint8List
              ? map['message']
              : ZIMDataUtils.convertToUInt8List(map['message']),
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Barrage message class.
///
/// Description: The barrage message class does not appear in the session and does not store historical messages.
class ZIMBarrageMessage extends ZIMMessage {
  /// Description: The content of the barrage message.
  String message;

  ZIMBarrageMessage({required this.message})
    : super(type: ZIMMessageType.barrage);

  ZIMBarrageMessage.fromMap(Map<dynamic, dynamic> map)
    : message = map['message']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Image message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is Image during callback, you can force the base class message object to be of this type.
class ZIMImageMessage extends ZIMMediaMessage {
  /// Detail description: Thumbnail external download URL of the image file. When developers upload thumbnails to their own servers, the SDK can pass through this field to other users. Required or not: optional on the sender side, this field will only take effect when fileDownloadUrl is filled in.
  String thumbnailDownloadUrl;

  /// Detailed description: The thumbnail local path of the image file. Required or not: The sender does not need to fill in it. After calling [downloadMediaFile] to download, the SDK will generate this value.
  String thumbnailLocalPath;

  /// Detail description: large Image external download URL of the image file. When developers upload large Images to their own servers, the SDK can pass through this field to other users.Required or not: optional on the sender side, this field will only take effect when fileDownloadUrl is filled in.
  String largeImageDownloadUrl;

  /// Detailed description: The large image local path of the image file. Required or not: The sender does not need to fill in it. After calling [downloadMediaFile] to download, the SDK will generate this value.
  String largeImageLocalPath;

  /// Detailed description: The width of the original image.
  int originalImageWidth;

  /// Detailed description: The height of the original image.
  int originalImageHeight;

  /// Detailed description: The width of the large image.
  int largeImageWidth;

  /// Detailed description: The height of the large image.
  int largeImageHeight;

  /// Detailed description: The width of the thumbnail.
  int thumbnailWidth;

  /// Detailed description: The height of the thumbnail.
  int thumbnailHeight;

  ZIMImageMessage(
    dynamic fileLocalPath, {
    this.thumbnailDownloadUrl = '',
    this.thumbnailLocalPath = '',
    this.largeImageDownloadUrl = '',
    this.largeImageLocalPath = '',
    this.originalImageWidth = 0,
    this.originalImageHeight = 0,
    this.largeImageWidth = 0,
    this.largeImageHeight = 0,
    this.thumbnailWidth = 0,
    this.thumbnailHeight = 0,
  }) : super(type: ZIMMessageType.image, fileLocalPath: fileLocalPath);

  ZIMImageMessage.fromMap(Map<dynamic, dynamic> map)
    : thumbnailDownloadUrl = map['thumbnailDownloadUrl']!,
      thumbnailLocalPath = map['thumbnailLocalPath']!,
      largeImageDownloadUrl = map['largeImageDownloadUrl']!,
      largeImageLocalPath = map['largeImageLocalPath']!,
      originalImageWidth = map['originalImageWidth']!,
      originalImageHeight = map['originalImageHeight']!,
      largeImageWidth = map['largeImageWidth']!,
      largeImageHeight = map['largeImageHeight']!,
      thumbnailWidth = map['thumbnailWidth']!,
      thumbnailHeight = map['thumbnailHeight']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'thumbnailDownloadUrl': thumbnailDownloadUrl,
      'thumbnailLocalPath': thumbnailLocalPath,
      'largeImageDownloadUrl': largeImageDownloadUrl,
      'largeImageLocalPath': largeImageLocalPath,
      'originalImageWidth': originalImageWidth,
      'originalImageHeight': originalImageHeight,
      'largeImageWidth': largeImageWidth,
      'largeImageHeight': largeImageHeight,
      'thumbnailWidth': thumbnailWidth,
      'thumbnailHeight': thumbnailHeight,
    });
    return baseMap;
  }
}

/// File message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is File during callback, you can force the base class message object to be of this type.
class ZIMFileMessage extends ZIMMediaMessage {
  ZIMFileMessage(dynamic fileLocalPath)
    : super(type: ZIMMessageType.file, fileLocalPath: fileLocalPath);

  ZIMFileMessage.fromMap(Map<dynamic, dynamic> map) : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({});
    return baseMap;
  }
}

/// Audio message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is Audio during callback, you can force the base class message object to be of this type.
class ZIMAudioMessage extends ZIMMediaMessage {
  /// Detail description: The duration of the audio file. Required: Required by the sender, if not filled, the audio message will fail to be sent When sending local audio messages.
  int audioDuration;

  ZIMAudioMessage(dynamic fileLocalPath, {this.audioDuration = 0})
    : super(type: ZIMMessageType.audio, fileLocalPath: fileLocalPath);

  ZIMAudioMessage.fromMap(Map<dynamic, dynamic> map)
    : audioDuration = map['audioDuration']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'audioDuration': audioDuration});
    return baseMap;
  }
}

/// Video message object.
///
/// Description: Identifies a video message.
/// Caution: When the Type parameter of the base class in the callback is Video, the base class message object can be cast to this class.
/// Restrictions: Only video files with H264 and H265 encoding formats are supported for getting the width and height of the first frame after the video message is sent successfully.
class ZIMVideoMessage extends ZIMMediaMessage {
  /// Detail description: The duration of the video file. Required: Required by the sender, if not filled, the video message will fail to be sent when sending local video messages.
  int videoDuration;

  /// Detail description: Video first frame external download URL of the video file. When developers upload thumbnails to their own servers, the SDK can pass through this field to other users. Required or not: optional on the sender side, this field will only take effect when fileDownloadUrl is filled in.
  String videoFirstFrameDownloadUrl;

  /// Detailed description: The video first frame local path of the video file. Required or not: The sender does not need to fill in it. After calling [downloadMediaFile] to download, the SDK will generate this value.
  String videoFirstFrameLocalPath;

  /// Detailed description: The width of the first frame of the video.
  int videoFirstFrameWidth;

  /// Detailed description: The height of the first frame of the video.
  int videoFirstFrameHeight;

  ZIMVideoMessage(
    dynamic fileLocalPath, {
    this.videoDuration = 0,
    this.videoFirstFrameDownloadUrl = '',
    this.videoFirstFrameLocalPath = '',
    this.videoFirstFrameWidth = 0,
    this.videoFirstFrameHeight = 0,
  }) : super(type: ZIMMessageType.video, fileLocalPath: fileLocalPath);

  ZIMVideoMessage.fromMap(Map<dynamic, dynamic> map)
    : videoDuration = map['videoDuration']!,
      videoFirstFrameDownloadUrl = map['videoFirstFrameDownloadUrl']!,
      videoFirstFrameLocalPath = map['videoFirstFrameLocalPath']!,
      videoFirstFrameWidth = map['videoFirstFrameWidth']!,
      videoFirstFrameHeight = map['videoFirstFrameHeight']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'videoDuration': videoDuration,
      'videoFirstFrameDownloadUrl': videoFirstFrameDownloadUrl,
      'videoFirstFrameLocalPath': videoFirstFrameLocalPath,
      'videoFirstFrameWidth': videoFirstFrameWidth,
      'videoFirstFrameHeight': videoFirstFrameHeight,
    });
    return baseMap;
  }
}

/// Base class for revoke message objects.
///
/// Description: Identifies a revoke message.
/// Caution: This base class is the basis of all revoke messages and contains the properties required by revoke messages.
class ZIMRevokeMessage extends ZIMMessage {
  /// Detail description: revoke type.
  ZIMRevokeType revokeType;

  /// Detail description: revoke timestamp.
  int revokeTimestamp;

  /// Detail description: operated user ID.
  String operatedUserID;

  /// Description: original message type
  ZIMMessageType originalMessageType;

  /// Detail description: original text message content, if the message to be revoked is not a text message, this field is empty.
  String originalTextMessageContent;

  /// Detail description: revoke extended data.
  String revokeExtendedData;

  /// Detail description: revoke status.
  ZIMMessageRevokeStatus revokeStatus;

  ZIMRevokeMessage({
    this.revokeType = ZIMRevokeType.unknown,
    this.revokeTimestamp = 0,
    this.operatedUserID = '',
    this.originalMessageType = ZIMMessageType.unknown,
    this.originalTextMessageContent = '',
    this.revokeExtendedData = '',
    this.revokeStatus = ZIMMessageRevokeStatus.unknown,
  }) : super(type: ZIMMessageType.revoke);

  ZIMRevokeMessage.fromMap(Map<dynamic, dynamic> map)
    : revokeType =
          ZIMRevokeTypeExtension.mapValue[map['revokeType']] ??
          ZIMRevokeType.unknown,
      revokeTimestamp = map['revokeTimestamp']!,
      operatedUserID = map['operatedUserID']!,
      originalMessageType =
          ZIMMessageTypeExtension.mapValue[map['originalMessageType']] ??
          ZIMMessageType.unknown,
      originalTextMessageContent = map['originalTextMessageContent']!,
      revokeExtendedData = map['revokeExtendedData']!,
      revokeStatus =
          ZIMMessageRevokeStatusExtension.mapValue[map['revokeStatus']] ??
          ZIMMessageRevokeStatus.unknown,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'revokeType': revokeType.value,
      'revokeTimestamp': revokeTimestamp,
      'operatedUserID': operatedUserID,
      'originalMessageType': originalMessageType.value,
      'originalTextMessageContent': originalTextMessageContent,
      'revokeExtendedData': revokeExtendedData,
      'revokeStatus': revokeStatus.value,
    });
    return baseMap;
  }
}

/// Base class for combine message objects.
///
/// Description: Identifies a combine message.
/// Caution: This base class is the basis of all combine messages and contains the properties required by combine messages.
/// Available since: 2.14.0 and above.
class ZIMCombineMessage extends ZIMMessage {
  /// Detail description: Combine message title.
  String title;

  /// Detail description: The summary of combine message.
  String summary;

  /// Detail description: Combine ID, internal used
  String combineID;

  /// List of child messages
  List<ZIMMessage> messageList;

  ZIMCombineMessage({
    required this.title,
    required this.summary,
    this.combineID = '',
    required this.messageList,
  }) : super(type: ZIMMessageType.combine);

  ZIMCombineMessage.fromMap(Map<dynamic, dynamic> map)
    : title = map['title']!,
      summary = map['summary']!,
      combineID = map['combineID']!,
      messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList(),
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'title': title,
      'summary': summary,
      'combineID': combineID,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    });
    return baseMap;
  }
}

/// Tips message object.
///
/// Description: Identifies a tips info message.
/// Caution: If the Type parameter of the base class is Tips during callback, you can force the base class message object to be of this type.
class ZIMTipsMessage extends ZIMMessage {
  /// Detail description: Tips event type.
  ZIMTipsMessageEvent event;

  /// Detail description: Operated user information.
  ZIMUserInfo operatedUser;

  /// Detail description: Target user list.
  List<ZIMUserInfo> targetUserList;

  /// Detail description: Change information.
  ZIMTipsMessageChangeInfo? changeInfo;

  ZIMTipsMessage({
    required this.event,
    ZIMUserInfo? operatedUser,
    required this.targetUserList,
    this.changeInfo,
  }) : operatedUser = operatedUser ?? ZIMUserInfo(),
       super(type: ZIMMessageType.tips);

  ZIMTipsMessage.fromMap(Map<dynamic, dynamic> map)
    : event =
          ZIMTipsMessageEventExtension.mapValue[map['event']] ??
          ZIMTipsMessageEvent.unknown,
      operatedUser = ZIMDataUtils.parseZIMUserInfoFromMap(map['operatedUser']),
      targetUserList =
          ((map['targetUserList']!) as List)
              .map<ZIMUserInfo>(
                (item) => ZIMDataUtils.parseZIMUserInfoFromMap(item),
              )
              .toList(),
      changeInfo =
          (map['changeInfo'] != null)
              ? ZIMDataUtils.parseZIMTipsMessageChangeInfoFromMap(
                map['changeInfo'],
              )
              : null,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'event': event.value,
      'operatedUser': operatedUser.toMap(),
      'targetUserList': targetUserList.map((item) => item.toMap()).toList(),
      'changeInfo': changeInfo?.toMap(),
    });
    return baseMap;
  }
}

/// Multiple message object.
class ZIMMultipleMessage extends ZIMMessage {
  /// Detail description: List of content in the multiple message.
  List<ZIMMessageLiteInfo> messageInfoList;

  /// Detail description: List of failed index in the multiple message.
  List<int> failedIndexList;

  ZIMMultipleMessage({
    required this.messageInfoList,
    List<int>? failedIndexList,
  }) : failedIndexList = failedIndexList ?? [],
       super(type: ZIMMessageType.multiple);

  ZIMMultipleMessage.fromMap(Map<dynamic, dynamic> map)
    : messageInfoList =
          ((map['messageInfoList']!) as List)
              .map<ZIMMessageLiteInfo>(
                (item) => ZIMDataUtils.parseZIMMessageLiteInfoFromMap(item),
              )
              .toList(),
      failedIndexList =
          ((map['failedIndexList']!) as List)
              .map<int>((item) => item as int)
              .toList(),
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'messageInfoList': messageInfoList.map((item) => item.toMap()).toList(),
      'failedIndexList': failedIndexList,
    });
    return baseMap;
  }
}

/// Reply to the root message of the message tree.
class ZIMMessageRootRepliedInfo {
  /// Description: Message replied state.
  ZIMMessageRepliedInfoState state;

  /// Description: Root message.
  ZIMMessage? message;

  /// Description: Sender user ID of the root message.
  String senderUserID;

  /// Description: Sent time of the root message.
  int sentTime;

  /// Description: Root replied count.
  int repliedCount;

  ZIMMessageRootRepliedInfo({
    required this.state,
    this.message,
    required this.senderUserID,
    required this.sentTime,
    required this.repliedCount,
  });

  ZIMMessageRootRepliedInfo.fromMap(Map<dynamic, dynamic> map)
    : state =
          ZIMMessageRepliedInfoStateExtension.mapValue[map['state']] ??
          ZIMMessageRepliedInfoState.normal,
      message =
          (map['message'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['message'])
              : null,
      senderUserID = map['senderUserID']!,
      sentTime = map['sentTime']!,
      repliedCount = map['repliedCount']!;

  Map<String, dynamic> toMap() {
    return {
      'state': state.value,
      'message': message?.toMap(),
      'senderUserID': senderUserID,
      'sentTime': sentTime,
      'repliedCount': repliedCount,
    };
  }
}

/// Information about the number of replies in the reply message tree.
class ZIMMessageRootRepliedCountInfo {
  /// Description: Message ID.
  dynamic messageID;

  /// Description: Conversation ID.
  String conversationID;

  /// Description: Conversation type.
  ZIMConversationType conversationType;

  /// Description: Root replied count.
  int count;

  ZIMMessageRootRepliedCountInfo({
    required this.messageID,
    required this.conversationID,
    required this.conversationType,
    required this.count,
  });

  ZIMMessageRootRepliedCountInfo.fromMap(Map<dynamic, dynamic> map)
    : messageID = map['messageID']!,
      conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'count': count,
    };
  }
}

/// message mention information.
///
/// message mention information.
class ZIMMessageMentionedInfo {
  /// Description: Message ID, used to match the notification information to which message it belongs toRequired or not: Developers do not need to fill in.
  dynamic messageID;

  /// Description: Message sequence number, used to match the notification information to which message it belongs toRequired or not: Developers do not need to fill in.
  int messageSeq;

  /// Description: From which user. Required:  Developers do not need to fill in.
  String fromUserID;

  /// Details Description: Type of notification, used to distinguish between reminding oneself and reminding everyone. Required: Developers do not need to fill in.
  ZIMMessageMentionedType type;

  ZIMMessageMentionedInfo({
    required this.messageID,
    required this.messageSeq,
    required this.fromUserID,
    required this.type,
  });

  ZIMMessageMentionedInfo.fromMap(Map<dynamic, dynamic> map)
    : messageID = map['messageID']!,
      messageSeq = map['messageSeq']!,
      fromUserID = map['fromUserID']!,
      type =
          ZIMMessageMentionedTypeExtension.mapValue[map['type']] ??
          ZIMMessageMentionedType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'messageSeq': messageSeq,
      'fromUserID': fromUserID,
      'type': type.value,
    };
  }
}

/// A structure in which the message receiving event carries relevant information.
class ZIMMessageReceivedInfo {
  /// Description: The ID of conversation.
  String conversationID;

  /// Description: The type of conversation.
  ZIMConversationType conversationType;

  /// Description: Whether it is an offline message.
  bool isOfflineMessage;

  ZIMMessageReceivedInfo({
    this.conversationID = '',
    this.conversationType = ZIMConversationType.unknown,
    this.isOfflineMessage = false,
  });

  ZIMMessageReceivedInfo.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      isOfflineMessage = map['isOfflineMessage']!;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'isOfflineMessage': isOfflineMessage,
    };
  }
}

/// Configurations related to sending messages.
///
/// Description: Configurations related to sending messages.
class ZIMMessageSendConfig {
  /// Configuration for sending offline push notifications. If the Android or iOS platform is integrated, configuring this property is strongly recommended. Required: No.
  ZIMPushConfig? pushConfig;

  /// The enum value used to set the message priority. Required: Yes.
  ZIMMessagePriority priority;

  /// Whether the message includes a receipt when it is sent. Use this property when a receipt is required for a message. Required: No. Default value: [false].
  bool hasReceipt;

  /// Whether to send offline push notifications to the users mentioned in the message's mentionedUserIDs when the message is sent. Required: No.
  bool isNotifyMentionedUsers;

  /// Whether to resend a message that failed to be sent. This property can be set to [true] only for messages whose sending status is [ZIMMessageSentStatus.failed]. Required: No. Default value: [false].
  bool isRetrySend;

  /// Whether a message that would normally affect the recipient's unread message count should be excluded from that count when sent. Required: No. Default value: [false].
  bool disableUnreadMessageCount;

  /// Whether to allow some sub-messages to fail when sending a combined message. Required: No. Default value: [false].
  bool isAllowMultipleMessagePartialFailed;

  /// The target userID to which this one-to-one chat message is delivered. This property needs to be specified only when userID and conversationID are different. Contact ZEGO technical support to enable this configuration before use. Required: No.
  String toPeerUserID;

  ZIMMessageSendConfig({
    this.pushConfig,
    this.priority = ZIMMessagePriority.low,
    this.hasReceipt = false,
    this.isNotifyMentionedUsers = true,
    this.isRetrySend = false,
    this.disableUnreadMessageCount = false,
    this.isAllowMultipleMessagePartialFailed = false,
    this.toPeerUserID = '',
  });

  ZIMMessageSendConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null,
      priority =
          ZIMMessagePriorityExtension.mapValue[map['priority']] ??
          ZIMMessagePriority.low,
      hasReceipt = map['hasReceipt']!,
      isNotifyMentionedUsers = map['isNotifyMentionedUsers']!,
      isRetrySend = map['isRetrySend']!,
      disableUnreadMessageCount = map['disableUnreadMessageCount']!,
      isAllowMultipleMessagePartialFailed =
          map['isAllowMultipleMessagePartialFailed']!,
      toPeerUserID = map['toPeerUserID']!;

  Map<String, dynamic> toMap() {
    return {
      'pushConfig': pushConfig?.toMap(),
      'priority': priority.value,
      'hasReceipt': hasReceipt,
      'isNotifyMentionedUsers': isNotifyMentionedUsers,
      'isRetrySend': isRetrySend,
      'disableUnreadMessageCount': disableUnreadMessageCount,
      'isAllowMultipleMessagePartialFailed':
          isAllowMultipleMessagePartialFailed,
      'toPeerUserID': toPeerUserID,
    };
  }
}

/// Example Query message configuration.
///
/// Description: Example Query the configurations of messages.
class ZIMMessageQueryConfig {
  /// Description: Query the anchor point of the message. Required: This parameter is not required for the first query but is required for subsequent paging queries.
  ZIMMessage? nextMessage;

  /// Description: Number of query messages. Required: not required.
  int count;

  /// Description: Indicates whether the query is in reverse order. Required: not required. Default value: false.
  bool reverse;

  /// Description: Sets the mode for querying historical messages. Since the SDK can determine whether local data is complete and therefore return historical messages more quickly, it is recommended to use the default value in most cases. Required: No.
  ZIMMessageQueryMode mode;

  ZIMMessageQueryConfig({
    this.nextMessage,
    this.count = 0,
    this.reverse = false,
    this.mode = ZIMMessageQueryMode.general,
  });

  ZIMMessageQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextMessage =
          (map['nextMessage'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
              : null,
      count = map['count']!,
      reverse = map['reverse']!,
      mode =
          ZIMMessageQueryModeExtension.mapValue[map['mode']] ??
          ZIMMessageQueryMode.general;

  Map<String, dynamic> toMap() {
    return {
      'nextMessage': nextMessage?.toMap(),
      'count': count,
      'reverse': reverse,
      'mode': mode.value,
    };
  }
}

/// Revoke configurations related to messages.
///
/// Description: Revoke configurations related to messages.
class ZIMMessageRevokeConfig {
  /// Description: Configures the offline push function, If Android or iOS platform is integrated, it is strongly recommended to configure this. Required: Not required.
  ZIMPushConfig? pushConfig;

  /// Description: revoking additional messages. Required: Not required.
  String revokeExtendedData;

  ZIMMessageRevokeConfig({this.pushConfig, this.revokeExtendedData = ''});

  ZIMMessageRevokeConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null,
      revokeExtendedData = map['revokeExtendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'pushConfig': pushConfig?.toMap(),
      'revokeExtendedData': revokeExtendedData,
    };
  }
}

/// Delete message configuration.
///
/// Description: Delete configurations related to messages.
class ZIMMessageDeleteConfig {
  /// Whether to also delete the message from the server. If this property is set to [true], the message deletion is synchronized to the current user's other devices. Required: No. Default value: [true].
  bool isAlsoDeleteServerMessage;

  /// Whether to delete the message for everyone in the conversation. If this property is set to [true], users in one-to-one conversations and regular group members can delete only messages they sent, while group owners and administrators can also delete messages sent by other members. This property is supported only by [deleteMessages] and is not currently supported by [deleteAllMessage] or [deleteAllConversationMessages]. Required: No. Default value: [false].
  bool isAlsoDeleteForEveryone;

  ZIMMessageDeleteConfig({
    this.isAlsoDeleteServerMessage = false,
    this.isAlsoDeleteForEveryone = false,
  });

  ZIMMessageDeleteConfig.fromMap(Map<dynamic, dynamic> map)
    : isAlsoDeleteServerMessage = map['isAlsoDeleteServerMessage']!,
      isAlsoDeleteForEveryone = map['isAlsoDeleteForEveryone']!;

  Map<String, dynamic> toMap() {
    return {
      'isAlsoDeleteServerMessage': isAlsoDeleteServerMessage,
      'isAlsoDeleteForEveryone': isAlsoDeleteForEveryone,
    };
  }
}

/// Deleted message information.
///
/// Description: Information class for deleted messages.
class ZIMMessageDeletedInfo {
  /// Description: Conversation ID.
  String conversationID;

  /// Description: Conversation type.
  ZIMConversationType conversationType;

  /// [onMessageDeleted] Indicates the cause of being triggered.
  ZIMMessageDeleteType messageDeleteType;

  /// List of deleted messages. Valid when [ZIMMessageDeleteType] is [ZIMMessageDeleteType.messageListDeleted].
  List<ZIMMessage> messageList;

  ZIMMessageDeletedInfo({
    required this.conversationID,
    required this.conversationType,
    required this.messageDeleteType,
    required this.messageList,
  });

  ZIMMessageDeletedInfo.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      messageDeleteType =
          ZIMMessageDeleteTypeExtension.mapValue[map['messageDeleteType']] ??
          ZIMMessageDeleteType.messageListDeleted,
      messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'messageDeleteType': messageDeleteType.value,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    };
  }
}

/// The notification callback when the message is sent, you can get the relevant information before the message object is sent through this notification
///
/// Description: Through this notification, developers can obtain relevant information before the message object is sent, such as localMessageID, etc.
/// Use cases: When developers need to record and cache relevant information before sending a message, they can obtain it by listening to the notification.
/// Caution: If no monitoring is required, it can be passed [null].
class ZIMMessageSendNotification {
  /// Detail description: After the message falls into the local DB, the notification will be called back before the message is sent to the server. Business scenario: This interface can be used when the developer needs to obtain the relevant information in the message in advance before sending the message. Required: not required. If no monitoring is required, it can be passed empty. Default: empty.
  ZIMMessageAttachedCallback? onMessageAttached;

  /// Description: Media file upload progress.
  ZIMMediaUploadingProgress? onMediaUploadingProgress;

  /// Description: Multiple media file upload progress.
  ZIMMultipleMediaUploadingProgress? onMultipleMediaUploadingProgress;

  ZIMMessageSendNotification({
    this.onMessageAttached,
    this.onMediaUploadingProgress,
    this.onMultipleMediaUploadingProgress,
  });
}

/// The notification callback when the media message is sent, you can get the relevant information before the message object is sent through this notification
///
/// Description: Through this notification, developers can obtain relevant information before the message object is sent, such as localMessageID, etc.
/// Use cases: When developers need to record and cache relevant information before sending a message, they can obtain it by listening to the notification.
/// Caution: If no monitoring is required, it can be passed [null].
class ZIMMediaMessageSendNotification {
  /// Detail description: After the message falls into the local DB, the notification will be called back before the message is sent to the server. Business scenario: This interface can be used when the developer needs to obtain the relevant information in the message in advance before sending the message. Required: not required. If no monitoring is required, it can be passed [null]. Default: [null].
  ZIMMessageAttachedCallback? onMessageAttached;

  /// Callback for media upload progress.
  ZIMMediaUploadingProgress? onMediaUploadingProgress;

  ZIMMediaMessageSendNotification({
    this.onMessageAttached,
    this.onMediaUploadingProgress,
  });
}

/// receipt information.
///
/// Description: receipt information.
class ZIMMessageReceiptInfo {
  /// Detail description: receipt status.
  ZIMMessageReceiptStatus status;

  /// Detailed Description: Message ID. Business scenario: Developers can match the loaded message list according to this ID. Is it required: No, SDK fills in.
  dynamic messageID;

  /// Session ID.
  String conversationID;

  /// Session type.
  ZIMConversationType conversationType;

  /// Description: Number of read members.
  int readMemberCount;

  /// Description: Number of unread members.
  int unreadMemberCount;

  /// Description: Number of delivered members.
  int deliveredMemberCount;

  /// Description: Whether it is self-operated by multi-terminal.
  bool isSelfOperated;

  /// Description: All the recipients have read the timestamp of that moment.
  int readTime;

  ZIMMessageReceiptInfo({
    required this.status,
    required this.messageID,
    required this.conversationID,
    required this.conversationType,
    required this.readMemberCount,
    required this.unreadMemberCount,
    this.deliveredMemberCount = 0,
    required this.isSelfOperated,
    this.readTime = 0,
  });

  ZIMMessageReceiptInfo.fromMap(Map<dynamic, dynamic> map)
    : status =
          ZIMMessageReceiptStatusExtension.mapValue[map['status']] ??
          ZIMMessageReceiptStatus.unknown,
      messageID = map['messageID']!,
      conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      readMemberCount = map['readMemberCount']!,
      unreadMemberCount = map['unreadMemberCount']!,
      deliveredMemberCount = map['deliveredMemberCount']!,
      isSelfOperated = map['isSelfOperated']!,
      readTime = map['readTime']!;

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'messageID': messageID,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'readMemberCount': readMemberCount,
      'unreadMemberCount': unreadMemberCount,
      'deliveredMemberCount': deliveredMemberCount,
      'isSelfOperated': isSelfOperated,
      'readTime': readTime,
    };
  }
}

/// Configuration for querying reaction user list
///
/// Description: When querying reaction member, you need to configure this object.
class ZIMMessageReactionUserQueryConfig {
  /// Description: The flag of the paging query. For the first query, set this field to an empty string. If the "nextFlag" field of the [ZIMMessageReactionUserListQueriedResult] callback is not an empty string, it needs to be set here to continue the query on the next page.Required: Not required.
  int nextFlag;

  /// Description: How many members are retrieved in one query, 100 at most.Caution: To obtain members in pages to reduce overhead, it is recommended to obtain within 20 members at a time. If the value is 0, the SDK will query 100 members by default.Required: Required.
  int count;

  /// Description: reaction type, defined by you.
  String reactionType;

  ZIMMessageReactionUserQueryConfig({
    this.nextFlag = 0,
    this.count = 0,
    this.reactionType = '',
  });

  ZIMMessageReactionUserQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!,
      reactionType = map['reactionType']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count, 'reactionType': reactionType};
  }
}

/// Notice of Room Message Status Change.
///
/// Description: Notice of Room Message Status Change.
class ZIMMessageSentStatusChangeInfo {
  /// message sent status.
  ZIMMessageSentStatus status;

  /// ZIMMessage.
  ZIMMessage? message;

  /// This field stores the reason why a message was rejected by ZEGOCLOUD In-app Chat due to interception by the server-side callback on message not sent yer. If you have enabled the ZEGOCLOUD In-app Chat content moderation service and require this field to capture failure reasons caused by failed content moderation, contact ZEGOCLOUD Technical Support for configuration.
  String reason;

  ZIMMessageSentStatusChangeInfo({
    required this.status,
    this.message,
    required this.reason,
  });

  ZIMMessageSentStatusChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : status =
          ZIMMessageSentStatusExtension.mapValue[map['status']] ??
          ZIMMessageSentStatus.sending,
      message =
          (map['message'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['message'])
              : null,
      reason = map['reason']!;

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'message': message?.toMap(),
      'reason': reason,
    };
  }
}

/// Message search configuration.
///
/// Description: Message search configuration.
class ZIMMessageSearchConfig {
  /// Paging fetch flag, which means fetching messages before or after nextMessage, with 'before' or 'after' determined by the order value. On the first search, nextMessage is null. On subsequent searches, nextMessage needs to pass in the last message in the message list queried last time.
  ZIMMessage? nextMessage;

  /// count It is recommended to keep the number of items less than 20 to reduce performance overhead.
  int count;

  /// When the 'order' is 'DESCENDING' during message search, it means querying messages with sending time earlier than nextMessage. If it's the first message query (i.e. nextMessage is null), then query from the last message stored locally forward. When 'order' is 'ASCENDING', it means querying messages with sending time later than nextMessage. If it's the first message query (i.e. nextMessage is null), then query from the first message stored locally backward. The default is 'DESCENDING'.
  ZIMMessageOrder order;

  /// Search keywords, up to 5 keywords are supported, otherwise an error will be reported. For example: passing in '1' and '2' will make the search results only show messages that contain both keywords '1' and '2'.
  List<String> keywords;

  /// Message types, can be used to specify message types. Support passing in multiple types.
  List<ZIMMessageType> messageTypes;

  /// The subtypes of custom messages have a value range of [0,200]. Developers can use this range to search for specific custom types.
  List<int> subMessageTypes;

  /// The user ID of the message sender, supporting up to 5 IDs. For example, if 'zego2023' is passed in, the search results will only display all the messages sent by the user 'zego2023' in that conversation.
  List<String> senderUserIDs;

  /// The starting point of the search, in milliseconds, with a default value of 0. The format is UTC timestamp.
  int startTime;

  /// The ending point of the search, which must be greater than the startTime, in milliseconds. The default value is 0 and the format is UTC timestamp.
  int endTime;

  ZIMMessageSearchConfig({
    this.nextMessage,
    this.count = 0,
    this.order = ZIMMessageOrder.descending,
    List<String>? keywords,
    List<ZIMMessageType>? messageTypes,
    List<int>? subMessageTypes,
    List<String>? senderUserIDs,
    this.startTime = 0,
    this.endTime = 0,
  }) : keywords = keywords ?? [],
       messageTypes = messageTypes ?? [],
       subMessageTypes = subMessageTypes ?? [],
       senderUserIDs = senderUserIDs ?? [];

  ZIMMessageSearchConfig.fromMap(Map<dynamic, dynamic> map)
    : nextMessage =
          (map['nextMessage'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
              : null,
      count = map['count']!,
      order =
          ZIMMessageOrderExtension.mapValue[map['order']] ??
          ZIMMessageOrder.descending,
      keywords =
          ((map['keywords']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      messageTypes =
          ((map['messageTypes']!) as List)
              .map<ZIMMessageType>(
                (item) =>
                    ZIMMessageTypeExtension.mapValue[item] ??
                    ZIMMessageType.unknown,
              )
              .toList(),
      subMessageTypes =
          ((map['subMessageTypes']!) as List)
              .map<int>((item) => item as int)
              .toList(),
      senderUserIDs =
          ((map['senderUserIDs']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      startTime = map['startTime']!,
      endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'nextMessage': nextMessage?.toMap(),
      'count': count,
      'order': order.value,
      'keywords': keywords,
      'messageTypes': messageTypes.map((item) => item.value).toList(),
      'subMessageTypes': subMessageTypes,
      'senderUserIDs': senderUserIDs,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

/// Configuration for querying reply message list.
///
/// Description: Configuration class for querying the replied message list.
class ZIMMessageRepliedListQueryConfig {
  /// The flag of paginated query. When querying for the first time, set this field to 0. If the 'nextFlag' field of the [queryMessageRepliedList] callback is not 0, it means that the query has not ended yet. You need to set it here to continue querying the next page.
  int nextFlag;

  /// The number of queries per query. The upper limit is 100. Exceeding 100 will result in an error.
  int count;

  ZIMMessageRepliedListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMMessageRepliedListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Configuration for downloading media files.
///
/// Description: Configuration class for media file downloads.
class ZIMMediaDownloadConfig {
  /// Detailed description: The index of the array where a file in the download multiple message is located.
  int messageInfoIndex;

  ZIMMediaDownloadConfig({this.messageInfoIndex = 0});

  ZIMMediaDownloadConfig.fromMap(Map<dynamic, dynamic> map)
    : messageInfoIndex = map['messageInfoIndex']!;

  Map<String, dynamic> toMap() {
    return {'messageInfoIndex': messageInfoIndex};
  }
}

/// (Empty Class) Configurations related to editing messages.
///
/// Description: (Empty Class) Configurations related to editing messages.
class ZIMMessageEditConfig {
  ZIMMessageEditConfig();

  ZIMMessageEditConfig.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// (Empty Class) Configurations related to cancel sending messages.
///
/// Description: (Empty Class) Configurations related to cancel sending messages.
class ZIMSendingMessageCancelConfig {
  ZIMSendingMessageCancelConfig();

  ZIMSendingMessageCancelConfig.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Pinning message configuration
///
/// Description: Pin configurations related to messages.
class ZIMMessagePinConfig {
  /// When the number of pinned messages exceeds the limit, replacing older pinned messages in the pinned list during the next pin operation is not allowed. The default value is [false].
  bool disableAutoReplace;

  ZIMMessagePinConfig({this.disableAutoReplace = false});

  ZIMMessagePinConfig.fromMap(Map<dynamic, dynamic> map)
    : disableAutoReplace = map['disableAutoReplace']!;

  Map<String, dynamic> toMap() {
    return {'disableAutoReplace': disableAutoReplace};
  }
}

/// Tips message additional information.
///
/// Description: Tips message additional information.
class ZIMTipsMessageChangeInfo {
  /// Tips message additional information type.
  ZIMTipsMessageChangeInfoType type;

  ZIMTipsMessageChangeInfo({required this.type});

  ZIMTipsMessageChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMTipsMessageChangeInfoTypeExtension.mapValue[map['type']] ??
          ZIMTipsMessageChangeInfoType.unknown;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// Tips Additional information about change events related to the message group.
///
/// Description: Tips Additional information about change events related to the message group.
class ZIMTipsMessageGroupChangeInfo extends ZIMTipsMessageChangeInfo {
  /// If there are multiple changes in the group name, group avatar, and group announcement, you need to know which ones have changed based on the value of this field. Among them, 0b0001 is the group name, 0b0010 is the group notice, and 0b0100 is the group avatar.
  int groupDataFlag;

  /// If the group name is changed, the changed value will be displayed here.
  String groupName;

  /// If the group notice is changed, the changed value will be displayed here.
  String groupNotice;

  /// If the group avatar url is changed, the changed value will be displayed here.
  String groupAvatarUrl;

  /// If the group mute info is changed, the changed value will be displayed here.
  ZIMGroupMuteInfo? groupMutedInfo;

  ZIMTipsMessageGroupChangeInfo({
    required ZIMTipsMessageChangeInfoType type,
    this.groupDataFlag = 0,
    this.groupName = '',
    this.groupNotice = '',
    this.groupAvatarUrl = '',
    this.groupMutedInfo,
  }) : super(type: type);

  ZIMTipsMessageGroupChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : groupDataFlag = map['groupDataFlag']!,
      groupName = map['groupName']!,
      groupNotice = map['groupNotice']!,
      groupAvatarUrl = map['groupAvatarUrl']!,
      groupMutedInfo =
          (map['groupMutedInfo'] != null)
              ? ZIMGroupMuteInfo.fromMap(map['groupMutedInfo'])
              : null,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'groupDataFlag': groupDataFlag,
      'groupName': groupName,
      'groupNotice': groupNotice,
      'groupAvatarUrl': groupAvatarUrl,
      'groupMutedInfo': groupMutedInfo?.toMap(),
    });
    return baseMap;
  }
}

/// Tips Additional information about change events related to the message group member.
///
/// Description: Tips Additional information about change events related to the message group member.
class ZIMTipsMessageGroupMemberChangeInfo extends ZIMTipsMessageChangeInfo {
  /// If a group member's role changes, the changed role will be displayed here.
  int memberRole;

  /// If the group member's muting expired time changes, the new muting expired time will be displayed here.
  int muteExpiredTime;

  /// Detailed description: tips message generated when the original group owner leaves the group and causes a change in the group owner. This field is true and indicates a newly created group owner.
  ZIMGroupMemberSimpleInfo? groupNewOwner;

  ZIMTipsMessageGroupMemberChangeInfo({
    required ZIMTipsMessageChangeInfoType type,
    this.memberRole = 0,
    this.muteExpiredTime = 0,
    this.groupNewOwner,
  }) : super(type: type);

  ZIMTipsMessageGroupMemberChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : memberRole = map['memberRole']!,
      muteExpiredTime = map['muteExpiredTime']!,
      groupNewOwner =
          (map['groupNewOwner'] != null)
              ? ZIMGroupMemberSimpleInfo.fromMap(map['groupNewOwner'])
              : null,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberRole': memberRole,
      'muteExpiredTime': muteExpiredTime,
      'groupNewOwner': groupNewOwner?.toMap(),
    });
    return baseMap;
  }
}

/// Tips Additional information about change events related to the message pinned or unpined.
///
/// Description: Tips Additional information about change events related to the message pinned or unpined.
class ZIMTipsMessagePinStatusChangeInfo extends ZIMTipsMessageChangeInfo {
  /// Describes whether the current operation is a pin operation or an unpin operation.
  bool isPinned;

  ZIMTipsMessagePinStatusChangeInfo({
    required ZIMTipsMessageChangeInfoType type,
    this.isPinned = false,
  }) : super(type: type);

  ZIMTipsMessagePinStatusChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : isPinned = map['isPinned']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'isPinned': isPinned});
    return baseMap;
  }
}

/// Notification of the message pinned status changed.
///
/// Description: When a message in a conversation is successfully pinned or unpinned and a notification is raised, this structure can be used to obtain the operated message and its current pinned status.
class ZIMMessagePinStatusChangeInfo {
  /// Message pin status
  ZIMMessagePinStatus pinStatus;

  /// The message object whose pin status changed.
  ZIMMessage message;

  ZIMMessagePinStatusChangeInfo({
    this.pinStatus = ZIMMessagePinStatus.notPinned,
    ZIMMessage? message,
  }) : message = message ?? ZIMMessage();

  ZIMMessagePinStatusChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : pinStatus =
          ZIMMessagePinStatusExtension.mapValue[map['pinStatus']] ??
          ZIMMessagePinStatus.notPinned,
      message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'pinStatus': pinStatus.value, 'message': message.toMap()};
  }
}

/// Clear cache configuration.
///
/// Description: Clear cache configuration.
class ZIMFileCacheClearConfig {
  /// Expiration stamp of cache cleanup.
  int endTime;

  ZIMFileCacheClearConfig({this.endTime = 0});

  ZIMFileCacheClearConfig.fromMap(Map<dynamic, dynamic> map)
    : endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {'endTime': endTime};
  }
}

/// Query cache configuration.
///
/// Description: Query cache configuration.
class ZIMFileCacheQueryConfig {
  /// Example Query the expiration timestamp of the cache.
  int endTime;

  ZIMFileCacheQueryConfig({this.endTime = 0});

  ZIMFileCacheQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {'endTime': endTime};
  }
}

/// File cache information.
///
/// Description: Detailed description: File cache information.
class ZIMFileCacheInfo {
  /// Total file size in bytes (B).
  int totalFileSize;

  ZIMFileCacheInfo({required this.totalFileSize});

  ZIMFileCacheInfo.fromMap(Map<dynamic, dynamic> map)
    : totalFileSize = map['totalFileSize']!;

  Map<String, dynamic> toMap() {
    return {'totalFileSize': totalFileSize};
  }
}

/// message reaction change information.
///
/// Description: A class that describes reaction change information.
class ZIMMessageReactionChangeInfo {
  /// Description: The message object containing updated reaction information, which can be used to directly replace the old data held by the developer.
  ZIMMessage message;

  /// Description: A list of user reaction operation changes under the current message.
  List<ZIMMessageReactionUserChangeInfo> userChangeInfoList;

  ZIMMessageReactionChangeInfo({
    ZIMMessage? message,
    List<ZIMMessageReactionUserChangeInfo>? userChangeInfoList,
  }) : message = message ?? ZIMMessage(),
       userChangeInfoList = userChangeInfoList ?? [];

  ZIMMessageReactionChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']),
      userChangeInfoList =
          ((map['userChangeInfoList']!) as List)
              .map<ZIMMessageReactionUserChangeInfo>(
                (item) => ZIMMessageReactionUserChangeInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'message': message.toMap(),
      'userChangeInfoList':
          userChangeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// The specific content of a conversation.
///
/// Description: The specific content of a conversation.
class ZIMConversation {
  /// The conversation ID.
  String conversationID;

  /// The conversation type.
  ZIMConversationType type;

  /// The conversationName, which is the same as the groupName/userName value corresponding to the conversation.
  String conversationName;

  /// The conversation avatar URL. The avatar URL of a one-to-one conversation is the same as the user's avatar URL, and the avatar URL of a group conversation is the same as the group's avatar URL.
  String conversationAvatarUrl;

  /// The conversation alias. After a friend alias is set through [updateFriendAlias], this property is updated accordingly for the corresponding one-to-one conversation. After a group alias is set through [updateGroupAlias], this property is updated accordingly for the corresponding group conversation.
  String conversationAlias;

  /// The conversation notification status.
  ZIMConversationNotificationStatus notificationStatus;

  /// The unread message count of the conversation.
  int unreadMessageCount;

  /// The last message.
  ZIMMessage? lastMessage;

  /// Used to describe the order of messages in the conversation. A larger orderKey indicates a newer message.
  int orderKey;

  /// Whether the conversation is pinned to the top.
  bool isPinned;

  /// The timestamp when the conversation was pinned to the top.
  int pinnedTime;

  /// This array contains records when the current user is mentioned or when all users are mentioned in a message within the conversation.
  List<ZIMMessageMentionedInfo> mentionedInfoList;

  /// The conversation draft. After a draft is set for the conversation, the conversation contains this property.
  String draft;

  /// Describes all existing marks of the conversation.
  List<int> marks;

  /// The sequence number up to which messages in the conversation have been read.
  int readMessageSeq;

  /// Whether the conversation is in an unavailable state.
  bool isConversationDisabled;

  /// The expiration time of the conversation mute.
  int selfMutedExpiredTime;

  /// The duration of timed messages.
  int messageDestructDuration;

  /// The ID associated with the conversation. When the conversation type is [ZIMConversationType.peer], this value is the user ID of the other participant in the one-on-one conversation; when the conversation type is [ZIMConversationType.communityChannel], this value is the communityID of the community to which the current channel conversation belongs.
  String relatedID;

  ZIMConversation({
    this.conversationID = '',
    this.type = ZIMConversationType.unknown,
    this.conversationName = '',
    this.conversationAvatarUrl = '',
    this.conversationAlias = '',
    this.notificationStatus = ZIMConversationNotificationStatus.notify,
    this.unreadMessageCount = 0,
    this.lastMessage,
    this.orderKey = 0,
    this.isPinned = false,
    this.pinnedTime = 0,
    List<ZIMMessageMentionedInfo>? mentionedInfoList,
    this.draft = '',
    List<int>? marks,
    this.readMessageSeq = 0,
    this.isConversationDisabled = false,
    this.selfMutedExpiredTime = 0,
    this.messageDestructDuration = 0,
    this.relatedID = '',
  }) : mentionedInfoList = mentionedInfoList ?? [],
       marks = marks ?? [];

  ZIMConversation.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      type =
          ZIMConversationTypeExtension.mapValue[map['type']] ??
          ZIMConversationType.unknown,
      conversationName = map['conversationName']!,
      conversationAvatarUrl = map['conversationAvatarUrl']!,
      conversationAlias = map['conversationAlias']!,
      notificationStatus =
          ZIMConversationNotificationStatusExtension
              .mapValue[map['notificationStatus']] ??
          ZIMConversationNotificationStatus.notify,
      unreadMessageCount = map['unreadMessageCount']!,
      lastMessage =
          (map['lastMessage'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['lastMessage'])
              : null,
      orderKey = map['orderKey']!,
      isPinned = map['isPinned']!,
      pinnedTime = map['pinnedTime']!,
      mentionedInfoList =
          ((map['mentionedInfoList']!) as List)
              .map<ZIMMessageMentionedInfo>(
                (item) => ZIMMessageMentionedInfo.fromMap(item),
              )
              .toList(),
      draft = map['draft']!,
      marks =
          ((map['marks']!) as List).map<int>((item) => item as int).toList(),
      readMessageSeq = map['readMessageSeq']!,
      isConversationDisabled = map['isConversationDisabled']!,
      selfMutedExpiredTime = map['selfMutedExpiredTime']!,
      messageDestructDuration = map['messageDestructDuration']!,
      relatedID = map['relatedID']!;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'type': type.value,
      'conversationName': conversationName,
      'conversationAvatarUrl': conversationAvatarUrl,
      'conversationAlias': conversationAlias,
      'notificationStatus': notificationStatus.value,
      'unreadMessageCount': unreadMessageCount,
      'lastMessage': lastMessage?.toMap(),
      'orderKey': orderKey,
      'isPinned': isPinned,
      'pinnedTime': pinnedTime,
      'mentionedInfoList':
          mentionedInfoList.map((item) => item.toMap()).toList(),
      'draft': draft,
      'marks': marks,
      'readMessageSeq': readMessageSeq,
      'isConversationDisabled': isConversationDisabled,
      'selfMutedExpiredTime': selfMutedExpiredTime,
      'messageDestructDuration': messageDestructDuration,
      'relatedID': relatedID,
    };
  }
}

/// Conversation base information
///
/// Description: The base content of the session.
class ZIMConversationBaseInfo {
  /// Conversation ID. For single chat, the conversation ID is the other user ID. For group chat, the conversation ID is the group ID.
  String conversationID;

  /// Conversation type
  ZIMConversationType conversationType;

  ZIMConversationBaseInfo({
    this.conversationID = '',
    this.conversationType = ZIMConversationType.unknown,
  });

  ZIMConversationBaseInfo.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Group session object, extend from ZIMGroupConversation.
///
/// Description: Group session object, extend from ZIMGroupConversation.
///
/// @deprecated Deprecated since 3.0.0. Use the [isConversationDisabled] and [selfMutedExpiredTime] properties in the [ZIMConversation] class instead.
@Deprecated(
  'Deprecated since 3.0.0. Use the [isConversationDisabled] and [selfMutedExpiredTime] properties in the [ZIMConversation] class instead.',
)
class ZIMGroupConversation extends ZIMConversation {
  /// Whether the group session is unavailable.
  bool isDisabled;

  /// The expiration date of the group gag.
  int mutedExpiredTime;

  ZIMGroupConversation({this.isDisabled = false, this.mutedExpiredTime = 0});

  ZIMGroupConversation.fromMap(Map<dynamic, dynamic> map)
    : isDisabled = map['isDisabled']!,
      mutedExpiredTime = map['mutedExpiredTime']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'isDisabled': isDisabled,
      'mutedExpiredTime': mutedExpiredTime,
    });
    return baseMap;
  }
}

/// Query the relevant configuration of the session.
///
/// Description: Configurable information when querying a session.
class ZIMConversationQueryConfig {
  /// Session that needs to be queried.
  ZIMConversation? nextConversation;

  /// The number of sessions to query.
  int count;

  ZIMConversationQueryConfig({this.nextConversation, this.count = 0});

  ZIMConversationQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextConversation =
          (map['nextConversation'] != null)
              ? ZIMDataUtils.parseZIMConversationFromMap(
                map['nextConversation'],
              )
              : null,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextConversation': nextConversation?.toMap(), 'count': count};
  }
}

/// Search filters related to the conversation.
///
/// Description: Configurable filter options when querying conversation list.
class ZIMConversationFilterOption {
  /// Conversation type list
  List<ZIMConversationType> conversationTypes;

  /// Conversation mark list
  List<int> marks;

  /// Whether to query only unread conversations
  bool isOnlyUnreadConversation;

  /// Conversation pinned filter
  ZIMConversationPinnedFilter pinnedFilter;

  ZIMConversationFilterOption({
    List<ZIMConversationType>? conversationTypes,
    List<int>? marks,
    this.isOnlyUnreadConversation = false,
    this.pinnedFilter = ZIMConversationPinnedFilter.all,
  }) : conversationTypes = conversationTypes ?? [],
       marks = marks ?? [];

  ZIMConversationFilterOption.fromMap(Map<dynamic, dynamic> map)
    : conversationTypes =
          ((map['conversationTypes']!) as List)
              .map<ZIMConversationType>(
                (item) =>
                    ZIMConversationTypeExtension.mapValue[item] ??
                    ZIMConversationType.unknown,
              )
              .toList(),
      marks =
          ((map['marks']!) as List).map<int>((item) => item as int).toList(),
      isOnlyUnreadConversation = map['isOnlyUnreadConversation']!,
      pinnedFilter =
          ZIMConversationPinnedFilterExtension.mapValue[map['pinnedFilter']] ??
          ZIMConversationPinnedFilter.all;

  Map<String, dynamic> toMap() {
    return {
      'conversationTypes': conversationTypes.map((item) => item.value).toList(),
      'marks': marks,
      'isOnlyUnreadConversation': isOnlyUnreadConversation,
      'pinnedFilter': pinnedFilter.value,
    };
  }
}

/// Search filters related to the conversation total unread message count.
///
/// Description: Configurable filter options when querying conversation total unread message count.
class ZIMConversationTotalUnreadMessageCountQueryConfig {
  /// Conversation type list
  List<ZIMConversationType> conversationTypes;

  /// Conversation mark list
  List<int> marks;

  ZIMConversationTotalUnreadMessageCountQueryConfig({
    List<ZIMConversationType>? conversationTypes,
    List<int>? marks,
  }) : conversationTypes = conversationTypes ?? [],
       marks = marks ?? [];

  ZIMConversationTotalUnreadMessageCountQueryConfig.fromMap(
    Map<dynamic, dynamic> map,
  ) : conversationTypes =
          ((map['conversationTypes']!) as List)
              .map<ZIMConversationType>(
                (item) =>
                    ZIMConversationTypeExtension.mapValue[item] ??
                    ZIMConversationType.unknown,
              )
              .toList(),
      marks =
          ((map['marks']!) as List).map<int>((item) => item as int).toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationTypes': conversationTypes.map((item) => item.value).toList(),
      'marks': marks,
    };
  }
}

/// Conversation delete configuration
///
/// Description: Delete the related configuration of the session.
class ZIMConversationDeleteConfig {
  /// Whether to delete server conversations at the same time
  bool isAlsoDeleteServerConversation;

  ZIMConversationDeleteConfig({this.isAlsoDeleteServerConversation = false});

  ZIMConversationDeleteConfig.fromMap(Map<dynamic, dynamic> map)
    : isAlsoDeleteServerConversation = map['isAlsoDeleteServerConversation']!;

  Map<String, dynamic> toMap() {
    return {'isAlsoDeleteServerConversation': isAlsoDeleteServerConversation};
  }
}

/// Delete all session notification information.
///
/// Description: Delete all session notification information.
class ZIMConversationsAllDeletedInfo {
  /// Number of sessions that were deleted.
  int count;

  ZIMConversationsAllDeletedInfo({required this.count});

  ZIMConversationsAllDeletedInfo.fromMap(Map<dynamic, dynamic> map)
    : count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'count': count};
  }
}

/// Conversation change information
///
/// Description: Contains information after session changes.
class ZIMConversationChangeInfo {
  @Deprecated('Conversation change event')
  ZIMConversationEvent event;

  /// Conversation change action
  ZIMConversationListChangeAction action;

  /// Changed conversation
  ZIMConversation? conversation;

  ZIMConversationChangeInfo({
    required this.event,
    this.action = ZIMConversationListChangeAction.added,
    this.conversation,
  });

  ZIMConversationChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : event =
          ZIMConversationEventExtension.mapValue[map['event']] ??
          ZIMConversationEvent.added,
      action =
          ZIMConversationListChangeActionExtension.mapValue[map['action']] ??
          ZIMConversationListChangeAction.added,
      conversation =
          (map['conversation'] != null)
              ? ZIMDataUtils.parseZIMConversationFromMap(map['conversation'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'event': event.value,
      'action': action.value,
      'conversation': conversation?.toMap(),
    };
  }
}

/// Conversation search configuration.
///
/// Description: Conversation search configuration.
class ZIMConversationSearchConfig {
  /// Conversation search mode.
  ZIMConversationSearchMode mode;

  /// Pagination token, fill in 0 initially, and then fill in the nextFlag returned from the callback to retrieve data for the next page.
  int nextFlag;

  /// The number of messages that can be retrieved in one search. It is recommended to be less than 20 to reduce performance overhead.
  int totalConversationCount;

  /// Search keywords, supports up to 5. Otherwise, an error will occur. For example, if you pass in '1' and '2', the search results will only display conversations that contain both '1' and '2' keywords in the messages.
  List<String> keywords;

  /// The number of local messages that can be retrieved for a single conversation in one search. It is recommended to be less than 10 to reduce performance overhead.
  int conversationMessageCount;

  /// Message types, can be used to specify message types. Support passing in multiple types.
  List<ZIMMessageType> messageTypes;

  /// The subtypes of custom messages have a value range of [0,200]. Developers can use this range to search for specific custom types.
  List<int> subMessageTypes;

  /// Send user ID, supports up to 5. For example, if you pass in zego2023, the search results will only display conversations where messages have been sent by the user zego2023.
  List<String> senderUserIDs;

  /// The starting point of the search, in milliseconds, with a default value of 0. The format is UTC timestamp.
  int startTime;

  /// The ending point of the search, which must be greater than the startTime, in milliseconds. The default value is 0 and the format is UTC timestamp.
  int endTime;

  ZIMConversationSearchConfig({
    this.mode = ZIMConversationSearchMode.matchMessage,
    this.nextFlag = 0,
    this.totalConversationCount = 0,
    List<String>? keywords,
    this.conversationMessageCount = 0,
    List<ZIMMessageType>? messageTypes,
    List<int>? subMessageTypes,
    List<String>? senderUserIDs,
    this.startTime = 0,
    this.endTime = 0,
  }) : keywords = keywords ?? [],
       messageTypes = messageTypes ?? [],
       subMessageTypes = subMessageTypes ?? [],
       senderUserIDs = senderUserIDs ?? [];

  ZIMConversationSearchConfig.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMConversationSearchModeExtension.mapValue[map['mode']] ??
          ZIMConversationSearchMode.matchMessage,
      nextFlag = map['nextFlag']!,
      totalConversationCount = map['totalConversationCount']!,
      keywords =
          ((map['keywords']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      conversationMessageCount = map['conversationMessageCount']!,
      messageTypes =
          ((map['messageTypes']!) as List)
              .map<ZIMMessageType>(
                (item) =>
                    ZIMMessageTypeExtension.mapValue[item] ??
                    ZIMMessageType.unknown,
              )
              .toList(),
      subMessageTypes =
          ((map['subMessageTypes']!) as List)
              .map<int>((item) => item as int)
              .toList(),
      senderUserIDs =
          ((map['senderUserIDs']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      startTime = map['startTime']!,
      endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.value,
      'nextFlag': nextFlag,
      'totalConversationCount': totalConversationCount,
      'keywords': keywords,
      'conversationMessageCount': conversationMessageCount,
      'messageTypes': messageTypes.map((item) => item.value).toList(),
      'subMessageTypes': subMessageTypes,
      'senderUserIDs': senderUserIDs,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

/// Conversation search result
///
/// Description: Information class for conversation search results.
class ZIMConversationSearchInfo {
  /// The conversation ID of the local message to be search.
  String conversationID;

  /// conversation type.
  ZIMConversationType conversationType;

  /// Conversation object.
  ZIMConversation conversation;

  /// Total message count.
  int totalMessageCount;

  /// Search results of messages.
  List<ZIMMessage> messageList;

  ZIMConversationSearchInfo({
    required this.conversationID,
    required this.conversationType,
    ZIMConversation? conversation,
    required this.totalMessageCount,
    required this.messageList,
  }) : conversation = conversation ?? ZIMConversation();

  ZIMConversationSearchInfo.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      conversation = ZIMDataUtils.parseZIMConversationFromMap(
        map['conversation'],
      ),
      totalMessageCount = map['totalMessageCount']!,
      messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'conversation': conversation.toMap(),
      'totalMessageCount': totalMessageCount,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Room information object.
///
/// Description: Identifies a unique room.
class ZIMRoomInfo {
  /// Room ID.  a string with a maximum length of 128 bytes.  It is customized by the developer and supports only digits, English characters, ~, and  '!', '#', '$', '%', '&', '(', ')', '+', '-', ':', ';', '<', '=', '.', '>', '?', '@', '[', ']', '^', '_', '{', '}', '|', '~'.
  String roomID;

  /// Room name, It is customized by the developer .a string with a maximum length of 64 bytes or less.
  String roomName;

  ZIMRoomInfo({this.roomID = '', this.roomName = ''});

  ZIMRoomInfo.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      roomName = map['roomName']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'roomName': roomName};
  }
}

/// The room details object.
///
/// Description: Identifies the detailed information of a room.
class ZIMRoomFullInfo {
  /// Room base information
  ZIMRoomInfo baseInfo;

  ZIMRoomFullInfo({required this.baseInfo});

  ZIMRoomFullInfo.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMRoomInfo.fromMap(map['baseInfo']);

  Map<String, dynamic> toMap() {
    return {'baseInfo': baseInfo.toMap()};
  }
}

/// Room user information.
///
/// Description: A class describing room user.
class ZIMRoomMemberInfo extends ZIMUserInfo {
  ZIMRoomMemberInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
  }) : super(
         userID: userID,
         userName: userName,
         userAvatarUrl: userAvatarUrl,
         type: ZIMUserInfoType.roomMember,
       );

  ZIMRoomMemberInfo.fromMap(Map<dynamic, dynamic> map) : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'classType': 'ZIMRoomMemberInfo'});
    return baseMap;
  }
}

/// Configuration for querying room member.
///
/// Description: When querying member, you need to configure this object.
class ZIMRoomMemberQueryConfig {
  /// The flag of the paging query. For the first query, set this field to an empty string. If the 'nextFlag' field of the callback is not an empty string, it needs to be set here to continue the query on the next page.
  String nextFlag;

  /// How many messages are retrieved in one query.
  int count;

  ZIMRoomMemberQueryConfig({this.nextFlag = '', this.count = 0});

  ZIMRoomMemberQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Room advanced configuration
///
/// Description: Room‘s advanced config.
class ZIMRoomAdvancedConfig {
  /// Room attributes of a room.
  Map<String, String> roomAttributes;

  /// Room destruction time delayed, the unit is seconds. The maximum room destroy delay time is 3 hours.
  int roomDestroyDelayTime;

  ZIMRoomAdvancedConfig({
    Map<String, String>? roomAttributes,
    this.roomDestroyDelayTime = 0,
  }) : roomAttributes = roomAttributes ?? {};

  ZIMRoomAdvancedConfig.fromMap(Map<dynamic, dynamic> map)
    : roomAttributes = ((map['roomAttributes']!) as Map).map<String, String>(
        (k, v) => MapEntry(k.toString(), v.toString()),
      ),
      roomDestroyDelayTime = map['roomDestroyDelayTime']!;

  Map<String, dynamic> toMap() {
    return {
      'roomAttributes': roomAttributes,
      'roomDestroyDelayTime': roomDestroyDelayTime,
    };
  }
}

/// The behavior attribute set by the room attribute.
///
/// Description: The behavior attribute set by the room attribute.
class ZIMRoomAttributesSetConfig {
  /// Whether the operation is mandatory, that is, the property of the room whose owner is another user can be modified.
  bool isForce;

  /// Room attributes are automatically deleted after the owner leaves the room.
  bool isDeleteAfterOwnerLeft;

  /// Whether to update the owner of the room attribute involved.
  bool isUpdateOwner;

  ZIMRoomAttributesSetConfig({
    this.isForce = false,
    this.isDeleteAfterOwnerLeft = false,
    this.isUpdateOwner = false,
  });

  ZIMRoomAttributesSetConfig.fromMap(Map<dynamic, dynamic> map)
    : isForce = map['isForce']!,
      isDeleteAfterOwnerLeft = map['isDeleteAfterOwnerLeft']!,
      isUpdateOwner = map['isUpdateOwner']!;

  Map<String, dynamic> toMap() {
    return {
      'isForce': isForce,
      'isDeleteAfterOwnerLeft': isDeleteAfterOwnerLeft,
      'isUpdateOwner': isUpdateOwner,
    };
  }
}

/// The behavior attribute set by the room attribute.
///
/// Description: The behavior attribute set by the room attribute.
class ZIMRoomAttributesBatchOperationConfig {
  /// Whether the operation is mandatory, that is, the property of the room whose owner is another user can be modified.
  bool isForce;

  /// Room attributes are automatically deleted after the owner leaves the room.
  bool isDeleteAfterOwnerLeft;

  /// Whether to update the owner of the room attribute involved.
  bool isUpdateOwner;

  ZIMRoomAttributesBatchOperationConfig({
    this.isForce = false,
    this.isDeleteAfterOwnerLeft = false,
    this.isUpdateOwner = false,
  });

  ZIMRoomAttributesBatchOperationConfig.fromMap(Map<dynamic, dynamic> map)
    : isForce = map['isForce']!,
      isDeleteAfterOwnerLeft = map['isDeleteAfterOwnerLeft']!,
      isUpdateOwner = map['isUpdateOwner']!;

  Map<String, dynamic> toMap() {
    return {
      'isForce': isForce,
      'isDeleteAfterOwnerLeft': isDeleteAfterOwnerLeft,
      'isUpdateOwner': isUpdateOwner,
    };
  }
}

/// The behavior attribute set by the room attribute.
///
/// Description: The behavior attribute set by the room attribute.
class ZIMRoomAttributesDeleteConfig {
  /// Whether the operation is mandatory, that is, the property of the room whose owner is another user can be deleted.
  bool isForce;

  ZIMRoomAttributesDeleteConfig({this.isForce = false});

  ZIMRoomAttributesDeleteConfig.fromMap(Map<dynamic, dynamic> map)
    : isForce = map['isForce']!;

  Map<String, dynamic> toMap() {
    return {'isForce': isForce};
  }
}

/// Room attribute update information
///
/// Description: Notice of Room Attribute Change.
class ZIMRoomAttributesUpdateInfo {
  /// Behavioral information of room attribute change notification.
  ZIMRoomAttributesUpdateAction action;

  /// Room attributes.
  Map<String, String> roomAttributes;

  ZIMRoomAttributesUpdateInfo({
    required this.action,
    required this.roomAttributes,
  });

  ZIMRoomAttributesUpdateInfo.fromMap(Map<dynamic, dynamic> map)
    : action =
          ZIMRoomAttributesUpdateActionExtension.mapValue[map['action']] ??
          ZIMRoomAttributesUpdateAction.set,
      roomAttributes = ((map['roomAttributes']!) as Map).map<String, String>(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );

  Map<String, dynamic> toMap() {
    return {'action': action.value, 'roomAttributes': roomAttributes};
  }
}

/// Room user attribute information.
///
/// Description: Detail description: A class describing room user attributes, including UserID and its corresponding attributes.
class ZIMRoomMemberAttributesInfo {
  /// Detail description: User ID.
  String userID;

  /// Detailed description: room user attributes.
  Map<String, String> attributes;

  ZIMRoomMemberAttributesInfo({
    this.userID = '',
    Map<String, String>? attributes,
  }) : attributes = attributes ?? {};

  ZIMRoomMemberAttributesInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      attributes = ((map['attributes']!) as Map).map<String, String>(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );

  Map<String, dynamic> toMap() {
    return {'userID': userID, 'attributes': attributes};
  }
}

/// Room user attribute operation information.
///
/// Description: Detail description: room user attribute operation information, including attributes of successful operation and keys of failure.
class ZIMRoomMemberAttributesOperatedInfo {
  /// Detailed description: room user attribute information.
  ZIMRoomMemberAttributesInfo attributesInfo;

  /// Detail description: The key of the room user attribute operation failure.
  List<String> errorKeys;

  ZIMRoomMemberAttributesOperatedInfo({
    ZIMRoomMemberAttributesInfo? attributesInfo,
    List<String>? errorKeys,
  }) : attributesInfo = attributesInfo ?? ZIMRoomMemberAttributesInfo(),
       errorKeys = errorKeys ?? [];

  ZIMRoomMemberAttributesOperatedInfo.fromMap(Map<dynamic, dynamic> map)
    : attributesInfo = ZIMRoomMemberAttributesInfo.fromMap(
        map['attributesInfo'],
      ),
      errorKeys =
          ((map['errorKeys']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'attributesInfo': attributesInfo.toMap(), 'errorKeys': errorKeys};
  }
}

/// Room user attribute update information.
///
/// Description: Detailed description: Room user attribute update information.
class ZIMRoomMemberAttributesUpdateInfo {
  /// Detailed description: room user attributes.
  ZIMRoomMemberAttributesInfo attributesInfo;

  ZIMRoomMemberAttributesUpdateInfo({
    ZIMRoomMemberAttributesInfo? attributesInfo,
  }) : attributesInfo = attributesInfo ?? ZIMRoomMemberAttributesInfo();

  ZIMRoomMemberAttributesUpdateInfo.fromMap(Map<dynamic, dynamic> map)
    : attributesInfo = ZIMRoomMemberAttributesInfo.fromMap(
        map['attributesInfo'],
      );

  Map<String, dynamic> toMap() {
    return {'attributesInfo': attributesInfo.toMap()};
  }
}

/// Room user property settings configuration.
///
/// Description: room user attribute setting configuration, including configurable whether to retain user attributes after the user leaves, etc.
/// Use cases: When setting room user attributes, developers can choose to use them according to their actual application scenarios.
class ZIMRoomMemberAttributesSetConfig {
  /// Default: true.
  bool isDeleteAfterOwnerLeft;

  ZIMRoomMemberAttributesSetConfig({this.isDeleteAfterOwnerLeft = true});

  ZIMRoomMemberAttributesSetConfig.fromMap(Map<dynamic, dynamic> map)
    : isDeleteAfterOwnerLeft = map['isDeleteAfterOwnerLeft']!;

  Map<String, dynamic> toMap() {
    return {'isDeleteAfterOwnerLeft': isDeleteAfterOwnerLeft};
  }
}

/// Room member attribute query configuration
///
/// Description: Detailed description: room user attribute query configuration.
class ZIMRoomMemberAttributesQueryConfig {
  /// Detail description: Query anchor for room user properties.
  String nextFlag;

  /// count.
  int count;

  ZIMRoomMemberAttributesQueryConfig({this.nextFlag = '', this.count = 0});

  ZIMRoomMemberAttributesQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Room operation information.
///
/// Description: Detailed description: Room operation information.
class ZIMRoomOperatedInfo {
  /// Detail description: UserID of the operator.
  String userID;

  ZIMRoomOperatedInfo({required this.userID});

  ZIMRoomOperatedInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'userID': userID};
  }
}

/// group information.
///
/// Description: group information.
class ZIMGroupInfo {
  /// groupID.
  String groupID;

  /// Group name.
  String groupName;

  /// Use Limit: the maximum number of characters is 500 bytes. There is no limit on special characters.
  String groupAvatarUrl;

  ZIMGroupInfo({
    this.groupID = '',
    this.groupName = '',
    this.groupAvatarUrl = '',
  });

  ZIMGroupInfo.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      groupName = map['groupName']!,
      groupAvatarUrl = map['groupAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'groupName': groupName,
      'groupAvatarUrl': groupAvatarUrl,
    };
  }
}

/// Group mute information.
///
/// Description: Group mute information.
class ZIMGroupMuteInfo {
  /// Group mute mode.
  ZIMGroupMuteMode mode;

  /// Group mute expiration time, measured in seconds. When it's 0, there is no mute; when it's -1, it means permanent mute.
  int expiredTime;

  /// Detail description: Role list muted in the group.
  List<int> roles;

  ZIMGroupMuteInfo({
    this.mode = ZIMGroupMuteMode.none,
    this.expiredTime = 0,
    List<int>? roles,
  }) : roles = roles ?? [];

  ZIMGroupMuteInfo.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMGroupMuteModeExtension.mapValue[map['mode']] ??
          ZIMGroupMuteMode.none,
      expiredTime = map['expiredTime']!,
      roles =
          ((map['roles']!) as List).map<int>((item) => item as int).toList();

  Map<String, dynamic> toMap() {
    return {'mode': mode.value, 'expiredTime': expiredTime, 'roles': roles};
  }
}

/// Verification mode for joining the group.
///
/// Description: Group verification information class, describing the group entry verification mode.
class ZIMGroupVerifyInfo {
  /// Verification mode for joining the group.
  ZIMGroupJoinMode joinMode;

  /// Verification mode for invite to the group.
  ZIMGroupInviteMode inviteMode;

  /// Verification mode for being invited to the group.
  ZIMGroupBeInviteMode beInviteMode;

  ZIMGroupVerifyInfo({
    this.joinMode = ZIMGroupJoinMode.any,
    this.inviteMode = ZIMGroupInviteMode.any,
    this.beInviteMode = ZIMGroupBeInviteMode.none,
  });

  ZIMGroupVerifyInfo.fromMap(Map<dynamic, dynamic> map)
    : joinMode =
          ZIMGroupJoinModeExtension.mapValue[map['joinMode']] ??
          ZIMGroupJoinMode.any,
      inviteMode =
          ZIMGroupInviteModeExtension.mapValue[map['inviteMode']] ??
          ZIMGroupInviteMode.any,
      beInviteMode =
          ZIMGroupBeInviteModeExtension.mapValue[map['beInviteMode']] ??
          ZIMGroupBeInviteMode.none;

  Map<String, dynamic> toMap() {
    return {
      'joinMode': joinMode.value,
      'inviteMode': inviteMode.value,
      'beInviteMode': beInviteMode.value,
    };
  }
}

/// complete group information.
///
/// Description: complete group information.
class ZIMGroupFullInfo {
  /// basic group information.
  ZIMGroupInfo baseInfo;

  /// Group of announcement.
  String groupNotice;

  /// group properties.
  Map<String, String> groupAttributes;

  /// the group alias defined by user, which is  visible only to that user.
  String groupAlias;

  /// group message notification status.
  ZIMGroupMessageNotificationStatus notificationStatus;

  /// Group mute info.
  ZIMGroupMuteInfo mutedInfo;

  /// The timestamp of the server when the group was created.
  int createTime;

  /// The maximum number of group members.
  int maxMemberCount;

  /// Verification mode for joining the group.
  ZIMGroupVerifyInfo verifyInfo;

  ZIMGroupFullInfo({
    required this.baseInfo,
    required this.groupNotice,
    required this.groupAttributes,
    required this.groupAlias,
    required this.notificationStatus,
    required this.mutedInfo,
    required this.createTime,
    required this.maxMemberCount,
    required this.verifyInfo,
  });

  ZIMGroupFullInfo.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMGroupInfo.fromMap(map['baseInfo']),
      groupNotice = map['groupNotice']!,
      groupAttributes = ((map['groupAttributes']!) as Map).map<String, String>(
        (k, v) => MapEntry(k.toString(), v.toString()),
      ),
      groupAlias = map['groupAlias']!,
      notificationStatus =
          ZIMGroupMessageNotificationStatusExtension
              .mapValue[map['notificationStatus']] ??
          ZIMGroupMessageNotificationStatus.notify,
      mutedInfo = ZIMGroupMuteInfo.fromMap(map['mutedInfo']),
      createTime = map['createTime']!,
      maxMemberCount = map['maxMemberCount']!,
      verifyInfo = ZIMGroupVerifyInfo.fromMap(map['verifyInfo']);

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'groupNotice': groupNotice,
      'groupAttributes': groupAttributes,
      'groupAlias': groupAlias,
      'notificationStatus': notificationStatus.value,
      'mutedInfo': mutedInfo.toMap(),
      'createTime': createTime,
      'maxMemberCount': maxMemberCount,
      'verifyInfo': verifyInfo.toMap(),
    };
  }
}

/// complete group information for group list.
///
/// Description: complete group information for group list.
class ZIMGroup {
  /// basic group information.
  ZIMGroupInfo baseInfo;

  /// the group alias defined by user, which is  visible only to that user.
  String groupAlias;

  /// group message notification status.
  ZIMGroupMessageNotificationStatus notificationStatus;

  ZIMGroup({
    required this.baseInfo,
    required this.groupAlias,
    required this.notificationStatus,
  });

  ZIMGroup.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMGroupInfo.fromMap(map['baseInfo']),
      groupAlias = map['groupAlias']!,
      notificationStatus =
          ZIMGroupMessageNotificationStatusExtension
              .mapValue[map['notificationStatus']] ??
          ZIMGroupMessageNotificationStatus.notify;

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'groupAlias': groupAlias,
      'notificationStatus': notificationStatus.value,
    };
  }
}

/// Group member simple information.
///
/// Description: Simple information class for group members.
class ZIMGroupMemberSimpleInfo extends ZIMUserInfo {
  /// Group member nickname.
  String memberNickname;

  /// group role.
  int memberRole;

  ZIMGroupMemberSimpleInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.memberNickname = '',
    this.memberRole = 0,
  }) : super(
         userID: userID,
         userName: userName,
         userAvatarUrl: userAvatarUrl,
         type: ZIMUserInfoType.groupSimpleMember,
       );

  ZIMGroupMemberSimpleInfo.fromMap(Map<dynamic, dynamic> map)
    : memberNickname = map['memberNickname']!,
      memberRole = map['memberRole']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberNickname': memberNickname,
      'memberRole': memberRole,
      'classType': 'ZIMGroupMemberSimpleInfo',
    });
    return baseMap;
  }
}

/// Information about group members when they join the group.
///
/// Description: Information class for a user entering a group.
class ZIMGroupEnterInfo {
  /// The timestamp of the server when joining the group.
  int enterTime;

  /// Group entry type.
  ZIMGroupEnterType enterType;

  /// Group entry type.
  ZIMGroupMemberSimpleInfo? operatedUser;

  ZIMGroupEnterInfo({
    this.enterTime = 0,
    this.enterType = ZIMGroupEnterType.unknown,
    this.operatedUser,
  });

  ZIMGroupEnterInfo.fromMap(Map<dynamic, dynamic> map)
    : enterTime = map['enterTime']!,
      enterType =
          ZIMGroupEnterTypeExtension.mapValue[map['enterType']] ??
          ZIMGroupEnterType.unknown,
      operatedUser =
          (map['operatedUser'] != null)
              ? ZIMGroupMemberSimpleInfo.fromMap(map['operatedUser'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'enterTime': enterTime,
      'enterType': enterType.value,
      'operatedUser': operatedUser?.toMap(),
    };
  }
}

/// Group member information.
///
/// Description: Group member information.
class ZIMGroupMemberInfo extends ZIMUserInfo {
  /// Group member nickname.
  String memberNickname;

  /// group role.
  int memberRole;

  /// Group member's mute expiration time. When it's 0, it means no mute; when it's -1, it means permanent mute.
  int muteExpiredTime;

  /// Information about group members when they join the group.
  ZIMGroupEnterInfo groupEnterInfo;

  ZIMGroupMemberInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.memberNickname = '',
    this.memberRole = 0,
    this.muteExpiredTime = 0,
    ZIMGroupEnterInfo? groupEnterInfo,
  }) : groupEnterInfo = groupEnterInfo ?? ZIMGroupEnterInfo(),
       super(
         userID: userID,
         userName: userName,
         userAvatarUrl: userAvatarUrl,
         type: ZIMUserInfoType.groupMember,
       );

  ZIMGroupMemberInfo.fromMap(Map<dynamic, dynamic> map)
    : memberNickname = map['memberNickname']!,
      memberRole = map['memberRole']!,
      muteExpiredTime = map['muteExpiredTime']!,
      groupEnterInfo = ZIMGroupEnterInfo.fromMap(map['groupEnterInfo']),
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberNickname': memberNickname,
      'memberRole': memberRole,
      'muteExpiredTime': muteExpiredTime,
      'groupEnterInfo': groupEnterInfo.toMap(),
      'classType': 'ZIMGroupMemberInfo',
    });
    return baseMap;
  }
}

/// The group causes the event to change the operator's information.
///
/// Description: The group causes the event to change the operator's information.
class ZIMGroupOperatedInfo {
  /// The operator's user ID.
  String userID;

  /// The operator's username.
  String userName;

  /// The operator's group member nickname.
  String memberNickname;

  /// The operator's group member role.
  int memberRole;

  ZIMGroupOperatedInfo({
    required this.userID,
    required this.userName,
    required this.memberNickname,
    required this.memberRole,
  });

  ZIMGroupOperatedInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      userName = map['userName']!,
      memberNickname = map['memberNickname']!,
      memberRole = map['memberRole']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'memberNickname': memberNickname,
      'memberRole': memberRole,
    };
  }
}

/// group member query configuration.
///
/// Description: group member query configuration.
class ZIMGroupMemberQueryConfig {
  /// nextFlag.
  int nextFlag;

  /// count. Quantity, upper limit is 100, over 100 will be treated as 100.
  int count;

  ZIMGroupMemberQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupMemberQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Group advanced configuration.
///
/// Description: Group advanced configuration.
class ZIMGroupAdvancedConfig {
  /// group notice.
  String groupNotice;

  /// Group properties, up to 10 can be configured..
  Map<String, String>? groupAttributes;

  /// The maximum number of group members.
  int maxMemberCount;

  /// Verification mode for joining the group.
  ZIMGroupJoinMode joinMode;

  /// Verification mode for invite to the group.
  ZIMGroupInviteMode inviteMode;

  /// Verification mode for being invited to the group.
  ZIMGroupBeInviteMode beInviteMode;

  ZIMGroupAdvancedConfig({
    this.groupNotice = '',
    this.groupAttributes,
    this.maxMemberCount = 0,
    this.joinMode = ZIMGroupJoinMode.any,
    this.inviteMode = ZIMGroupInviteMode.any,
    this.beInviteMode = ZIMGroupBeInviteMode.none,
  });

  ZIMGroupAdvancedConfig.fromMap(Map<dynamic, dynamic> map)
    : groupNotice = map['groupNotice']!,
      groupAttributes =
          (map['groupAttributes'] != null)
              ? ((map['groupAttributes']) as Map).map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString()),
              )
              : null,
      maxMemberCount = map['maxMemberCount']!,
      joinMode =
          ZIMGroupJoinModeExtension.mapValue[map['joinMode']] ??
          ZIMGroupJoinMode.any,
      inviteMode =
          ZIMGroupInviteModeExtension.mapValue[map['inviteMode']] ??
          ZIMGroupInviteMode.any,
      beInviteMode =
          ZIMGroupBeInviteModeExtension.mapValue[map['beInviteMode']] ??
          ZIMGroupBeInviteMode.none;

  Map<String, dynamic> toMap() {
    return {
      'groupNotice': groupNotice,
      'groupAttributes': groupAttributes,
      'maxMemberCount': maxMemberCount,
      'joinMode': joinMode.value,
      'inviteMode': inviteMode.value,
      'beInviteMode': beInviteMode.value,
    };
  }
}

/// Group attribute update information.
///
/// Description: Group attribute update information.
class ZIMGroupAttributesUpdateInfo {
  /// Group attribute update action.
  ZIMGroupAttributesUpdateAction action;

  /// group properties.
  Map<String, String>? groupAttributes;

  ZIMGroupAttributesUpdateInfo({required this.action, this.groupAttributes});

  ZIMGroupAttributesUpdateInfo.fromMap(Map<dynamic, dynamic> map)
    : action =
          ZIMGroupAttributesUpdateActionExtension.mapValue[map['action']] ??
          ZIMGroupAttributesUpdateAction.set,
      groupAttributes =
          (map['groupAttributes'] != null)
              ? ((map['groupAttributes']) as Map).map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString()),
              )
              : null;

  Map<String, dynamic> toMap() {
    return {'action': action.value, 'groupAttributes': groupAttributes};
  }
}

/// Group message receipt read/unread member query configuration.
///
/// Description: Group message receipt read/unread member query configuration.
///
/// @deprecated This class was deprecated in 3.1.0. Please use [ZIMGroupMessageReceiptMemberListQueryConfig] instead.
@Deprecated(
  'This class was deprecated in 3.1.0. Please use [ZIMGroupMessageReceiptMemberListQueryConfig] instead.',
)
class ZIMGroupMessageReceiptMemberQueryConfig {
  /// The pagination cursor. Set to 0 for the first query, then use the nextFlag from the [ZIMGroupMessageReceiptMemberListQueriedResult] callback for subsequent pages.
  int nextFlag;

  /// The number of group members to query.
  int count;

  ZIMGroupMessageReceiptMemberQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupMessageReceiptMemberQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Group message receipt member query configuration.
class ZIMGroupMessageReceiptMemberListQueryConfig {
  /// The pagination cursor. Set to 0 for the first query, then use the nextFlag from the [ZIMGroupMessageReceiptMemberListQueriedResult] callback for subsequent pages.
  int nextFlag;

  /// Filter type for the receipt member list to query.
  ZIMMessageReceiptFilterType filterType;

  ZIMGroupMessageReceiptMemberListQueryConfig({
    this.nextFlag = 0,
    this.filterType = ZIMMessageReceiptFilterType.read,
  });

  ZIMGroupMessageReceiptMemberListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      filterType =
          ZIMMessageReceiptFilterTypeExtension.mapValue[map['filterType']] ??
          ZIMMessageReceiptFilterType.read;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'filterType': filterType.value};
  }
}

/// Group search configuration.
///
/// Description: Group search configuration.
class ZIMGroupSearchConfig {
  /// The flag used to search groups.
  int nextFlag;

  /// count.
  int count;

  /// Search keywords. For example: passing in '1' and '2' will make the search results only show groups whose group names contain both keywords '1' and '2'.
  List<String> keywords;

  /// Whether the search scope includes group member user names. Default is false.
  bool isAlsoMatchGroupMemberUserName;

  /// Whether the search scope includes group member user nicknames. Default is false.
  bool isAlsoMatchGroupMemberNickname;

  ZIMGroupSearchConfig({
    this.nextFlag = 0,
    this.count = 0,
    List<String>? keywords,
    this.isAlsoMatchGroupMemberUserName = false,
    this.isAlsoMatchGroupMemberNickname = false,
  }) : keywords = keywords ?? [];

  ZIMGroupSearchConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!,
      keywords =
          ((map['keywords']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      isAlsoMatchGroupMemberUserName = map['isAlsoMatchGroupMemberUserName']!,
      isAlsoMatchGroupMemberNickname = map['isAlsoMatchGroupMemberNickname']!;

  Map<String, dynamic> toMap() {
    return {
      'nextFlag': nextFlag,
      'count': count,
      'keywords': keywords,
      'isAlsoMatchGroupMemberUserName': isAlsoMatchGroupMemberUserName,
      'isAlsoMatchGroupMemberNickname': isAlsoMatchGroupMemberNickname,
    };
  }
}

/// Group search info.
///
/// Description: Group search info.
class ZIMGroupSearchInfo {
  /// group info.
  ZIMGroupInfo groupInfo;

  /// Group member information.
  List<ZIMGroupMemberInfo> userList;

  ZIMGroupSearchInfo({required this.groupInfo, required this.userList});

  ZIMGroupSearchInfo.fromMap(Map<dynamic, dynamic> map)
    : groupInfo = ZIMGroupInfo.fromMap(map['groupInfo']),
      userList =
          ((map['userList']!) as List)
              .map<ZIMGroupMemberInfo>(
                (item) => ZIMGroupMemberInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupInfo': groupInfo.toMap(),
      'userList': userList.map((item) => item.toMap()).toList(),
    };
  }
}

/// group member search configuration.
///
/// Description: group member search configuration.
class ZIMGroupMemberSearchConfig {
  /// The flag for querying, fill in 0 when calling the interface for the first time. When calling the interface again later, fill in the nextFlag returned from the callback to retrieve the remaining data.
  int nextFlag;

  /// count.
  int count;

  /// Search keywords, up to 5 keywords are supported, otherwise an error will be reported. For example: passing in '1' and '2' will make the search results only show group members whose names contain both keywords '1' and '2'.
  List<String> keywords;

  /// Whether the search scope includes group member user nickname. Default is false.
  bool isAlsoMatchGroupMemberNickname;

  ZIMGroupMemberSearchConfig({
    this.nextFlag = 0,
    this.count = 0,
    List<String>? keywords,
    this.isAlsoMatchGroupMemberNickname = false,
  }) : keywords = keywords ?? [];

  ZIMGroupMemberSearchConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!,
      keywords =
          ((map['keywords']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      isAlsoMatchGroupMemberNickname = map['isAlsoMatchGroupMemberNickname']!;

  Map<String, dynamic> toMap() {
    return {
      'nextFlag': nextFlag,
      'count': count,
      'keywords': keywords,
      'isAlsoMatchGroupMemberNickname': isAlsoMatchGroupMemberNickname,
    };
  }
}

/// Group mute configuration.
///
/// Description: Group mute configuration.
class ZIMGroupMuteConfig {
  /// Group mute mode.
  ZIMGroupMuteMode mode;

  /// Group mute duration, the unit is seconds. The value is -1, which means permanent mute. If you need to implement non-permanent mute, the upper limit is 604800 (7 days). If you need to increase it, please contact ZEGO technical support.
  int duration;

  /// Group role list.
  List<int> roles;

  ZIMGroupMuteConfig({
    this.mode = ZIMGroupMuteMode.normal,
    this.duration = -1,
    List<int>? roles,
  }) : roles = roles ?? [];

  ZIMGroupMuteConfig.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMGroupMuteModeExtension.mapValue[map['mode']] ??
          ZIMGroupMuteMode.normal,
      duration = map['duration']!,
      roles =
          ((map['roles']!) as List).map<int>((item) => item as int).toList();

  Map<String, dynamic> toMap() {
    return {'mode': mode.value, 'duration': duration, 'roles': roles};
  }
}

/// Group members mute configuration.
///
/// Description: Group members mute configuration.
class ZIMGroupMemberMuteConfig {
  /// Group members mute duration, the unit is seconds. The value is -1, which means permanent mute. If you need to implement non-permanent mute, the upper limit is 604800 (7 days). If you need to increase it, please contact ZEGO technical support.
  int duration;

  ZIMGroupMemberMuteConfig({this.duration = -1});

  ZIMGroupMemberMuteConfig.fromMap(Map<dynamic, dynamic> map)
    : duration = map['duration']!;

  Map<String, dynamic> toMap() {
    return {'duration': duration};
  }
}

/// Group muted member list query configuration.
///
/// Description: Group muted member list query configuration.
class ZIMGroupMemberMutedListQueryConfig {
  /// nextFlag.
  int nextFlag;

  /// count.
  int count;

  ZIMGroupMemberMutedListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupMemberMutedListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Group application information.
///
/// Description: Group application information class, containing details of join or invite applications.
class ZIMGroupApplicationInfo {
  /// Group application type.
  ZIMGroupApplicationType type;

  /// Group application state.
  ZIMGroupApplicationState state;

  /// Group information for applying to join the group.
  ZIMGroupInfo groupInfo;

  /// Detail description: The applicant is the applicant when applying to join, the invitee when applying to invite, and the inviter when applying by invitation.
  ZIMUserInfo applyUser;

  /// Group application create time.
  int createTime;

  /// Group application status update time.
  int updateTime;

  /// The wording of group application information.
  String wording;

  /// The operator who agrees to join the group application.
  ZIMGroupMemberSimpleInfo? operatedUser;

  ZIMGroupApplicationInfo({
    required this.type,
    required this.state,
    required this.groupInfo,
    required this.applyUser,
    required this.createTime,
    required this.updateTime,
    required this.wording,
    this.operatedUser,
  });

  ZIMGroupApplicationInfo.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMGroupApplicationTypeExtension.mapValue[map['type']] ??
          ZIMGroupApplicationType.unknown,
      state =
          ZIMGroupApplicationStateExtension.mapValue[map['state']] ??
          ZIMGroupApplicationState.unknown,
      groupInfo = ZIMGroupInfo.fromMap(map['groupInfo']),
      applyUser = ZIMDataUtils.parseZIMUserInfoFromMap(map['applyUser']),
      createTime = map['createTime']!,
      updateTime = map['updateTime']!,
      wording = map['wording']!,
      operatedUser =
          (map['operatedUser'] != null)
              ? ZIMGroupMemberSimpleInfo.fromMap(map['operatedUser'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'state': state.value,
      'groupInfo': groupInfo.toMap(),
      'applyUser': applyUser.toMap(),
      'createTime': createTime,
      'updateTime': updateTime,
      'wording': wording,
      'operatedUser': operatedUser?.toMap(),
    };
  }
}

/// The behavior property of the send group join application setting.
///
/// Description: Configuration class for sending group join applications.
class ZIMGroupJoinApplicationSendConfig {
  /// Postscript to the application operation. Size limit: 256 characters.
  String wording;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMGroupJoinApplicationSendConfig({this.wording = '', this.pushConfig});

  ZIMGroupJoinApplicationSendConfig.fromMap(Map<dynamic, dynamic> map)
    : wording = map['wording']!,
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'wording': wording, 'pushConfig': pushConfig?.toMap()};
  }
}

/// The behavior property of the accept group join application setting.
///
/// Description: Configuration class for accepting group join applications.
class ZIMGroupJoinApplicationAcceptConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMGroupJoinApplicationAcceptConfig({this.pushConfig});

  ZIMGroupJoinApplicationAcceptConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// The behavior property of the reject group join application setting.
///
/// Description: Configuration class for rejecting group join applications.
class ZIMGroupJoinApplicationRejectConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMGroupJoinApplicationRejectConfig({this.pushConfig});

  ZIMGroupJoinApplicationRejectConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// The behavior property of the send group invite application setting.
///
/// Description: Configuration class for sending group invite applications.
class ZIMGroupInviteApplicationSendConfig {
  /// Postscript to the application operation. Size limit: 256 characters.
  String wording;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMGroupInviteApplicationSendConfig({this.wording = '', this.pushConfig});

  ZIMGroupInviteApplicationSendConfig.fromMap(Map<dynamic, dynamic> map)
    : wording = map['wording']!,
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'wording': wording, 'pushConfig': pushConfig?.toMap()};
  }
}

/// The behavior property of the accept group invite application setting.
///
/// Description: Configuration class for accepting group invite applications.
class ZIMGroupInviteApplicationAcceptConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMGroupInviteApplicationAcceptConfig({this.pushConfig});

  ZIMGroupInviteApplicationAcceptConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// The behavior property of the reject group invite application setting.
///
/// Description: Configuration class for rejecting group invite applications.
class ZIMGroupInviteApplicationRejectConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMGroupInviteApplicationRejectConfig({this.pushConfig});

  ZIMGroupInviteApplicationRejectConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// Query the group application configuration.
///
/// Description: Through this configuration, you can set the total number of queries and the pagination query.
class ZIMGroupApplicationListQueryConfig {
  /// nextFlag.
  int nextFlag;

  /// count. It is advised to be no more than 30.
  int count;

  ZIMGroupApplicationListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupApplicationListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Group list query configuration.
///
/// Description: Configuration class for querying the group list.
class ZIMGroupListQueryConfig {
  /// nextFlag.
  int nextFlag;

  /// Specify the list of users.
  List<String> userIDs;

  ZIMGroupListQueryConfig({this.nextFlag = 0, List<String>? userIDs})
    : userIDs = userIDs ?? [];

  ZIMGroupListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      userIDs =
          ((map['userIDs']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'userIDs': userIDs};
  }
}

/// Call invitation user information.
///
/// Description: Call invitation user information.
class ZIMCallUserInfo {
  /// User ID, a string with a maximum length of 32 bytes or less. It is customized by the developer. Only support numbers, English characters and  '!', '#', '$', '%', '&', '(', ')', '+', '-', ':', ';', '<', '=', '.', '>', '?', '@', '[', ']', '^', '_', '{', '}', '|', '~'.
  String userID;

  /// user status.
  ZIMCallUserState state;

  /// Call the additional information in user information.
  String extendedData;

  ZIMCallUserInfo({
    required this.userID,
    required this.state,
    required this.extendedData,
  });

  ZIMCallUserInfo.fromMap(Map<dynamic, dynamic> map)
    : userID = map['userID']!,
      state =
          ZIMCallUserStateExtension.mapValue[map['state']] ??
          ZIMCallUserState.unknown,
      extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'state': state.value,
      'extendedData': extendedData,
    };
  }
}

/// The behavior property of the Send Call Invitation setting.
///
/// Description: The behavior property of the Send Call Invitation setting.
class ZIMCallInviteConfig {
  /// The timeout setting of the call invitation, the unit is seconds. The range is  [1, 600].
  int timeout;

  /// Call invitation mode configuration.
  ZIMCallInvitationMode mode;

  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  /// If the pass value is true, the system checks whether the call invitation is delivered in this call and subsequent calls.
  bool enableNotReceivedCheck;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCallInviteConfig({
    this.timeout = 90,
    this.mode = ZIMCallInvitationMode.general,
    this.extendedData = '',
    this.enableNotReceivedCheck = false,
    this.pushConfig,
  });

  ZIMCallInviteConfig.fromMap(Map<dynamic, dynamic> map)
    : timeout = map['timeout']!,
      mode =
          ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
          ZIMCallInvitationMode.general,
      extendedData = map['extendedData']!,
      enableNotReceivedCheck = map['enableNotReceivedCheck']!,
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'timeout': timeout,
      'mode': mode.value,
      'extendedData': extendedData,
      'enableNotReceivedCheck': enableNotReceivedCheck,
      'pushConfig': pushConfig?.toMap(),
    };
  }
}

/// Behavior property set by quit a call invitation.
///
/// Description: Behavior property set by quit a call invitation.
class ZIMCallingInviteConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCallingInviteConfig({this.pushConfig});

  ZIMCallingInviteConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// Add the behavior attribute of the call invitation setting.<br/>.
///
/// Description: Add the behavior attribute of the call invitation setting.
class ZIMCallJoinConfig {
  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  ZIMCallJoinConfig({this.extendedData = ''});

  ZIMCallJoinConfig.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// Behavior property set by quit a call invitation.
///
/// Description: Behavior property set by quit a call invitation.
class ZIMCallQuitConfig {
  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCallQuitConfig({this.extendedData = '', this.pushConfig});

  ZIMCallQuitConfig.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!,
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData, 'pushConfig': pushConfig?.toMap()};
  }
}

/// End the behavior attribute of the call invitation setting.
///
/// Description: End the behavior attribute of the call invitation setting.
class ZIMCallEndConfig {
  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCallEndConfig({this.extendedData = '', this.pushConfig});

  ZIMCallEndConfig.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!,
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData, 'pushConfig': pushConfig?.toMap()};
  }
}

/// Behavior property that cancels the call invitation setting.
///
/// Description: Behavior property that cancels the call invitation setting.
class ZIMCallCancelConfig {
  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCallCancelConfig({this.extendedData = '', this.pushConfig});

  ZIMCallCancelConfig.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!,
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData, 'pushConfig': pushConfig?.toMap()};
  }
}

/// Behavior property set by accepting a call invitation.
///
/// Description: Behavior property set by accepting a call invitation.
class ZIMCallAcceptConfig {
  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  ZIMCallAcceptConfig({this.extendedData = ''});

  ZIMCallAcceptConfig.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// This parameter is used to set the configuration item of call invitation rejection.
///
/// Description: This command is used to customize the call invitation when sending invitation rejection.
/// Use cases: You need to pass the configuration item to the interface when invoking the call rejection invitation.
class ZIMCallRejectConfig {
  /// Additional fields for attaching custom content when sending a reject invitation.
  String extendedData;

  ZIMCallRejectConfig({this.extendedData = ''});

  ZIMCallRejectConfig.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// Call invitation sent message.
///
/// Description: Call invitation sent message.
class ZIMCallInvitationSentInfo {
  /// The timeout setting of the call invitation, the unit is seconds.
  int timeout;

  /// User id that has not received a call invitation list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMCallInvitationSentInfo({
    this.timeout = 0,
    List<ZIMErrorUserInfo>? errorUserList,
  }) : errorUserList = errorUserList ?? [];

  ZIMCallInvitationSentInfo.fromMap(Map<dynamic, dynamic> map)
    : timeout = map['timeout']!,
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'timeout': timeout,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Information about callingInvite.
///
/// Description: Information about callingInvite
class ZIMCallingInvitationSentInfo {
  /// Error user list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMCallingInvitationSentInfo({List<ZIMErrorUserInfo>? errorUserList})
    : errorUserList = errorUserList ?? [];

  ZIMCallingInvitationSentInfo.fromMap(Map<dynamic, dynamic> map)
    : errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Result of join the call operation.
///
/// Description: Result of join the call operation.
class ZIMCallJoinSentInfo {
  /// The pass-through field that comes with invoking the end of the call.
  String extendedData;

  /// Timestamp of the time when the call invitation was created.
  int createTime;

  /// Time stamp of the person join the call invitation.
  int joinTime;

  /// List of user information in the current call invitation.
  List<ZIMCallUserInfo> callUserList;

  ZIMCallJoinSentInfo({
    this.extendedData = '',
    this.createTime = 0,
    this.joinTime = 0,
    List<ZIMCallUserInfo>? callUserList,
  }) : callUserList = callUserList ?? [];

  ZIMCallJoinSentInfo.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!,
      createTime = map['createTime']!,
      joinTime = map['joinTime']!,
      callUserList =
          ((map['callUserList']!) as List)
              .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'extendedData': extendedData,
      'createTime': createTime,
      'joinTime': joinTime,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Result of quit the call operation.
///
/// Description: Result of quit the call operation.
class ZIMCallQuitSentInfo {
  /// Timestamp of the time when the call invitation was created.
  int createTime;

  /// Time stamp of the person accepting the call invitation.
  int acceptTime;

  /// The time stamp for me to exit the call.
  int quitTime;

  ZIMCallQuitSentInfo({
    this.createTime = 0,
    this.acceptTime = 0,
    this.quitTime = 0,
  });

  ZIMCallQuitSentInfo.fromMap(Map<dynamic, dynamic> map)
    : createTime = map['createTime']!,
      acceptTime = map['acceptTime']!,
      quitTime = map['quitTime']!;

  Map<String, dynamic> toMap() {
    return {
      'createTime': createTime,
      'acceptTime': acceptTime,
      'quitTime': quitTime,
    };
  }
}

/// Information about ending a call invitation.
///
/// Description: Information class for the result of ending a call invitation.
class ZIMCallEndedSentInfo {
  /// Call invites to create a timestamp.
  int createTime;

  /// Time stamp of the person accepting the call invitation.
  int acceptTime;

  /// Call invitation end time.
  int endTime;

  ZIMCallEndedSentInfo({
    this.createTime = 0,
    this.acceptTime = 0,
    this.endTime = 0,
  });

  ZIMCallEndedSentInfo.fromMap(Map<dynamic, dynamic> map)
    : createTime = map['createTime']!,
      acceptTime = map['acceptTime']!,
      endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'createTime': createTime,
      'acceptTime': acceptTime,
      'endTime': endTime,
    };
  }
}

/// Information to accept the call invitation.
///
/// Description: Information to accept the call invitation.
class ZIMCallInvitationReceivedInfo {
  /// mode of the call invitation.
  ZIMCallInvitationMode mode;

  /// The timeout setting of the call invitation, the unit is seconds.
  int timeout;

  /// The creator of the call invitation is the same as the userID that calls callInvite.
  String caller;

  /// Inviter ID.
  String inviter;

  /// The event stamp when the call invitation was created on the server, accurate to milliseconds.
  int createTime;

  /// List of members invited to the call.
  List<ZIMCallUserInfo> callUserList;

  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  ZIMCallInvitationReceivedInfo({
    this.mode = ZIMCallInvitationMode.unknown,
    this.timeout = 0,
    this.caller = '',
    this.inviter = '',
    this.createTime = 0,
    List<ZIMCallUserInfo>? callUserList,
    this.extendedData = '',
  }) : callUserList = callUserList ?? [];

  ZIMCallInvitationReceivedInfo.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
          ZIMCallInvitationMode.unknown,
      timeout = map['timeout']!,
      caller = map['caller']!,
      inviter = map['inviter']!,
      createTime = map['createTime']!,
      callUserList =
          ((map['callUserList']!) as List)
              .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
              .toList(),
      extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.value,
      'timeout': timeout,
      'caller': caller,
      'inviter': inviter,
      'createTime': createTime,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
      'extendedData': extendedData,
    };
  }
}

/// Information to created the call invitation.
///
/// Description: Information to created the call invitation.
class ZIMCallInvitationCreatedInfo {
  /// mode of the call invitation.
  ZIMCallInvitationMode mode;

  /// The creator of the call invitation is the same as the userID that calls callInvite.
  String caller;

  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  /// The timeout setting of the call invitation, the unit is seconds.
  int timeout;

  /// The event stamp when the call invitation was created on the server, accurate to milliseconds.
  int createTime;

  /// List of members invited to the call.
  List<ZIMCallUserInfo> callUserList;

  ZIMCallInvitationCreatedInfo({
    this.mode = ZIMCallInvitationMode.unknown,
    this.caller = '',
    this.extendedData = '',
    this.timeout = 0,
    this.createTime = 0,
    List<ZIMCallUserInfo>? callUserList,
  }) : callUserList = callUserList ?? [];

  ZIMCallInvitationCreatedInfo.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
          ZIMCallInvitationMode.unknown,
      caller = map['caller']!,
      extendedData = map['extendedData']!,
      timeout = map['timeout']!,
      createTime = map['createTime']!,
      callUserList =
          ((map['callUserList']!) as List)
              .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.value,
      'caller': caller,
      'extendedData': extendedData,
      'timeout': timeout,
      'createTime': createTime,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Cancel the call invitation message.
///
/// Description: Cancel the call invitation message.
class ZIMCallInvitationCancelledInfo {
  /// The inviter ID of the call invitation.
  String inviter;

  /// The call invitation mode.
  ZIMCallInvitationMode mode;

  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  ZIMCallInvitationCancelledInfo({
    this.inviter = '',
    this.mode = ZIMCallInvitationMode.unknown,
    this.extendedData = '',
  });

  ZIMCallInvitationCancelledInfo.fromMap(Map<dynamic, dynamic> map)
    : inviter = map['inviter']!,
      mode =
          ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
          ZIMCallInvitationMode.unknown,
      extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'inviter': inviter,
      'mode': mode.value,
      'extendedData': extendedData,
    };
  }
}

/// Accept the call invitation message.
///
/// Description: Accept the call invitation message.
class ZIMCallInvitationAcceptedInfo {
  /// Invitee ID.
  String invitee;

  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  ZIMCallInvitationAcceptedInfo({this.invitee = '', this.extendedData = ''});

  ZIMCallInvitationAcceptedInfo.fromMap(Map<dynamic, dynamic> map)
    : invitee = map['invitee']!,
      extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'invitee': invitee, 'extendedData': extendedData};
  }
}

/// Reject the call invitation message.
///
/// Description: Reject the call invitation message.
class ZIMCallInvitationRejectedInfo {
  /// Invitee ID.
  String invitee;

  /// Extended field, through which the inviter can carry information to the invitee.
  String extendedData;

  ZIMCallInvitationRejectedInfo({this.invitee = '', this.extendedData = ''});

  ZIMCallInvitationRejectedInfo.fromMap(Map<dynamic, dynamic> map)
    : invitee = map['invitee']!,
      extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'invitee': invitee, 'extendedData': extendedData};
  }
}

/// End the call operation information.
///
/// Description: End the call operation information.
class ZIMCallInvitationEndedInfo {
  /// The calling party of the current call.
  String caller;

  /// End the call operator.
  String operatedUserID;

  /// The pass-through field that comes with invoking the end of the call.
  String extendedData;

  /// The mode of the call invitation.
  ZIMCallInvitationMode mode;

  /// Time stamp of the end of the call, in milliseconds. The format is UTC time stamp.
  int endTime;

  ZIMCallInvitationEndedInfo({
    this.caller = '',
    this.operatedUserID = '',
    this.extendedData = '',
    this.mode = ZIMCallInvitationMode.unknown,
    this.endTime = 0,
  });

  ZIMCallInvitationEndedInfo.fromMap(Map<dynamic, dynamic> map)
    : caller = map['caller']!,
      operatedUserID = map['operatedUserID']!,
      extendedData = map['extendedData']!,
      mode =
          ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
          ZIMCallInvitationMode.unknown,
      endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'caller': caller,
      'operatedUserID': operatedUserID,
      'extendedData': extendedData,
      'mode': mode.value,
      'endTime': endTime,
    };
  }
}

/// Information class about timeout notifications.
///
/// Description: Information class about timeout notifications.
class ZIMCallInvitationTimeoutInfo {
  /// Call invitation type.
  ZIMCallInvitationMode mode;

  ZIMCallInvitationTimeoutInfo({this.mode = ZIMCallInvitationMode.unknown});

  ZIMCallInvitationTimeoutInfo.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
          ZIMCallInvitationMode.unknown;

  Map<String, dynamic> toMap() {
    return {'mode': mode.value};
  }
}

/// Inquiry the setting attribute of the call invitation list.
///
/// Description: Inquiry the setting attribute of the call invitation list
class ZIMCallInvitationQueryConfig {
  /// The query number is limited to up to 100.
  int count;

  /// The flag of the query list.No padding is required for the first query. After the query, callback will return a nextFlag, which can be filled in the next query to continue the query based on the last query.
  int nextFlag;

  ZIMCallInvitationQueryConfig({this.count = 0, this.nextFlag = 0});

  ZIMCallInvitationQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : count = map['count']!,
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {'count': count, 'nextFlag': nextFlag};
  }
}

/// Call invitation information.
///
/// Description: Call invitation information.
class ZIMCallInfo {
  /// Call invite ID.
  String callID;

  /// Call invitation initiator ID.
  String caller;

  /// The inviter ID of the call invitation.
  String inviter;

  /// Call invites to create a timestamp.
  int createTime;

  /// Call invitation end time.
  int endTime;

  /// Call invitation status.
  ZIMCallState state;

  /// Call invitation mode.
  ZIMCallInvitationMode mode;

  /// Create a call invitation additional information.
  String extendedData;

  /// The list of call member.
  List<ZIMCallUserInfo> callUserList;

  ZIMCallInfo({
    required this.callID,
    required this.caller,
    required this.inviter,
    required this.createTime,
    required this.endTime,
    required this.state,
    required this.mode,
    required this.extendedData,
    required this.callUserList,
  });

  ZIMCallInfo.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!,
      caller = map['caller']!,
      inviter = map['inviter']!,
      createTime = map['createTime']!,
      endTime = map['endTime']!,
      state =
          ZIMCallStateExtension.mapValue[map['state']] ?? ZIMCallState.unknown,
      mode =
          ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
          ZIMCallInvitationMode.unknown,
      extendedData = map['extendedData']!,
      callUserList =
          ((map['callUserList']!) as List)
              .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'callID': callID,
      'caller': caller,
      'inviter': inviter,
      'createTime': createTime,
      'endTime': endTime,
      'state': state.value,
      'mode': mode.value,
      'extendedData': extendedData,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Call member status change information.
///
/// Description: Call member status change information.
class ZIMCallUserStateChangeInfo {
  /// List of call members whose status changes.
  List<ZIMCallUserInfo> callUserList;

  ZIMCallUserStateChangeInfo({List<ZIMCallUserInfo>? callUserList})
    : callUserList = callUserList ?? [];

  ZIMCallUserStateChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : callUserList =
          ((map['callUserList']!) as List)
              .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {'callUserList': callUserList.map((item) => item.toMap()).toList()};
  }
}

/// Query the blacklist configuration.
///
/// Description: Through this configuration, you can set the total number of queries and the pagination query.
class ZIMBlacklistQueryConfig {
  /// nextFlag.
  int nextFlag;

  /// count.
  int count;

  ZIMBlacklistQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMBlacklistQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// The behavior property of the Add Friend setting.
///
/// Description: The behavior property of the Add Friend setting.
class ZIMFriendAddConfig {
  /// Alias of friend.
  String friendAlias;

  /// Friend attributes. Up to 5 can be set. The key of the attribute can only be selected from k0 to k4.
  Map<String, String> friendAttributes;

  /// Add a friend postscript.
  String wording;

  ZIMFriendAddConfig({
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.wording = '',
  }) : friendAttributes = friendAttributes ?? {};

  ZIMFriendAddConfig.fromMap(Map<dynamic, dynamic> map)
    : friendAlias = map['friendAlias']!,
      friendAttributes = ((map['friendAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      wording = map['wording']!;

  Map<String, dynamic> toMap() {
    return {
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'wording': wording,
    };
  }
}

/// The behavior property of the Delete Friend setting.
///
/// Description: The behavior property of the Delete Friend setting.
class ZIMFriendDeleteConfig {
  /// Delete type.
  ZIMFriendDeleteType type;

  ZIMFriendDeleteConfig({this.type = ZIMFriendDeleteType.both});

  ZIMFriendDeleteConfig.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMFriendDeleteTypeExtension.mapValue[map['type']] ??
          ZIMFriendDeleteType.both;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// Query the configuration of the friend list.
///
/// Description: Query the configuration of the friend list.
class ZIMFriendListQueryConfig {
  /// The index of the current query anchor point.
  int nextFlag;

  /// Total number of current queries.
  int count;

  ZIMFriendListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMFriendListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Friend search configuration.
///
/// Description: Configuration class for searching friends.
class ZIMFriendSearchConfig {
  /// nextFlag.
  int nextFlag;

  /// count.
  int count;

  /// Search keywords, supports up to 5. Otherwise, an error will occur. For example, if you pass in '1' and '2', the search results will only display conversations that contain both '1' and '2' keywords in the messages.
  List<String> keywords;

  /// Whether to match friend aliases.
  bool isAlsoMatchFriendAlias;

  ZIMFriendSearchConfig({
    this.nextFlag = 0,
    this.count = 0,
    List<String>? keywords,
    this.isAlsoMatchFriendAlias = false,
  }) : keywords = keywords ?? [];

  ZIMFriendSearchConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!,
      keywords =
          ((map['keywords']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      isAlsoMatchFriendAlias = map['isAlsoMatchFriendAlias']!;

  Map<String, dynamic> toMap() {
    return {
      'nextFlag': nextFlag,
      'count': count,
      'keywords': keywords,
      'isAlsoMatchFriendAlias': isAlsoMatchFriendAlias,
    };
  }
}

/// Check the behavior properties of friend relationships.
///
/// Description: Check the behavior properties of friend relationships.
class ZIMFriendRelationCheckConfig {
  /// Check type.
  ZIMFriendRelationCheckType type;

  ZIMFriendRelationCheckConfig({this.type = ZIMFriendRelationCheckType.both});

  ZIMFriendRelationCheckConfig.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMFriendRelationCheckTypeExtension.mapValue[map['type']] ??
          ZIMFriendRelationCheckType.both;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// Friend relationship information.
///
/// Description: Detailed description: Friend relationship information.
class ZIMFriendRelationInfo {
  /// Friend relationship type.
  ZIMUserRelationType type;

  /// user ID.
  String userID;

  ZIMFriendRelationInfo({required this.type, required this.userID});

  ZIMFriendRelationInfo.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMUserRelationTypeExtension.mapValue[map['type']] ??
          ZIMUserRelationType.unknown,
      userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'type': type.value, 'userID': userID};
  }
}

/// Friend information.
///
/// Description: Detailed description: Friend information.
class ZIMFriendInfo extends ZIMUserInfo {
  /// The alias of friend.
  String friendAlias;

  /// Friend attributes. Up to 5 can be set. The key of the attribute can only be selected from k0 to k4.
  Map<String, String> friendAttributes;

  /// Friend add time.
  int createTime;

  /// Add a friend postscript.
  String wording;

  ZIMFriendInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.createTime = 0,
    this.wording = '',
  }) : friendAttributes = friendAttributes ?? {},
       super(
         userID: userID,
         userName: userName,
         userAvatarUrl: userAvatarUrl,
         type: ZIMUserInfoType.friend,
       );

  ZIMFriendInfo.fromMap(Map<dynamic, dynamic> map)
    : friendAlias = map['friendAlias']!,
      friendAttributes = ((map['friendAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      createTime = map['createTime']!,
      wording = map['wording']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'createTime': createTime,
      'wording': wording,
      'classType': 'ZIMFriendInfo',
    });
    return baseMap;
  }
}

/// The behavior property of the Send Friend Application setting.
///
/// Description: The behavior property of the Send Friend Application setting.
class ZIMFriendApplicationSendConfig {
  /// Add a friend postscript.
  String wording;

  /// Alias of friend.
  String friendAlias;

  /// Friend attributes. Up to 5 can be set. The key of the attribute can only be selected from k0 to k4.
  Map<String, String> friendAttributes;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMFriendApplicationSendConfig({
    this.wording = '',
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.pushConfig,
  }) : friendAttributes = friendAttributes ?? {};

  ZIMFriendApplicationSendConfig.fromMap(Map<dynamic, dynamic> map)
    : wording = map['wording']!,
      friendAlias = map['friendAlias']!,
      friendAttributes = ((map['friendAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'wording': wording,
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'pushConfig': pushConfig?.toMap(),
    };
  }
}

/// Behavior attributes for accepting friend requests.
///
/// Description: Behavior attributes for accepting friend requests.
class ZIMFriendApplicationAcceptConfig {
  /// friend alias.
  String friendAlias;

  /// friend attributes.
  Map<String, String> friendAttributes;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMFriendApplicationAcceptConfig({
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.pushConfig,
  }) : friendAttributes = friendAttributes ?? {};

  ZIMFriendApplicationAcceptConfig.fromMap(Map<dynamic, dynamic> map)
    : friendAlias = map['friendAlias']!,
      friendAttributes = ((map['friendAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'pushConfig': pushConfig?.toMap(),
    };
  }
}

/// Behavior attributes for rejecting friend application.
///
/// Description: Behavior attributes for rejecting friend application.
class ZIMFriendApplicationRejectConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMFriendApplicationRejectConfig({this.pushConfig});

  ZIMFriendApplicationRejectConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// Query the configuration of the friend application list.
///
/// Description: Query the configuration of the friend application list.
class ZIMFriendApplicationListQueryConfig {
  /// The index of the current query anchor point.
  int nextFlag;

  /// Total number of current queries.
  int count;

  ZIMFriendApplicationListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMFriendApplicationListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Friend application information.
///
/// Description: Detailed description: Friend application information.
class ZIMFriendApplicationInfo {
  /// Friend application type.
  ZIMFriendApplicationType type;

  /// Friend application state.
  ZIMFriendApplicationState state;

  /// Detail description: If you are the applicant, here is the respondent information; if you are the respondent, here is the applicant information;.
  ZIMUserInfo applyUser;

  /// The wording of friend application information.
  String wording;

  /// Friend add time.
  int createTime;

  /// Friend application status update time.
  int updateTime;

  ZIMFriendApplicationInfo({
    required this.type,
    required this.state,
    required this.applyUser,
    required this.wording,
    required this.createTime,
    required this.updateTime,
  });

  ZIMFriendApplicationInfo.fromMap(Map<dynamic, dynamic> map)
    : type =
          ZIMFriendApplicationTypeExtension.mapValue[map['type']] ??
          ZIMFriendApplicationType.unknown,
      state =
          ZIMFriendApplicationStateExtension.mapValue[map['state']] ??
          ZIMFriendApplicationState.unknown,
      applyUser = ZIMDataUtils.parseZIMUserInfoFromMap(map['applyUser']),
      wording = map['wording']!,
      createTime = map['createTime']!,
      updateTime = map['updateTime']!;

  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'state': state.value,
      'applyUser': applyUser.toMap(),
      'wording': wording,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}

/// Basic community information.
///
/// Description: Community basic information class.
class ZIMCommunityInfo {
  /// The community ID.
  String communityID;

  /// The community name.
  String communityName;

  /// The URL of the community avatar.
  String communityAvatarUrl;

  ZIMCommunityInfo({
    this.communityID = '',
    this.communityName = '',
    this.communityAvatarUrl = '',
  });

  ZIMCommunityInfo.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      communityName = map['communityName']!,
      communityAvatarUrl = map['communityAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'communityName': communityName,
      'communityAvatarUrl': communityAvatarUrl,
    };
  }
}

/// Community object.
///
/// Description: Community information class, containing basic attributes of a community.
class ZIMCommunity {
  /// The basic information of the community.
  ZIMCommunityInfo baseInfo;

  /// The total unread message count across all channels.
  int totalUnreadMessageCount;

  ZIMCommunity({ZIMCommunityInfo? baseInfo, this.totalUnreadMessageCount = 0})
    : baseInfo = baseInfo ?? ZIMCommunityInfo();

  ZIMCommunity.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMCommunityInfo.fromMap(map['baseInfo']),
      totalUnreadMessageCount = map['totalUnreadMessageCount']!;

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'totalUnreadMessageCount': totalUnreadMessageCount,
    };
  }
}

/// Community visitor verification information.
///
/// Description: Community visitor verification information class, containing the message fetch count and time duration for visitors.
class ZIMCommunityVisitorAccessInfo {
  /// The number of messages that visitors can fetch.
  int fetchMessageCount;

  /// The time duration for visitors to fetch messages, in seconds.
  int fetchMessageDuration;

  ZIMCommunityVisitorAccessInfo({
    this.fetchMessageCount = 0,
    this.fetchMessageDuration = 0,
  });

  ZIMCommunityVisitorAccessInfo.fromMap(Map<dynamic, dynamic> map)
    : fetchMessageCount = map['fetchMessageCount']!,
      fetchMessageDuration = map['fetchMessageDuration']!;

  Map<String, dynamic> toMap() {
    return {
      'fetchMessageCount': fetchMessageCount,
      'fetchMessageDuration': fetchMessageDuration,
    };
  }
}

/// Verification mode for joining the community.
///
/// Description: Community verification information class, describing the community join verification mode.
class ZIMCommunityVerifyInfo {
  /// Verification mode for joining the community.
  ZIMCommunityJoinMode joinMode;

  ZIMCommunityVerifyInfo({this.joinMode = ZIMCommunityJoinMode.any});

  ZIMCommunityVerifyInfo.fromMap(Map<dynamic, dynamic> map)
    : joinMode =
          ZIMCommunityJoinModeExtension.mapValue[map['joinMode']] ??
          ZIMCommunityJoinMode.any;

  Map<String, dynamic> toMap() {
    return {'joinMode': joinMode.value};
  }
}

/// Full community information.
///
/// Description: Community full information class, containing all attributes of a community.
class ZIMCommunityFullInfo {
  /// The basic information of the community.
  ZIMCommunityInfo baseInfo;

  /// The community notice.
  String communityNotice;

  /// The community attributes.
  Map<String, String> communityAttributes;

  /// The time when the community was created.
  int createTime;

  /// The user ID of the community creator.
  String creatorUserID;

  /// The current number of community members.
  int currentMemberCount;

  /// The notification status of the community.
  ZIMCommunityMessageNotificationStatus notificationStatus;

  /// The community visitor access information.
  ZIMCommunityVisitorAccessInfo visitorAccessInfo;

  /// The join verification info of the community.
  ZIMCommunityVerifyInfo verifyInfo;

  ZIMCommunityFullInfo({
    ZIMCommunityInfo? baseInfo,
    this.communityNotice = '',
    Map<String, String>? communityAttributes,
    this.createTime = 0,
    this.creatorUserID = '',
    this.currentMemberCount = 0,
    this.notificationStatus = ZIMCommunityMessageNotificationStatus.notify,
    ZIMCommunityVisitorAccessInfo? visitorAccessInfo,
    ZIMCommunityVerifyInfo? verifyInfo,
  }) : baseInfo = baseInfo ?? ZIMCommunityInfo(),
       communityAttributes = communityAttributes ?? {},
       visitorAccessInfo = visitorAccessInfo ?? ZIMCommunityVisitorAccessInfo(),
       verifyInfo = verifyInfo ?? ZIMCommunityVerifyInfo();

  ZIMCommunityFullInfo.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMCommunityInfo.fromMap(map['baseInfo']),
      communityNotice = map['communityNotice']!,
      communityAttributes = ((map['communityAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      createTime = map['createTime']!,
      creatorUserID = map['creatorUserID']!,
      currentMemberCount = map['currentMemberCount']!,
      notificationStatus =
          ZIMCommunityMessageNotificationStatusExtension
              .mapValue[map['notificationStatus']] ??
          ZIMCommunityMessageNotificationStatus.notify,
      visitorAccessInfo = ZIMCommunityVisitorAccessInfo.fromMap(
        map['visitorAccessInfo'],
      ),
      verifyInfo = ZIMCommunityVerifyInfo.fromMap(map['verifyInfo']);

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'communityNotice': communityNotice,
      'communityAttributes': communityAttributes,
      'createTime': createTime,
      'creatorUserID': creatorUserID,
      'currentMemberCount': currentMemberCount,
      'notificationStatus': notificationStatus.value,
      'visitorAccessInfo': visitorAccessInfo.toMap(),
      'verifyInfo': verifyInfo.toMap(),
    };
  }
}

/// Configuration for creating a community.
///
/// Description: Configuration class for creating a community.
class ZIMCommunityCreateConfig {
  /// The community notice to set when creating the community.
  String communityNotice;

  /// The community attributes to set when creating the community.
  Map<String, String> communityAttributes;

  /// The join verification mode to set when creating the community. Defaults to anyone can join.
  ZIMCommunityJoinMode joinMode;

  ZIMCommunityCreateConfig({
    this.communityNotice = '',
    Map<String, String>? communityAttributes,
    this.joinMode = ZIMCommunityJoinMode.any,
  }) : communityAttributes = communityAttributes ?? {};

  ZIMCommunityCreateConfig.fromMap(Map<dynamic, dynamic> map)
    : communityNotice = map['communityNotice']!,
      communityAttributes = ((map['communityAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      joinMode =
          ZIMCommunityJoinModeExtension.mapValue[map['joinMode']] ??
          ZIMCommunityJoinMode.any;

  Map<String, dynamic> toMap() {
    return {
      'communityNotice': communityNotice,
      'communityAttributes': communityAttributes,
      'joinMode': joinMode.value,
    };
  }
}

/// The behavior property of the send community join application setting.
///
/// Description: Configuration class for sending community join applications.
class ZIMCommunityJoinApplicationSendConfig {
  /// Postscript to the application operation. Size limit: 256 characters.
  String wording;

  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCommunityJoinApplicationSendConfig({this.wording = '', this.pushConfig});

  ZIMCommunityJoinApplicationSendConfig.fromMap(Map<dynamic, dynamic> map)
    : wording = map['wording']!,
      pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'wording': wording, 'pushConfig': pushConfig?.toMap()};
  }
}

/// (Empty Class) Configurations related to canceling the community join application.
///
/// Description: (Empty Class) Configurations related to canceling the community join application.
class ZIMCommunityJoinApplicationCancelConfig {
  ZIMCommunityJoinApplicationCancelConfig();

  ZIMCommunityJoinApplicationCancelConfig.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Configurations related to accepting the community join application.
///
/// Description: Configuration class for accepting community join applications.
class ZIMCommunityJoinApplicationAcceptConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCommunityJoinApplicationAcceptConfig({this.pushConfig});

  ZIMCommunityJoinApplicationAcceptConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// Configurations related to rejecting the community join application.
///
/// Description: Configuration class for rejecting community join applications.
class ZIMCommunityJoinApplicationRejectConfig {
  /// Offline push configuration.
  ZIMPushConfig? pushConfig;

  ZIMCommunityJoinApplicationRejectConfig({this.pushConfig});

  ZIMCommunityJoinApplicationRejectConfig.fromMap(Map<dynamic, dynamic> map)
    : pushConfig =
          (map['pushConfig'] != null)
              ? ZIMPushConfig.fromMap(map['pushConfig'])
              : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// Community application list query configuration.
///
/// Description: Configuration class for querying the community application list under a specified community, supporting pagination.
class ZIMCommunityApplicationListQueryConfig {
  /// The pagination flag for querying the next page, which uses the applyID as the anchor. Pass 0 to query from the latest page, and pass the nextFlag returned by the previous page callback (the applyID of the last application in that page) to query the next page.
  int nextFlag;

  ZIMCommunityApplicationListQueryConfig({this.nextFlag = 0});

  ZIMCommunityApplicationListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag};
  }
}

/// Community application information.
///
/// Description: Community application information class, containing details of the community join application.
class ZIMCommunityApplicationInfo {
  /// The unique ID of the community application.
  int applyID;

  /// Community application type.
  ZIMCommunityApplicationType type;

  /// Community application state.
  ZIMCommunityApplicationState state;

  /// The community information to apply to join.
  ZIMCommunityInfo communityInfo;

  /// The applicant information.
  ZIMUserInfo applyUser;

  /// The operator user ID, which is empty when the application is awaiting response.
  String? operatedUserID;

  /// The wording of community application information.
  String wording;

  /// Community application create time.
  int createTime;

  /// Community application status update time.
  int updateTime;

  ZIMCommunityApplicationInfo({
    this.applyID = 0,
    this.type = ZIMCommunityApplicationType.unknown,
    this.state = ZIMCommunityApplicationState.unknown,
    ZIMCommunityInfo? communityInfo,
    ZIMUserInfo? applyUser,
    this.operatedUserID,
    this.wording = '',
    this.createTime = 0,
    this.updateTime = 0,
  }) : communityInfo = communityInfo ?? ZIMCommunityInfo(),
       applyUser = applyUser ?? ZIMUserInfo();

  ZIMCommunityApplicationInfo.fromMap(Map<dynamic, dynamic> map)
    : applyID = map['applyID']!,
      type =
          ZIMCommunityApplicationTypeExtension.mapValue[map['type']] ??
          ZIMCommunityApplicationType.unknown,
      state =
          ZIMCommunityApplicationStateExtension.mapValue[map['state']] ??
          ZIMCommunityApplicationState.unknown,
      communityInfo = ZIMCommunityInfo.fromMap(map['communityInfo']),
      applyUser = ZIMDataUtils.parseZIMUserInfoFromMap(map['applyUser']),
      operatedUserID = map['operatedUserID'],
      wording = map['wording']!,
      createTime = map['createTime']!,
      updateTime = map['updateTime']!;

  Map<String, dynamic> toMap() {
    return {
      'applyID': applyID,
      'type': type.value,
      'state': state.value,
      'communityInfo': communityInfo.toMap(),
      'applyUser': applyUser.toMap(),
      'operatedUserID': operatedUserID,
      'wording': wording,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}

/// Community application change information.
///
/// Description: Community application change information class, describing the addition, deletion, or update of a single application in the community application list.
class ZIMCommunityApplicationChangeInfo {
  /// Community application list change action.
  ZIMCommunityApplicationListAction action;

  /// The changed community application information.
  ZIMCommunityApplicationInfo applicationInfo;

  ZIMCommunityApplicationChangeInfo({
    this.action = ZIMCommunityApplicationListAction.added,
    ZIMCommunityApplicationInfo? applicationInfo,
  }) : applicationInfo = applicationInfo ?? ZIMCommunityApplicationInfo();

  ZIMCommunityApplicationChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : action =
          ZIMCommunityApplicationListActionExtension.mapValue[map['action']] ??
          ZIMCommunityApplicationListAction.added,
      applicationInfo = ZIMCommunityApplicationInfo.fromMap(
        map['applicationInfo'],
      );

  Map<String, dynamic> toMap() {
    return {'action': action.value, 'applicationInfo': applicationInfo.toMap()};
  }
}

/// Self community application list query configuration.
///
/// Description: Configuration class for querying the community join applications submitted by the current user, supporting pagination.
class ZIMCommunitySelfApplicationListQueryConfig {
  /// The pagination flag for querying the next page, which uses the applyID as the anchor. Pass 0 to query from the latest page, and pass the nextFlag returned by the previous page callback (the applyID of the last application in that page) to query the next page.
  int nextFlag;

  ZIMCommunitySelfApplicationListQueryConfig({this.nextFlag = 0});

  ZIMCommunitySelfApplicationListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag};
  }
}

/// Configuration for querying the community list.
///
/// Description: Configuration class for querying the community list.
class ZIMCommunityListQueryConfig {
  /// The pagination flag for querying the next page.
  int nextFlag;

  ZIMCommunityListQueryConfig({this.nextFlag = 0});

  ZIMCommunityListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag};
  }
}

/// Community change information
///
/// Description: Community change information class, describing changes to community attributes.
class ZIMCommunityChangeInfo {
  /// Conmmunity change event
  ZIMCommunityListChangeAction action;

  /// Changed community
  ZIMCommunity community;

  ZIMCommunityChangeInfo({
    this.action = ZIMCommunityListChangeAction.added,
    ZIMCommunity? community,
  }) : community = community ?? ZIMCommunity();

  ZIMCommunityChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : action =
          ZIMCommunityListChangeActionExtension.mapValue[map['action']] ??
          ZIMCommunityListChangeAction.added,
      community = ZIMCommunity.fromMap(map['community']);

  Map<String, dynamic> toMap() {
    return {'action': action.value, 'community': community.toMap()};
  }
}

/// Community member list query configuration
///
/// Description: Configuration class for querying the community member list.
class ZIMCommunityMemberListQueryConfig {
  /// The pagination flag for querying the next page.
  int nextFlag;

  /// The channel ID to query members from.
  String channelID;

  /// Whether to query only muted members.
  bool isMutedMember;

  ZIMCommunityMemberListQueryConfig({
    this.nextFlag = 0,
    this.channelID = '',
    this.isMutedMember = false,
  });

  ZIMCommunityMemberListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!,
      channelID = map['channelID']!,
      isMutedMember = map['isMutedMember']!;

  Map<String, dynamic> toMap() {
    return {
      'nextFlag': nextFlag,
      'channelID': channelID,
      'isMutedMember': isMutedMember,
    };
  }
}

/// Community full info update information
///
/// Description: Community full information update notification class.
class ZIMCommunityFullInfoUpdateInfo {
  /// Changed community full info
  ZIMCommunityFullInfo communityInfo;

  ZIMCommunityFullInfoUpdateInfo({ZIMCommunityFullInfo? communityInfo})
    : communityInfo = communityInfo ?? ZIMCommunityFullInfo();

  ZIMCommunityFullInfoUpdateInfo.fromMap(Map<dynamic, dynamic> map)
    : communityInfo = ZIMCommunityFullInfo.fromMap(map['communityInfo']);

  Map<String, dynamic> toMap() {
    return {'communityInfo': communityInfo.toMap()};
  }
}

/// Community member enter information
///
/// Description: Information class for a member entering a community.
class ZIMCommunityMemberEnterInfo {
  /// The time when the member entered the community.
  int enterTime;

  /// The type of how the member entered the community.
  ZIMCommunityMemberEnterType enterType;

  /// The user ID of the operator (e.g., the inviter).
  String operatedUserID;

  ZIMCommunityMemberEnterInfo({
    this.enterTime = 0,
    this.enterType = ZIMCommunityMemberEnterType.unknown,
    this.operatedUserID = '',
  });

  ZIMCommunityMemberEnterInfo.fromMap(Map<dynamic, dynamic> map)
    : enterTime = map['enterTime']!,
      enterType =
          ZIMCommunityMemberEnterTypeExtension.mapValue[map['enterType']] ??
          ZIMCommunityMemberEnterType.unknown,
      operatedUserID = map['operatedUserID']!;

  Map<String, dynamic> toMap() {
    return {
      'enterTime': enterTime,
      'enterType': enterType.value,
      'operatedUserID': operatedUserID,
    };
  }
}

/// Community member mute info
///
/// Description: Community member mute status information class.
class ZIMCommunityMemberMuteInfo {
  /// The mute type indicating which level the member is muted at.
  ZIMCommunityMemberMuteType muteType;

  /// The channel ID of the mute. Empty means muted at the community level.
  String channelID;

  /// The expiration time of the member's mute.
  int muteExpiredTime;

  ZIMCommunityMemberMuteInfo({
    this.muteType = ZIMCommunityMemberMuteType.none,
    this.channelID = '',
    this.muteExpiredTime = 0,
  });

  ZIMCommunityMemberMuteInfo.fromMap(Map<dynamic, dynamic> map)
    : muteType =
          ZIMCommunityMemberMuteTypeExtension.mapValue[map['muteType']] ??
          ZIMCommunityMemberMuteType.none,
      channelID = map['channelID']!,
      muteExpiredTime = map['muteExpiredTime']!;

  Map<String, dynamic> toMap() {
    return {
      'muteType': muteType.value,
      'channelID': channelID,
      'muteExpiredTime': muteExpiredTime,
    };
  }
}

/// Community member information
///
/// Description: Community member information class.
class ZIMCommunityMemberInfo extends ZIMUserInfo {
  /// The role of the community member.
  int memberRole;

  /// The information about how the member entered the community.
  ZIMCommunityMemberEnterInfo enterInfo;

  /// The mute information of the community member.
  ZIMCommunityMemberMuteInfo muteInfo;

  ZIMCommunityMemberInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.memberRole = 0,
    ZIMCommunityMemberEnterInfo? enterInfo,
    ZIMCommunityMemberMuteInfo? muteInfo,
  }) : enterInfo = enterInfo ?? ZIMCommunityMemberEnterInfo(),
       muteInfo = muteInfo ?? ZIMCommunityMemberMuteInfo(),
       super(
         userID: userID,
         userName: userName,
         userAvatarUrl: userAvatarUrl,
         type: ZIMUserInfoType.communityMember,
       );

  ZIMCommunityMemberInfo.fromMap(Map<dynamic, dynamic> map)
    : memberRole = map['memberRole']!,
      enterInfo = ZIMCommunityMemberEnterInfo.fromMap(map['enterInfo']),
      muteInfo = ZIMCommunityMemberMuteInfo.fromMap(map['muteInfo']),
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberRole': memberRole,
      'enterInfo': enterInfo.toMap(),
      'muteInfo': muteInfo.toMap(),
      'classType': 'ZIMCommunityMemberInfo',
    });
    return baseMap;
  }
}

/// Community member simple information
///
/// Description: Simple community member information class.
class ZIMCommunityMemberSimpleInfo extends ZIMUserInfo {
  /// The role of the community member.
  int memberRole;

  ZIMCommunityMemberSimpleInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.memberRole = 0,
  }) : super(userID: userID, userName: userName, userAvatarUrl: userAvatarUrl);

  ZIMCommunityMemberSimpleInfo.fromMap(Map<dynamic, dynamic> map)
    : memberRole = map['memberRole']!,
      super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberRole': memberRole,
      'classType': 'ZIMCommunityMemberSimpleInfo',
    });
    return baseMap;
  }
}

/// Community member state info change information
///
/// Description: Community member state change information class.
class ZIMCommunityMemberStateChangeInfo {
  /// The current state of the community member.
  ZIMCommunityMemberChangeState state;

  /// The action type of the member state change.
  ZIMCommunityMemberChangeAction action;

  /// Changed community member simple info
  ZIMCommunityMemberSimpleInfo memberInfo;

  ZIMCommunityMemberStateChangeInfo({
    this.state = ZIMCommunityMemberChangeState.exited,
    this.action = ZIMCommunityMemberChangeAction.unknown,
    ZIMCommunityMemberSimpleInfo? memberInfo,
  }) : memberInfo = memberInfo ?? ZIMCommunityMemberSimpleInfo();

  ZIMCommunityMemberStateChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : state =
          ZIMCommunityMemberChangeStateExtension.mapValue[map['state']] ??
          ZIMCommunityMemberChangeState.exited,
      action =
          ZIMCommunityMemberChangeActionExtension.mapValue[map['action']] ??
          ZIMCommunityMemberChangeAction.unknown,
      memberInfo = ZIMCommunityMemberSimpleInfo.fromMap(map['memberInfo']);

  Map<String, dynamic> toMap() {
    return {
      'state': state.value,
      'action': action.value,
      'memberInfo': memberInfo.toMap(),
    };
  }
}

/// Community member full info update information
///
/// Description: Community member information update notification class.
class ZIMCommunityMemberInfoUpdateInfo {
  /// Changed community member info
  ZIMCommunityMemberInfo memberInfo;

  ZIMCommunityMemberInfoUpdateInfo({ZIMCommunityMemberInfo? memberInfo})
    : memberInfo = memberInfo ?? ZIMCommunityMemberInfo();

  ZIMCommunityMemberInfoUpdateInfo.fromMap(Map<dynamic, dynamic> map)
    : memberInfo = ZIMCommunityMemberInfo.fromMap(map['memberInfo']);

  Map<String, dynamic> toMap() {
    return {'memberInfo': memberInfo.toMap()};
  }
}

/// Basic community channel information.
///
/// Description: Community channel basic information class.
class ZIMCommunityChannelInfo {
  /// The channel ID.
  String channelID;

  /// The type of the community channel.
  ZIMCommunityChannelType channelType;

  /// The channel name.
  String channelName;

  /// The URL of the channel avatar.
  String channelAvatarUrl;

  /// The ID of the community that the channel belongs to.
  String communityID;

  ZIMCommunityChannelInfo({
    this.channelID = '',
    this.channelType = ZIMCommunityChannelType.public,
    this.channelName = '',
    this.channelAvatarUrl = '',
    this.communityID = '',
  });

  ZIMCommunityChannelInfo.fromMap(Map<dynamic, dynamic> map)
    : channelID = map['channelID']!,
      channelType =
          ZIMCommunityChannelTypeExtension.mapValue[map['channelType']] ??
          ZIMCommunityChannelType.public,
      channelName = map['channelName']!,
      channelAvatarUrl = map['channelAvatarUrl']!,
      communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {
      'channelID': channelID,
      'channelType': channelType.value,
      'channelName': channelName,
      'channelAvatarUrl': channelAvatarUrl,
      'communityID': communityID,
    };
  }
}

/// Community channel mute info
///
/// Description: Community channel mute status information class.
class ZIMCommunityChannelMuteInfo {
  /// The mute mode of the community channel.
  ZIMCommunityChannelMuteMode mode;

  /// The expiration time of the channel mute.
  int expiredTime;

  /// The muted roles in the community channel.
  List<int> roles;

  ZIMCommunityChannelMuteInfo({
    this.mode = ZIMCommunityChannelMuteMode.none,
    this.expiredTime = 0,
    List<int>? roles,
  }) : roles = roles ?? [];

  ZIMCommunityChannelMuteInfo.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMCommunityChannelMuteModeExtension.mapValue[map['mode']] ??
          ZIMCommunityChannelMuteMode.none,
      expiredTime = map['expiredTime']!,
      roles =
          ((map['roles']!) as List).map<int>((item) => item as int).toList();

  Map<String, dynamic> toMap() {
    return {'mode': mode.value, 'expiredTime': expiredTime, 'roles': roles};
  }
}

/// Community channel object.
///
/// Description: Community channel information class, containing basic attributes of a channel.
class ZIMCommunityChannel {
  /// The basic information of the community channel.
  ZIMCommunityChannelInfo baseInfo;

  /// The conversation ID of the community channel.
  String conversationID;

  /// The community channel attributes.
  Map<String, String> channelAttributes;

  /// The notification status of the community channel.
  ZIMConversationNotificationStatus notificationStatus;

  /// The number of unread messages in the community channel.
  int unreadMessageCount;

  /// The last message in the community channel.
  ZIMMessage? lastMessage;

  /// The list of mention information in the community channel.
  List<ZIMMessageMentionedInfo> mentionedInfoList;

  /// The expiration time of the local user's mute in the channel.
  int selfMutedExpiredTime;

  /// The draft message of the community channel.
  String draft;

  ZIMCommunityChannel({
    ZIMCommunityChannelInfo? baseInfo,
    this.conversationID = '',
    Map<String, String>? channelAttributes,
    this.notificationStatus = ZIMConversationNotificationStatus.notify,
    this.unreadMessageCount = 0,
    this.lastMessage,
    List<ZIMMessageMentionedInfo>? mentionedInfoList,
    this.selfMutedExpiredTime = 0,
    this.draft = '',
  }) : baseInfo = baseInfo ?? ZIMCommunityChannelInfo(),
       channelAttributes = channelAttributes ?? {},
       mentionedInfoList = mentionedInfoList ?? [];

  ZIMCommunityChannel.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMCommunityChannelInfo.fromMap(map['baseInfo']),
      conversationID = map['conversationID']!,
      channelAttributes = ((map['channelAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      notificationStatus =
          ZIMConversationNotificationStatusExtension
              .mapValue[map['notificationStatus']] ??
          ZIMConversationNotificationStatus.notify,
      unreadMessageCount = map['unreadMessageCount']!,
      lastMessage =
          (map['lastMessage'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['lastMessage'])
              : null,
      mentionedInfoList =
          ((map['mentionedInfoList']!) as List)
              .map<ZIMMessageMentionedInfo>(
                (item) => ZIMMessageMentionedInfo.fromMap(item),
              )
              .toList(),
      selfMutedExpiredTime = map['selfMutedExpiredTime']!,
      draft = map['draft']!;

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'conversationID': conversationID,
      'channelAttributes': channelAttributes,
      'notificationStatus': notificationStatus.value,
      'unreadMessageCount': unreadMessageCount,
      'lastMessage': lastMessage?.toMap(),
      'mentionedInfoList':
          mentionedInfoList.map((item) => item.toMap()).toList(),
      'selfMutedExpiredTime': selfMutedExpiredTime,
      'draft': draft,
    };
  }
}

/// Full community channel information.
///
/// Description: Community channel full information class, containing all attributes of a channel.
class ZIMCommunityChannelFullInfo {
  /// The basic information of the community channel.
  ZIMCommunityChannelInfo baseInfo;

  /// The time when the channel was created.
  int createTime;

  /// The user ID of the channel creator.
  String creatorUserID;

  /// The community channel notice.
  String channelNotice;

  /// The community channel attributes.
  Map<String, String> channelAttributes;

  /// The current number of channel members.
  int currentMemberCount;

  /// The mute information of the community channel.
  ZIMCommunityChannelMuteInfo muteInfo;

  ZIMCommunityChannelFullInfo({
    ZIMCommunityChannelInfo? baseInfo,
    this.createTime = 0,
    this.creatorUserID = '',
    this.channelNotice = '',
    Map<String, String>? channelAttributes,
    this.currentMemberCount = 0,
    ZIMCommunityChannelMuteInfo? muteInfo,
  }) : baseInfo = baseInfo ?? ZIMCommunityChannelInfo(),
       channelAttributes = channelAttributes ?? {},
       muteInfo = muteInfo ?? ZIMCommunityChannelMuteInfo();

  ZIMCommunityChannelFullInfo.fromMap(Map<dynamic, dynamic> map)
    : baseInfo = ZIMCommunityChannelInfo.fromMap(map['baseInfo']),
      createTime = map['createTime']!,
      creatorUserID = map['creatorUserID']!,
      channelNotice = map['channelNotice']!,
      channelAttributes = ((map['channelAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString())),
      currentMemberCount = map['currentMemberCount']!,
      muteInfo = ZIMCommunityChannelMuteInfo.fromMap(map['muteInfo']);

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'createTime': createTime,
      'creatorUserID': creatorUserID,
      'channelNotice': channelNotice,
      'channelAttributes': channelAttributes,
      'currentMemberCount': currentMemberCount,
      'muteInfo': muteInfo.toMap(),
    };
  }
}

/// Configuration for creating a community channel.
///
/// Description: Configuration class for creating a community channel.
class ZIMCommunityChannelCreateConfig {
  /// The channel notice to set when creating the channel.
  String channelNotice;

  /// The channel attributes to set when creating the channel.
  Map<String, String> channelAttributes;

  ZIMCommunityChannelCreateConfig({
    this.channelNotice = '',
    Map<String, String>? channelAttributes,
  }) : channelAttributes = channelAttributes ?? {};

  ZIMCommunityChannelCreateConfig.fromMap(Map<dynamic, dynamic> map)
    : channelNotice = map['channelNotice']!,
      channelAttributes = ((map['channelAttributes']!) as Map)
          .map<String, String>((k, v) => MapEntry(k.toString(), v.toString()));

  Map<String, dynamic> toMap() {
    return {
      'channelNotice': channelNotice,
      'channelAttributes': channelAttributes,
    };
  }
}

/// Configuration for querying the community channel list.
///
/// Description: Configuration class for querying the community channel list.
class ZIMCommunityChannelListQueryConfig {
  /// The pagination flag for querying the next page.
  int nextFlag;

  ZIMCommunityChannelListQueryConfig({this.nextFlag = 0});

  ZIMCommunityChannelListQueryConfig.fromMap(Map<dynamic, dynamic> map)
    : nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag};
  }
}

/// Community channel change information.
///
/// Description: Community channel change information class, describing changes to channel attributes.
class ZIMCommunityChannelChangeInfo {
  /// The action type of the channel list change.
  ZIMCommunityChannelListChangeAction action;

  /// The changed community channel information.
  ZIMCommunityChannel channel;

  ZIMCommunityChannelChangeInfo({
    this.action = ZIMCommunityChannelListChangeAction.added,
    ZIMCommunityChannel? channel,
  }) : channel = channel ?? ZIMCommunityChannel();

  ZIMCommunityChannelChangeInfo.fromMap(Map<dynamic, dynamic> map)
    : action =
          ZIMCommunityChannelListChangeActionExtension
              .mapValue[map['action']] ??
          ZIMCommunityChannelListChangeAction.added,
      channel = ZIMCommunityChannel.fromMap(map['channel']);

  Map<String, dynamic> toMap() {
    return {'action': action.value, 'channel': channel.toMap()};
  }
}

/// Community channel full info update information
///
/// Description: Community channel full information update notification class.
class ZIMCommunityChannelFullInfoUpdateInfo {
  /// Changed community channel full info
  ZIMCommunityChannelFullInfo channelInfo;

  ZIMCommunityChannelFullInfoUpdateInfo({
    ZIMCommunityChannelFullInfo? channelInfo,
  }) : channelInfo = channelInfo ?? ZIMCommunityChannelFullInfo();

  ZIMCommunityChannelFullInfoUpdateInfo.fromMap(Map<dynamic, dynamic> map)
    : channelInfo = ZIMCommunityChannelFullInfo.fromMap(map['channelInfo']);

  Map<String, dynamic> toMap() {
    return {'channelInfo': channelInfo.toMap()};
  }
}

/// Community channel mute configuration
///
/// Description: Configuration class for muting a community channel.
class ZIMCommunityChannelMuteConfig {
  /// The mute mode for the community channel.
  ZIMCommunityChannelMuteMode mode;

  /// The roles to mute. Empty means muting all roles.
  List<int> roles;

  /// The mute duration in seconds. 0 means unmute.
  int duration;

  ZIMCommunityChannelMuteConfig({
    this.mode = ZIMCommunityChannelMuteMode.normal,
    List<int>? roles,
    this.duration = -1,
  }) : roles = roles ?? [];

  ZIMCommunityChannelMuteConfig.fromMap(Map<dynamic, dynamic> map)
    : mode =
          ZIMCommunityChannelMuteModeExtension.mapValue[map['mode']] ??
          ZIMCommunityChannelMuteMode.normal,
      roles =
          ((map['roles']!) as List).map<int>((item) => item as int).toList(),
      duration = map['duration']!;

  Map<String, dynamic> toMap() {
    return {'mode': mode.value, 'roles': roles, 'duration': duration};
  }
}

/// Community channel mute configuration
///
/// Description: Configuration class for muting community members.
class ZIMCommunityMemberMuteConfig {
  /// The mute duration in seconds. 0 means unmute.
  int duration;

  /// The channel ID. Leave empty to mute at the community level.
  String channelID;

  ZIMCommunityMemberMuteConfig({this.duration = -1, this.channelID = ''});

  ZIMCommunityMemberMuteConfig.fromMap(Map<dynamic, dynamic> map)
    : duration = map['duration']!,
      channelID = map['channelID']!;

  Map<String, dynamic> toMap() {
    return {'duration': duration, 'channelID': channelID};
  }
}

/// Callback of the log upload result.
class ZIMLogUploadedResult {
  ZIMLogUploadedResult();

  ZIMLogUploadedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Callback of the login result.
///
/// Available since: 1.2.0 and above.
/// Description: After the developer login, execute the callback of the result.
/// Use cases: Developers can use the [errorCode] in the callback to determine whether the login is successful.
/// Triggered when: When the developer calls the [login] interface, the callback will be triggered.
class ZIMLoggedInResult {
  ZIMLoggedInResult();

  ZIMLoggedInResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Callback of the result of renewing the token.
///
/// - [token] The renewed token.
class ZIMTokenRenewedResult {
  /// The renewed token.
  String token;

  ZIMTokenRenewedResult({required this.token});

  ZIMTokenRenewedResult.fromMap(Map<dynamic, dynamic> map)
    : token = map['token']!;

  Map<String, dynamic> toMap() {
    return {'token': token};
  }
}

/// Update the user name callback.
///
/// - [userName] The updated user name.
class ZIMUserNameUpdatedResult {
  /// The updated user name.
  String userName;

  ZIMUserNameUpdatedResult({required this.userName});

  ZIMUserNameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : userName = map['userName']!;

  Map<String, dynamic> toMap() {
    return {'userName': userName};
  }
}

/// Callback for updating the user avatar URL.
///
/// - [userAvatarUrl] The updated user avatar URL.
class ZIMUserAvatarUrlUpdatedResult {
  /// The updated user avatar URL.
  String userAvatarUrl;

  ZIMUserAvatarUrlUpdatedResult({required this.userAvatarUrl});

  ZIMUserAvatarUrlUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : userAvatarUrl = map['userAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {'userAvatarUrl': userAvatarUrl};
  }
}

/// Update the user extended data callback.
///
/// - [extendedData] The updated user extended data.
class ZIMUserExtendedDataUpdatedResult {
  /// The updated user extended data.
  String extendedData;

  ZIMUserExtendedDataUpdatedResult({required this.extendedData});

  ZIMUserExtendedDataUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// The callback of the custom status update.
///
/// - [customStatus] The updated user custom status.
class ZIMUserCustomStatusUpdatedResult {
  /// The updated user custom status.
  String customStatus;

  ZIMUserCustomStatusUpdatedResult({required this.customStatus});

  ZIMUserCustomStatusUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : customStatus = map['customStatus']!;

  Map<String, dynamic> toMap() {
    return {'customStatus': customStatus};
  }
}

/// Query the userInfo callback.
///
/// - [userList] The queried user information list.
/// - [errorUserList] The list of user IDs that failed to be queried.
class ZIMUsersInfoQueriedResult {
  /// The queried user information list.
  List<ZIMUserFullInfo> userList;

  /// The list of user IDs that failed to be queried.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersInfoQueriedResult({
    required this.userList,
    required this.errorUserList,
  });

  ZIMUsersInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : userList =
          ((map['userList']!) as List)
              .map<ZIMUserFullInfo>((item) => ZIMUserFullInfo.fromMap(item))
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'userList': userList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Update the result callback of the user offline push rule.
///
/// - [offlinePushRule] The updated user offline push rule.
class ZIMUserOfflinePushRuleUpdatedResult {
  /// The updated user offline push rule.
  ZIMUserOfflinePushRule offlinePushRule;

  ZIMUserOfflinePushRuleUpdatedResult({required this.offlinePushRule});

  ZIMUserOfflinePushRuleUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : offlinePushRule = ZIMUserOfflinePushRule.fromMap(map['offlinePushRule']);

  Map<String, dynamic> toMap() {
    return {'offlinePushRule': offlinePushRule.toMap()};
  }
}

/// Callback result of querying personal user information and rules.
///
/// - [selfUserInfo] The current user information and rules.
class ZIMSelfUserInfoQueriedResult {
  /// The current user information and rules.
  ZIMSelfUserInfo selfUserInfo;

  ZIMSelfUserInfoQueriedResult({required this.selfUserInfo});

  ZIMSelfUserInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : selfUserInfo = ZIMSelfUserInfo.fromMap(map['selfUserInfo']);

  Map<String, dynamic> toMap() {
    return {'selfUserInfo': selfUserInfo.toMap()};
  }
}

/// Result callback of the queryUsersStatus interface for batch querying user online status.
///
/// - [userStatusList] The queried user status list.
/// - [errorUserList] The list of user IDs that failed to be queried.
class ZIMUsersStatusQueriedResult {
  /// The queried user status list.
  List<ZIMUserStatus> userStatusList;

  /// The list of user IDs that failed to be queried.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersStatusQueriedResult({
    required this.userStatusList,
    required this.errorUserList,
  });

  ZIMUsersStatusQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : userStatusList =
          ((map['userStatusList']!) as List)
              .map<ZIMUserStatus>((item) => ZIMUserStatus.fromMap(item))
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'userStatusList': userStatusList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback for the operation results of the batch subscription interface.
///
/// - [errorUserList] The list of user IDs that failed to subscribe.
class ZIMUsersStatusSubscribedResult {
  /// The list of user IDs that failed to subscribe.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersStatusSubscribedResult({required this.errorUserList});

  ZIMUsersStatusSubscribedResult.fromMap(Map<dynamic, dynamic> map)
    : errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback for canceling the operations of subscribing interfaces in a batch.
///
/// - [errorUserList] The list of user IDs that failed to unsubscribe.
class ZIMUsersStatusUnsubscribedResult {
  /// The list of user IDs that failed to unsubscribe.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersStatusUnsubscribedResult({required this.errorUserList});

  ZIMUsersStatusUnsubscribedResult.fromMap(Map<dynamic, dynamic> map)
    : errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Query for the current user subscription list operation results callback.
///
/// - [userStatusSubscriptionList] The user status subscription list.
class ZIMSubscribedUserStatusListQueriedResult {
  /// The user status subscription list.
  List<ZIMUserStatusSubscription> userStatusSubscriptionList;

  ZIMSubscribedUserStatusListQueriedResult({
    required this.userStatusSubscriptionList,
  });

  ZIMSubscribedUserStatusListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : userStatusSubscriptionList =
          ((map['userStatusSubscriptionList']!) as List)
              .map<ZIMUserStatusSubscription>(
                (item) => ZIMUserStatusSubscription.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'userStatusSubscriptionList':
          userStatusSubscriptionList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Conversation query callback.
///
/// - [conversation] The queried conversation object.
class ZIMConversationQueriedResult {
  /// The queried conversation object.
  ZIMConversation conversation;

  ZIMConversationQueriedResult({required this.conversation});

  ZIMConversationQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : conversation = ZIMDataUtils.parseZIMConversationFromMap(
        map['conversation'],
      );

  Map<String, dynamic> toMap() {
    return {'conversation': conversation.toMap()};
  }
}

/// Session list query callback.
///
/// - [conversationList] The queried conversation list.
class ZIMConversationListQueriedResult {
  /// The queried conversation list.
  List<ZIMConversation> conversationList;

  ZIMConversationListQueriedResult({required this.conversationList});

  ZIMConversationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationList =
          ((map['conversationList']!) as List)
              .map<ZIMConversation>(
                (item) => ZIMDataUtils.parseZIMConversationFromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationList': conversationList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Query conversation unread total count callback.
///
/// - [unreadMessageCount] The total count of unread messages across all conversations.
class ZIMConversationTotalUnreadMessageCountQueriedResult {
  /// The total count of unread messages across all conversations.
  int unreadMessageCount;

  ZIMConversationTotalUnreadMessageCountQueriedResult({
    required this.unreadMessageCount,
  });

  ZIMConversationTotalUnreadMessageCountQueriedResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : unreadMessageCount = map['unreadMessageCount']!;

  Map<String, dynamic> toMap() {
    return {'unreadMessageCount': unreadMessageCount};
  }
}

/// Callback for conversation deletion.
///
/// - [conversationID] The ID of the deleted conversation.
/// - [conversationType] The type of the deleted conversation.
class ZIMConversationDeletedResult {
  /// The ID of the deleted conversation.
  String conversationID;

  /// The type of the deleted conversation.
  ZIMConversationType conversationType;

  ZIMConversationDeletedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationDeletedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Callback for conversations deletion.
class ZIMConversationsAllDeletedResult {
  ZIMConversationsAllDeletedResult();

  ZIMConversationsAllDeletedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Callback for session unread clearing.
///
/// - [conversationID] The conversation ID whose unread message count was cleared.
/// - [conversationType] The conversation type whose unread message count was cleared.
class ZIMConversationUnreadMessageCountClearedResult {
  /// The conversation ID whose unread message count was cleared.
  String conversationID;

  /// The conversation type whose unread message count was cleared.
  ZIMConversationType conversationType;

  ZIMConversationUnreadMessageCountClearedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationUnreadMessageCountClearedResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Callback for sessions unread clearing.
class ZIMConversationTotalUnreadMessageCountClearedResult {
  ZIMConversationTotalUnreadMessageCountClearedResult();

  ZIMConversationTotalUnreadMessageCountClearedResult.fromMap(
    Map<dynamic, dynamic> map,
  );

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Callback for conversation notification state settings.
///
/// - [conversationID] The conversation ID for which the notification status was set.
/// - [conversationType] The conversation type for which the notification status was set.
class ZIMConversationNotificationStatusSetResult {
  /// The conversation ID for which the notification status was set.
  String conversationID;

  /// The conversation type for which the notification status was set.
  ZIMConversationType conversationType;

  ZIMConversationNotificationStatusSetResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationNotificationStatusSetResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Callback interface for setting the read receipt conversation.
///
/// - [conversationID] The conversation ID for which the receipt was sent.
/// - [conversationType] The conversation type for which the receipt was sent.
class ZIMConversationMessageReceiptReadSentResult {
  /// The conversation ID for which the receipt was sent.
  String conversationID;

  /// The conversation type for which the receipt was sent.
  ZIMConversationType conversationType;

  ZIMConversationMessageReceiptReadSentResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationMessageReceiptReadSentResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Callback for conversation pinned state updated.
///
/// - [conversationID] The conversation ID whose pinned state was updated.
/// - [conversationType] The conversation type whose pinned state was updated.
class ZIMConversationPinnedStateUpdatedResult {
  /// The conversation ID whose pinned state was updated.
  String conversationID;

  /// The conversation type whose pinned state was updated.
  ZIMConversationType conversationType;

  ZIMConversationPinnedStateUpdatedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationPinnedStateUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Callback for querying the pinned conversation list.
///
/// - [conversationList] The queried pinned conversation list.
class ZIMConversationPinnedListQueriedResult {
  /// The queried pinned conversation list.
  List<ZIMConversation> conversationList;

  ZIMConversationPinnedListQueriedResult({required this.conversationList});

  ZIMConversationPinnedListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationList =
          ((map['conversationList']!) as List)
              .map<ZIMConversation>(
                (item) => ZIMDataUtils.parseZIMConversationFromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationList': conversationList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Sets the callback for the session draft.
///
/// - [conversationID] The conversation ID for which the draft was set.
/// - [conversationType] The conversation type for which the draft was set.
class ZIMConversationDraftSetResult {
  /// The conversation ID for which the draft was set.
  String conversationID;

  /// The conversation type for which the draft was set.
  ZIMConversationType conversationType;

  ZIMConversationDraftSetResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationDraftSetResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Callback for conversation mark set.
///
/// - [failedConversationInfos] The list of conversation info objects that failed to have marks set.
class ZIMConversationMarkSetResult {
  /// The list of conversation info objects that failed to have marks set.
  List<ZIMConversationBaseInfo> failedConversationInfos;

  ZIMConversationMarkSetResult({required this.failedConversationInfos});

  ZIMConversationMarkSetResult.fromMap(Map<dynamic, dynamic> map)
    : failedConversationInfos =
          ((map['failedConversationInfos']!) as List)
              .map<ZIMConversationBaseInfo>(
                (item) => ZIMConversationBaseInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'failedConversationInfos':
          failedConversationInfos.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback for the result of setting the message self-destruction duration in a conversation.
///
/// - [conversationID] The ID of the conversation for which the setting was applied.
/// - [conversationType] The type of the conversation for which the setting was applied.
class ZIMConversationMessageDestructDurationSetResult {
  /// The ID of the conversation for which the setting was applied.
  String conversationID;

  /// The type of the conversation for which the setting was applied.
  ZIMConversationType conversationType;

  ZIMConversationMessageDestructDurationSetResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationMessageDestructDurationSetResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Search for the return of local conversations results based on local messages.
///
/// - [conversationSearchInfoList] The list of searched conversation results.
/// - [nextFlag] Anchor for the next page query.
class ZIMConversationsSearchedResult {
  /// The list of searched conversation results.
  List<ZIMConversationSearchInfo> conversationSearchInfoList;

  /// Anchor for the next page query.
  int nextFlag;

  ZIMConversationsSearchedResult({
    required this.conversationSearchInfoList,
    required this.nextFlag,
  });

  ZIMConversationsSearchedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationSearchInfoList =
          ((map['conversationSearchInfoList']!) as List)
              .map<ZIMConversationSearchInfo>(
                (item) => ZIMConversationSearchInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'conversationSearchInfoList':
          conversationSearchInfoList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback of the result of sending the message.
///
/// - [message] Message object.
class ZIMMessageSentResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageSentResult({required this.message});

  ZIMMessageSentResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// The incoming message object is given a localMessgeID and returned.
///
/// - [message] Message object.
typedef ZIMMessageAttachedCallback = void Function(ZIMMessage message);

/// Progress callback for sending media messages.
///
/// - [message] Media message object.
/// - [currentFileSize] Current file size.
/// - [totalFileSize] Total file size.
typedef ZIMMediaUploadingProgress =
    void Function(
      ZIMMediaMessage message,
      int currentFileSize,
      int totalFileSize,
    );

/// Callback for multiple media file upload progress.
///
/// - [message] Multiple media message object.
/// - [currentFileSize] Current file size.
/// - [totalFileSize] Total file size.
/// - [messageInfoIndex] Current message index.
/// - [currentIndexFileSize] Current index file size.
/// - [totalIndexFileSize] Total index file size.
typedef ZIMMultipleMediaUploadingProgress =
    void Function(
      ZIMMultipleMessage message,
      int currentFileSize,
      int totalFileSize,
      int messageInfoIndex,
      int currentIndexFileSize,
      int totalIndexFileSize,
    );

/// The developer uses this callback to get a list of queried messages, which can be used to display historical messages.
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
/// - [messageList] Message list.
class ZIMMessageQueriedResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  /// Message list.
  List<ZIMMessage> messageList;

  ZIMMessageQueriedResult({
    required this.conversationID,
    required this.conversationType,
    required this.messageList,
  });

  ZIMMessageQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    };
  }
}

/// A callback to delete a message.
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
class ZIMMessageDeletedResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  ZIMMessageDeletedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMMessageDeletedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// Deletes callbacks of all messages for all sessions.
class ZIMConversationMessagesAllDeletedResult {
  ZIMConversationMessagesAllDeletedResult();

  ZIMConversationMessagesAllDeletedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Retracted news consequential reconciliation.
///
/// - [message] Message object.
class ZIMMessageRevokedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageRevokedResult({required this.message});

  ZIMMessageRevokedResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// Callback of the result of inserting the message.
///
/// - [message] Message object.
class ZIMMessageInsertedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageInsertedResult({required this.message});

  ZIMMessageInsertedResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// Callback for updating message local extension fields.
///
/// - [message] Message object.
class ZIMMessageLocalExtendedDataUpdatedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageLocalExtendedDataUpdatedResult({required this.message});

  ZIMMessageLocalExtendedDataUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// Callback interface for setting the read receipt message.
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
/// - [errorMessageIDs] Error message ID list.
class ZIMMessageReceiptsReadSentResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  /// Error message ID list.
  List<dynamic> errorMessageIDs;

  ZIMMessageReceiptsReadSentResult({
    required this.conversationID,
    required this.conversationType,
    required this.errorMessageIDs,
  });

  ZIMMessageReceiptsReadSentResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      errorMessageIDs =
          ((map['errorMessageIDs']!) as List)
              .map<dynamic>((item) => item as dynamic)
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'errorMessageIDs': errorMessageIDs,
    };
  }
}

/// Callback interface for query receipt message read.
///
/// - [infos] Message receipt information list.
/// - [errorMessageIDs] Error message ID list.
class ZIMMessageReceiptsInfoQueriedResult {
  /// Message receipt information list.
  List<ZIMMessageReceiptInfo> infos;

  /// Error message ID list.
  List<dynamic> errorMessageIDs;

  ZIMMessageReceiptsInfoQueriedResult({
    required this.infos,
    required this.errorMessageIDs,
  });

  ZIMMessageReceiptsInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : infos =
          ((map['infos']!) as List)
              .map<ZIMMessageReceiptInfo>(
                (item) => ZIMMessageReceiptInfo.fromMap(item),
              )
              .toList(),
      errorMessageIDs =
          ((map['errorMessageIDs']!) as List)
              .map<dynamic>((item) => item as dynamic)
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'infos': infos.map((item) => item.toMap()).toList(),
      'errorMessageIDs': errorMessageIDs,
    };
  }
}

/// The result callback of the download completion of the media message.
///
/// - [message] Message object.
class ZIMMediaDownloadedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMediaDownloadedResult({required this.message});

  ZIMMediaDownloadedResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// Progress callback for downloading media messages.
///
/// - [message] Message object.
/// - [currentFileSize] Current file size.
/// - [totalFileSize] Total file size.
typedef ZIMMediaDownloadingProgress =
    void Function(ZIMMessage message, int currentFileSize, int totalFileSize);

/// Return of local message search results.
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
/// - [messageList] Message list.
/// - [nextMessage] Next message object.
class ZIMMessagesSearchedResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  /// Message list.
  List<ZIMMessage> messageList;

  /// Next message object.
  ZIMMessage? nextMessage;

  ZIMMessagesSearchedResult({
    required this.conversationID,
    required this.conversationType,
    required this.messageList,
    this.nextMessage,
  });

  ZIMMessagesSearchedResult.fromMap(Map<dynamic, dynamic> map)
    : conversationID = map['conversationID']!,
      conversationType =
          ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
          ZIMConversationType.unknown,
      messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList(),
      nextMessage =
          (map['nextMessage'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'nextMessage': nextMessage?.toMap(),
    };
  }
}

/// Return of local message search results.
///
/// - [messageList] Message list.
/// - [nextMessage] Next message object.
class ZIMMessagesGlobalSearchedResult {
  /// Message list.
  List<ZIMMessage> messageList;

  /// Next message object.
  ZIMMessage? nextMessage;

  ZIMMessagesGlobalSearchedResult({
    required this.messageList,
    this.nextMessage,
  });

  ZIMMessagesGlobalSearchedResult.fromMap(Map<dynamic, dynamic> map)
    : messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList(),
      nextMessage =
          (map['nextMessage'] != null)
              ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
              : null;

  Map<String, dynamic> toMap() {
    return {
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'nextMessage': nextMessage?.toMap(),
    };
  }
}

/// The addition of return for message reactions.
///
/// - [reaction] Message reaction object.
class ZIMMessageReactionAddedResult {
  /// Message reaction object.
  ZIMMessageReaction reaction;

  ZIMMessageReactionAddedResult({required this.reaction});

  ZIMMessageReactionAddedResult.fromMap(Map<dynamic, dynamic> map)
    : reaction = ZIMMessageReaction.fromMap(map['reaction']);

  Map<String, dynamic> toMap() {
    return {'reaction': reaction.toMap()};
  }
}

/// The delete of return for message reactions.
///
/// - [reaction] Message reaction object.
class ZIMMessageReactionDeletedResult {
  /// Message reaction object.
  ZIMMessageReaction reaction;

  ZIMMessageReactionDeletedResult({required this.reaction});

  ZIMMessageReactionDeletedResult.fromMap(Map<dynamic, dynamic> map)
    : reaction = ZIMMessageReaction.fromMap(map['reaction']);

  Map<String, dynamic> toMap() {
    return {'reaction': reaction.toMap()};
  }
}

/// The return of the query for the details of the reaction.
///
/// - [message] Message object.
/// - [userInfoList] List of user reaction information.
/// - [reactionType] Message reaction type.
/// - [nextFlag] List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
/// - [totalCount] Total user count.
class ZIMMessageReactionUserListQueriedResult {
  /// Message object.
  ZIMMessage message;

  /// List of user reaction information.
  List<ZIMMessageReactionUserFullInfo> userInfoList;

  /// Message reaction type.
  String reactionType;

  /// List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  /// Total user count.
  int totalCount;

  @Deprecated('Deprecated since 2.28.0. Please use `userInfoList` instead.')
  List<ZIMMessageReactionUserInfo> userList;

  ZIMMessageReactionUserListQueriedResult({
    required this.message,
    required this.userInfoList,
    required this.reactionType,
    required this.nextFlag,
    required this.totalCount,
    required this.userList,
  });

  ZIMMessageReactionUserListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']),
      userInfoList =
          ((map['userInfoList']!) as List)
              .map<ZIMMessageReactionUserFullInfo>(
                (item) => ZIMMessageReactionUserFullInfo.fromMap(item),
              )
              .toList(),
      reactionType = map['reactionType']!,
      nextFlag = map['nextFlag']!,
      totalCount = map['totalCount']!,
      userList =
          ((map['userList']!) as List)
              .map<ZIMMessageReactionUserInfo>(
                (item) => ZIMMessageReactionUserInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'message': message.toMap(),
      'userInfoList': userInfoList.map((item) => item.toMap()).toList(),
      'reactionType': reactionType,
      'nextFlag': nextFlag,
      'totalCount': totalCount,
      'userList': userList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Result callback for querying merge message details.
///
/// - [message] Combine message object. The messageList in this object already contains the sub-message list of the merged message.
class ZIMCombineMessageDetailQueriedResult {
  /// Combine message object. The messageList in this object already contains the sub-message list of the merged message.
  ZIMCombineMessage message;

  ZIMCombineMessageDetailQueriedResult({required this.message});

  ZIMCombineMessageDetailQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMCombineMessage.fromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// The callback for querying the reply message list result.
///
/// - [messageList] Message list.
/// - [nextFlag] List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
/// - [rootRepliedInfo] Root message reply information.
class ZIMMessageRepliedListQueriedResult {
  /// Message list.
  List<ZIMMessage> messageList;

  /// List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  /// Root message reply information.
  ZIMMessageRootRepliedInfo rootRepliedInfo;

  ZIMMessageRepliedListQueriedResult({
    required this.messageList,
    required this.nextFlag,
    required this.rootRepliedInfo,
  });

  ZIMMessageRepliedListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!,
      rootRepliedInfo = ZIMMessageRootRepliedInfo.fromMap(
        map['rootRepliedInfo'],
      );

  Map<String, dynamic> toMap() {
    return {
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
      'rootRepliedInfo': rootRepliedInfo.toMap(),
    };
  }
}

/// Callback of the result of editing the message.
///
/// - [message] Message object.
class ZIMMessageEditedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageEditedResult({required this.message});

  ZIMMessageEditedResult.fromMap(Map<dynamic, dynamic> map)
    : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// Callback of the result of cancel sending the message.
class ZIMSendingMessageCancelledResult {
  ZIMSendingMessageCancelledResult();

  ZIMSendingMessageCancelledResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Callback of the result of the message to be pinned or unpinned.
class ZIMMessagePinnedResult {
  ZIMMessagePinnedResult();

  ZIMMessagePinnedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// The developer uses this callback to get a list of queried pinned messages, which can be used to display pinned messages.
///
/// - [messageList] Message list.
class ZIMPinnedMessageListQueriedResult {
  /// Message list.
  List<ZIMMessage> messageList;

  ZIMPinnedMessageListQueriedResult({required this.messageList});

  ZIMPinnedMessageListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {'messageList': messageList.map((item) => item.toMap()).toList()};
  }
}

/// Progress callback of the exported message.
///
/// - [exportedMessageCount] The number of exported messages.
/// - [totalMessageCount] The total number of messages.
typedef ZIMMessageExportingProgress =
    void Function(int exportedMessageCount, int totalMessageCount);

/// Callback for querying the results of the local cache.
///
/// - [fileCacheInfo] File cache information.
class ZIMFileCacheQueriedResult {
  /// File cache information.
  ZIMFileCacheInfo fileCacheInfo;

  ZIMFileCacheQueriedResult({required this.fileCacheInfo});

  ZIMFileCacheQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : fileCacheInfo = ZIMFileCacheInfo.fromMap(map['fileCacheInfo']);

  Map<String, dynamic> toMap() {
    return {'fileCacheInfo': fileCacheInfo.toMap()};
  }
}

/// Clears the callback of the local cache result.
class ZIMFileCacheClearedResult {
  ZIMFileCacheClearedResult();

  ZIMFileCacheClearedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Callback of the result of creating the room.
///
/// - [roomInfo] Room information.
class ZIMRoomCreatedResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomCreatedResult({required this.roomInfo});

  ZIMRoomCreatedResult.fromMap(Map<dynamic, dynamic> map)
    : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// Callback of the result of joining the room.
///
/// - [roomInfo] Room information.
class ZIMRoomJoinedResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomJoinedResult({required this.roomInfo});

  ZIMRoomJoinedResult.fromMap(Map<dynamic, dynamic> map)
    : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// Callback of the result of entering the room.
///
/// - [roomInfo] Room information.
class ZIMRoomEnteredResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomEnteredResult({required this.roomInfo});

  ZIMRoomEnteredResult.fromMap(Map<dynamic, dynamic> map)
    : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// Callback of the result of switched rooms.
///
/// - [roomInfo] Room information.
class ZIMRoomSwitchedResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomSwitchedResult({required this.roomInfo});

  ZIMRoomSwitchedResult.fromMap(Map<dynamic, dynamic> map)
    : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// Callback of the result of leaving the room.
///
/// - [roomID] Room ID.
class ZIMRoomLeftResult {
  /// Room ID.
  String roomID;

  ZIMRoomLeftResult({required this.roomID});

  ZIMRoomLeftResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID};
  }
}

/// Callback for the results of leaving all rooms.
///
/// - [roomIDs] Room ID list.
class ZIMRoomAllLeftResult {
  /// Room ID list.
  List<String> roomIDs;

  ZIMRoomAllLeftResult({required this.roomIDs});

  ZIMRoomAllLeftResult.fromMap(Map<dynamic, dynamic> map)
    : roomIDs =
          ((map['roomIDs']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'roomIDs': roomIDs};
  }
}

/// Callback of the result of querying the room members list.
///
/// - [roomID] Room ID.
/// - [memberList] Room member list.
/// - [nextFlag] Used to query the next page. The current value returns an empty string, which means that the list has been pulled out.
class ZIMRoomMemberQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member list.
  List<ZIMUserInfo> memberList;

  /// Used to query the next page. The current value returns an empty string, which means that the list has been pulled out.
  String nextFlag;

  ZIMRoomMemberQueriedResult({
    required this.roomID,
    required this.memberList,
    required this.nextFlag,
  });

  ZIMRoomMemberQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      memberList =
          ((map['memberList']!) as List)
              .map<ZIMUserInfo>(
                (item) => ZIMDataUtils.parseZIMUserInfoFromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'memberList': memberList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback for the result of querying the specified member of the room.
///
/// - [roomID] Room ID.
/// - [memberList] Room member list.
/// - [errorUserList] Error member list.
class ZIMRoomMembersQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member list.
  List<ZIMRoomMemberInfo> memberList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMRoomMembersQueriedResult({
    required this.roomID,
    required this.memberList,
    required this.errorUserList,
  });

  ZIMRoomMembersQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      memberList =
          ((map['memberList']!) as List)
              .map<ZIMRoomMemberInfo>((item) => ZIMRoomMemberInfo.fromMap(item))
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'memberList': memberList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback of the result of querying the online members count in the room.
///
/// - [roomID] Room ID.
/// - [count] Online member count.
class ZIMRoomOnlineMemberCountQueriedResult {
  /// Room ID.
  String roomID;

  /// Online member count.
  int count;

  ZIMRoomOnlineMemberCountQueriedResult({
    required this.roomID,
    required this.count,
  });

  ZIMRoomOnlineMemberCountQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'count': count};
  }
}

/// The return of the operation result of the room attribute.
///
/// - [roomID] Room ID.
/// - [errorKeys] Error key list.
class ZIMRoomAttributesOperatedResult {
  /// Room ID.
  String roomID;

  /// Error key list.
  List<String> errorKeys;

  ZIMRoomAttributesOperatedResult({
    required this.roomID,
    required this.errorKeys,
  });

  ZIMRoomAttributesOperatedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      errorKeys =
          ((map['errorKeys']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'errorKeys': errorKeys};
  }
}

/// The return of the result of the room attribute combination operation.
///
/// - [roomID] Room ID.
class ZIMRoomAttributesBatchOperatedResult {
  /// Room ID.
  String roomID;

  ZIMRoomAttributesBatchOperatedResult({required this.roomID});

  ZIMRoomAttributesBatchOperatedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID};
  }
}

/// Return of room attribute query results.
///
/// - [roomID] Room ID.
/// - [roomAttributes] Room attributes.
class ZIMRoomAttributesQueriedResult {
  /// Room ID.
  String roomID;

  /// Room attributes.
  Map<String, String> roomAttributes;

  ZIMRoomAttributesQueriedResult({
    required this.roomID,
    required this.roomAttributes,
  });

  ZIMRoomAttributesQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      roomAttributes = ((map['roomAttributes']!) as Map).map<String, String>(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'roomAttributes': roomAttributes};
  }
}

/// Callback of the result of setting room member attributes.
///
/// - [roomID] Room ID.
/// - [infos] Room member attribute operation information list.
/// - [errorUserList] Error member list.
class ZIMRoomMembersAttributesOperatedResult {
  /// Room ID.
  String roomID;

  /// Room member attribute operation information list.
  List<ZIMRoomMemberAttributesOperatedInfo> infos;

  /// Error member list.
  List<String> errorUserList;

  ZIMRoomMembersAttributesOperatedResult({
    required this.roomID,
    required this.infos,
    required this.errorUserList,
  });

  ZIMRoomMembersAttributesOperatedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      infos =
          ((map['infos']!) as List)
              .map<ZIMRoomMemberAttributesOperatedInfo>(
                (item) => ZIMRoomMemberAttributesOperatedInfo.fromMap(item),
              )
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'infos': infos.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList,
    };
  }
}

/// Returns the results of batch query of room user attributes.
///
/// - [roomID] Room ID.
/// - [infos] Room member attribute information list.
class ZIMRoomMembersAttributesQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member attribute information list.
  List<ZIMRoomMemberAttributesInfo> infos;

  ZIMRoomMembersAttributesQueriedResult({
    required this.roomID,
    required this.infos,
  });

  ZIMRoomMembersAttributesQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      infos =
          ((map['infos']!) as List)
              .map<ZIMRoomMemberAttributesInfo>(
                (item) => ZIMRoomMemberAttributesInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'infos': infos.map((item) => item.toMap()).toList(),
    };
  }
}

/// Returns the query result of the user attribute list in the room.
///
/// - [roomID] Room ID.
/// - [infos] Room member attribute information list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMRoomMemberAttributesListQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member attribute information list.
  List<ZIMRoomMemberAttributesInfo> infos;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  String nextFlag;

  ZIMRoomMemberAttributesListQueriedResult({
    required this.roomID,
    required this.infos,
    required this.nextFlag,
  });

  ZIMRoomMemberAttributesListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : roomID = map['roomID']!,
      infos =
          ((map['infos']!) as List)
              .map<ZIMRoomMemberAttributesInfo>(
                (item) => ZIMRoomMemberAttributesInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'infos': infos.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Returns the result of creating a group.
///
/// - [groupInfo] Group information.
/// - [userList] Group member information list.
/// - [errorUserList] Error member list.
class ZIMGroupCreatedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  /// Group member information list.
  List<ZIMGroupMemberInfo> userList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupCreatedResult({
    required this.groupInfo,
    required this.userList,
    required this.errorUserList,
  });

  ZIMGroupCreatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']),
      userList =
          ((map['userList']!) as List)
              .map<ZIMGroupMemberInfo>(
                (item) => ZIMGroupMemberInfo.fromMap(item),
              )
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupInfo': groupInfo.toMap(),
      'userList': userList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Returns the result of dismissing the group.
///
/// - [groupID] Group ID.
class ZIMGroupDismissedResult {
  /// Group ID.
  String groupID;

  ZIMGroupDismissedResult({required this.groupID});

  ZIMGroupDismissedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }
}

/// Returns the result of joining the group.
///
/// - [groupInfo] Group information.
class ZIMGroupJoinedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  ZIMGroupJoinedResult({required this.groupInfo});

  ZIMGroupJoinedResult.fromMap(Map<dynamic, dynamic> map)
    : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']);

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toMap()};
  }
}

/// Return of the result of leaving the group.
///
/// - [groupID] Group ID.
class ZIMGroupLeftResult {
  /// Group ID.
  String groupID;

  ZIMGroupLeftResult({required this.groupID});

  ZIMGroupLeftResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }
}

/// The result of the user being invited to the group is returned.
///
/// - [groupID] Group ID.
/// - [userList] Group member information list.
/// - [errorUserList] Error member list.
class ZIMGroupUsersInvitedResult {
  /// Group ID.
  String groupID;

  /// Group member information list.
  List<ZIMGroupMemberInfo> userList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupUsersInvitedResult({
    required this.groupID,
    required this.userList,
    required this.errorUserList,
  });

  ZIMGroupUsersInvitedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      userList =
          ((map['userList']!) as List)
              .map<ZIMGroupMemberInfo>(
                (item) => ZIMGroupMemberInfo.fromMap(item),
              )
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Returns the result of kicking out a group member.
///
/// - [groupID] Group ID.
/// - [kickedUserIDList] List of user IDs kicked out.
/// - [errorUserList] Error member list.
class ZIMGroupMemberKickedResult {
  /// Group ID.
  String groupID;

  /// List of user IDs kicked out.
  List<String> kickedUserIDList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupMemberKickedResult({
    required this.groupID,
    required this.kickedUserIDList,
    required this.errorUserList,
  });

  ZIMGroupMemberKickedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      kickedUserIDList =
          ((map['kickedUserIDList']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'kickedUserIDList': kickedUserIDList,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Returns the result of the group owner assignment.
///
/// - [groupID] Group ID.
/// - [toUserID] New group owner user ID.
class ZIMGroupOwnerTransferredResult {
  /// Group ID.
  String groupID;

  /// New group owner user ID.
  String toUserID;

  ZIMGroupOwnerTransferredResult({
    required this.groupID,
    required this.toUserID,
  });

  ZIMGroupOwnerTransferredResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      toUserID = map['toUserID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'toUserID': toUserID};
  }
}

/// Returns the result of the group name update.
///
/// - [groupID] Group ID.
/// - [groupName] Group name.
class ZIMGroupNameUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group name.
  String groupName;

  ZIMGroupNameUpdatedResult({required this.groupID, required this.groupName});

  ZIMGroupNameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      groupName = map['groupName']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupName': groupName};
  }
}

/// Returns the result of the group avatar URL update.
///
/// - [groupID] Group ID.
/// - [groupAvatarUrl] Group avatar URL.
class ZIMGroupAvatarUrlUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group avatar URL.
  String groupAvatarUrl;

  ZIMGroupAvatarUrlUpdatedResult({
    required this.groupID,
    required this.groupAvatarUrl,
  });

  ZIMGroupAvatarUrlUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      groupAvatarUrl = map['groupAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupAvatarUrl': groupAvatarUrl};
  }
}

/// The return of the results of the group announcement update.
///
/// - [groupID] Group ID.
/// - [groupNotice] Group notice.
class ZIMGroupNoticeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group notice.
  String groupNotice;

  ZIMGroupNoticeUpdatedResult({
    required this.groupID,
    required this.groupNotice,
  });

  ZIMGroupNoticeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      groupNotice = map['groupNotice']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupNotice': groupNotice};
  }
}

/// Returns the result of the group alias update.
///
/// - [groupID] Group ID.
/// - [groupAlias] Group alias.
class ZIMGroupAliasUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group alias.
  String groupAlias;

  ZIMGroupAliasUpdatedResult({required this.groupID, required this.groupAlias});

  ZIMGroupAliasUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      groupAlias = map['groupAlias']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupAlias': groupAlias};
  }
}

/// Returns the result of querying group information.
///
/// - [groupInfo] Group information.
class ZIMGroupInfoQueriedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  ZIMGroupInfoQueriedResult({required this.groupInfo});

  ZIMGroupInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']);

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toMap()};
  }
}

/// Returns the result of a group attribute operation.
///
/// - [groupID] Group ID.
/// - [errorKeys] Error keys.
class ZIMGroupAttributesOperatedResult {
  /// Group ID.
  String groupID;

  /// Error keys.
  List<String> errorKeys;

  ZIMGroupAttributesOperatedResult({
    required this.groupID,
    required this.errorKeys,
  });

  ZIMGroupAttributesOperatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      errorKeys =
          ((map['errorKeys']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'errorKeys': errorKeys};
  }
}

/// The return of query group attribute results.
///
/// - [groupID] Group ID.
/// - [groupAttributes] Group attributes.
class ZIMGroupAttributesQueriedResult {
  /// Group ID.
  String groupID;

  /// Group attributes.
  Map<String, String> groupAttributes;

  ZIMGroupAttributesQueriedResult({
    required this.groupID,
    required this.groupAttributes,
  });

  ZIMGroupAttributesQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      groupAttributes = ((map['groupAttributes']!) as Map).map<String, String>(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupAttributes': groupAttributes};
  }
}

/// Returns the result of the member role update.
///
/// - [groupID] Group ID.
/// - [forUserID] User ID.
/// - [role] User role.
class ZIMGroupMemberRoleUpdatedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String forUserID;

  /// User role.
  int role;

  ZIMGroupMemberRoleUpdatedResult({
    required this.groupID,
    required this.forUserID,
    required this.role,
  });

  ZIMGroupMemberRoleUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      forUserID = map['forUserID']!,
      role = map['role']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'forUserID': forUserID, 'role': role};
  }
}

/// Returns the result of the group member's nickname update.
///
/// - [groupID] Group ID.
/// - [forUserID] User ID.
/// - [nickname] User nickname.
class ZIMGroupMemberNicknameUpdatedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String forUserID;

  /// User nickname.
  String nickname;

  ZIMGroupMemberNicknameUpdatedResult({
    required this.groupID,
    required this.forUserID,
    required this.nickname,
  });

  ZIMGroupMemberNicknameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      forUserID = map['forUserID']!,
      nickname = map['nickname']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'forUserID': forUserID, 'nickname': nickname};
  }
}

/// Returns the result of the group member query.
///
/// - [groupID] Group ID.
/// - [userInfo] Group member user information.
class ZIMGroupMemberInfoQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member user information.
  ZIMGroupMemberInfo userInfo;

  ZIMGroupMemberInfoQueriedResult({
    required this.groupID,
    required this.userInfo,
  });

  ZIMGroupMemberInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      userInfo = ZIMGroupMemberInfo.fromMap(map['userInfo']);

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'userInfo': userInfo.toMap()};
  }
}

/// Returns the results of the query group list.
///
/// - [groupList] Group list.
/// - [nextFlag] The pagination anchor returned by the SDK is 0 if it means the list has been completely queried, and non-0 if it means there is still data to be queried.
class ZIMGroupListQueriedResult {
  /// Group list.
  List<ZIMGroup> groupList;

  /// The pagination anchor returned by the SDK is 0 if it means the list has been completely queried, and non-0 if it means there is still data to be queried.
  int nextFlag;

  ZIMGroupListQueriedResult({required this.groupList, required this.nextFlag});

  ZIMGroupListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : groupList =
          ((map['groupList']!) as List)
              .map<ZIMGroup>((item) => ZIMGroup.fromMap(item))
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupList': groupList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Returns the result of querying the group member list.
///
/// - [groupID] Group ID.
/// - [userList] Group member list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupMemberListQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupMemberListQueriedResult({
    required this.groupID,
    required this.userList,
    required this.nextFlag,
  });

  ZIMGroupMemberListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      userList =
          ((map['userList']!) as List)
              .map<ZIMGroupMemberInfo>(
                (item) => ZIMGroupMemberInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Returns the result of querying the group member count.
///
/// - [groupID] Group ID.
/// - [count] Group member count.
class ZIMGroupMemberCountQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member count.
  int count;

  ZIMGroupMemberCountQueriedResult({
    required this.groupID,
    required this.count,
  });

  ZIMGroupMemberCountQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'count': count};
  }
}

/// Callback interface for querying the specific read/unread member list of group receipt messages.
///
/// - [groupID] Group ID.
/// - [userList] Group member list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupMessageReceiptMemberListQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupMessageReceiptMemberListQueriedResult({
    required this.groupID,
    required this.userList,
    required this.nextFlag,
  });

  ZIMGroupMessageReceiptMemberListQueriedResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : groupID = map['groupID']!,
      userList =
          ((map['userList']!) as List)
              .map<ZIMGroupMemberInfo>(
                (item) => ZIMGroupMemberInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Returns the result of the group mute info update.
///
/// - [groupID] Group ID.
/// - [isMute] Whether to mute.
/// - [mutedInfo] Group mute information.
class ZIMGroupMutedResult {
  /// Group ID.
  String groupID;

  /// Whether to mute.
  bool isMute;

  /// Group mute information.
  ZIMGroupMuteInfo mutedInfo;

  ZIMGroupMutedResult({
    required this.groupID,
    required this.isMute,
    required this.mutedInfo,
  });

  ZIMGroupMutedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      isMute = map['isMute']!,
      mutedInfo = ZIMGroupMuteInfo.fromMap(map['mutedInfo']);

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'isMute': isMute,
      'mutedInfo': mutedInfo.toMap(),
    };
  }
}

/// Returns the result of the group members mute info update.
///
/// - [groupID] Group ID.
/// - [isMute] Whether to mute.
/// - [duration] Mute duration.
/// - [mutedUserIDs] List of muted member userIDs.
/// - [errorUserList] List of user information that failed to be muted.
class ZIMGroupMembersMutedResult {
  /// Group ID.
  String groupID;

  /// Whether to mute.
  bool isMute;

  /// Mute duration.
  int duration;

  /// List of muted member userIDs.
  List<String> mutedMemberIDs;

  /// List of user information that failed to be muted.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupMembersMutedResult({
    required this.groupID,
    required this.isMute,
    required this.duration,
    required this.mutedMemberIDs,
    required this.errorUserList,
  });

  ZIMGroupMembersMutedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      isMute = map['isMute']!,
      duration = map['duration']!,
      mutedMemberIDs =
          ((map['mutedMemberIDs']!) as List)
              .map<String>((item) => item as String)
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'isMute': isMute,
      'duration': duration,
      'mutedMemberIDs': mutedMemberIDs,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Returns the result of querying the group muted member list.
///
/// - [groupID] Group ID.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
/// - [userList] Group member list.
class ZIMGroupMemberMutedListQueriedResult {
  /// Group ID.
  String groupID;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  ZIMGroupMemberMutedListQueriedResult({
    required this.groupID,
    required this.nextFlag,
    required this.userList,
  });

  ZIMGroupMemberMutedListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      nextFlag = map['nextFlag']!,
      userList =
          ((map['userList']!) as List)
              .map<ZIMGroupMemberInfo>(
                (item) => ZIMGroupMemberInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'nextFlag': nextFlag,
      'userList': userList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Returns the result of search a group.
///
/// - [groupSearchInfoList] Group search information list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupsSearchedResult {
  /// Group search information list.
  List<ZIMGroupSearchInfo> groupSearchInfoList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupsSearchedResult({
    required this.groupSearchInfoList,
    required this.nextFlag,
  });

  ZIMGroupsSearchedResult.fromMap(Map<dynamic, dynamic> map)
    : groupSearchInfoList =
          ((map['groupSearchInfoList']!) as List)
              .map<ZIMGroupSearchInfo>(
                (item) => ZIMGroupSearchInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupSearchInfoList':
          groupSearchInfoList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Returns the result of search a group members.
///
/// - [groupID] Group ID.
/// - [userList] Group member list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupMembersSearchedResult {
  /// Group ID.
  String groupID;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupMembersSearchedResult({
    required this.groupID,
    required this.userList,
    required this.nextFlag,
  });

  ZIMGroupMembersSearchedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      userList =
          ((map['userList']!) as List)
              .map<ZIMGroupMemberInfo>(
                (item) => ZIMGroupMemberInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// The return of the results of the group verification mode update.
///
/// - [groupID] Group ID.
/// - [mode] Group join mode.
class ZIMGroupJoinModeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group join mode.
  ZIMGroupJoinMode mode;

  ZIMGroupJoinModeUpdatedResult({required this.groupID, required this.mode});

  ZIMGroupJoinModeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      mode =
          ZIMGroupJoinModeExtension.mapValue[map['mode']] ??
          ZIMGroupJoinMode.any;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'mode': mode.value};
  }
}

/// The return of the results of the group verification mode update.
///
/// - [groupID] Group ID.
/// - [mode] Group invite mode.
class ZIMGroupInviteModeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group invite mode.
  ZIMGroupInviteMode mode;

  ZIMGroupInviteModeUpdatedResult({required this.groupID, required this.mode});

  ZIMGroupInviteModeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      mode =
          ZIMGroupInviteModeExtension.mapValue[map['mode']] ??
          ZIMGroupInviteMode.any;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'mode': mode.value};
  }
}

/// The return of the results of the group verification mode update.
///
/// - [groupID] Group ID.
/// - [mode] Group be invite mode.
class ZIMGroupBeInviteModeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group be invite mode.
  ZIMGroupBeInviteMode mode;

  ZIMGroupBeInviteModeUpdatedResult({
    required this.groupID,
    required this.mode,
  });

  ZIMGroupBeInviteModeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      mode =
          ZIMGroupBeInviteModeExtension.mapValue[map['mode']] ??
          ZIMGroupBeInviteMode.none;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'mode': mode.value};
  }
}

/// The return of the results of the group join application sent.
///
/// - [groupID] Group ID.
class ZIMGroupJoinApplicationSentResult {
  /// Group ID.
  String groupID;

  ZIMGroupJoinApplicationSentResult({required this.groupID});

  ZIMGroupJoinApplicationSentResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }
}

/// The return of the results of the group join application accept.
///
/// - [groupID] Group ID.
/// - [userID] User ID.
class ZIMGroupJoinApplicationAcceptedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String userID;

  ZIMGroupJoinApplicationAcceptedResult({
    required this.groupID,
    required this.userID,
  });

  ZIMGroupJoinApplicationAcceptedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'userID': userID};
  }
}

/// The return of the results of the group join application reject.
///
/// - [groupID] Group ID.
/// - [userID] User ID.
class ZIMGroupJoinApplicationRejectedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String userID;

  ZIMGroupJoinApplicationRejectedResult({
    required this.groupID,
    required this.userID,
  });

  ZIMGroupJoinApplicationRejectedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'userID': userID};
  }
}

/// The return of the results of the group invite application sent.
///
/// - [groupID] Group ID.
/// - [errorUserList] Invite failed user information list.
class ZIMGroupInviteApplicationsSentResult {
  /// Group ID.
  String groupID;

  /// Invite failed user information list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupInviteApplicationsSentResult({
    required this.groupID,
    required this.errorUserList,
  });

  ZIMGroupInviteApplicationsSentResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// The return of the results of the group invite application accept.
///
/// - [groupInfo] Group information.
/// - [inviterUserID] Inviter user ID.
class ZIMGroupInviteApplicationAcceptedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  /// Inviter user ID.
  String inviterUserID;

  ZIMGroupInviteApplicationAcceptedResult({
    required this.groupInfo,
    required this.inviterUserID,
  });

  ZIMGroupInviteApplicationAcceptedResult.fromMap(Map<dynamic, dynamic> map)
    : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']),
      inviterUserID = map['inviterUserID']!;

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toMap(), 'inviterUserID': inviterUserID};
  }
}

/// The return of the results of the group invite application accept.
///
/// - [groupID] Group information.
/// - [inviterUserID] Inviter user ID.
class ZIMGroupInviteApplicationRejectedResult {
  /// Group information.
  String groupID;

  /// Inviter user ID.
  String inviterUserID;

  ZIMGroupInviteApplicationRejectedResult({
    required this.groupID,
    required this.inviterUserID,
  });

  ZIMGroupInviteApplicationRejectedResult.fromMap(Map<dynamic, dynamic> map)
    : groupID = map['groupID']!,
      inviterUserID = map['inviterUserID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'inviterUserID': inviterUserID};
  }
}

/// Query the callback of group application list.
///
/// - [applicationList] Group application information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMGroupApplicationListQueriedResult {
  /// Group application information list.
  List<ZIMGroupApplicationInfo> applicationList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMGroupApplicationListQueriedResult({
    required this.applicationList,
    required this.nextFlag,
  });

  ZIMGroupApplicationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : applicationList =
          ((map['applicationList']!) as List)
              .map<ZIMGroupApplicationInfo>(
                (item) => ZIMGroupApplicationInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'applicationList': applicationList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Action callback for sending a call invitation.
///
/// - [callID] Call ID.
/// - [info] Call invitation information.
class ZIMCallInvitationSentResult {
  /// Call ID.
  String callID;

  /// Call invitation information.
  ZIMCallInvitationSentInfo info;

  ZIMCallInvitationSentResult({required this.callID, required this.info});

  ZIMCallInvitationSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!,
      info = ZIMCallInvitationSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// Callback result of inviting the current call.
///
/// - [callID] Call ID.
/// - [info] Calling invitation information.
class ZIMCallingInvitationSentResult {
  /// Call ID.
  String callID;

  /// Calling invitation information.
  ZIMCallingInvitationSentInfo info;

  ZIMCallingInvitationSentResult({required this.callID, required this.info});

  ZIMCallingInvitationSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!,
      info = ZIMCallingInvitationSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// Callback for the action to cancel the call invitation.
///
/// - [callID] Call ID.
/// - [errorInvitees] Call invitation failed user ID list.
class ZIMCallCancelSentResult {
  /// Call ID.
  String callID;

  /// Call invitation failed user ID list.
  List<String> errorInvitees;

  ZIMCallCancelSentResult({required this.callID, required this.errorInvitees});

  ZIMCallCancelSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!,
      errorInvitees =
          ((map['errorInvitees']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'errorInvitees': errorInvitees};
  }
}

/// Action callback for accepting call invitations.
///
/// - [callID] Call ID.
class ZIMCallAcceptanceSentResult {
  /// Call ID.
  String callID;

  ZIMCallAcceptanceSentResult({required this.callID});

  ZIMCallAcceptanceSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!;

  Map<String, dynamic> toMap() {
    return {'callID': callID};
  }
}

/// Action callback for rejecting a call invitation.
///
/// - [callID] Call ID.
class ZIMCallRejectionSentResult {
  /// Call ID.
  String callID;

  ZIMCallRejectionSentResult({required this.callID});

  ZIMCallRejectionSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!;

  Map<String, dynamic> toMap() {
    return {'callID': callID};
  }
}

/// Result callback of joining the call invitation.
///
/// - [callID] Call ID.
/// - [info] Call join information.
class ZIMCallJoinSentResult {
  /// Call ID.
  String callID;

  /// Call join information.
  ZIMCallJoinSentInfo info;

  ZIMCallJoinSentResult({required this.callID, required this.info});

  ZIMCallJoinSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!,
      info = ZIMCallJoinSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// Quit the callback closure of the call invitation operation.
///
/// - [callID] Call ID.
/// - [info] Call quit information.
class ZIMCallQuitSentResult {
  /// Call ID.
  String callID;

  /// Call quit information.
  ZIMCallQuitSentInfo info;

  ZIMCallQuitSentResult({required this.callID, required this.info});

  ZIMCallQuitSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!,
      info = ZIMCallQuitSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// Result callback of ending the call invitation.
///
/// - [callID] Call ID.
/// - [info] Call end information.
class ZIMCallEndSentResult {
  /// Call ID.
  String callID;

  /// Call end information.
  ZIMCallEndedSentInfo info;

  ZIMCallEndSentResult({required this.callID, required this.info});

  ZIMCallEndSentResult.fromMap(Map<dynamic, dynamic> map)
    : callID = map['callID']!,
      info = ZIMCallEndedSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// Result Callback of querying the call list.
///
/// - [callList] Call information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMCallInvitationListQueriedResult {
  /// Call information list.
  List<ZIMCallInfo> callList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMCallInvitationListQueriedResult({
    required this.callList,
    required this.nextFlag,
  });

  ZIMCallInvitationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : callList =
          ((map['callList']!) as List)
              .map<ZIMCallInfo>((item) => ZIMCallInfo.fromMap(item))
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'callList': callList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Add a friend result callback.
///
/// - [friendInfo] Friend information.
class ZIMFriendAddedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendAddedResult({required this.friendInfo});

  ZIMFriendAddedResult.fromMap(Map<dynamic, dynamic> map)
    : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// Return results of deleting friends.
///
/// - [errorUserList] Friend information.
class ZIMFriendsDeletedResult {
  /// Friend information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMFriendsDeletedResult({required this.errorUserList});

  ZIMFriendsDeletedResult.fromMap(Map<dynamic, dynamic> map)
    : errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// The returned result of querying the friends list.
///
/// - [friendList] Friend information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMFriendListQueriedResult {
  /// Friend information list.
  List<ZIMFriendInfo> friendList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMFriendListQueriedResult({
    required this.friendList,
    required this.nextFlag,
  });

  ZIMFriendListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : friendList =
          ((map['friendList']!) as List)
              .map<ZIMFriendInfo>((item) => ZIMFriendInfo.fromMap(item))
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'friendList': friendList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Return results of querying friend information in batches.
///
/// - [friendInfos] Friend information list.
/// - [errorUserList] Friend information.
class ZIMFriendsInfoQueriedResult {
  /// Friend information list.
  List<ZIMFriendInfo> friendInfos;

  /// Friend information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMFriendsInfoQueriedResult({
    required this.friendInfos,
    required this.errorUserList,
  });

  ZIMFriendsInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : friendInfos =
          ((map['friendInfos']!) as List)
              .map<ZIMFriendInfo>((item) => ZIMFriendInfo.fromMap(item))
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'friendInfos': friendInfos.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Check the friend relationship result.
///
/// - [relationInfos] Friend relationship information list.
/// - [errorUserList] Friend information.
class ZIMFriendsRelationCheckedResult {
  /// Friend relationship information list.
  List<ZIMFriendRelationInfo> relationInfos;

  /// Friend information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMFriendsRelationCheckedResult({
    required this.relationInfos,
    required this.errorUserList,
  });

  ZIMFriendsRelationCheckedResult.fromMap(Map<dynamic, dynamic> map)
    : relationInfos =
          ((map['relationInfos']!) as List)
              .map<ZIMFriendRelationInfo>(
                (item) => ZIMFriendRelationInfo.fromMap(item),
              )
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'relationInfos': relationInfos.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// The result of sending a friend application.
///
/// - [applicationInfo] Friend application information.
class ZIMFriendApplicationSentResult {
  /// Friend application information.
  ZIMFriendApplicationInfo applicationInfo;

  ZIMFriendApplicationSentResult({required this.applicationInfo});

  ZIMFriendApplicationSentResult.fromMap(Map<dynamic, dynamic> map)
    : applicationInfo = ZIMFriendApplicationInfo.fromMap(
        map['applicationInfo'],
      );

  Map<String, dynamic> toMap() {
    return {'applicationInfo': applicationInfo.toMap()};
  }
}

/// Accept the returned result of friend application.
///
/// - [friendInfo] Friend information.
class ZIMFriendApplicationAcceptedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendApplicationAcceptedResult({required this.friendInfo});

  ZIMFriendApplicationAcceptedResult.fromMap(Map<dynamic, dynamic> map)
    : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// Accept the returned result of friend application.
///
/// - [userInfo] User information.
class ZIMFriendApplicationRejectedResult {
  /// User information.
  ZIMUserInfo userInfo;

  ZIMFriendApplicationRejectedResult({required this.userInfo});

  ZIMFriendApplicationRejectedResult.fromMap(Map<dynamic, dynamic> map)
    : userInfo = ZIMDataUtils.parseZIMUserInfoFromMap(map['userInfo']);

  Map<String, dynamic> toMap() {
    return {'userInfo': userInfo.toMap()};
  }
}

/// The result of sending a friend application.
///
/// - [applicationList] Friend application information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMFriendApplicationListQueriedResult {
  /// Friend application information list.
  List<ZIMFriendApplicationInfo> applicationList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMFriendApplicationListQueriedResult({
    required this.applicationList,
    required this.nextFlag,
  });

  ZIMFriendApplicationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : applicationList =
          ((map['applicationList']!) as List)
              .map<ZIMFriendApplicationInfo>(
                (item) => ZIMFriendApplicationInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'applicationList': applicationList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Return results of updating friend alias.
///
/// - [friendInfo] Friend information.
class ZIMFriendAliasUpdatedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendAliasUpdatedResult({required this.friendInfo});

  ZIMFriendAliasUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// Return results of updating friend attributes.
///
/// - [friendInfo] Friend information.
class ZIMFriendAttributesUpdatedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendAttributesUpdatedResult({required this.friendInfo});

  ZIMFriendAttributesUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// Search results returned by local friends.
///
/// - [friendInfos] Friend information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMFriendsSearchedResult {
  /// Friend information list.
  List<ZIMFriendInfo> friendInfos;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMFriendsSearchedResult({required this.friendInfos, required this.nextFlag});

  ZIMFriendsSearchedResult.fromMap(Map<dynamic, dynamic> map)
    : friendInfos =
          ((map['friendInfos']!) as List)
              .map<ZIMFriendInfo>((item) => ZIMFriendInfo.fromMap(item))
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'friendInfos': friendInfos.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback for operation results of adding users to the blacklist.
///
/// - [errorUserList] User information.
class ZIMBlacklistUsersAddedResult {
  /// User information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMBlacklistUsersAddedResult({required this.errorUserList});

  ZIMBlacklistUsersAddedResult.fromMap(Map<dynamic, dynamic> map)
    : errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// The callback result of the operation to remove the user from the blacklist.
///
/// - [errorUserList] User information.
class ZIMBlacklistUsersRemovedResult {
  /// User information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMBlacklistUsersRemovedResult({required this.errorUserList});

  ZIMBlacklistUsersRemovedResult.fromMap(Map<dynamic, dynamic> map)
    : errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Query the blacklist result callback.
///
/// - [blacklist] Blacklist user information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMBlacklistQueriedResult {
  /// Blacklist user information list.
  List<ZIMUserInfo> blacklist;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMBlacklistQueriedResult({required this.blacklist, required this.nextFlag});

  ZIMBlacklistQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : blacklist =
          ((map['blacklist']!) as List)
              .map<ZIMUserInfo>(
                (item) => ZIMDataUtils.parseZIMUserInfoFromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'blacklist': blacklist.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Blacklist check result callback.
///
/// - [isUserInBlacklist] Whether in blacklist.
class ZIMBlacklistCheckedResult {
  /// Whether in blacklist.
  bool isUserInBlacklist;

  ZIMBlacklistCheckedResult({required this.isUserInBlacklist});

  ZIMBlacklistCheckedResult.fromMap(Map<dynamic, dynamic> map)
    : isUserInBlacklist = map['isUserInBlacklist']!;

  Map<String, dynamic> toMap() {
    return {'isUserInBlacklist': isUserInBlacklist};
  }
}

/// Callback of the result of creating a community.
///
/// - [communityInfo] Community information.
class ZIMCommunityCreatedResult {
  /// Community information.
  ZIMCommunityFullInfo communityInfo;

  ZIMCommunityCreatedResult({required this.communityInfo});

  ZIMCommunityCreatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityInfo = ZIMCommunityFullInfo.fromMap(map['communityInfo']);

  Map<String, dynamic> toMap() {
    return {'communityInfo': communityInfo.toMap()};
  }
}

/// Callback of the result of dismissing a community.
///
/// - [communityID] Community ID.
class ZIMCommunityDismissedResult {
  /// Community ID.
  String communityID;

  ZIMCommunityDismissedResult({required this.communityID});

  ZIMCommunityDismissedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID};
  }
}

/// Callback of the result of joining a community.
///
/// - [communityInfo] Community information.
class ZIMCommunityJoinedResult {
  /// Community information.
  ZIMCommunityFullInfo communityInfo;

  ZIMCommunityJoinedResult({required this.communityInfo});

  ZIMCommunityJoinedResult.fromMap(Map<dynamic, dynamic> map)
    : communityInfo = ZIMCommunityFullInfo.fromMap(map['communityInfo']);

  Map<String, dynamic> toMap() {
    return {'communityInfo': communityInfo.toMap()};
  }
}

/// Callback of the result of leaving a community.
///
/// - [communityID] Community ID.
class ZIMCommunityLeftResult {
  /// Community ID.
  String communityID;

  ZIMCommunityLeftResult({required this.communityID});

  ZIMCommunityLeftResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID};
  }
}

/// Callback of the result of joining a community as a visitor.
///
/// - [communityInfo] Community information.
class ZIMCommunityAsVisitorEnteredResult {
  /// Community information.
  ZIMCommunityFullInfo communityInfo;

  ZIMCommunityAsVisitorEnteredResult({required this.communityInfo});

  ZIMCommunityAsVisitorEnteredResult.fromMap(Map<dynamic, dynamic> map)
    : communityInfo = ZIMCommunityFullInfo.fromMap(map['communityInfo']);

  Map<String, dynamic> toMap() {
    return {'communityInfo': communityInfo.toMap()};
  }
}

/// Callback of the result of leaving a community as a visitor.
///
/// - [communityID] Community ID.
class ZIMCommunityAsVisitorQuitResult {
  /// Community ID.
  String communityID;

  ZIMCommunityAsVisitorQuitResult({required this.communityID});

  ZIMCommunityAsVisitorQuitResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID};
  }
}

/// Callback of updating the message fetch count for community visitors.
///
/// - [communityID] Community ID.
class ZIMCommunityVisitorFetchMessageCountUpdatedResult {
  /// Community ID.
  String communityID;

  ZIMCommunityVisitorFetchMessageCountUpdatedResult({
    required this.communityID,
  });

  ZIMCommunityVisitorFetchMessageCountUpdatedResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID};
  }
}

/// Callback of updating the message fetch time duration for community visitors.
///
/// - [communityID] Community ID.
class ZIMCommunityVisitorFetchMessageDurationUpdatedResult {
  /// Community ID.
  String communityID;

  ZIMCommunityVisitorFetchMessageDurationUpdatedResult({
    required this.communityID,
  });

  ZIMCommunityVisitorFetchMessageDurationUpdatedResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID};
  }
}

/// Callback of the result of querying the community list.
///
/// - [communityList] Community list.
/// - [nextFlag] Next query community list flag.
class ZIMCommunityListQueriedResult {
  /// Community list.
  List<ZIMCommunity> communityList;

  /// Next query community list flag.
  int nextFlag;

  ZIMCommunityListQueriedResult({
    required this.communityList,
    required this.nextFlag,
  });

  ZIMCommunityListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : communityList =
          ((map['communityList']!) as List)
              .map<ZIMCommunity>((item) => ZIMCommunity.fromMap(item))
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'communityList': communityList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback of the result of updating the community name.
///
/// - [communityID] Community ID.
/// - [communityName] Community name.
class ZIMCommunityNameUpdatedResult {
  /// Community ID.
  String communityID;

  /// Community name.
  String communityName;

  ZIMCommunityNameUpdatedResult({
    required this.communityID,
    required this.communityName,
  });

  ZIMCommunityNameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      communityName = map['communityName']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'communityName': communityName};
  }
}

/// Callback of the result of updating the community avatar URL.
///
/// - [communityID] Community ID.
/// - [communityAvatarUrl] Community avatar URL.
class ZIMCommunityAvatarUrlUpdatedResult {
  /// Community ID.
  String communityID;

  /// Community avatar URL.
  String communityAvatarUrl;

  ZIMCommunityAvatarUrlUpdatedResult({
    required this.communityID,
    required this.communityAvatarUrl,
  });

  ZIMCommunityAvatarUrlUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      communityAvatarUrl = map['communityAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'communityAvatarUrl': communityAvatarUrl,
    };
  }
}

/// Callback of the result of updating the community notice.
///
/// - [communityID] Community ID.
/// - [communityNotice] Community notice.
class ZIMCommunityNoticeUpdatedResult {
  /// Community ID.
  String communityID;

  /// Community notice.
  String communityNotice;

  ZIMCommunityNoticeUpdatedResult({
    required this.communityID,
    required this.communityNotice,
  });

  ZIMCommunityNoticeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      communityNotice = map['communityNotice']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'communityNotice': communityNotice};
  }
}

/// Callback of the result of updating the community join mode.
///
/// - [communityID] Community ID.
/// - [joinMode] The updated community join mode.
class ZIMCommunityJoinModeUpdatedResult {
  /// Community ID.
  String communityID;

  /// The updated community join mode.
  ZIMCommunityJoinMode joinMode;

  ZIMCommunityJoinModeUpdatedResult({
    required this.communityID,
    required this.joinMode,
  });

  ZIMCommunityJoinModeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      joinMode =
          ZIMCommunityJoinModeExtension.mapValue[map['joinMode']] ??
          ZIMCommunityJoinMode.any;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'joinMode': joinMode.value};
  }
}

/// The return of the results of the community join application sent.
///
/// - [communityID] Community ID.
class ZIMCommunityJoinApplicationSentResult {
  /// Community ID.
  String communityID;

  ZIMCommunityJoinApplicationSentResult({required this.communityID});

  ZIMCommunityJoinApplicationSentResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID};
  }
}

/// The return of the results of the community join application canceled.
class ZIMCommunityJoinApplicationCancelledResult {
  ZIMCommunityJoinApplicationCancelledResult();

  ZIMCommunityJoinApplicationCancelledResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// The return of the results of the community join application accepted.
///
/// - [communityID] Community ID.
/// - [userID] The ID of the user who submitted the application.
class ZIMCommunityJoinApplicationAcceptedResult {
  /// Community ID.
  String communityID;

  /// The ID of the user who submitted the application.
  String userID;

  ZIMCommunityJoinApplicationAcceptedResult({
    required this.communityID,
    required this.userID,
  });

  ZIMCommunityJoinApplicationAcceptedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'userID': userID};
  }
}

/// The return of the results of the community join application rejected.
///
/// - [communityID] Community ID.
/// - [userID] The ID of the user who submitted the application.
class ZIMCommunityJoinApplicationRejectedResult {
  /// Community ID.
  String communityID;

  /// The ID of the user who submitted the application.
  String userID;

  ZIMCommunityJoinApplicationRejectedResult({
    required this.communityID,
    required this.userID,
  });

  ZIMCommunityJoinApplicationRejectedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'userID': userID};
  }
}

/// Callback for the result of querying the community application list.
///
/// - [applicationList] Community application list.
/// - [nextFlag] The pagination flag for querying the next page, which uses the applyID as the anchor (the applyID of the last application in the current page). 0 means no more data; otherwise pass it to the config's nextFlag to query the next page.
class ZIMCommunityApplicationListQueriedResult {
  /// Community application list.
  List<ZIMCommunityApplicationInfo> applicationList;

  /// The pagination flag for querying the next page, which uses the applyID as the anchor (the applyID of the last application in the current page). 0 means no more data; otherwise pass it to the config's nextFlag to query the next page.
  int nextFlag;

  ZIMCommunityApplicationListQueriedResult({
    required this.applicationList,
    required this.nextFlag,
  });

  ZIMCommunityApplicationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : applicationList =
          ((map['applicationList']!) as List)
              .map<ZIMCommunityApplicationInfo>(
                (item) => ZIMCommunityApplicationInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'applicationList': applicationList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback for the result of querying the self community application list.
///
/// - [applicationList] Community application list.
/// - [nextFlag] The pagination flag for querying the next page, which uses the applyID as the anchor (the applyID of the last application in the current page). 0 means no more data; otherwise pass it to the config's nextFlag to query the next page.
class ZIMCommunitySelfApplicationListQueriedResult {
  /// Community application list.
  List<ZIMCommunityApplicationInfo> applicationList;

  /// The pagination flag for querying the next page, which uses the applyID as the anchor (the applyID of the last application in the current page). 0 means no more data; otherwise pass it to the config's nextFlag to query the next page.
  int nextFlag;

  ZIMCommunitySelfApplicationListQueriedResult({
    required this.applicationList,
    required this.nextFlag,
  });

  ZIMCommunitySelfApplicationListQueriedResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : applicationList =
          ((map['applicationList']!) as List)
              .map<ZIMCommunityApplicationInfo>(
                (item) => ZIMCommunityApplicationInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'applicationList': applicationList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback of the result of operating community attributes.
///
/// - [communityID] Community ID.
/// - [errorKeys] Error keys.
class ZIMCommunityAttributesOperatedResult {
  /// Community ID.
  String communityID;

  /// Error keys.
  List<String> errorKeys;

  ZIMCommunityAttributesOperatedResult({
    required this.communityID,
    required this.errorKeys,
  });

  ZIMCommunityAttributesOperatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      errorKeys =
          ((map['errorKeys']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'errorKeys': errorKeys};
  }
}

/// Callback of the result of setting the community notification status.
///
/// - [communityID] Community ID.
class ZIMCommunityNotificationStatusSetResult {
  /// Community ID.
  String communityID;

  ZIMCommunityNotificationStatusSetResult({required this.communityID});

  ZIMCommunityNotificationStatusSetResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID};
  }
}

/// Callback of the result of querying community information.
///
/// - [communityInfo] Community information.
class ZIMCommunityInfoQueriedResult {
  /// Community information.
  ZIMCommunityFullInfo communityInfo;

  ZIMCommunityInfoQueriedResult({required this.communityInfo});

  ZIMCommunityInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : communityInfo = ZIMCommunityFullInfo.fromMap(map['communityInfo']);

  Map<String, dynamic> toMap() {
    return {'communityInfo': communityInfo.toMap()};
  }
}

/// Callback of the result of inviting users into the community.
///
/// - [communityID] Community ID.
/// - [errorUserList] The error userID list
class ZIMCommunityUsersInvitedResult {
  /// Community ID.
  String communityID;

  /// The error userID list
  List<ZIMErrorUserInfo> errorUserList;

  ZIMCommunityUsersInvitedResult({
    required this.communityID,
    required this.errorUserList,
  });

  ZIMCommunityUsersInvitedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback of the result of kicking members from the community.
///
/// - [communityID] Community ID.
/// - [errorUserList] The error userID list
class ZIMCommunityMembersKickedResult {
  /// Community ID.
  String communityID;

  /// The error userID list
  List<ZIMErrorUserInfo> errorUserList;

  ZIMCommunityMembersKickedResult({
    required this.communityID,
    required this.errorUserList,
  });

  ZIMCommunityMembersKickedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback of the result of updating a community member's role.
///
/// - [communityID] Community ID.
/// - [forUserID] The user ID of the target user.
/// - [memberRole] member role value
class ZIMCommunityMemberRoleUpdatedResult {
  /// Community ID.
  String communityID;

  /// The user ID of the target user.
  String forUserID;

  /// member role value
  int memberRole;

  ZIMCommunityMemberRoleUpdatedResult({
    required this.communityID,
    required this.forUserID,
    required this.memberRole,
  });

  ZIMCommunityMemberRoleUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      forUserID = map['forUserID']!,
      memberRole = map['memberRole']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'forUserID': forUserID,
      'memberRole': memberRole,
    };
  }
}

/// Callback of the result of transferring the community owner.
///
/// - [communityID] Community ID.
/// - [toUserID] The user ID of the new community owner.
class ZIMCommunityOwnerTransferredResult {
  /// Community ID.
  String communityID;

  /// The user ID of the new community owner.
  String toUserID;

  ZIMCommunityOwnerTransferredResult({
    required this.communityID,
    required this.toUserID,
  });

  ZIMCommunityOwnerTransferredResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      toUserID = map['toUserID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'toUserID': toUserID};
  }
}

/// Callback of the result of querying the community member list.
///
/// - [communityID] Community ID.
/// - [memberList] Community member list.
/// - [nextFlag] Anchor for the next community member list query.
class ZIMCommunityMemberListQueriedResult {
  /// Community ID.
  String communityID;

  /// Community member list.
  List<ZIMCommunityMemberInfo> memberList;

  /// Anchor for the next community member list query.
  int nextFlag;

  ZIMCommunityMemberListQueriedResult({
    required this.communityID,
    required this.memberList,
    required this.nextFlag,
  });

  ZIMCommunityMemberListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      memberList =
          ((map['memberList']!) as List)
              .map<ZIMCommunityMemberInfo>(
                (item) => ZIMCommunityMemberInfo.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'memberList': memberList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback of the result of querying specific community members.
///
/// - [communityID] Community ID.
/// - [memberList] List of queried community members.
/// - [errorUserList] List of users that failed to be queried.
class ZIMCommunityMembersQueriedResult {
  /// Community ID.
  String communityID;

  /// List of queried community members.
  List<ZIMCommunityMemberInfo> memberList;

  /// List of users that failed to be queried.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMCommunityMembersQueriedResult({
    required this.communityID,
    required this.memberList,
    required this.errorUserList,
  });

  ZIMCommunityMembersQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      memberList =
          ((map['memberList']!) as List)
              .map<ZIMCommunityMemberInfo>(
                (item) => ZIMCommunityMemberInfo.fromMap(item),
              )
              .toList(),
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'memberList': memberList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback of the result of creating a community channel.
///
/// - [channelInfo] Community channel information.
class ZIMCommunityChannelCreatedResult {
  /// Community channel information.
  ZIMCommunityChannelFullInfo channelInfo;

  ZIMCommunityChannelCreatedResult({required this.channelInfo});

  ZIMCommunityChannelCreatedResult.fromMap(Map<dynamic, dynamic> map)
    : channelInfo = ZIMCommunityChannelFullInfo.fromMap(map['channelInfo']);

  Map<String, dynamic> toMap() {
    return {'channelInfo': channelInfo.toMap()};
  }
}

/// Callback of the result of dismissing a community channel.
///
/// - [communityID] Community ID.
/// - [channelID] Community channel ID
class ZIMCommunityChannelDismissedResult {
  /// Community ID.
  String communityID;

  /// Community channel ID
  String channelID;

  ZIMCommunityChannelDismissedResult({
    required this.communityID,
    required this.channelID,
  });

  ZIMCommunityChannelDismissedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelID = map['channelID']!;

  Map<String, dynamic> toMap() {
    return {'communityID': communityID, 'channelID': channelID};
  }
}

/// Callback of the result of updating the community channel name.
///
/// - [communityID] Community ID.
/// - [channelID] Community channel ID
/// - [channelName] Community channel name.
class ZIMCommunityChannelNameUpdatedResult {
  /// Community ID.
  String communityID;

  /// Community channel ID
  String channelID;

  /// Community channel name.
  String channelName;

  ZIMCommunityChannelNameUpdatedResult({
    required this.communityID,
    required this.channelID,
    required this.channelName,
  });

  ZIMCommunityChannelNameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelID = map['channelID']!,
      channelName = map['channelName']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'channelID': channelID,
      'channelName': channelName,
    };
  }
}

/// Callback of the result of updating the community channel avatar URL.
///
/// - [communityID] Community ID.
/// - [channelID] Community channel ID
/// - [channelAvatarUrl] Community avatar URL.
class ZIMCommunityChannelAvatarUrlUpdatedResult {
  /// Community ID.
  String communityID;

  /// Community channel ID
  String channelID;

  /// Community avatar URL.
  String channelAvatarUrl;

  ZIMCommunityChannelAvatarUrlUpdatedResult({
    required this.communityID,
    required this.channelID,
    required this.channelAvatarUrl,
  });

  ZIMCommunityChannelAvatarUrlUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelID = map['channelID']!,
      channelAvatarUrl = map['channelAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'channelID': channelID,
      'channelAvatarUrl': channelAvatarUrl,
    };
  }
}

/// Callback of the result of updating the community channel notice.
///
/// - [communityID] Community ID.
/// - [channelID] Community channel ID
/// - [channelNotice] Community channel notice.
class ZIMCommunityChannelNoticeUpdatedResult {
  /// Community ID.
  String communityID;

  /// Community channel ID
  String channelID;

  /// Community channel notice.
  String channelNotice;

  ZIMCommunityChannelNoticeUpdatedResult({
    required this.communityID,
    required this.channelID,
    required this.channelNotice,
  });

  ZIMCommunityChannelNoticeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelID = map['channelID']!,
      channelNotice = map['channelNotice']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'channelID': channelID,
      'channelNotice': channelNotice,
    };
  }
}

/// Callback of the result of operating community channel attributes.
///
/// - [communityID] Community ID.
/// - [channelID] Community channel ID.
/// - [errorKeys] Error keys.
class ZIMCommunityChannelAttributesOperatedResult {
  /// Community ID.
  String communityID;

  /// Community channel ID.
  String channelID;

  /// Error keys.
  List<String> errorKeys;

  ZIMCommunityChannelAttributesOperatedResult({
    required this.communityID,
    required this.channelID,
    required this.errorKeys,
  });

  ZIMCommunityChannelAttributesOperatedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelID = map['channelID']!,
      errorKeys =
          ((map['errorKeys']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'channelID': channelID,
      'errorKeys': errorKeys,
    };
  }
}

/// Callback of the result of querying community channel information.
///
/// - [communityID] Community ID.
/// - [channelInfos] List of queried community channels.
/// - [errorChannelIDs] List of channel IDs that failed to be queried.
class ZIMCommunityChannelsInfoQueriedResult {
  /// Community ID.
  String communityID;

  /// List of queried community channels.
  List<ZIMCommunityChannelFullInfo> channelInfos;

  /// List of channel IDs that failed to be queried.
  List<String> errorChannelIDs;

  ZIMCommunityChannelsInfoQueriedResult({
    required this.communityID,
    required this.channelInfos,
    required this.errorChannelIDs,
  });

  ZIMCommunityChannelsInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelInfos =
          ((map['channelInfos']!) as List)
              .map<ZIMCommunityChannelFullInfo>(
                (item) => ZIMCommunityChannelFullInfo.fromMap(item),
              )
              .toList(),
      errorChannelIDs =
          ((map['errorChannelIDs']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'channelInfos': channelInfos.map((item) => item.toMap()).toList(),
      'errorChannelIDs': errorChannelIDs,
    };
  }
}

/// Callback of the result of querying the community channel list.
///
/// - [communityID] Community ID.
/// - [channelList] Community channel list.
/// - [nextFlag] Anchor for the next channel list query.
class ZIMCommunityChannelListQueriedResult {
  /// Community ID.
  String communityID;

  /// Community channel list.
  List<ZIMCommunityChannel> channelList;

  /// Anchor for the next channel list query.
  int nextFlag;

  ZIMCommunityChannelListQueriedResult({
    required this.communityID,
    required this.channelList,
    required this.nextFlag,
  });

  ZIMCommunityChannelListQueriedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelList =
          ((map['channelList']!) as List)
              .map<ZIMCommunityChannel>(
                (item) => ZIMCommunityChannel.fromMap(item),
              )
              .toList(),
      nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'channelList': channelList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// Callback of the result of muting community members.
///
/// - [communityID] Community ID.
/// - [channelID] The channel ID. Empty means muted at the community level.
/// - [isMute] Whether to mute the members.
/// - [errorUserList] List of users that failed to be muted.
class ZIMCommunityMembersMutedResult {
  /// Community ID.
  String communityID;

  /// The channel ID. Empty means muted at the community level.
  String channelID;

  /// Whether to mute the members.
  bool isMute;

  /// List of users that failed to be muted.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMCommunityMembersMutedResult({
    required this.communityID,
    required this.channelID,
    required this.isMute,
    required this.errorUserList,
  });

  ZIMCommunityMembersMutedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      channelID = map['channelID']!,
      isMute = map['isMute']!,
      errorUserList =
          ((map['errorUserList']!) as List)
              .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'channelID': channelID,
      'isMute': isMute,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Callback of the result of muting community channels.
///
/// - [communityID] Community ID.
/// - [isMute] Whether to mute the channels.
/// - [errorChannelIDs] List of channel IDs that failed to be muted.
class ZIMCommunityChannelsMutedResult {
  /// Community ID.
  String communityID;

  /// Whether to mute the channels.
  bool isMute;

  /// List of channel IDs that failed to be muted.
  List<String> errorChannelIDs;

  ZIMCommunityChannelsMutedResult({
    required this.communityID,
    required this.isMute,
    required this.errorChannelIDs,
  });

  ZIMCommunityChannelsMutedResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      isMute = map['isMute']!,
      errorChannelIDs =
          ((map['errorChannelIDs']!) as List)
              .map<String>((item) => item as String)
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'isMute': isMute,
      'errorChannelIDs': errorChannelIDs,
    };
  }
}

/// The callback of the reactions change.
///
/// - [reactions] Message reaction change info list
/// - [changeInfoList] Message reaction change info list
class ZIMMessageReactionsChangedEventResult {
  /// Message reaction change info list
  List<ZIMMessageReaction> reactions;

  /// Message reaction change info list
  List<ZIMMessageReactionChangeInfo> changeInfoList;

  ZIMMessageReactionsChangedEventResult({
    List<ZIMMessageReaction>? reactions,
    List<ZIMMessageReactionChangeInfo>? changeInfoList,
  }) : reactions = reactions ?? [],
       changeInfoList = changeInfoList ?? [];

  ZIMMessageReactionsChangedEventResult.fromMap(Map<dynamic, dynamic> map)
    : reactions =
          ((map['reactions']!) as List)
              .map<ZIMMessageReaction>(
                (item) => ZIMMessageReaction.fromMap(item),
              )
              .toList(),
      changeInfoList =
          ((map['changeInfoList']!) as List)
              .map<ZIMMessageReactionChangeInfo>(
                (item) => ZIMMessageReactionChangeInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'reactions': reactions.map((item) => item.toMap()).toList(),
      'changeInfoList': changeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when messages are received.
///
/// - [messageList] message list
/// - [receivedInfo] Message received info
class ZIMMessageReceivedEventResult {
  /// message list
  List<ZIMMessage> messageList;

  /// Message received info
  ZIMMessageReceivedInfo receivedInfo;

  ZIMMessageReceivedEventResult({
    List<ZIMMessage>? messageList,
    ZIMMessageReceivedInfo? receivedInfo,
  }) : messageList = messageList ?? [],
       receivedInfo = receivedInfo ?? ZIMMessageReceivedInfo();

  ZIMMessageReceivedEventResult.fromMap(Map<dynamic, dynamic> map)
    : messageList =
          ((map['messageList']!) as List)
              .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item),
              )
              .toList(),
      receivedInfo = ZIMMessageReceivedInfo.fromMap(map['receivedInfo']);

  Map<String, dynamic> toMap() {
    return {
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'receivedInfo': receivedInfo.toMap(),
    };
  }
}

/// Triggered when the community list changes.
///
/// - [changeInfoList] List of community change information.
class ZIMCommunityListChangedEventResult {
  /// List of community change information.
  List<ZIMCommunityChangeInfo> changeInfoList;

  ZIMCommunityListChangedEventResult({
    List<ZIMCommunityChangeInfo>? changeInfoList,
  }) : changeInfoList = changeInfoList ?? [];

  ZIMCommunityListChangedEventResult.fromMap(Map<dynamic, dynamic> map)
    : changeInfoList =
          ((map['changeInfoList']!) as List)
              .map<ZIMCommunityChangeInfo>(
                (item) => ZIMCommunityChangeInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'changeInfoList': changeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when the self community application list changes.
///
/// - [changeInfoList] List of community application change information.
class ZIMCommunitySelfApplicationListChangedEventResult {
  /// List of community application change information.
  List<ZIMCommunityApplicationChangeInfo> changeInfoList;

  ZIMCommunitySelfApplicationListChangedEventResult({
    List<ZIMCommunityApplicationChangeInfo>? changeInfoList,
  }) : changeInfoList = changeInfoList ?? [];

  ZIMCommunitySelfApplicationListChangedEventResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : changeInfoList =
          ((map['changeInfoList']!) as List)
              .map<ZIMCommunityApplicationChangeInfo>(
                (item) => ZIMCommunityApplicationChangeInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'changeInfoList': changeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when the community application review list changes.
///
/// - [communityID] Community ID.
/// - [changeInfoList] List of community application change information.
class ZIMCommunityApplicationListChangedEventResult {
  /// Community ID.
  String communityID;

  /// List of community application change information.
  List<ZIMCommunityApplicationChangeInfo> changeInfoList;

  ZIMCommunityApplicationListChangedEventResult({
    this.communityID = '',
    List<ZIMCommunityApplicationChangeInfo>? changeInfoList,
  }) : changeInfoList = changeInfoList ?? [];

  ZIMCommunityApplicationListChangedEventResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : communityID = map['communityID']!,
      changeInfoList =
          ((map['changeInfoList']!) as List)
              .map<ZIMCommunityApplicationChangeInfo>(
                (item) => ZIMCommunityApplicationChangeInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'changeInfoList': changeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when community information is updated.
///
/// - [updateInfoList] List of community information updates.
class ZIMCommunityInfoUpdatedEventResult {
  /// List of community information updates.
  List<ZIMCommunityFullInfoUpdateInfo> updateInfoList;

  ZIMCommunityInfoUpdatedEventResult({
    List<ZIMCommunityFullInfoUpdateInfo>? updateInfoList,
  }) : updateInfoList = updateInfoList ?? [];

  ZIMCommunityInfoUpdatedEventResult.fromMap(Map<dynamic, dynamic> map)
    : updateInfoList =
          ((map['updateInfoList']!) as List)
              .map<ZIMCommunityFullInfoUpdateInfo>(
                (item) => ZIMCommunityFullInfoUpdateInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'updateInfoList': updateInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when a community member's state changes.
///
/// - [communityID] Community ID.
/// - [changeInfoList] List of community member state changes.
class ZIMCommunityMemberStateChangedEventResult {
  /// Community ID.
  String communityID;

  /// List of community member state changes.
  List<ZIMCommunityMemberStateChangeInfo> changeInfoList;

  ZIMCommunityMemberStateChangedEventResult({
    this.communityID = '',
    List<ZIMCommunityMemberStateChangeInfo>? changeInfoList,
  }) : changeInfoList = changeInfoList ?? [];

  ZIMCommunityMemberStateChangedEventResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      changeInfoList =
          ((map['changeInfoList']!) as List)
              .map<ZIMCommunityMemberStateChangeInfo>(
                (item) => ZIMCommunityMemberStateChangeInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'changeInfoList': changeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when community member information is updated.
///
/// - [communityID] Community ID.
/// - [updateInfoList] List of community member information updates.
class ZIMCommunityMemberInfoUpdatedEventResult {
  /// Community ID.
  String communityID;

  /// List of community member information updates.
  List<ZIMCommunityMemberInfoUpdateInfo> updateInfoList;

  ZIMCommunityMemberInfoUpdatedEventResult({
    this.communityID = '',
    List<ZIMCommunityMemberInfoUpdateInfo>? updateInfoList,
  }) : updateInfoList = updateInfoList ?? [];

  ZIMCommunityMemberInfoUpdatedEventResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      updateInfoList =
          ((map['updateInfoList']!) as List)
              .map<ZIMCommunityMemberInfoUpdateInfo>(
                (item) => ZIMCommunityMemberInfoUpdateInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'updateInfoList': updateInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when the community channel list changes.
///
/// - [communityID] Community ID.
/// - [changeInfoList] List of community channel changes.
class ZIMCommunityChannelListChangedEventResult {
  /// Community ID.
  String communityID;

  /// List of community channel changes.
  List<ZIMCommunityChannelChangeInfo> changeInfoList;

  ZIMCommunityChannelListChangedEventResult({
    this.communityID = '',
    List<ZIMCommunityChannelChangeInfo>? changeInfoList,
  }) : changeInfoList = changeInfoList ?? [];

  ZIMCommunityChannelListChangedEventResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      changeInfoList =
          ((map['changeInfoList']!) as List)
              .map<ZIMCommunityChannelChangeInfo>(
                (item) => ZIMCommunityChannelChangeInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'changeInfoList': changeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Triggered when community channel information is updated.
///
/// - [communityID] Community ID.
/// - [updateInfoList] List of community channel information updates.
class ZIMCommunityChannelInfoUpdatedEventResult {
  /// Community ID.
  String communityID;

  /// List of community channel information updates.
  List<ZIMCommunityChannelFullInfoUpdateInfo> updateInfoList;

  ZIMCommunityChannelInfoUpdatedEventResult({
    this.communityID = '',
    List<ZIMCommunityChannelFullInfoUpdateInfo>? updateInfoList,
  }) : updateInfoList = updateInfoList ?? [];

  ZIMCommunityChannelInfoUpdatedEventResult.fromMap(Map<dynamic, dynamic> map)
    : communityID = map['communityID']!,
      updateInfoList =
          ((map['updateInfoList']!) as List)
              .map<ZIMCommunityChannelFullInfoUpdateInfo>(
                (item) => ZIMCommunityChannelFullInfoUpdateInfo.fromMap(item),
              )
              .toList();

  Map<String, dynamic> toMap() {
    return {
      'communityID': communityID,
      'updateInfoList': updateInfoList.map((item) => item.toMap()).toList(),
    };
  }
}
