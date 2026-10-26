import '../zego_zim.dart';

class ZIMEventHandler {
  /// The callback for error information.
  ///
  /// Available since: 1.0.0 and above.
  /// Description: When an exception occurs in the SDK, the callback will prompt detailed exception information.
  /// Use cases: It is recommended that developers, after integrating the SDK, listen to this callback during the debugging phase and print error information to the console to promptly identify and fix errors that occur during development.
  /// Triggered when: This callback is triggered when an error occurs internally in the SDK. For error codes, refer to the official website documentation.
  ///
  /// - [zim] ZIM instance.
  /// - [errorInfo] The error information
  static void Function(ZIM zim, ZIMError errorInfo)? onError;

  /// Experimental API callback.
  ///
  /// Available since: 2.28.0 and above.
  /// Description: Receive experimental API callbacks. Please use this feature with the assistance of ZEGO technical support.
  ///
  /// - [zim] ZIM instance.
  /// - [content] Callback content in JSON string format.
  static void Function(ZIM zim, String content)? onExperimentalEventReceived;

  /// A reminder callback that the token is about to expire.
  ///
  /// Available since: 1.1.0 and above.
  /// Description: When developers use authentication tokens for login, the token update logic can be handled through this event when the token is about to expire.
  /// Triggered when: When the authentication token has only 30 seconds remaining, the SDK will trigger this callback to notify developers to update the authentication token. If the token passed during [login] has less than 30 seconds of validity, this callback will be triggered immediately after [login] succeeds.
  /// Caution: When this callback is received, developers should promptly call [renewToken] to update the token.
  /// References: For details, please refer to the authentication token generation guide at https://doc-zh.zego.im/article/11617 .
  ///
  /// - [zim] ZIM instance.
  /// - [second] The remaining second before the token expires.
  static void Function(ZIM zim, int second)? onTokenWillExpire;

  /// The event callback when the connection state changes.
  ///
  /// Available since: 1.1.0 and above.
  /// Description: When the connection state changes, this callback notifies the user of the current state and event.
  /// Use cases: When you need to monitor the connection state and the events that cause connection state changes, you can use [ZIMConnectionState] and [ZIMConnectionEvent] in this callback to implement different business logic.
  /// Triggered when: This callback is triggered when the SDK performs login, logout, or when the network is temporarily interrupted.
  /// Caution: In the case of connection state changes caused by general network exceptions, developers do not need to perform reconnection themselves. The SDK will continuously attempt to reconnect until successful.
  ///
  /// - [zim] zim ZIM instance.
  /// - [state] The current connection state after changed.
  /// - [event] The event that caused the connection state to change.
  /// - [extendedData] Extra information when the event occurs, a standard JSON string.
  static void Function(
    ZIM zim,
    ZIMConnectionState state,
    ZIMConnectionEvent event,
    Map extendedData,
  )?
  onConnectionStateChanged;

  /// In the multi-terminal login scenario, after the user modifies their information on device A, other online multi-terminal devices will receive this callback. For offline devices, after the user goes online, they need to call the [queryUsersInfo] interface to actively query user information.
  ///
  /// Available since: 2.11.0 and above.
  /// Description: In multi-device login scenarios, after the user modifies their information on device A, other online multi-device devices will receive this callback. For offline devices, after the user comes online, they need to call the [queryUsersInfo] interface to actively query user information.
  /// Triggered when: When the current user on another device modifies their own user information, this callback is triggered on all currently online devices.
  ///
  /// - [zim] ZIM instance.
  /// - [info] The user info after updating.
  static void Function(ZIM zim, ZIMUserFullInfo info)? onUserInfoUpdated;

  /// Triggered when the user rule changes.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When the current user changes user rules via [updateUserOfflinePushRule], this callback notifies other online multi-device devices.
  /// Triggered when: When the current user on another device modifies their own user rules, this callback is triggered on all currently online devices.
  ///
  /// - [zim] ZIM instance.
  /// - [userRule] The user rule after updating.
  static void Function(ZIM zim, ZIMUserRule userRule)? onUserRuleUpdated;

  /// User online status change notification.
  ///
  /// Available since: 2.18.0 and above.
  /// Description: Event notification when the online status of subscribed users changes.
  /// Use cases: When your business needs to monitor the online status of certain users, such as displaying online group members, subscribe to those users via [subscribeUsersStatus]. Changes to those users' online status and platform list during the subscription period will be notified through this callback.
  /// Triggered when: After the current user first subscribes to a target user, this event is triggered when the target user is first added to the subscription list, or when the subscribed user's online status or online platform list changes. Additionally, if the current user has multi-device login enabled and the online platform changes, this callback will also be triggered.
  /// Caution: When the [onUserStatusUpdated] callback returns the current user's `userStatus` information, the `onlineStatus` will be [ZIMUserOnlineStatus.unknown] and `lastUpdateTime` will be 0, which does not accurately reflect the online status. Please use [onConnectionStateChanged] to map the current user's online status.
  ///
  /// - [zim] ZIM instance.
  /// - [userStatusList] The user status list after updating.
  static void Function(ZIM zim, List<ZIMUserStatus> userStatusList)?
  onUserStatusUpdated;

  /// Received notification callback for session update.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Trigger this callback to return notification of session updates when a session is added, deleted, or modified.
  /// Triggered when: Notifications are triggered when a new message is updated in the session, or when the session itself is added, deleted, or modified.
  /// Caution: ConversationID is the same as single chat toUserID and group chat groupID.
  /// Related APIs: Through [sendMessage], [deleteConversation] [deleteMessages], [clearConversationUnreadMessageCount] trigger.
  ///
  /// - [zim] ZIM instance.
  /// - [infoList] Changed information about the conversation.
  static void Function(ZIM zim, List<ZIMConversationChangeInfo> infoList)?
  onConversationChanged;

  /// Received notification callback for session update.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: This callback returns the total number of unread messages across all conversations.
  /// Triggered when: Immediately after the SDK logs in, a notification of the current total unread message count is triggered. It is also triggered when new messages are received or when the unread count of a conversation is cleared.
  /// Caution: If a conversation is set to do-not-disturb mode, changes to its unread count will not drive changes to the total unread count.
  ///
  /// - [zim] ZIM instance.
  /// - [totalUnreadMessageCount] Total number of unread messages.
  static void Function(ZIM zim, int totalUnreadMessageCount)?
  onConversationTotalUnreadMessageCountUpdated;

  /// Received notification callback when the message receiver has read this receipt message.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: When the message receiver has read the session, the message sender knows through this callback.
  /// Triggered when: Trigger a notification when the message receiver has read the session.
  /// Related APIs: [sendConversationMessageReceiptRead]
  ///
  /// - [zim] ZIM instance.
  /// - [infos] Receipt information.
  static void Function(ZIM zim, List<ZIMMessageReceiptInfo> infos)?
  onConversationMessageReceiptChanged;

  /// When multiple login ends delete all sessions, the local end triggers the callback to notify the local end that all sessions are deleted.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: When multiple login ends delete all sessions, the local end triggers the callback to notify the local end that all sessions are deleted.
  /// Triggered when: When another end clears all unread sessions, the local end triggers a notification.
  /// Caution: After calling the SDK [deleteAllConversations] interface to delete all conversations, [onConversationChanged] will not be triggered. It is recommended that developers, upon receiving this callback, call [queryConversationList] again to sync the conversation list UI to the latest state.
  /// Related APIs: [deleteAllConversations].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Information about deleted conversations.
  static void Function(ZIM zim, ZIMConversationsAllDeletedInfo info)?
  onConversationsAllDeleted;

  /// Notification of synchronization status change events between the conversation list and the server
  ///
  /// Available since: 2.21.0 and above.
  /// Description: After the SDK first logs in and starts the process of syncing conversations from the server, this callback is triggered to return notifications of conversation updates when the process completes or fails.
  /// Triggered when: This callback is triggered when the SDK performs the sync conversation list operation after the first login or after reconnecting from a network disconnect.
  /// Caution: Even if the conversation list does not need to be synced, the SDK will still trigger the sync completion callback so that developers can display or dismiss UI loading indicators.
  ///
  /// - [zim] ZIM instance.
  /// - [state] Sync status
  static void Function(ZIM zim, ZIMConversationSyncState state)?
  onConversationSyncStateChanged;

  /// The callback for receiving peer-to-peer message.
  ///
  /// Available since: 2.18.0 and above.
  /// Description: When online, users can receive online peer-to-peer messages through this callback. After re-logging in to the ZIM SDK, users can receive all peer-to-peer messages received during the offline period (up to 7 days) through this callback.
  /// Triggered when: This callback is triggered when a peer-to-peer message sent by another user is received.
  /// Related APIs: [sendMessage]
  ///
  /// @deprecated This API was deprecated in version 3.0.0. Please use [onMessageReceived] instead.
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [info] The message receive extra information.
  /// - [fromUserID] The user ID of the message source.
  @Deprecated(
    'This API was deprecated in version 3.0.0. Please use [onMessageReceived] instead.',
  )
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    ZIMMessageReceivedInfo info,
    String fromUserID,
  )?
  onPeerMessageReceived;

  /// The callback for receiving room message.
  ///
  /// Available since: 2.18.0 and above.
  /// Description: When online, users can receive online room messages through this callback. After recovering from offline to online, if the user is still in the room, they can receive all room messages from the offline period through this callback (this capability requires the room offline message storage feature to be enabled).
  /// Triggered when: This callback is triggered when the current user is in a room and other users in the same room send messages to the room the current user has joined or created.
  /// Related APIs: [sendMessage]
  ///
  /// @deprecated This API was deprecated in version 3.0.0. Please use [onMessageReceived] instead.
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [info] The message receive extra information.
  /// - [fromRoomID] The room ID of the message source.
  @Deprecated(
    'This API was deprecated in version 3.0.0. Please use [onMessageReceived] instead.',
  )
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    ZIMMessageReceivedInfo info,
    String fromRoomID,
  )?
  onRoomMessageReceived;

  /// The callback for receiving group message.
  ///
  /// Available since: 2.18.0 and above.
  /// Description: When online, users can receive online group messages through this callback. After re-logging in to the ZIM SDK, users can receive all group chat messages received during the offline period (up to 7 days) through this callback.
  /// Triggered when: This callback is triggered when group members in the same group send messages.
  /// Related APIs: [sendMessage]
  ///
  /// @deprecated This API was deprecated in version 3.0.0. Please use [onMessageReceived] instead.
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [info] The message receive extra information.
  /// - [fromGroupID] The group ID of the message source.
  @Deprecated(
    'This API was deprecated in version 3.0.0. Please use [onMessageReceived] instead.',
  )
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    ZIMMessageReceivedInfo info,
    String fromGroupID,
  )?
  onGroupMessageReceived;

  /// The callback for receiving message.
  ///
  /// Available since: 3.0.0 and above.
  /// Description: When online, users can receive online messages through this callback. After re-logging in to the ZIM SDK, users can receive all single chat and group chat messages received during the offline period (up to 7 days); if the room has the offline message storage feature enabled, room messages can also be received.
  /// Triggered when: This callback is triggered when a peer-to-peer message, room message, group message, or community channel message is received.
  /// Related APIs: [sendMessage]
  ///
  /// - [zim] ZIM instance.
  /// - [result] The receive group message event callback result
  static void Function(ZIM zim, ZIMMessageReceivedEventResult result)?
  onMessageReceived;

  /// The callback for receiving broadcast message.
  ///
  /// Available since: 2.10.0 or later.
  /// Description: The callback is received when the server interface [SendMessageToAllUsers] sends a message.
  /// Triggered when: This callback is received after logging in to the ZIM service and the server call the [SendMessageToAllUsers] interface to send a message.
  ///
  /// - [zim] ZIM instance.
  /// - [message] Received broadcast message.
  static void Function(ZIM zim, ZIMMessage message)? onBroadcastMessageReceived;

  /// The callback for message sent status changed.
  ///
  /// Available since: 2.6.0 and above.
  /// Description: This callback is received when the message sending status changes.
  /// Triggered when: When the current user sends a message and the message status changes from sending to sent successfully or send failed, this callback will be triggered.
  /// Caution: Only the device user who actually sends the message can receive this callback. Other devices in a multi-device login scenario will not receive this callback.
  /// Related APIs: [sendMessage]
  ///
  /// - [zim] ZIM instance.
  /// - [infos] List of message sent status change information.
  static void Function(ZIM zim, List<ZIMMessageSentStatusChangeInfo> infos)?
  onMessageSentStatusChanged;

  /// Received notification callback when the message receiver confirms that the message has been read.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: When the message receiver confirms that the message has been read, the message sender knows through this callback.
  /// Triggered when: Trigger a notification when the message receiver has read the message.
  /// Related APIs: Triggered when the peer calls via [sendMessageReceiptsRead].
  ///
  /// - [zim] ZIM instance.
  /// - [infos] List of message receipt change information.
  static void Function(ZIM zim, List<ZIMMessageReceiptInfo> infos)?
  onMessageReceiptChanged;

  /// Received notification callback when some one else sends a message and then revoke a message sent by themselves.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This callback is received when some one else sends a message and then revoke.
  /// Triggered when: This callback occurs when a ZIM instance is created with [create] and the other user revoke a message.
  /// Related APIs: You can revoke message to other members via [revokeMessage].
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] List of message revoke information.
  static void Function(ZIM zim, List<ZIMRevokeMessage> messageList)?
  onMessageRevokeReceived;

  /// The callback is received when reactions change
  ///
  /// Available since: 2.28.0 and above.
  /// Description: This callback is received when the reaction types in a message increase or decrease, or when the user count and count of a specific reaction change.
  /// Triggered when: This callback is triggered when the current user has already received a message in the conversation and the reaction content of the message changes.
  /// Related APIs: [addMessageReaction], [deleteMessageReaction]
  ///
  /// - [zim] ZIM instance.
  /// - [result] The message reaction change event callback result
  static void Function(ZIM zim, ZIMMessageReactionsChangedEventResult result)?
  onMessageReactionsChanged;

  /// The callback is received when a message is deleted.
  ///
  /// Available since: 2.11.0 and above.
  /// Description: In multi-device login scenarios, after the user deletes server-side messages on device A, other online multi-device devices will receive this callback.
  /// Triggered when: When another device of the current user in a multi-device online login performs message deletion, the online user on the current device will trigger this callback.
  /// Caution: When other users in a conversation delete messages, other users will not receive this callback. This callback only takes effect for the user who performs the deletion.
  /// Related APIs: [deleteMessages], [deleteAllMessage], [deleteAllConversationMessages]
  ///
  /// - [zim] ZIM instance.
  /// - [deletedInfo] Information about deleted messages.
  static void Function(ZIM zim, ZIMMessageDeletedInfo deletedInfo)?
  onMessageDeleted;

  /// The callback is received when the message replied information changes.
  ///
  /// Available since: 2.17.0 and above.
  /// Description: Users in the conversation will receive this callback when the source message referenced by a reply message is deleted, revoked, or its content is edited.
  /// Triggered when: This callback is triggered when the current user has already received a message in the conversation and the reply content carried by that message changes.
  /// Use cases: This allows developers to be notified in advance of source message status changes for quoted messages in the chat view before the reply source message is fetched, enabling timely UI refresh.
  /// Related APIs: [deleteMessages], [revokeMessage], [editMessage]
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] List of message information.
  static void Function(ZIM zim, List<ZIMMessage> messageList)?
  onMessageRepliedInfoChanged;

  /// The callback is received when the message replied count changes.
  ///
  /// Available since: 2.17.0 and above.
  /// Description: When messages continue to be replied to in the same reply chain, changes to the reply count of the source message are notified through this callback.
  /// Triggered when: This callback is triggered when the current user has received the source message and the message is replied to.
  /// Related APIs: [replyMessage].
  ///
  /// - [zim] ZIM instance.
  /// - [infos] List of message root reply count change information.
  static void Function(ZIM zim, List<ZIMMessageRootRepliedCountInfo> infos)?
  onMessageRepliedCountChanged;

  /// The callback is received when a message is edited.
  ///
  /// Available since: 2.20.0 and above.
  /// Description: Users in the conversation will receive this callback when a message is edited.
  /// Triggered when: This callback is triggered when the current user has already received a message in the conversation and that message is subsequently edited.
  /// Related APIs: [editMessage].
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] The message list.
  static void Function(ZIM zim, List<ZIMMessage> messageList)? onMessageEdited;

  /// The callback is received when a message is pinned.
  ///
  /// Available since: 2.25.0 and above.
  /// Description: This callback is received when a message in the conversation is successfully pinned or unpinned, or when the pinned message information changes.
  /// Triggered when: This callback is triggered when a message in the conversation is successfully pinned or unpinned, or when the pinned message information changes.
  /// Related APIs: [pinMessage].
  ///
  /// - [zim] ZIM instance.
  /// - [changeInfoList] The message list.
  static void Function(
    ZIM zim,
    List<ZIMMessagePinStatusChangeInfo> changeInfoList,
  )?
  onMessagePinStatusChanged;

  /// The event callback when the room connection status changes.
  ///
  /// Description: Event callback when the room connection status changes. It is recommended that developers always listen to this callback to properly manage the room lifecycle.
  /// Triggered when: This callback is triggered when the room connection status changes, such as when entering or leaving a room, a temporary network interruption, or a room connection timeout.
  /// Caution: Since the SDK does not perform unlimited reconnection for room connections, developers need to selectively perform limited reconnection according to their own business requirements.
  /// References: https://doc-zh.zego.im/faq/zim-reconnect-support
  ///
  /// - [zim] ZIM instance.
  /// - [state] Room state.
  /// - [event] Room event.
  /// - [extendedData] Extended data.
  /// - [roomID] Room ID.
  static void Function(
    ZIM zim,
    ZIMRoomState state,
    ZIMRoomEvent event,
    Map extendedData,
    String roomID,
  )?
  onRoomStateChanged;

  /// Callback when other members join the room.
  ///
  /// Available since: 1.1.0 and above.
  /// Description: After joining a room, this callback will be triggered when other members also join the room.
  /// Triggered when: This callback is triggered when the current user is online in the room and other users join the room.
  /// Caution: If the current user is temporarily offline due to network issues when other users enter the room, this callback will not be re-sent after reconnection. Developers can use [queryRoomMemberList] to get the latest room member list at that time.
  /// Related APIs: [enterRoom], [joinRoom].
  ///
  /// - [zim] ZIM instance.
  /// - [memberList] List of members who joined the room.
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(ZIM zim, List<ZIMUserInfo> memberList, String roomID)?
  onRoomMemberJoined;

  /// Callback when other members leave the room.
  ///
  /// Available since: 1.1.0 and above.
  /// Description: After joining a room, this callback will be triggered when other members leave the room.
  /// Triggered when: This callback is triggered when the current user is online in the room and other users leave the room.
  /// Caution: If the current user is temporarily offline due to network issues when other users leave the room, this callback will not be re-sent after reconnection. Developers can use [queryRoomMemberList] to get the latest room member list at that time.
  /// Related APIs: [leaveRoom].
  ///
  /// - [zim] ZIM instance.
  /// - [memberList] List of members who left the room.
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(ZIM zim, List<ZIMUserInfo> memberList, String roomID)?
  onRoomMemberLeft;

  /// Event callback when the room attributes changes.
  ///
  /// Available since: 1.3.0 and above.
  /// Description: When the room attributes in the room change, this callback notifies the users.
  /// Triggered when: When first joining a room, if there are room attributes in the room at that time, a callback is triggered once, which developers can use to save as initial attribute values. This callback is also triggered when other users in the room change room attributes (triggered when the current user is online or successfully reconnects after a brief offline period).
  /// Use cases: In voice chat room scenarios, room attributes can be used to manage microphone seat information.
  /// Related APIs: [setRoomAttributes], [deleteRoomAttributes].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Room attribute change information
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(
    ZIM zim,
    ZIMRoomAttributesUpdateInfo info,
    String roomID,
  )?
  onRoomAttributesUpdated;

  /// Event callback when the room attributes batch changes.
  ///
  /// Available since: 1.3.0 and above.
  /// Description: When room attributes in the room change in batch, this callback notifies the users.
  /// Triggered when: This callback is triggered when another user in the room calls the batch attribute change interface for room attributes.
  /// Use cases: In voice chat room scenarios, room attributes can be used to manage microphone seat information.
  /// Related APIs: [beginRoomAttributesBatchOperation], [endRoomAttributesBatchOperation].
  ///
  /// - [zim] ZIM instance.
  /// - [infos] Room attribute change information list
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(
    ZIM zim,
    List<ZIMRoomAttributesUpdateInfo> infos,
    String roomID,
  )?
  onRoomAttributesBatchUpdated;

  /// Event callback when the room member attributes changes.
  ///
  /// Available since: 1.3.0 and above.
  /// Description: When the member user attributes in the room change, this callback notifies the users.
  /// Triggered when: This callback is triggered when another user's attributes are changed in the room and the current user is online.
  /// Use cases: When business additional information needs to be recorded for each member in the room, this callback can be used to receive changes and refresh the UI.
  /// Related APIs: [setRoomMemberAttributes].
  ///
  /// - [zim] ZIM instance.
  /// - [infos] Room member attribute change information list
  /// - [operatedInfo] Operation information
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(
    ZIM zim,
    List<ZIMRoomMemberAttributesUpdateInfo> infos,
    ZIMRoomOperatedInfo operatedInfo,
    String roomID,
  )?
  onRoomMemberAttributesUpdated;

  /// Event callback when the group state changes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Callback notification of group status change. Used to describe the current lifecycle state of the group and the events triggered when the lifecycle state changes.
  /// Use cases: Scenarios that require interaction based on the group status.
  /// Triggered when: A notification is triggered when a group is created, joined, left, or dismissed.
  /// Related APIs: [createGroup] creates a group; [joinGroup] joins a group; [leaveGroup] leaves a group; [dismissGroup] dismisses a group.
  ///
  /// - [zim] ZIM instance.
  /// - [state] Group status.
  /// - [event] Group related events.
  /// - [operatedInfo] Group operation information.
  /// - [groupInfo] Group detailed information.
  static void Function(
    ZIM zim,
    ZIMGroupState state,
    ZIMGroupEvent event,
    ZIMGroupOperatedInfo operatedInfo,
    ZIMGroupFullInfo groupInfo,
  )?
  onGroupStateChanged;

  /// Event callback when the group name changes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Group name change notification callback.
  /// Use cases: When the group name changes, you need to synchronize the latest group name.
  /// Triggered when: Triggered when the group name changes.
  /// Related APIs: [updateGroupName], which updates the group name.
  ///
  /// - [zim] ZIM instance.
  /// - [groupName] Group name.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupName,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupNameUpdated;

  /// Event callback when the group avatar changes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Notification callback when the group avatar URL changes.
  /// Use cases: When the group avatar URL changes, you need to synchronize the latest group avatar URL.
  /// Triggered when: The group avatar URL changes.
  /// Related APIs: [updateGroupAvatarUrl], which updates the group avatar URL.
  ///
  /// - [zim] ZIM instance.
  /// - [groupAvatarUrl] Group avatar.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupAvatarUrl,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupAvatarUrlUpdated;

  /// Event callback when the group notice changes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Group notice change notification callback.
  /// Use cases: When the group notice changes, you need to synchronize the latest notice content.
  /// Triggered when: Triggered when the group notice changes.
  /// Related APIs: [updateGroupNotice], which updates the group notice.
  ///
  /// - [zim] ZIM instance.
  /// - [groupNotice] Group notice.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupNotice,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupNoticeUpdated;

  /// Event callback when the group alias changes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Group alias change notification callback.
  /// Use cases: When the group alias changes, you need to synchronize the latest alias content.
  /// Triggered when: Triggered when the current user who set the group alias or their online multi-device devices change the group alias.
  /// Caution: The group alias feature is only visible to the user who set it. Therefore, changes to the group alias by the current user will not be pushed to other users in the group.
  /// Related APIs: [updateGroupAlias], which updates the group alias.
  ///
  /// - [zim] ZIM instance.
  /// - [groupAlias] Group alias.
  /// - [operatedUserID] Operated user ID.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupAlias,
    String operatedUserID,
    String groupID,
  )?
  onGroupAliasUpdated;

  /// Event callback when the group attributes change.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Group attribute change notification callback.
  /// Use cases: When group attributes are changed, you need to synchronize the latest group attributes.
  /// Triggered when: Triggered when group attributes are set, updated, or deleted.
  /// Related APIs: [setGroupAttributes] updates group attributes; [deleteGroupAttributes] deletes group attributes.
  ///
  /// - [zim] ZIM instance.
  /// - [infoList] Group attribute change information.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    List<ZIMGroupAttributesUpdateInfo> infoList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupAttributesUpdated;

  /// Event callback when the group is muted.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: Notification callback when the group mute information changes.
  /// Triggered when: When the group mute information changes, users in the group will trigger this callback.
  /// Related APIs: [muteGroup], group mute.
  ///
  /// - [zim] ZIM instance.
  /// - [mutedInfo] Group mute information.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    ZIMGroupMuteInfo mutedInfo,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupMutedInfoUpdated;

  /// Event callback when the group verification information changes.
  ///
  /// Description: Notification callback when the group join verification mode changes.
  /// Triggered when: When the group owner or administrator changes the group join verification mode, users in the group will trigger this callback.
  /// Related APIs: [updateGroupJoinMode, updateGroupInviteMode, updateGroupBeInviteMode].
  ///
  /// - [zim] ZIM instance.
  /// - [verifyInfo] Group verification information.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    ZIMGroupVerifyInfo verifyInfo,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupVerifyInfoUpdated;

  /// Event callback when the group member status changes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Callback notification when group member status changes.
  /// Use cases: Scenarios that require interaction based on group member states, such as displaying group member join/leave notification UI.
  /// Triggered when: Notification is triggered when a group is created, joined, left, or dismissed, or a user is invited to join or kicked out of the group.
  /// Related APIs: [createGroup] creates a group, [joinGroup] joins a group, [leaveGroup] leaves a group, [dismissGroup] dismisses a group, [inviteUsersIntoGroup] invites users into the group, [kickGroupMembers] kicks out members.
  ///
  /// - [zim] ZIM instance.
  /// - [state] Group member status.
  /// - [event] Group member event.
  /// - [userList] Group member information list.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    ZIMGroupMemberState state,
    ZIMGroupMemberEvent event,
    List<ZIMGroupMemberInfo> userList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupMemberStateChanged;

  /// Event callback when the group member information changes.
  ///
  /// Description: Callback for group member basic information change events, including group member nickname, role, and other change events.
  /// Use cases: After the basic information of group members is changed, scenarios that require displaying or interacting with group members on the page, such as displaying notifications when a group member's role changes.
  /// Triggered when: After group member information changes, users in the group will trigger this notification.
  /// Related APIs: [setGroupMemberNickname] updates group member nickname; [setGroupMemberRole] updates group member role; [transferGroupOwner] transfers group ownership.
  ///
  /// - [zim] ZIM instance.
  /// - [userList] Group member information list.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    List<ZIMGroupMemberInfo> userList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )?
  onGroupMemberInfoUpdated;

  /// Event callback when the group application list changes.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: This callback is triggered when the group join application list changes.
  /// Related APIs: [sendGroupJoinApplication], [sendGroupInviteApplications].
  ///
  /// - [zim] ZIM instance.
  /// - [applicationList] Group application list.
  /// - [action] Group operation information.
  static void Function(
    ZIM zim,
    List<ZIMGroupApplicationInfo> applicationList,
    ZIMGroupApplicationListChangeAction action,
  )?
  onGroupApplicationListChanged;

  /// Event callback when the group application information changes.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: This callback is triggered when the group join application list information changes.
  /// Related APIs: [acceptGroupJoinApplication], [rejectGroupJoinApplication], [acceptGroupInviteApplication], [rejectGroupInviteApplication].
  ///
  /// - [zim] ZIM instance.
  /// - [applicationList] Group application list.
  static void Function(ZIM zim, List<ZIMGroupApplicationInfo> applicationList)?
  onGroupApplicationUpdated;

  /// Event callback when the call invitation is created.
  ///
  /// Available since: 2.13.0 and above.
  /// Description: After the inviter initiates a call invitation and the inviter is online, this callback will be received.
  /// Triggered when: If the inviter has multiple online devices, all multi-device devices of the current user will trigger this callback after the inviter sends the call invitation.
  /// Related APIs: [callInvite].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationCreatedInfo info,
    String callID,
  )?
  onCallInvitationCreated;

  /// Event callback when the call invitation is received.
  ///
  /// Available since: 2.0.0 and above.
  /// Use cases: The invitee will call this callback after the inviter sends a call invitation.
  /// Triggered when: After creating a ZIM instance through [create].
  /// Caution: If the user is not in the invitation list or not online, this callback will not be called.
  /// Related APIs: [callInvite].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationReceivedInfo info,
    String callID,
  )?
  onCallInvitationReceived;

  /// Event callback when the call invitation is cancelled.
  ///
  /// Available since: 2.0.0 and above.
  /// Use cases: The invitee will call this callback after the inviter cancels the call invitation.
  /// Triggered when: After creating a ZIM instance through [create].
  /// Caution: If the user is not in the cancel invitation list or is offline, this callback will not be called.
  /// Related APIs: [callCancel].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation cancellation information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationCancelledInfo info,
    String callID,
  )?
  onCallInvitationCancelled;

  /// Event callback when the call invitation is ended.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: After an advanced mode call invitation is established and a participant ends the call, all participants will receive this callback.
  /// Caution: If the user is not a participant who initiated this call or is not online, this callback will not be received.
  /// Related APIs: [callEnd].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation end information.
  /// - [callID] Call ID.
  static void Function(ZIM zim, ZIMCallInvitationEndedInfo info, String callID)?
  onCallInvitationEnded;

  /// Event callback when the call invitation times out.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: When the call invitation times out, the invitee does not respond and will receive a callback.
  /// Use cases: If the invitee does not respond before the timeout period, this callback will be received.
  /// Triggered when: After creating a ZIM instance through [create].
  /// Caution: If the user is not on the invitation list or is not online, the callback will not be received.
  /// Related APIs: [callInvite], [callAccept], [callReject].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation timeout information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationTimeoutInfo info,
    String callID,
  )?
  onCallInvitationTimeout;

  /// Event callback when the call invitation user status changes.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: Listen for calling user status changes.
  /// Triggered when: When a new member is invited to a call, or a member accepts, rejects, exits, or a member response times out, all users on the current call invitation whose status is "Inviting," "Accepted," and "Received" receive the callback here. If the member is not online at the time of notification, the call is still ongoing when the login succeeds. The status changes of all members during the offline period will be sent to the user at one time.
  /// Caution: If the user is not the inviter who initiated this call invitation or is not online, the callback will not be received.
  /// Related APIs: [callInvite], [callingInvite], [callAccept], [callReject],[callQuit].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation user status change information.
  /// - [callID] Call ID.
  static void Function(ZIM zim, ZIMCallUserStateChangeInfo info, String callID)?
  onCallUserStateChanged;

  /// Event callback when the friend list changes.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: When the friend list changes, this callback is triggered for the current user and all devices logged in by the current user.
  /// Triggered when: This callback is triggered when the current user's friend list changes, i.e., when a friend is added, deleted, or similar events occur.
  /// Related APIs: [addFriend], [deleteFriends].
  ///
  /// - [zim] ZIM instance.
  /// - [friendInfoList] Friend information list.
  /// - [action] Friend list change operation.
  static void Function(
    ZIM zim,
    List<ZIMFriendInfo> friendInfoList,
    ZIMFriendListChangeAction action,
  )?
  onFriendListChanged;

  /// Event callback when the friend information changes.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: This callback is triggered when friend information is updated.
  /// Triggered when: This callback is triggered when a friend's basic information changes, such as avatar or name, or when the current user or another online device modifies a friend's alias or attributes.
  /// Related APIs: [updateFriendAlias], [updateFriendAttributes].
  ///
  /// - [zim] ZIM instance.
  /// - [friendInfoList] List of updated friend information.
  static void Function(ZIM zim, List<ZIMFriendInfo> friendInfoList)?
  onFriendInfoUpdated;

  /// Event callback when the friend application list changes.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: This callback is triggered when the friend application list changes.
  /// Triggered when: This callback is triggered when a user applies to become a friend, or when you send a friend application to a user, causing changes to the friend application list.
  /// Related APIs: [sendFriendApplication].
  ///
  /// - [zim] ZIM instance.
  /// - [friendApplicationInfoList] Friend application information list.
  /// - [action] Friend application list change operation.
  static void Function(
    ZIM zim,
    List<ZIMFriendApplicationInfo> friendApplicationInfoList,
    ZIMFriendApplicationListChangeAction action,
  )?
  onFriendApplicationListChanged;

  /// Event callback when the friend application information changes.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: This callback is triggered when the status or information of the friend application list is updated.
  /// Triggered when: This callback is triggered when the other party accepts or rejects your friend application, or when you accept or reject the other party's friend application, causing changes to the friend application information.
  /// Related APIs: [acceptFriendApplication], [rejectFriendApplication].
  ///
  /// - [zim] ZIM instance.
  /// - [friendApplicationInfoList] Friend application information list.
  static void Function(
    ZIM zim,
    List<ZIMFriendApplicationInfo> friendApplicationInfoList,
  )?
  onFriendApplicationUpdated;

  /// Event callback when the blacklist changes.
  ///
  /// Available since: 2.13.0 and above.
  /// Description: This callback is triggered when the current user's blacklist changes.
  /// Triggered when: This callback is triggered for the current user and all online devices when the current user adds or removes a user from the blacklist.
  /// Related APIs: [addUsersToBlacklist], [removeUsersFromBlacklist].
  ///
  /// - [zim] ZIM instance.
  /// - [userList] Blacklist user list.
  /// - [action] Blacklist change operation.
  static void Function(
    ZIM zim,
    List<ZIMUserInfo> userList,
    ZIMBlacklistChangeAction action,
  )?
  onBlacklistChanged;

  /// Received notification callback for community list changed.
  ///
  /// Available since: 3.0.0 and above.
  /// Description: This callback is received when the current user's own community list changes, or when attributes such as the total unread count of joined communities change.
  /// Triggered when: This callback is triggered when the current user joins a new community, leaves a joined community, or when the total unread count of a joined community changes.
  /// Use cases: Used to display the list of communities the current user has joined in the UI and subsequent changes.
  /// Caution: Only communities that you have joined will trigger this callback notification. Communities you have not joined will not trigger this callback.
  /// Related APIs: [createCommunity], [joinCommunity], [leaveCommunity], [dismissCommunity].
  ///
  /// - [zim] ZIM instance.
  /// - [result] The community list changed event callback result
  static void Function(ZIM zim, ZIMCommunityListChangedEventResult result)?
  onCommunityListChanged;

  /// Received notification callback for self community application list changed.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: This callback is received when the current user's community application list changes, with each change item carrying an added, deleted, or updated action.
  /// Triggered when: This callback is triggered when the current user submits a new community join application, when the application state changes such as being accepted or rejected, or when the application is deleted.
  /// Use cases: Used to display the current user's own community application list in the UI and subsequent changes.
  /// Related APIs: [sendCommunityJoinApplication], [queryCommunitySelfApplicationList].
  ///
  /// - [zim] ZIM instance.
  /// - [result] The self community application list changed event callback result
  static void Function(
    ZIM zim,
    ZIMCommunitySelfApplicationListChangedEventResult result,
  )?
  onCommunitySelfApplicationListChanged;

  /// Received notification callback for community application list changed (review list, community owner and administrators).
  ///
  /// Available since: 3.2.0 and above.
  /// Description: When the current user is the community owner or administrator, this callback is received when the community's application review list changes, with each change item carrying an added, deleted, or updated action.
  /// Triggered when: This callback is triggered when a user submits a new community join application, when the application state changes such as being accepted or rejected, or when the application is cancelled or deleted.
  /// Use cases: Used to display the community application review list in the administrator UI and subsequent changes.
  /// Related APIs: [queryCommunityApplicationList], [acceptCommunityJoinApplication], [rejectCommunityJoinApplication].
  ///
  /// - [zim] ZIM instance.
  /// - [result] The community application list changed event callback result
  static void Function(
    ZIM zim,
    ZIMCommunityApplicationListChangedEventResult result,
  )?
  onCommunityApplicationListChanged;

  /// Received notification callback for community info updated.
  ///
  /// Available since: 3.0.0 and above.
  /// Description: This callback is received when the current community information changes.
  /// Triggered when: When the current community information changes, such as when the community name, avatar, notice, or other attributes are modified by the community owner or administrator, community members will trigger this callback.
  /// Use cases: Used to display the latest community attribute data in the UI.
  /// Caution: Due to the large scale of community membership, when community attributes change, push notifications are only sent to users who have recently called [queryCommunityInfo]. Users who do not receive the push notification can also obtain the latest community attributes via [queryCommunityInfo].
  /// Related APIs: [updateCommunityName], [updateCommunityAvatarUrl], [updateCommunityNotice], [updateCommunityJoinMode], [setCommunityAttributes], [deleteCommunityAttributes].
  ///
  /// - [zim] ZIM instance.
  /// - [result] The community info list updated event callback result
  static void Function(ZIM zim, ZIMCommunityInfoUpdatedEventResult result)?
  onCommunityInfoUpdated;

  /// .
  ///
  /// Available since: 3.0.0 and above.
  /// Description: This callback is received when the status of members in the community changes.
  /// Triggered when: This callback is triggered when events that change the community member status occur, such as a community member joining or leaving.
  /// Caution: Due to the large scale of community membership, when a community member's status changes, push notifications are only sent to users who have recently called [queryCommunityInfo]. Users who do not receive the push notification can also obtain the latest community member list via [queryCommunityMemberList].
  /// Related APIs: [joinCommunity], [leaveCommunity], [inviteUsersIntoCommunity], [kickCommunityMembers].
  ///
  /// - [zim] ZIM instance.
  /// - [result] The community member state change event callback result
  static void Function(
    ZIM zim,
    ZIMCommunityMemberStateChangedEventResult result,
  )?
  onCommunityMemberStateChanged;

  /// .
  ///
  /// Available since: 3.0.0 and above.
  /// Description: This callback is received when member information in the community changes.
  /// Triggered when: This callback is triggered when a community member's role changes, when a community member is muted or unmuted, or when their basic user information changes.
  /// Caution: Due to the large scale of community membership, when a community member's status changes, push notifications are only sent to users who have recently called [queryCommunityInfo]. Users who do not receive the push notification can also obtain the latest community member information via [queryCommunityMembers].
  /// Related APIs: [updateCommunityMemberRole], [muteCommunityMembers].
  ///
  /// - [zim] ZIM instance.
  /// - [result] The community member state change event callback result
  static void Function(
    ZIM zim,
    ZIMCommunityMemberInfoUpdatedEventResult result,
  )?
  onCommunityMemberInfoUpdated;

  /// Received notification callback for community channel list changed.
  ///
  /// Available since: 3.0.0 and above.
  /// Description: This callback is received when the community channel list changes or when attributes within a channel change.
  /// Triggered when: This callback is triggered when a channel in the community is created or deleted, or when messages are produced in a channel (similar to conversation-related operations).
  /// Use cases: Used by developers to render the user chat activity in community channels in real time.
  /// Related APIs: [sendMessage], [createCommunityChannel], [dismissCommunityChannel], [clearConversationUnreadMessageCount], etc.
  ///
  /// - [zim] ZIM instance.
  /// - [result] The community channel list changed event callback result
  static void Function(
    ZIM zim,
    ZIMCommunityChannelListChangedEventResult result,
  )?
  onCommunityChannelListChanged;

  /// Received notification callback for community info updated.
  ///
  /// Available since: 3.0.0 and above.
  /// Description: This callback is received when the attributes of a channel in the community change.
  /// Triggered when: When the community channel name, channel notice, channel attributes, channel mute, or other attributes are changed by the community owner or administrator, active users in the channel will trigger this callback.
  /// Caution: Due to the large scale of community membership, ZIM filters active users based on each user's API call behavior to push channel information change notifications. Users who do not receive the push notification can also obtain the latest community channel information via [queryCommunityChannelsInfo].
  /// Related APIs: [updateCommunityChannelName], [updateCommunityChannelAvatarUrl], [updateCommunityChannelNotice], [setCommunityChannelAttributes], [deleteCommunityChannelAttributes].
  ///
  /// - [zim] ZIM instance.
  /// - [result] The community channel info list updated event callback result
  static void Function(
    ZIM zim,
    ZIMCommunityChannelInfoUpdatedEventResult result,
  )?
  onCommunityChannelInfoUpdated;
}
