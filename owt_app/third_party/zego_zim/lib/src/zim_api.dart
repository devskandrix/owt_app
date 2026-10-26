import 'internal/zim_manager.dart';
import 'zim_defines.dart';

abstract class ZIM {
  /// Gets the SDK's version number.
  ///
  /// Available since: 1.1.0.
  /// Description: Get the SDK version.
  /// Use cases:
  /// 1. When the SDK is running, the developer finds that it does not match the expected situation and submits the problem and related logs to the ZEGO technical staff for locating. The ZEGO technical staff may need the information of the engine version to assist in locating the problem.
  /// 2. Developers can also collect this information as the version information of the engine used by the app, so that the SDK corresponding to each version of the app on the line.
  /// When to call: It can be called at any time.
  static Future<String> getVersion() async {
    return await ZIMManager.getVersion();
  }

  /// Create a ZIM instance.
  ///
  /// Available since: 2.3.0 and above.
  /// Description: Create a ZIM instance for subsequent calls to other member functions.
  /// When to call: Before calling other member functions, you must call this API to create a ZIM example.
  /// Restrictions: Currently only one instance is supported, repeated calls will return [null].
  /// Caution:
  /// 1. Currently, the [create] function can only create one instance at most. If it is called multiple times, only the first one will return a valid instance, and the rest will be [null]. The developer should save the ZIM instance by himself, and ensure that the life cycle of the instance is available in the process of using the ZIM business function; or after calling [create], he can use [getInstance] to obtain its singleton object and call other member functions.
  /// 2. If you use this function to create an instance, you must pass in both AppID and AppSign (exclude Web platform).
  /// Scope of impact: Failure to call this function will prevent other member functions from being called.
  /// Platform differences: When calling this function on the Android platform, in addition to the appID, the Application class object must also be passed in.
  ///
  /// - [appConfig] ZIMAppConfig
  static ZIM? create(ZIMAppConfig appConfig) {
    return ZIMManager.create(appConfig);
  }

  /// Get the ZIM singleton object.
  ///
  /// Available since: 2.3.0 and above.
  /// Description: Get the ZIM singleton object for subsequent calls to other member functions.
  /// When to call: You must call [create] to create an instance before calling this function to obtain a singleton object, otherwise it will return [null].
  /// Related APIs: [create].
  static ZIM? getInstance() {
    return ZIMManager.getInstance();
  }

  /// Set ZIM advanced configuration.
  ///
  /// When you need to customize the set advanced configurations, you need to call this function.
  /// It must be set before calling [create] to take effect. If it is set after [create], it will take effect at the next [create].
  ///
  /// - [key] Configuration Key
  /// - [value] Configuration value
  static void setAdvancedConfig(String key, String value) {
    ZIMManager.setAdvancedConfig(key, value);
  }

  /// Set geofence-related configurations.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: Geofencing means that instant messaging data transmission is limited to a certain area to meet regional data privacy and security regulations, that is, to restrict access to communication services in a specific area.
  /// When to call: The [setGeofencingConfig] interface needs to be called before the [create] interface.
  /// Restrictions: If you need to use this function, please contact ZEGO technical support.
  /// Caution: If you need to update geo fencing information, please call the [destroy] interface to destroy the current ZIM instance, and then call this interface.
  ///
  /// - [areaList] Geofencing area list
  /// - [type] Geofencing type
  static Future<bool> setGeofencingConfig(
    List<int> areaList,
    ZIMGeofencingType type,
  ) async {
    return await ZIMManager.setGeofencingConfig(areaList, type);
  }

  ///  Set log related configuration.
  ///
  /// Available since: 1.1.0 and above.
  /// Description: Set log related configuration, including log path and log size. Since there is a default log path inside the SDK, unless the developer has a strong need to customize the log path, it is generally not recommended that customers set it by themselves.
  /// Default value:
  /// Android: /storage/Android/data/[packageName]/files/ZIMLogs
  /// iOS: ~/Library/Caches/ZIMLogs
  /// macOS: (sandbox) ~/Library/Containers/[Bundle ID]/Data/Library/Caches/ZIMLogs /; (non-sandbox) ~/Library/Caches/ZIMLogs
  /// Windows: C:/Users/[Your UserName]/AppData/[App Name]ZEGO.SDK/ZIMLogs
  /// When to call: It must be called before [create].
  /// Caution: If the developer calls after [create], the SDK will save this configuration until the next time [create] takes effect.
  /// Life cycle: Set before calling [create], and take effect when calling [create]. If the developer does not set a new log configuration in the next [create], the previous configuration will still take effect.
  /// Platform differences: The default path of different platforms is different, please refer to the default value.
  /// Related APIs: For details, please refer to https://doc-zh.zego.im/faq/IM_sdkLog?product=IM&platform=all.
  ///
  /// - [config] Custom log configuration
  static void setLogConfig(ZIMLogConfig config) {
    ZIMManager.setLogConfig(config);
  }

  /// Set cache related configuration.
  ///
  /// Available since: 1.1.0 and above.
  /// Description: Example Set the SDK cache file path. Because the SDK has a default path, it is generally not recommended that you set your own path unless there is a strong need to do so.
  /// Default value: Android：/storage/Android/data/[packageName]/files/ZIMCaches
  /// iOS: ~/Library/Caches/ZIMCaches
  /// macOS: （sandbox）~/Library/Containers/[Bundle ID]/Data/Library/Caches/ZIMCaches / ~/Library/Caches/ZIMCaches
  /// Windows: C:\Users\[Your UserName]\AppData\[App Name]ZEGO.SDK\ZIMCaches
  /// When to call: It must be called before [create].
  /// Caution: If the developer calls after [create], the SDK saves the configuration until it takes effect the next time [create] is invoked.
  /// Related callbacks: In addition to getting the login result in the callback parameter, the developer will also receive the [onConnectionStateChanged] callback during the login request and after the login is successful/failed to determine the current user's login status.
  /// Life cycle: Set before calling [create] and takes effect when calling [create]. If the developer does not set the new caches configuration the next time [create] is created, the previous configuration will still take effect.
  /// Platform differences: The default path varies with platforms. Please refer to the default value.
  ///
  /// - [config] Custom cache configuration
  static void setCacheConfig(ZIMCacheConfig config) {
    ZIMManager.setCacheConfig(config);
  }

  /// Destroy the ZIM instance.
  ///
  /// Available since: 1.1.0 and above.
  /// Description: Release the resources used by the ZIM instance. This function must be called to release the occupied memory resources when ZIM is no longer needed, otherwise a memory leak may occur.
  /// When to call: call when ZIM is no longer needed, usually before emptying the ZIM object.
  /// Caution: After calling this function, ZIM internal functions can no longer be used, and all callback notifications will no longer be triggered. If you need to continue using the ZIM function, please call [create] again to create a new instance.
  destroy();

  /// Upload log and call after setting up log path.
  ///
  /// Available since: 1.2.0 and above.
  /// Description: By default, the SDK will create and print log files in the default directory of the App. By default, the maximum value of each log file is 5MB, and the three log files are written in a cycle. When this function is called, the SDK automatically packages and uploads the log file to the ZEGO server.
  /// Use cases: Developers can provide business "feedback" channels in the App. When user feedback problems belong to ZEGO SDK, they can call this function to upload the local log information of SDK and contact ZEGO technical support to help locate user problems.
  /// When to call: It must be after calling [create] to create an instance.
  /// Restrictions: If this interface is invoked repeatedly within 10 minutes, only the last invocation takes effect.
  /// Caution: If you call [destroy] or exit the App too quickly after calling this interface to upload logs, it may fail. You are advised to wait a few seconds and then call [destroy] or exit the App after receiving the callback for successful upload.
  /// Related callbacks: Developers can get the upload results through the callback parameter.
  Future<void> uploadLog();

  /// Login, you must log in before using all functions.
  ///
  /// Available since: 2.13.0 and above.
  /// Description: Log in to the ZIM service. [login] is the most important step of the ZIM function. You need to log in before using any other functions.
  /// When to call: This function must be called after calling [create] to create an instance and before calling other instance functions.
  /// Caution: Before using ZIM's single chat, room, message sending and receiving functions, you must first call this function to log in, and the UI can be displayed to the user through the login result.
  /// Privacy statement: remind users not to pass in sensitive information involving personal privacy in the userID parameter, including but not limited to mobile phone number, ID number, passport number, real name, etc.
  /// Related callbacks: In addition to getting the login result in the callback parameter, the developer will also receive the [onConnectionStateChanged] callback during the login request and after the login is successful/failed to determine the current user's login status.
  /// FAQ: How is the RTC login different from ZEGO's? RTC login refers to the login to the room, ZIM login to the account.
  /// References: For details, please refer to Authentication (https://docs.zegocloud.com/article/13772).
  ///
  /// - [userID] Used to identify user information, the unique ID of the user.
  /// - [config] Various parameters used for specific login actions.
  Future<void> login(String userID, ZIMLoginConfig config);

  /// Log out of ZIM service.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: Log out of the ZIM service.
  /// Use cases: This function must be called from the instance after it has been created by calling [create].
  /// When to call: After invoking [logout], you can no longer use ZIM's chat, room, send and receive, and other functions. To use the ZIM service again, the developer must call [login] to login again.
  /// Caution: Upon logout, the developer will receive the [onConnectionStateChanged] callback with the login state being [Disconnected].
  logout();

  /// Update the authentication token.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: Update the authentication token so that the authentication token can be updated in time after it expires, so as to continue to use ZIM functions normally.
  /// Use cases: When you need to create a multi-person chat scene, you can create and join a room by this API.
  /// When to call: This function must be called through the instance after calling [create] to create the instance.
  /// Life cycle: The life cycle of this function depends on the validity period of the authentication token, which is determined by the developer business.
  /// References: For details, please refer to the Token generation documentation.
  /// Caution: After the developer receives the [onTokenWillExpire] callback, the developer needs to request the authentication server to regenerate a token in time.
  ///
  /// - [token] The token issued by the developer's business server, used to ensure security. The generation rules are detailed in ZEGO document website.
  Future<ZIMTokenRenewedResult> renewToken(String token);

  /// Call the experimental API.
  ///
  /// ZEGO provides some technical previews or special customization functions in ZIM business through this API. If you need to get the use of the function or the details, please consult ZEGO technical support.
  ///
  /// - [params] Parameters in the format of a JSON string, please consult ZEGO technical support for details.
  Future<String> callExperimentalAPI(String params);

  /// Update user's user name.
  ///
  /// Available since: 2.2.0 or above.
  /// Description: After user logs in, calling this interface could update the user's own user name.
  /// When to call: After the user is logged in.
  /// Caution: This interface does not support modifying user names in rooms.
  /// Privacy statement: Try not to pass in sensitive information involving personal privacy, including but not limited to mobile phone numbers, ID numbers, passport numbers, real names, etc.
  /// Related callbacks: [ZIMUserNameUpdatedResult].
  /// Related APIs: [updateUserExtendedData] and [queryUsersInfo].
  ///
  /// - [userName] User name , It is customized by the developer. For version 2.0.0 and onwards, the string has a maximum length of 256 bytes.
  Future<ZIMUserNameUpdatedResult> updateUserName(String userName);

  /// Update user's avatar URL.
  ///
  /// Available since: 2.3.0 and above.
  /// Description: After the user logs in, calling this interface can set or update the user's own user avatar URL.
  /// When to call: After the user logs in.
  /// Caution: The user avatar itself needs to be stored by the developer, and ZIM only saves its user information as a pass-through URL.
  /// Restrictions: There is no limit on special characters and a maximum of 500 bytes.
  /// Related callbacks: [ZIMUserAvatarUrlUpdatedResult].
  /// Related APIs: [queryUsersInfo].
  ///
  /// - [userAvatarUrl] User avatar URL wanted to changed to.
  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(
    String userAvatarUrl,
  );

  /// Update user's user extended data.
  ///
  /// Available since: 2.2.0 or above.
  /// Description: After user logs in, calling this interface could update the user's own user extended data.
  /// When to call: After the user is logged in.
  /// Privacy statement: Try not to pass in sensitive information involving personal privacy, including but not limited to mobile phone numbers, ID numbers, passport numbers, real names, etc.
  /// Related callbacks: [ZIMUserExtendedDataUpdatedResult].
  /// Related APIs: [updateUserName] and [ queryUsersInfo ].
  ///
  /// - [extendedData] User extended data wanted to changed to .
  Future<ZIMUserExtendedDataUpdatedResult> updateUserExtendedData(
    String extendedData,
  );

  /// Update user's custom rule of offline push.
  ///
  /// Available since: 2.15.0 and later versions.
  /// Description: This interface is used to modify the custom rule of offline push for the current user.
  /// Use cases: For example, in the multi-terminal login scenario, the developer hopes that when the desktop is online, the mobile terminal does not want to receive offline push. In this scenario, the interface can be invoked to achieve this function.
  /// When to call: You can call it after you log in and the network is in good condition.
  /// Caution: After the interface is successfully invoked, all ends will receive onUserRuleUpdate notifying the user that the rule has been updated.
  /// Related callbacks: onUserRuleUpdate、ZIMUserOfflinePushRuleUpdatedCallback
  /// Related APIs: querySelfUserInfo
  ///
  /// - [offlinePushRule] The user pushes the rule information offline, and the interface will be fully updated with the member properties of the input object each time the interface is called.
  Future<ZIMUserOfflinePushRuleUpdatedResult> updateUserOfflinePushRule(
    ZIMUserOfflinePushRule offlinePushRule,
  );

  /// Update user's custom status.
  ///
  /// Use cases: After login, call the interface to modify the current user's custom status as 'do not disturb', 'busy' and other states.
  /// When to call: After an online login and a network connection exists.
  /// Related callbacks: After the interface is successfully invoked to update the user-defined status, other devices that are logged in to multiple devices and users who subscribe to the current user status through subscribeUsersStatus receive onUserStatusUpdated and updates the user-defined status of the current user.
  ///
  /// - [customStatus] User custom status.
  /// - [config] Config of user custom status.
  Future<ZIMUserCustomStatusUpdatedResult> updateUserCustomStatus({
    required String customStatus,
    ZIMUserCustomStatusUpdateConfig? config,
  });

  /// Update the number of iOS offline notification badges.
  ///
  /// Available since: 2.28.0 or above.
  /// Description: This API updates the APP badge count on the current user’s mobile clients. It applies to the user on mobile devices where they have logged in.
  /// Use cases: In multi-device login scenarios, after the developer clears unread counts (or when unread counts change) on desktop or web, and wants mobile users’ APP badge counts to reflect and sync to the corresponding value, this API can be called to achieve that.
  /// When to call: After login, with a good network connection, and when the total unread count changes. It only needs to be called on non-mobile platforms that do not support ZPNs (such as desktop and web).
  /// Caution: After a successful call, the APP badge value will be updated to the specified value on all offline mobile clients where the user has logged in.
  /// Related callbacks: [ZIMUserBadgeUpdatedCallback].
  ///
  /// - [badge] The user’s expected APP badge value.
  Future<void> updateUserBadge({required int badge});

  /// Query user information.
  ///
  /// Available since: 2.3.0 or above.
  /// Description: Through this interface, you can query and obtain the corresponding UserInfo by userID.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMUsersInfoQueriedResult].
  /// Restrictions: No more than 10 userids can be queried by invoking the interface at a time. If the interface is invoked multiple times within 10 seconds, the total number of userids queried cannot exceed 10.
  ///
  /// - [userIDs] userID list.
  /// - [config] Query user information configuration.
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
    List<String> userIDs,
    ZIMUserInfoQueryConfig config,
  );

  /// Query the user statuses of other users.
  ///
  /// Available since: 2.18.0
  /// Description: Query the user statuses of other users.
  /// Use cases: When you do not need to continuously follow the user statuses of certain users but only need to obtain their user statuses once, you can use this method.
  /// When to call: Can be called after login and when the network conditions are good.
  /// Caution: The query targets can not include unregistered users.
  /// Related callbacks: ZIMUsersStatusQueriedCallback.
  ///
  /// - [userIDs] User ID list.
  Future<ZIMUsersStatusQueriedResult> queryUsersStatus(List<String> userIDs);

  /// Query user information and user rules.
  ///
  /// Available since: 2.15.0 .
  /// Description: Query information about the current user and user rules. In offline state, you can query local data.
  /// Use cases: If you need to display the user information and rules, you can invoke the query, for example, to enter the personal page of the current user.
  /// When to call: Call after login.
  /// Restrictions: ZIMSelfUserInfoQueriedCallback、userInfoUpdated、userRuleUpdated
  Future<ZIMSelfUserInfoQueriedResult> querySelfUserInfo();

  /// Subscribe to the user status of other users
  ///
  /// Available since: 2.18.0
  /// Description: Subscribing to the user status of other users through this interface.
  /// Use cases: When you enter the group/room/friends list and need to know which room/group members/friends are online, subscribe through this interface. When the user status of these users is updated successfully, the [onUserStatusUpdated] interface is updated.
  /// When to call: Can be called when the login is successful and the network conditions are good.
  /// Restrictions: The maximum number of subscribers is 100. By default, a single user can subscribe to a maximum of 3000 users. When the number of subscribers reaches the upper limit, the new subscribers will overwrite the original subscribers.
  /// Caution: You cannot subscribe to the current login user through this interface. The subscribed user must be registered.
  /// Related callbacks: [ZIMUsersStatusSubscribedResult],[onUserStatusUpdated]
  /// Related APIs: [unsubscribeUsersStatus]
  ///
  /// - [userIDs] User ID list.
  /// - [config] Configuration for subscribing to user status.
  Future<ZIMUsersStatusSubscribedResult> subscribeUsersStatus(
    List<String> userIDs,
    ZIMUserStatusSubscribeConfig config,
  );

  /// This command is used to batch unsubscribe the target users in the current user subscription list.
  ///
  /// Available since: 2.18.0
  /// Description: Batch unsubscribe the target user in the current user subscription list.
  /// Use cases: In non-multi-terminal login scenarios, when you leave a room or group, if you no longer follow the user status of the room or group members for a short period of time, and you have subscribed to the user status of the room or group members when you enter the room or group, you can unsubscribe through this interface.
  /// When to call: Called after login and when the network is in good condition.
  /// Restrictions: The maximum number of userids passed in at a time is 100.
  /// Caution: You cannot cancel a user that is not in the current user subscription list.
  /// Related callbacks: ZIMUsersStatusUnsubscribedCallback.
  /// Related APIs: subscribeUsersStatus、queryUsersStatus、querySubscribedUserStatusList.
  ///
  /// - [userIDs] User ID list.
  Future<ZIMUsersStatusUnsubscribedResult> unsubscribeUsersStatus(
    List<String> userIDs,
  );

  /// This command is used to query the user status subscription list of the current user.
  ///
  /// Available since: 2.18.0
  /// Description: This command is used to query the user status subscription list of the current user.
  /// Use cases: Through this interface, you can obtain the local cache of the user status subscription list of the current user, so that you can know which users the current user has subscribed to, obtain the subscription expiration time of the subscriber, and obtain the status data of the subscriber when it changed last time.
  /// When to call: It can be called after login, regardless of network status.
  /// Restrictions: The data obtained is the local cache of the SDK. When the network conditions are good after login, the SDK periodically synchronizes data to the background.
  /// Related callbacks: ZIMSubscribedUserStatusListQueriedCallback、subscribeUsersStatus、unsubscribeUsersStatus.
  /// Related APIs: subscribeUsersStatus、unsubscribeUsersStatus.
  ///
  /// - [config] Configuration for querying subscribed user status list.
  Future<ZIMSubscribedUserStatusListQueriedResult>
  querySubscribedUserStatusList(ZIMSubscribedUserStatusQueryConfig config);

  /// Query the conversation list.
  ///
  /// Use cases: This interface can be invoked to get the data source when you need to display an existing message session after logging in.
  /// When to call: Can be invoked after login.
  /// Caution: NextConversation is the riveting point of the query message, which can be [null] for the first query. In subsequent query, the earliest conversation can be used as nextConversation to query earlier sessions. In paging query, Count in ZIMConversationQueryConfig fill each pull the number of sessions.
  /// Related callbacks: ZIMConversationListQueriedCallback.
  /// Related APIs: deleteConversation Deletes the session. clearConversationUnreadMessageCount clear session readings.
  ///
  /// - [config] Configuration for session queries.
  /// - [option] Filter options for session queries.
  Future<ZIMConversationListQueriedResult> queryConversationList(
    ZIMConversationQueryConfig config, [
    ZIMConversationFilterOption? option,
  ]);

  /// Query a conversation by conversation ID and conversation type.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method displays the session list of the logged in user.
  /// Use cases: When you need to know the relevant information of the specified conversation, you can call this interface to obtain the data source.
  /// When to call: Can be invoked after login.
  /// Restrictions: There is no limit to the frequency of use, available after login, unavailable after logout.
  /// Related callbacks: [ZIMConversationQueriedResult].
  ///
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMConversationQueriedResult> queryConversation(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Query the conversation pinned list.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method displays the pinned conversation list of the logged in user.
  /// Use cases: This interface can be invoked to get the data source when you need to display an existing pinned message conversation after logging in.
  /// When to call: Can be invoked after login.
  /// Restrictions: There is no limit to the frequency of use, available after login, unavailable after logout.
  /// Caution: NextConversation is the riveting point of the query message, which can be [null] for the first query. In subsequent query, the earliest conversation can be used as nextConversation to query earlier sessions. In paging query, Count in [ZIMConversationQueryConfig] fill each pull the number of sessions.
  ///
  /// - [config] Configuration for session queries.
  Future<ZIMConversationPinnedListQueriedResult> queryConversationPinnedList(
    ZIMConversationQueryConfig config,
  );

  /// Modify the conversation pinned state.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method can modify the pinned state of the specified conversation of the logged-in user.
  /// Use cases: You can call this interface when you need to modify the pinned state of a conversation.
  /// When to call: Can be invoked after login.
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: [ZIMConversationPinnedStateUpdatedResult].
  ///
  /// - [isPinned] Whether the conversation is pinned, [true] is pinned, [false] is unpinned.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMConversationPinnedStateUpdatedResult> updateConversationPinnedState(
    bool isPinned,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// delete the conversation.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: This interface is invoked when a session needs to be deleted. All members in the session can invoke this interface.
  /// Use cases: You can invoke this interface implementation to delete an entire session when it is no longer needed.
  /// When to call: his parameter is invoked when a session needs to be deleted and can be invoked after a ZIM instance is created. The call takes effect after login and becomes invalid after logout.
  /// Scope of impact: A successful call triggers the deleteConversation callback. If the deleted conversation contains unread messages, the [onConversationTotalUnreadMessageCountUpdated] callback is triggered.
  /// Related callbacks: [ZIMConversationDeletedResult]
  ///
  /// - [conversationID] conversationID.
  /// - [conversationType] conversationtype.
  /// - [config] delete the session's configuration.
  Future<ZIMConversationDeletedResult> deleteConversation(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMConversationDeleteConfig config,
  );

  /// delete all conversations.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: This interface is invoked when all conversations needs to be deleted. All members in conversations can invoke this interface.
  /// Use cases: If you want to delete all conversations when they are no longer needed, you can call this interface implementation.
  /// When to call: his parameter is invoked when conversations needs to be deleted and can be invoked after a ZIM instance is created. The call takes effect after login and becomes invalid after logout.
  /// Scope of impact: If deleted conversations include unread message will trigger the [onConversationTotalUnreadMessageCountUpdated] callback, the call is successful at login, and the other end will trigger [onConversationsAllDeleted] callback.
  /// Related callbacks: [ZIMConversationsAllDeletedResult]
  ///
  /// - [config] delete all conversation's configuration.
  Future<void> deleteAllConversations(ZIMConversationDeleteConfig config);

  /// clear session unreads.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Used to clear unread for the current user target session.
  /// Use cases: This interface is called when a chat page is entered from a session and the original message readings of the session need to be cleared.
  /// When to call: Called when a target needs to be cleared without readings.
  /// Restrictions: Valid after login, invalid after logout.
  /// Scope of impact: Calling this method will trigger a total readings not updated callback [onConversationTotalUnreadMessageCountUpdated], would trigger a session to update callbacks [onConversationChanged].
  /// Related callbacks: [ZIMConversationUnreadMessageCountClearedResult].
  /// Related APIs: [onConversationTotalUnreadMessageCountUpdated]、[onConversationChanged].
  ///
  /// - [conversationID] conversationID.
  /// - [conversationType] conversation type.
  Future<ZIMConversationUnreadMessageCountClearedResult>
  clearConversationUnreadMessageCount(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// clear all conversations unreads.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: Used to clear unread for all conversations.
  /// Use cases: You can call this interface when you need to clear all unread conversations to zero.
  /// When to call: Called when all conversation readings need to be cleared.
  /// Restrictions: Valid after login, invalid after logout.
  /// Scope of impact: Calling this method will trigger a total readings not updated callback [onConversationTotalUnreadMessageCountUpdated].
  /// Related callbacks: [ZIMConversationTotalUnreadMessageCountClearedResult].
  /// Related APIs: [onConversationTotalUnreadMessageCountUpdated].
  Future<void> clearConversationTotalUnreadMessageCount();

  /// Query the conversations total unread message count by config.
  ///
  /// Available since: 2.17.0 and above.
  /// Description: his method can query the total number of unread messages in the conversations of the logged-in user according to the configuration items.
  /// Use cases: This interface can be invoked to get the data source when you need to display an existing message conversation after logging in.
  /// When to call: Can be called after logging in.
  /// Restrictions: There is no limit on the frequency of use; it is available after logging in and not available after logging out.
  /// Related callbacks: [ZIMConversationTotalUnreadMessageCountQueriedResult].
  ///
  /// - [config] Configuration for querying the total unread count of the conversation.
  Future<ZIMConversationTotalUnreadMessageCountQueriedResult>
  queryConversationTotalUnreadMessageCount(
    ZIMConversationTotalUnreadMessageCountQueryConfig config,
  );

  /// Set the conversation notification state.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: This method enables DND by selecting whether the unread of the target session is updated when a message is received. For conversations where Do Not Disturb is enabled, offline push notifications for that conversation are generally not received, unless the conversation is a group chat, the message sender has mentioned the current user, and the isNotifyMentionedUsers property in ZIMMessageSendConfig is set to true. In that case, the user will receive offline push notifications for that conversation.
  /// Use cases: If the user selects MESSAGE DO not Disturb (DND), the user can call the corresponding method.
  /// Default value: Message DND is disabled by default.
  /// When to call: If the target session exists after login, invoke this interface if you want to enable the DND status of the target session.
  /// Restrictions: Valid after login, invalid after logout.
  /// Scope of impact: After the DND state is enabled, receiving messages is not triggered [conversationTotalUnreadMessageCountUpdated]。
  /// Related callbacks: [ZIMConversationNotificationStatusSetResult]。
  /// Related APIs: [conversationTotalUnreadMessageCountUpdated]。
  ///
  /// - [status] the session notification state.
  /// - [conversationID] Conversation ID. Currently, only "group" conversations and "peer"(only for 2.14.0 or above version)  conversations can be set by notification state.
  /// - [conversationType] Conversation type, such as peer, group, etc.
  Future<ZIMConversationNotificationStatusSetResult>
  setConversationNotificationStatus(
    ZIMConversationNotificationStatus status,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Sets all received receipts for the conversation as read.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: Set all received receipts of the conversation to be read.
  /// Use cases: Set all received receipt messages in the entire conversation to be read, and the sender of the message receipt in the conversation will receive the [onConversationMessageReceiptChanged] callback from ZIMEventHandler.
  /// When to call: It can be called after login. It is recommended to call before entering the message list page. In the message list page, it is recommended to call [sendMessageReceiptsRead] to batch set the messages that need to be read.
  /// Caution: Only single chat conversation are allowed.
  /// Related callbacks: [ZIMConversationMessageReceiptReadSentResult].
  /// Related APIs: [sendMessageReceiptsRead], [sendMessage].
  ///
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type, such as peer, group, etc.
  Future<ZIMConversationMessageReceiptReadSentResult>
  sendConversationMessageReceiptRead(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Set a conversation draft.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: When you need to set a draft for a session, call this interface, and members of the session can call this interface.
  /// Use cases: This interface can be invoked when you need to temporarily save the text message that the user is editing but has not yet sent.
  /// When to call: Call when you need to set session draft, call after creating ZIM instance, take effect after login, invalid after logout.
  /// Scope of impact: A successful call triggers the [onConversationChanged] callback.
  /// Related callbacks: [ZIMConversationDraftSetResult]
  ///
  /// - [draft] Drafts that need to be set.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type, such as peer, group, etc.
  Future<ZIMConversationDraftSetResult> setConversationDraft(
    String draft,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Set the conversation marked status.
  ///
  /// Available since: 2.17.0 and above.
  /// Description: This method can set marks for the conversation.
  /// Use cases: When you need to implement custom business logic based on conversation marks.
  /// Default value: The conversation marks defaults to empty.
  /// When to call: When logged in and a valid conversation exists, if you want to set or unset mark for the target conversation, call this interface.
  /// Restrictions: The range for setting marks is [1, 20]. A maximum of 100 conversations are supported for marking at one time.
  /// Related callbacks: [ZIMConversationMarkSetResult]。
  ///
  /// - [markType] Mark value that needs to be set.
  /// - [enable] Whether to enable the mark value.
  /// - [conversationInfos] Conversation information list that needs to be set.
  Future<ZIMConversationMarkSetResult> setConversationMark(
    int markType,
    bool enable,
    List<ZIMConversationBaseInfo> conversationInfos,
  );

  /// Set the timed message self-destruction duration for a conversation.
  ///
  /// Available since: 3.0.0 and above.
  /// Description: Call this API when you need messages in a conversation to be automatically destroyed after being sent. By default, all members in the conversation can call this API.
  /// Use cases: This API can be used when users have higher sensitivity or security requirements in conversation chats.
  /// When to call: Can be called after creating a ZIM instance. Takes effect after login and becomes invalid after logout.
  /// Scope of impact: After a successful call, the setting takes effect for both the local and peer users in peer-to-peer conversations simultaneously, and for all members in group conversations.
  /// Caution: In group chat scenarios, all group members can configure this setting by default. The permission can be restricted to group owners or administrators only.
  /// Related callbacks: [ZIMConversationMessageDestructDurationSetResult].
  ///
  /// - [duration] The message self-destruction duration to set for the conversation.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type, such as peer, group, etc.
  Future<ZIMConversationMessageDestructDurationSetResult>
  setConversationMessageDestructDuration({
    required int duration,
    required String conversationID,
    required ZIMConversationType conversationType,
  });

  /// Search local conversations on local messages.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: This method is used for searching local conversations based on local messages.
  /// Use cases: When there is a need to search conversations using keywords or other conditions, this API can be called for searching.
  /// When to call: It should be invoked when there is a requirement to search conversations using keywords or other conditions.
  /// Restrictions: effective after logging in and becomes invalid after logging out. Searching is not supported in room scenarios (conversationType=1).
  /// Related callbacks: [ZIMConversationsSearchedResult].
  ///
  /// - [config] Global search conversation config.
  Future<ZIMConversationsSearchedResult> searchLocalConversations(
    ZIMConversationSearchConfig config,
  );

  /// send message.
  ///
  /// Available since: 2.4.0 and above.
  /// Description: This method can be used to send messages in single chat, room and group chat.
  /// Use cases: When you need to send message to the target user, target message room, and target group chat after logging in, send it through this interface.
  /// When to call: It can be called after login.
  /// Restrictions: The interval between sending messages should be greater than 100ms. Available after login, unavailable after logout.
  /// Related callbacks: [ZIMMessageSentResult], [ZIMMessageSendNotification], [onPeerMessageReceived], [onRoomMessageReceived], [onGroupMessageReceived], [onConversationChanged], [onConversationTotalUnreadMessageCountUpdated].
  /// Related APIs: [queryHistoryMessage], [deleteAllMessage], [deleteMessages],[sendMediaMessage].
  ///
  /// - [message] The message to be sent.
  /// - [toConversationID] The conversation ID the message needs to be sent.
  /// - [conversationType] The conversation type the message needs to be sent.
  /// - [config] Related configuration for sending messages.
  /// - [notification] Related notifications when messages are sent.
  Future<ZIMMessageSentResult> sendMessage(
    ZIMMessage message,
    String toConversationID,
    ZIMConversationType conversationType,
    ZIMMessageSendConfig config, [
    ZIMMessageSendNotification? notification,
  ]);

  /// Download media file message content.
  ///
  /// Available since: 2.19.0 and above.
  /// Description: This method can be used to download the content of media messages, including the original image, large image, thumbnail image, file message, audio message, video message and the first frame of the image message.
  /// Use cases: After the user receives a message, if the message is a media message, he can call this API to download its content.You cannot Download Network urls before 2.9.0.
  /// When to call: can be invoked after logging in and receiving a media message.
  /// Caution: If [sendMediaMessage] sends a network URL, SDK earlier than 2.9.0 cannot be downloaded through this interface.
  /// Restrictions: If you download an external URL, you can only download a maximum of 200MB of resources. For configuration, please contact ZEGO technical support.
  /// Related callbacks: [ZIMMediaDownloadedResult], [ZIMMediaDownloadingProgress].
  ///
  /// - [message] The media message to download.
  /// - [fileType] Media file type.
  /// - [config] Download media file configuration.
  /// - [progress] Progress callback for downloading media files.
  Future<ZIMMediaDownloadedResult> downloadMediaFile(
    ZIMMessage message,
    ZIMMediaFileType fileType,
    ZIMMediaDownloadConfig config,
    ZIMMediaDownloadingProgress progress,
  );

  /// Query historical messages.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: This method is used to query historical messages.
  /// Use cases: When you need to obtain past historical messages, you can call this interface to query historical messages by paging.
  /// When to call: Called when historical messages need to be queried.
  /// Restrictions: Effective after login, invalid after logout. In the default room scenario (conversationType=1), offline message is disabled. If you need to enable it, please contact the corresponding technical support.
  /// Related callbacks: [ZIMMessageQueriedResult].
  ///
  /// - [conversationID] The session ID of the queried historical message.
  /// - [conversationType] conversation type.
  /// - [config] Query the configuration of historical messages.
  Future<ZIMMessageQueriedResult> queryHistoryMessage(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageQueryConfig config,
  );

  /// Query messages based on the message seq list.
  ///
  /// Available since: 2.19.0 and above.
  ///
  /// - [messageSeqs] The list of message sequence numbers to query.
  /// - [conversationID] The session ID of the queried message.
  /// - [conversationType] conversation type.
  Future<ZIMMessageQueriedResult> queryMessages(
    List<int> messageSeqs,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// delete message.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: This method implements the function of deleting messages.
  /// Use cases: The user needs to delete a message. When the user does not need to display a message, this method can be used to delete it.
  /// When to call: Called when the message needs to be deleted.
  /// Caution: The impact of deleting messages is limited to this account.
  /// Restrictions: Effective after login.
  /// Scope of impact: If the deleted message is the latest message of the session, the [conversationChanged] callback will be triggered, and if the message is unread, the [conversationTotalUnreadMessageCountUpdated] callback will be triggered.
  /// Related callbacks: [ZIMMessageDeletedResult]、[conversationChanged]、[conversationTotalUnreadMessageCountUpdated].
  ///
  /// - [messageList] List of deleted messages.
  /// - [conversationID] The session ID of the deleted message.
  /// - [conversationType] conversation type.
  /// - [config] Delete the configuration of the message.
  Future<ZIMMessageDeletedResult> deleteMessages(
    List<ZIMMessage> messageList,
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageDeleteConfig config,
  );

  /// Delete all message.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: When you need to delete all messages under the target session, call this method.
  /// Use cases: If you want to implement a group setting page to clear the chat information under the current session, you can call this interface.
  /// When to call: The target session exists and the user is a member of this session.
  /// Restrictions: Effective after login, invalid after logout.
  /// Caution: The impact of deleting messages is limited to this account, and messages from other accounts will not be deleted.
  /// Scope of impact: The [conversationChanged] callback is triggered, and if there are unread messages, the [conversationTotalUnreadMessageCountUpdated] callback is triggered.
  /// Related callbacks: [ZIMMessageDeletedResult].
  ///
  /// - [conversationID] The session ID of the message to be deleted.
  /// - [conversationType] conversation type.
  /// - [config] delete message configuration.
  Future<ZIMMessageDeletedResult> deleteAllMessage(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageDeleteConfig config,
  );

  /// Delete all messages for all conversations.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: This method implements the function of deleting all messages for all sessions.
  /// Use cases: The user needs to delete a message. When the user does not need to display a message, this method can be used to delete it.
  /// When to call: Called when you need to delete all messages for all sessions.
  /// Caution: IsAlsoDeleteServerMessage decided whether to delete a server message, the impact of deleting messages is limited to this account.
  /// Restrictions: Effective after login.
  /// Scope of impact: Call the interface trigger [onMessageDeleted] callback, if there are unread messages at this time, will trigger  [onConversationTotalUnreadMessageCountUpdated] callback.
  /// Related callbacks: [ZIMConversationMessagesAllDeletedResult]、[onMessageDeleted]、[onConversationTotalUnreadMessageCountUpdated].
  ///
  /// - [config] delete message configuration.
  Future<void> deleteAllConversationMessages(ZIMMessageDeleteConfig config);

  /// Insert a message to the local DB.
  ///
  /// Available since: 2.4.0 and above.
  /// Description: This method can insert a message directly to the local DB on the client side.
  /// Use cases: The developer can combine the system message type, and convert the callback notification (for example, invite someone into the group, remove someone from the group, etc.) to the system message type on the client side and insert it into the local DB to achieve the effect of the system prompt .
  /// When to call: It can be called after login.
  /// Caution: Inserting "command" messages is not supported. To insert a "room" message, upgrade the SDK to 2.13.0 and above.
  /// Related callbacks: [ZIMMessageInsertedResult].
  /// Related APIs: [queryHistoryMessage], [deleteAllMessage], [deleteMessages].
  ///
  /// - [message] The message to be sent.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  /// - [senderUserID] The sender ID of this message.
  Future<ZIMMessageInsertedResult> insertMessageToLocalDB(
    ZIMMessage message,
    String conversationID,
    ZIMConversationType conversationType,
    String senderUserID,
  );

  /// Set the receipt of a batch of messages to become read.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This method can set the receipt of a batch of messages to become read.
  /// Use cases: Developers can use this method to set a batch of messages with receipts that have been read. If the sender is online, it will receive the [onMessageReceiptChanged] callback.
  /// When to call: Callable after login. It is recommended to set the settings for the messages that need to be read on the message list page. It is not recommended to mix with [sendConversationMessageReceiptRead].
  /// Restrictions: Only support the settings for received messages with receipt status as PROCESSING.
  /// Related callbacks: [ZIMMessageReceiptsReadSentResult].
  /// Related APIs: [sendMessage].
  ///
  /// - [messageList] The list of messages to be read with no more than 10 messages.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMMessageReceiptsReadSentResult> sendMessageReceiptsRead(
    List<ZIMMessage> messageList,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Query the receipt information of a batch of messages.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This method can query the receipt information of a batch of messages, including the status, the number of unread users and the number of read users.
  /// Use cases: If you need to query the receipt status of the message, the number of unread users and the number of read users, you can call this interface.
  /// When to call: Callable after login. If you need to query the detailed member list, you can query through the interface [queryGroupMessageReceiptReadMemberList] or [queryGroupMessageReceiptUnreadMemberList].
  /// Restrictions: Only messages whose statuses are not NONE and UNKNOWN are supported.
  /// Related callbacks: [ZIMMessageReceiptsInfoQueriedResult].
  /// Related APIs: [queryGroupMessageReceiptReadMemberList] , [queryGroupMessageReceiptUnreadMemberList].
  ///
  /// - [messageList] list of messages to query.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMMessageReceiptsInfoQueriedResult> queryMessageReceiptsInfo(
    List<ZIMMessage> messageList,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// revoke message.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This method implements the function of message recall. The interface only allows recalling messages within 2 minutes. If you need to recall messages sent earlier, please contact technical support.
  /// Use cases: The user needs to recall a message. This method can be used when the user does not want other users to see the message.
  /// When to call: Called when the message needs to be revoked.
  /// Caution: Room message revoke is not supported.
  /// Restrictions: Login is required to use. To revoke messages from other members within the group, the group owner needs to use version 2.9.0 or above.
  /// Related callbacks: If the revoked message is the latest message of the session, the [onConversationChanged] callback will be triggered, and if the message is unread, the [onConversationTotalUnreadMessageCountUpdated] callback will be triggered.
  ///
  /// - [message] The message needs to be revoke.
  /// - [config] Revoke the configuration of the message.
  Future<ZIMMessageRevokedResult> revokeMessage(
    ZIMMessage message,
    ZIMMessageRevokeConfig config,
  );

  /// Update the local expandable field of the message.
  ///
  /// Available since: 2.2.0 or above.
  /// Description: After the user logs in, calling this interface allows updating the local expandable field of the message.
  /// When to call: After the user is logged in.
  /// Privacy statement: Please avoid passing sensitive personal information, including but not limited to phone numbers, ID card numbers, passport numbers, real names, etc.
  /// Related callbacks: [ ZIMMessageLocalExtendedDataUpdatedResult ].
  ///
  /// - [localExtendedData] The expandable message field visible only on this end can store additional information locally and currently has a length limit of 128K. If you have special requirements, please contact ZEGO technical support for configuration.
  /// - [message] Message body to be updated
  Future<ZIMMessageLocalExtendedDataUpdatedResult>
  updateMessageLocalExtendedData(String localExtendedData, ZIMMessage message);

  /// Edit message.
  ///
  /// Available since: 2.20.0 and above.
  /// Description: This method can be used to edit messages in single chat, group chat.
  /// Use cases: When you need to edit message to the target user, target group chat after logging in, edit it through this interface.
  /// Related callbacks: [ZIMMessageSendNotification], [ZIMMessageEditedResult], [onMessageEdited], [onConversationChanged], [onMessageRepliedInfoChanged].
  /// Related APIs: [queryHistoryMessage], [sendMessage].
  ///
  /// - [message] The message needs to be edited.
  /// - [config] Edit the configuration of the message.
  /// - [notification] Message send notification object (optional).
  Future<ZIMMessageEditedResult> editMessage(
    ZIMMessage message,
    ZIMMessageEditConfig config,
    ZIMMessageSendNotification? notification,
  );

  /// Cancels sending of media message.
  ///
  /// Available since: 2.22.0 and above.
  /// Description: This method can be used to cancel the sending of a local media file upload message.
  /// Related APIs: [queryHistoryMessage], [sendMessage].
  ///
  /// - [message] The message needs to be cancelled to be sent.
  /// - [config] The configuration of cancelling to be sent message.
  Future<void> cancelSendingMessage(
    ZIMMessage message,
    ZIMSendingMessageCancelConfig config,
  );

  /// Search local message list.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: This method is used to search local messages.
  /// Use cases: When it is necessary to search for past local messages based on keywords or other conditions, this interface can be called to perform pagination search for local messages.
  /// Restrictions: Effective after login, invalid after logout. Searching is not supported in the room scene (conversationType=1).
  /// Related callbacks: [ZIMMessagesSearchedResult].
  ///
  /// - [conversationID] The conversation ID of the local message to be search.
  /// - [conversationType] conversation type.
  /// - [config] Search the configuration of local messages.
  Future<ZIMMessagesSearchedResult> searchLocalMessages(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageSearchConfig config,
  );

  /// Search global local message list.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: This method is used to search global local messages.
  /// Use cases: When there is a need to perform a global search of previous local messages based on keywords or other conditions, you can invoke this interface to search local messages by grouping them according to conversations.
  /// Restrictions: Effective after login, invalid after logout. Searching global is not supported in the room scene (conversationType=1).
  /// Related callbacks: [ZIMMessagesGlobalSearchedResult].
  ///
  /// - [config] Search global the configuration of local messages.
  Future<ZIMMessagesGlobalSearchedResult> searchGlobalLocalMessages(
    ZIMMessageSearchConfig config,
  );

  /// add message reaction
  ///
  /// Available since: 2.28.0 and above.
  /// Description: Message reaction refers to the user's response to a message. It can generally be used to add or remove emoticons for single chat or group chat messages, as well as to initiate group voting, confirm group results, and other operations.
  /// Use cases: Users need to express their position on a certain message, such as liking, and this method can be used to express their position.
  /// Caution: Room message reaction is not supported.
  /// Restrictions: You can only use it after logging in. And only supports message reactions for single chat and group chat
  /// Related callbacks: If the addition is successful, the [onMessageReactionsChanged] callback will be triggered. If the reaction is made to the latest message in the conversation, the [onConversationChanged] callback will be triggered when the addition is successful.
  ///
  /// - [reactionType] Type of reaction, defined by you, with a maximum length of 32 bytes.
  /// - [message] The message needs reaction.
  /// - [config] Added configuration for reactions. It now supports reacting multiple times to the same item and increases the aggregated count accordingly.
  Future<ZIMMessageReactionAddedResult> addMessageReaction({
    required String reactionType,
    required ZIMMessage message,
    ZIMMessageReactionAddConfig? config,
  });

  /// delete message reaction
  ///
  /// Available since: 2.10.0 and above.
  /// Description: Delete the reaction made by the local user.
  /// Use cases: Users need to delete the status of a message that has already been stated, which can be done using this method.
  /// Caution: Room message reaction is not supported.
  /// Restrictions: You can only use it after logging in. And only supports message statements for single chat and group chat
  /// Related callbacks: If the deletion is successful, the [onMessageReactionsChanged] callback will be triggered. If the reaction is deleted from the latest message in the conversation, the [onConversationChanged] callback will be triggered when the addition is successful.
  ///
  /// - [reactionType] Reaction type. It must be the type of reaction made by the local user.
  /// - [message] The message needs reaction delete.
  Future<ZIMMessageReactionDeletedResult> deleteMessageReaction({
    required String reactionType,
    required ZIMMessage message,
  });

  /// Delete all of your reactions under this message
  ///
  /// Available since: 2.28.0 and above.
  /// Description: Delete all reactions made by the local user.
  /// Use cases: Users need to delete the status of a message that has already been stated, which can be done using this method.
  /// Caution: Room message reaction is not supported.
  /// Restrictions: You can only use it after logging in. And only supports message statements for single chat and group chat
  /// Related callbacks: If the deletion is successful, the [onMessageReactionsChanged] callback will be triggered. If the reaction is deleted from the latest message in the conversation, the [onConversationChanged] callback will be triggered when the addition is successful.
  ///
  /// - [message] The message needs reaction delete.
  Future<void> deleteMessageAllReactions({required ZIMMessage message});

  /// query message reaction userlist
  ///
  /// Available since: 2.10.0 and above.
  /// Description: This method is used to query specific user information under a certain state of a message.
  /// Use cases: When it is necessary to obtain specific user information under a certain state of a message, this interface can be called to query state user messages in a paginated manner.
  /// When to call: Call when you need to query reaction user information.
  /// Restrictions: You can only use it after logging in. And only supports message statements for single chat and group chat
  ///
  /// - [message] The message needs querying reaction user list.
  /// - [config] reaction user query config.
  Future<ZIMMessageReactionUserListQueriedResult> queryMessageReactionUserList(
    ZIMMessage message,
    ZIMMessageReactionUserQueryConfig config,
  );

  /// query combine message detail
  ///
  /// Available since: 2.14.0 and above.
  /// Description: This method is used to query the sub-messages of the combine message.
  /// Use cases: If you need to obtain the specific sub-messages under the combine message, you can call this API to query.
  /// When to call: Call when you need to query the sub-messages of a combine message.
  /// Restrictions: You can only use it after logging in.
  ///
  /// - [message] The combine message needs querying message list.
  Future<ZIMCombineMessageDetailQueriedResult> queryCombineMessageDetail(
    ZIMCombineMessage message,
  );

  /// send reply message.
  ///
  /// Available since: 2.17.0 and above.
  /// Description: This method can be used to send reply messages in single chat and group chat.
  /// Use cases: When you need to send reply message to the target user and target group chat after logging in, send it through this interface.
  /// When to call: It can be called after login.
  /// Restrictions: The interval between sending messages should be greater than 100ms. Available after login, unavailable after logout.
  /// Related callbacks: [onPeerMessageReceived], [onGroupMessageReceived].
  /// Related APIs: [queryHistoryMessage], [sendMessage], [sendMediaMessage].
  ///
  /// - [message] The message needs to be sent.
  /// - [toOriginalMessage] The message needs to be replied.
  /// - [config] The configuration of the message needs to be sent.
  /// - [notification] The notification of the message needs to be sent.
  Future<ZIMMessageSentResult> replyMessage(
    ZIMMessage message,
    ZIMMessage toOriginalMessage,
    ZIMMessageSendConfig config,
    ZIMMessageSendNotification? notification,
  );

  /// Query message replied list.
  ///
  /// Available since: 2.17.0 and above.
  /// Description: Query the reply message list.
  /// Use cases: Developers can use this method to query the entire reply message tree.
  /// When to call: Callable after login.
  ///
  /// - [message] The message needs to be queried replied list.
  /// - [config] The configuration of the message needs to be queried replied list.
  Future<ZIMMessageRepliedListQueriedResult> queryMessageRepliedList(
    ZIMMessage message,
    ZIMMessageRepliedListQueryConfig config,
  );

  /// Pin message.
  ///
  /// Use cases: After logging in, when you need to pin or unpin a successfully sent message for a target user or target group chat, use this API to perform the operation.
  /// Related callbacks: ZIMMessagePinnedCallback, onMessagePinStatusChanged.
  /// Related APIs: queryPinnedMessageList, sendMessage.
  ///
  /// - [message] The message needs to be pinned.
  /// - [isPinned] Whether to pin.
  /// - [config] Pinning configuration parameters.
  Future<void> pinMessage({
    required ZIMMessage message,
    required bool isPinned,
    ZIMMessagePinConfig? config,
  });

  /// Query pinned message list.
  ///
  /// Available since: 2.25.0 and above.
  /// Description: This method is used to query the list of pinned messages.
  /// Use cases: When you need to display pinned messages, you can call this interface to query the list of pinned messages within a conversation.
  /// When to call: Called when pinned messages need to be queried.
  /// Restrictions: The SDK must be logged in and the message pinning feature must be supported to use this interface.
  /// Related callbacks: [ZIMPinnedMessageListQueriedResult].
  ///
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMPinnedMessageListQueriedResult> queryPinnedMessageList(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Query the local message cache of the current user.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: Query the local message cache of the current user.
  /// Use cases: This interface is invoked when the local message cache needs to be queried.
  /// Restrictions: This takes effect after the login and becomes invalid after the logout.
  /// Related callbacks: [ZIMFileCacheQueriedResult].
  ///
  /// - [config] Query the cache configuration.
  Future<ZIMFileCacheQueriedResult> queryLocalFileCache(
    ZIMFileCacheQueryConfig config,
  );

  /// Clear the local message cache of the current user.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: Clear the local message cache of the current user.
  /// Use cases: This interface is invoked when the local message cache needs to be cleared.
  /// Restrictions: This takes effect after the login and becomes invalid after the logout.
  /// Related callbacks: [ZIMFileCacheClearedResult].
  ///
  /// - [config] Clear the cache configuration.
  Future<void> clearLocalFileCache(ZIMFileCacheClearConfig config);

  /// Create a room with advanced settings
  ///
  /// Available since: 1.3.0.
  /// Description: Users can create and join rooms through this api, other users can join this room through [joinRoom] function.
  /// Use cases: When you need to create a multi-person chat scenario with custom attributes, use this API to create and join a room.
  /// When to call: Can be called after login.
  /// Caution: After all users leave the room, it will be automatically destroyed. A user can be in at most 5 rooms at the same time.
  /// Restrictions: If the room already exists, calling this API will result in an error. Please refer to the returned error code for handling.
  /// Related callbacks: The result of creating a room can be obtained through the [onRoomCreated] callback.
  /// Related APIs: Use [joinRoom] to join a room, and [leaveRoom] to leave a room.
  ///
  /// - [roomInfo] The configuration information of the room to be created.
  /// - [config] The advanced properties of the room to be created.
  Future<ZIMRoomCreatedResult> createRoom(
    ZIMRoomInfo roomInfo, [
    ZIMRoomAdvancedConfig? config,
  ]);

  /// Join a room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: If the room does not exist, the join fails and you need to call [createRoom] to create the room first.
  /// Use cases: In a multi-person chat scenario, users can call this interface to enter the room when they need to join the room.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Caution: When everyone leaves the room, the room will be automatically destroyed.
  /// Related callbacks: The result of joining the room can be obtained through the [ZIMRoomJoinedResult] callback.
  /// Related APIs: You can create a room with [createRoom] and leave the room with [leaveRoom].
  ///
  /// - [roomID] ID of the room to join.
  Future<ZIMRoomJoinedResult> joinRoom(String roomID);

  /// Enter the room. If the room does not exist, it will be created automatically.
  ///
  /// Available since: 2.1.0.
  /// Description: After calling this API, If the room already exists, join the room directly; if the room does not exist, create a room and join. At the same time, if the room does not exist, after calling this interface, the room advanced properties set by the user will take effect.
  /// Use cases: When you need to enter a multi-person chat scene with custom attributes, and you do not need to distinguish whether the room is created or added, you can enter a room through this interface.
  /// When to call: It can be called after logging in.
  /// Caution: When everyone leaves the room, the room will be automatically destroyed, and a user can be in a maximum of 5 rooms at the same time. [enterRoom] is equivalent to [createRoom] and [joinRoom], so you only need to choose one of the APIs.
  /// Related callbacks: The result of entering the room can be obtained through the [ZIMRoomEnteredResult] callback.
  /// Related APIs: You can enter the room through [enterRoom], and leave the room through [leaveRoom].
  ///
  /// - [roomInfo] Configuration information for the room that will be created. Only the first user who enters the room creates roomName and takes effect.
  /// - [config] Advanced properties of the room that will be created. Only the first user who enters the room is configured to take effect.
  Future<ZIMRoomEnteredResult> enterRoom(
    ZIMRoomInfo roomInfo,
    ZIMRoomAdvancedConfig config,
  );

  /// Switch from one room to another. If the room does not exist, it will decide whether to create the corresponding room based on the passed parameters.
  ///
  /// Available since: 2.18.0.
  /// Description: After calling this API, If the room already exists, join the room directly; if the room does not exist, create a room and join. At the same time, if the room does not exist, after calling this interface, the room advanced properties set by the user will take effect.
  /// Use cases: Scenarios that require quick switching from one room to another.
  /// When to call: It can be called after logging in.
  /// Related callbacks: The result of switching the room can be obtained through the [ZIMRoomSwitchedResult] callback.
  ///
  /// - [fromRoomID] ID of the source room to switch.
  /// - [toRoomInfo] Configuration information for the room to switch to.
  /// - [isCreateWhenRoomNotExisted] Whether to create the room if it does not exist.
  /// - [config] Advanced properties for the room to switch to.
  Future<ZIMRoomSwitchedResult> switchRoom(
    String fromRoomID,
    ZIMRoomInfo toRoomInfo,
    bool isCreateWhenRoomNotExisted,
    ZIMRoomAdvancedConfig config,
  );

  /// Leave a room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: When the user in the room needs to leave the room, use [leaveRoom] to leave the room. If the room does not exist, the leave fails.
  /// Use cases: In the multi-person chat scenario, when users in the room need to leave the room, they can leave the room through this interface.
  /// When to call: After creating a ZIM instance via [create], it can be called when the user is in the room.
  /// Caution: If the current user is not in this room, the exit fails. When everyone leaves the room, the room will be automatically destroyed.
  /// Related callbacks: The result of leaving the room can be obtained through the [ZIMRoomLeftResult] callback.
  /// Related APIs: You can create a room through [createRoom] and join a room with [joinRoom].
  ///
  /// - [roomID] ID of the room to leave.
  Future<ZIMRoomLeftResult> leaveRoom(String roomID);

  /// Leave all rooms entered.
  ///
  /// Available since: 2.15.0 or above.
  /// Description: Call this interface to exit all rooms you have entered at once.
  /// When to call: After creating a ZIM instance via [create], it can be called when the user is in the room.
  /// Caution: If the current user is not in this room, leaving will fail; and calling this interface can only leave the room entered under the current terminal, and will not affect the rooms entered by other terminals with multi-terminal login.
  /// Related callbacks: The result of leaving the room can be obtained through the [ZIMRoomAllLeftResult] callback.
  Future<ZIMRoomAllLeftResult> leaveAllRoom();

  /// Query the list of members in the room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: After joining a room, you can use this function to get the list of members in the room.
  /// Use cases: When a developer needs to obtain a list of room members for other business operations, this interface can be called to obtain a list of members.
  /// When to call: After creating a ZIM instance through [create], and the user is in the room that needs to be queried, you can call this interface.
  /// Caution: To use this feature, please contact ZEGOCLOUD technical support. If the user is not currently in this room, the query fails. When there are more than 500 room members, the result of querying the list of room members can only contain the information of a maximum of 500 members.
  /// Related callbacks: Through the [ZIMRoomMemberQueriedResult] callback, you can get the result of querying the room member list.
  /// Related APIs: You can check the online number of people in the room through [queryRoomOnlineMemberCount].
  ///
  /// - [roomID] ID of the room to query.
  /// - [config] Configuration of query room member operation.
  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
    String roomID,
    ZIMRoomMemberQueryConfig config,
  );

  /// Query the information of the specified userID in the specified room.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method can query the information of up to ten users in the specified room of the logged-in user.
  /// Use cases: When you need to know the user information in the specified room, you can call this interface to obtain the data source.
  /// When to call: Can be invoked after login.
  /// Restrictions: Available after login, unavailable after logout, up to ten users can be queried at one time.
  ///
  /// - [userIDs] List of user IDs to query.
  /// - [roomID] The room ID of the specified room.
  Future<ZIMRoomMembersQueriedResult> queryRoomMembers(
    List<String> userIDs,
    String roomID,
  );

  /// Query the number of online members in the room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: After joining a room, you can use this function to get the number of online members in the room.
  /// Use cases: When a developer needs to obtain the number of room members who are online, this interface can be called.
  /// When to call: After creating a ZIM instance through [create], and the user is in the room that needs to be queried, this interface can be called.
  /// Caution: If the user is not currently in this room, the query will fail.
  /// Related callbacks: The result of querying the online number of room members can be obtained through the [ZIMRoomOnlineMemberCountQueriedResult] callback.
  /// Related APIs: the room member can be inquired through [queryRoomMemberList].
  ///
  /// - [roomID] ID of the room to query.
  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
    String roomID,
  );

  /// Set room attributes (use this for all additions and changes).
  ///
  /// Available since: 1.3.0.
  /// Description: Used to set room properties.
  /// Use cases: This interface is used when you need to set the mic bit in a chat room.
  /// When to call: after login, and in the relevant room to call.
  /// Restrictions: You can set a maximum of 20 properties per room.
  /// Caution: Key-value of the room property. The default key length is 16 and the default value length is 1024.
  /// Default value: [ZIMRoomAttributesSetConfig] the space-time of the default configuration is optional, and do not update the owner, and involves the room properties in the owner is not automatically deleted after exit.
  /// Privacy statement: Try not to introduce sensitive information related to personal privacy into the property of the room, including but not limited to mobile phone number, ID number, passport number, real name, etc.
  /// Related callbacks: [ZIMRoomAttributesOperatedResult].
  /// Related APIs: [deleteRoomAttributes] to delete room attributes. [queryRoomAllAttributes], queries the room attributes.
  ///
  /// - [roomAttributes] Room attributes to be set.
  /// - [roomID] To modify the room number of the room attribute.
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomAttributesOperatedResult> setRoomAttributes(
    Map<String, String> roomAttributes,
    String roomID,
    ZIMRoomAttributesSetConfig config,
  );

  /// Delete room attributes.
  ///
  /// Available since: 1.3.0.
  /// Use cases: This interface can be used when a voice chat room needs to delete a seat.
  /// When to call: After login and while in the relevant room.
  /// Default value: The default configuration when [ZIMRoomAttributesDeleteConfig] is empty is non-forced operation.
  /// Scope of impact: Deletes the room attributes of the existing room.
  /// Related callbacks: [ZIMRoomAttributesOperatedResult].
  /// Related APIs: [setRoomAttributes] to set room attributes. [queryRoomAllAttributes] to query room attributes.
  /// Description: Used to delete room attributes.
  ///
  /// - [keys] The key of the room attribute to be deleted.
  /// - [roomID] To modify the room number of the room attribute
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomAttributesOperatedResult> deleteRoomAttributes(
    List<String> keys,
    String roomID,
    ZIMRoomAttributesDeleteConfig config,
  );

  /// Open combination room attribute operation.
  ///
  /// Available since: 1.3.0.
  /// Use cases: When a voice chat room needs to switch seats, this interface can be used to initiate a batch operation.
  /// When to call: After login and while in the relevant room.
  /// Caution: After starting batch operations on room attributes, all set and delete operations will be included in the batch until the batch operation is complete. Consecutive calls reset the state. Not calling [endRoomAttributesBatchOperation] is treated as no operation.
  /// Scope of impact: After being enabled, set and delete room attribute operations will be included in this batch operation.
  /// Related APIs: [endRoomAttributesBatchOperation] to complete the batch operation.
  /// Description: Used to turn on the combination of room attributes.
  ///
  /// - [roomID] The number of the room where the combined operation needs to be turned on.
  /// - [config] The configuration of the combined operation.
  void beginRoomAttributesBatchOperation(
    String roomID,
    ZIMRoomAttributesBatchOperationConfig config,
  );

  /// Complete the property operation of the combined room.
  ///
  /// Available since: 1.3.0.
  /// Description: After completing the operation of combining room attributes, all the setting/deleting operations from the last call to beginRoomAttributesBatchOperation to this operation will be completed for the room.
  /// Use cases: This interface can be used when a voice chat room needs to switch seats.
  /// When to call: After login, execute after [beginRoomAttributesBatchOperation].
  /// Restrictions: Requires that batch operations have been started in the room.
  /// Caution: Calling without [beginRoomAttributesBatchOperation] will return an error. Not calling [endRoomAttributesBatchOperation] after [beginRoomAttributesBatchOperation] is treated as no operation.
  /// Scope of impact: Set and delete room attributes within the same room.
  /// Related callbacks: [ZIMRoomAttributesBatchOperatedResult].
  /// Related APIs: [beginRoomAttributesBatchOperation] to start the batch operation.
  ///
  /// - [roomID] To modify the room number of the room attribute.
  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
    String roomID,
  );

  /// Query all properties of the room.
  ///
  /// Available since: 1.3.0.
  /// When to call: After login and while in the relevant room.
  /// Use cases: This interface can be used when a voice chat room needs to query seat information.
  /// Related callbacks: [ZIMRoomAttributesQueriedResult].
  /// Related APIs: [deleteRoomAttributes] to delete room attributes. [setRoomAttributes] to set room attributes.
  /// Description: Used to query room attributes.
  ///
  /// - [roomID] Need to query the room number of the custom attributes.
  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(String roomID);

  /// Set room member attributes (use this for all additions and changes).
  ///
  /// Available since: 2.4.0 and above.
  /// Description: Call this API to set room user properties of members in the room.
  /// Use cases: If you need to set a level for members in the room, you can use this interface to set a state.
  /// Default value: [ZIMRoomMemberAttributesSetConfig] Default constructor isDeleteAfterOwnerLeft is true.
  /// When to call: After logging in and calling in the relevant room.
  /// Restrictions: A maximum of 500 user attributes can be set in each room and stored in the key-value mode. If you need to increase the attribute limit, please contact ZEGO technical support. The total length of user attribute key-values owned by each user in a room cannot exceed 144 bytes, and the number of key-values cannot exceed 30 pairs. The length of a single key-value cannot exceed 8 bytes for a Key and 64 bytes for a Value. If you need to raise the cap, please contact ZEGO technical support. After the room is destroyed, the user-defined user properties are also destroyed.
  /// Related callbacks: [ZIMRoomMembersAttributesOperatedResult],[onRoomMemberAttributesUpdated].
  /// Related APIs: [queryRoomMembersAttributes], [queryRoomMemberAttributesList].
  ///
  /// - [attributes] Room member attributes to be set.
  /// - [userIDs] A list of userIDs to set.
  /// - [roomID] Room ID.
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomMembersAttributesOperatedResult> setRoomMembersAttributes(
    Map<String, String> attributes,
    List<String> userIDs,
    String roomID,
    ZIMRoomMemberAttributesSetConfig config,
  );

  /// Batch query the room user attributes of the members in the room.
  ///
  /// Available since: 2.4.0 or later.
  /// Description: Call this API to batch query the room user attributes of the members in the room.
  /// Use cases: Use this interface when you need to specify that you want to query some room users.
  /// Restrictions: The maximum call frequency is 5 times within 30 seconds by default, and the maximum query time is 100 people.
  /// Related callbacks: [ZIMRoomMembersAttributesQueriedResult].
  /// Related APIs: [setRoomMembersAttributes]、[queryRoomMemberAttributesList].
  /// Life cycle: It is available after logging in and joining the corresponding room, but unavailable after leaving the corresponding room.
  ///
  /// - [userIDs] A list of userIDs to query.
  /// - [roomID] Room ID.
  Future<ZIMRoomMembersAttributesQueriedResult> queryRoomMembersAttributes(
    List<String> userIDs,
    String roomID,
  );

  /// paginate the room user properties that have room property members in the room.
  ///
  /// Available since: 2.4.0 or later.
  /// Description: paginate the room user properties that have room property members in the room.
  /// Use cases: This interface is used when you need to query all room users.
  /// Restrictions: The maximum call frequency is 5 times within 30 seconds by default, and the maximum query time is 100 people.
  /// Related callbacks: [ZIMRoomMemberAttributesListQueriedResult].
  /// Related APIs: [setRoomMembersAttributes]、[queryRoomMembersAttributes].
  /// Life cycle: It is available after logging in and joining the corresponding room, but unavailable after leaving the corresponding room.
  ///
  /// - [roomID] Room ID.
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomMemberAttributesListQueriedResult>
  queryRoomMemberAttributesList(
    String roomID,
    ZIMRoomMemberAttributesQueryConfig config,
  );

  /// Create a group with the andvanced info such as group attributes and group notice.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: You can call this interface to create a group, and the person who calls this interface is the group leader.
  /// Use cases: You can use this interface to create a chat scenario and join a group.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Caution: Available after login, unavailable after logout. UserIDs can have a maximum of 100 users and a group can have a maximum of 500 users.
  /// Related callbacks: The result of creating the group is obtained through the [ZIMGroupCreatedResult] callback.
  /// Related APIs: You can use [joinGroup] to join a group, [leaveGroup] to leave a group, or [dismissGroup] to dismiss a group.
  ///
  /// - [groupInfo] Configuration information for the group to be created.
  /// - [userIDs] List of users invited to the group.
  /// - [config] Create the relevant configuration of the group.
  Future<ZIMGroupCreatedResult> createGroup(
    ZIMGroupInfo groupInfo,
    List<String> userIDs, [
    ZIMGroupAdvancedConfig? config,
  ]);

  /// Dismiss the group.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: When a group is created, you can use [dismissGroup] to dismiss it.
  /// Use cases: After you create a chat group, you do not need to use this interface to dissolve the group.
  /// When to call: This parameter can be called after a group is created by using [createGroup].
  /// Caution: A non-group owner cannot dissolve a group.
  /// Related callbacks: Through callback can get [ZIMGroupDismissedResult] dissolution results of the room, through [onGroupStateChanged] listen callback can get the room status.
  /// Related APIs: You can use [createGroup] to create a group, [joinGroup] to join a group, and [leaveGroup] to leave a group.
  ///
  /// - [groupID] The ID of the group to be dismissed.
  Future<ZIMGroupDismissedResult> dismissGroup(String groupID);

  /// Join a group.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, other users can use [joinGroup] to join the group.
  /// Use cases: This interface is used to join a group in a chat scenario.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Caution: Available after login, unavailable after logout. If you have joined a group, the join succeeds. A group is limited to 500 people and fails to join when it is full.
  /// Related callbacks: To get the result of joining the room, call [ZIMGroupJoinedResult].
  /// Related APIs: You can use [createGroup] to create a group, [leaveGroup] to leave a group, or [dismissGroup] to dismiss a group.
  ///
  /// - [groupID] The group ID to join.
  Future<ZIMGroupJoinedResult> joinGroup(String groupID);

  /// Leave the group.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a user joins a group, the user can leave the group through this interface.
  /// Use cases: This interface is used to exit a chat group.
  /// When to call: It can be invoked after a ZIM instance is created through [create] and logged in.
  /// Restrictions: Available after login, unavailable after logout.
  /// Caution: When the group owner quits the group, the identity of the group owner will be automatically transferred to the earliest member who joined the group. When all members exit the group, the group is automatically dissolved.
  /// Scope of impact: You can use [createGroup] to create a group, [joinGroup] to join a group, or [dismissGroup] to dismiss a group.
  /// Related callbacks: The result of leaving the room can be obtained by the [ZIMGroupLeftResult] callback.
  ///
  /// - [groupID] The group ID to leave.
  Future<ZIMGroupLeftResult> leaveGroup(String groupID);

  /// invite some members into the group.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, users can add multiple users to the group through this interface. The interface can be invoked by both the master and members of the group.
  /// Use cases: This interface allows you to invite others to join a group chat.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: The maximum number of userIDs users can join the group is 100. If the number of users reaches 100, the interface callback will notify the user. The maximum number of people in a group is 500.
  /// Caution: This interface does not require the peer's consent or the peer's online status. The service layer determines the number of invited users.
  /// Related callbacks: Through the callback [ZIMGroupUsersInvitedResult] can add multiple users into the group's results.
  /// Related APIs: KickGroupMember can be used to kick a target user out of the group.
  ///
  /// - [userIDs] The list of user IDs to invite into the group.
  /// - [groupID] The target group ID.
  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
    List<String> userIDs,
    String groupID,
  );

  /// kick some members out of the group.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a user joins a group, you can use this method to remove the user from the group.
  /// Use cases: You can use this method to remove one or more users from the group.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: You can't kick someone unless you're the leader of the group.
  /// Caution: This interface does not require the peer's consent or the peer's online status. It cannot accept group-related callbacks after being kicked out. History messages and sessions remain after being kicked out and can still enter the group.
  /// Related callbacks: Through the callback [ZIMGroupMemberKickedResult] can get the user kicked out the results of the group.
  /// Related APIs: You can invite a target user into a group through [inviteUsersIntoGroup].
  ///
  /// - [userIDs] The list of user IDs to kick out of the group.
  /// - [groupID] The target group ID.
  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
    List<String> userIDs,
    String groupID,
  );

  /// Transfer the group owner.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, the group owner can use this method to assign the group owner to a specified user.
  /// Use cases: In a group chat scenario, you can transfer the group master through this interface.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: You cannot transfer a group owner if you are not a group owner.
  /// Related callbacks: Through the callback [ZIMGroupOwnerTransferredResult] can get the result of the transfer of the group manager.
  ///
  /// - [toUserID] The user ID of the new group owner.
  /// - [groupID] The target group ID.
  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
    String toUserID,
    String groupID,
  );

  /// Query group information.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Query information about a created group.
  /// Use cases: You need to obtain group information for display.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: Through the callback [ZIMGroupInfoQueriedResult] can query the result of the group information.
  ///
  /// - [groupID] The group ID of the group information to be queried.
  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID);

  /// Query group member information.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, you can use this method to query information about a specified group member.
  /// Use cases: You need to obtain the specified group member information for display or interaction.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: Through the callback [ZIMGroupMemberInfoQueriedResult] can get the query specifies the result of group membership information.
  ///
  /// - [userID] User ID of the queried member information.
  /// - [groupID] The ID of the group whose member information will be queried.
  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
    String userID,
    String groupID,
  );

  /// Query the group list.
  ///
  /// Available since: 2.27.0 and above.
  /// Description: Query the list of all groups.
  /// Use cases: You need to get a list of groups to display.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: Through the callback [ZIMGroupListQueriedResult] can get a check list of all current group results.
  ///
  /// - [count] The number of groups to query.
  /// - [config] Group list query configuration.
  Future<ZIMGroupListQueriedResult> queryGroupList({
    int? count,
    ZIMGroupListQueryConfig? config,
  });

  /// Query the list of group members.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, you can use this method to query the group member list.
  /// Use cases: You need to obtain the specified group member list for display or interaction.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: Through the callback [ZIMGroupMemberListQueriedResult] can query the result of the group member list.
  ///
  /// - [groupID] The group ID of the group member list to be queried.
  /// - [config] Group member query configuration.
  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
    String groupID,
    ZIMGroupMemberQueryConfig config,
  );

  /// Query the number of group members in a specified group.
  ///
  /// Available since: 2.2.0 or above.
  /// Description: Query the number of group members in a group.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: This function can only query the group that the user has entered.
  /// Related callbacks: [ZIMGroupMemberCountQueriedResult].
  ///
  /// - [groupID] The group ID of the group to be queried.
  Future<ZIMGroupMemberCountQueriedResult> queryGroupMemberCount(
    String groupID,
  );

  /// Update the group name.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, users can call this method to change the group name.
  /// Use cases: After creating a group, you need to change the group name.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Group members and group owners can change the group name. The maximum length of the name is 100 bytes.
  /// Related callbacks: Through the callback [ZIMGroupNameUpdatedResult] can get the result of the change of name, through [onGroupNoticeUpdated] can get update group name information.
  ///
  /// - [groupName] The new group name.
  /// - [groupID] The target group ID.
  Future<ZIMGroupNameUpdatedResult> updateGroupName(
    String groupName,
    String groupID,
  );

  /// Update the group avatar URL.
  ///
  /// Available since: 2.3.0 and above.
  /// Description: After a group is created, the user can modify the group avatar URL by calling this method.
  /// Use cases: After creating a group, the user needs to change the group avatar URL.
  /// When to call: It can be invoked after creating a ZIM instance through [create] and logging in.
  /// Restrictions: Group members and group owners can modify the group avatar, with a maximum length of 500 bytes.
  /// Related callbacks: The result of changing the group name can be obtained through the [ZIMGroupAvatarUrlUpdatedResult] callback, and the updated group avatar information can be obtained through the [onGroupAvatarUrlUpdated] callback.
  ///
  /// - [groupAvatarUrl] The new group avatar URL.
  /// - [groupID] The target group ID.
  Future<ZIMGroupAvatarUrlUpdatedResult> updateGroupAvatarUrl(
    String groupAvatarUrl,
    String groupID,
  );

  /// Update group announcements.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: When a group is created, users can use this method to update the group bulletin.
  /// Use cases: You need to update the group bulletin in the group.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Only group members can update the group bulletin. The maximum number of bytes is 300. There is no special character limit.
  /// Related callbacks: Through callback [ZIMGroupNoticeUpdatedResult] can get update group of the results announcement, announcement by [onGroupNoticeUpdated] can get update group information.
  ///
  /// - [groupNotice] The new group notice content.
  /// - [groupID] The target group ID.
  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
    String groupNotice,
    String groupID,
  );

  /// Update the group alias.
  ///
  /// Available since: 2.18.0 and above.
  /// Description: After a group is created, users can call this method to change the group alias.
  /// Use cases: To distinguish different group.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Related callbacks: Through the callback [ZIMGroupAliasUpdatedResult] can get the result of the change of group alias.
  ///
  /// - [groupAlias] The new group alias.
  /// - [groupID] The target group ID.
  Future<ZIMGroupAliasUpdatedResult> updateGroupAlias(
    String groupAlias,
    String groupID,
  );

  /// Update group verification mode.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group is created, the group owner and administrators can use this method to update the group verification mode.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [mode] The group join mode.
  /// - [groupID] The target group ID.
  Future<ZIMGroupJoinModeUpdatedResult> updateGroupJoinMode(
    ZIMGroupJoinMode mode,
    String groupID,
  );

  /// Update group verification mode.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group is created, the group owner and administrators can use this method to update the group verification mode.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [mode] The group invite mode.
  /// - [groupID] The target group ID.
  Future<ZIMGroupInviteModeUpdatedResult> updateGroupInviteMode(
    ZIMGroupInviteMode mode,
    String groupID,
  );

  /// Update group verification mode.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: After a group is created, the group owner and administrators can update the invited group verification mode through this method.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [mode] The group be-invite mode.
  /// - [groupID] The target group ID.
  Future<ZIMGroupBeInviteModeUpdatedResult> updateGroupBeInviteMode(
    ZIMGroupBeInviteMode mode,
    String groupID,
  );

  /// Add or update group attributes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: If a group already exists, all users of the group can use this method to set group attributes.
  /// Use cases: Added extended field information about group description, such as group family, label, and industry category.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Only group members can set group attributes.
  /// Related callbacks: Through the callback [ZIMGroupAttributesOperatedResult] can get the result of the set of attributes.
  /// Related APIs: [deleteGroupAttributes] can be used to deleteGroupAttributes, [queryGroupAttributes] can be used to queryGroupAttributes, [queryGroupAllAttributes] can be used to queryAllGroupAttributes.
  ///
  /// - [groupAttributes] The group attributes to set, in key-value pairs.
  /// - [groupID] The target group ID.
  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
    Map<String, String> groupAttributes,
    String groupID,
  );

  /// Delete group attributes.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: When a group already exists, you can use this method to delete group attributes. Both the master and members of the interface group can be invoked.
  /// Use cases: Deleted the extended field of the group description.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Only group members can delete group attributes.
  /// Related callbacks: Through the callback [ZIMGroupAttributesOperatedResult] can delete the result of the group of attributes.
  /// Related APIs: You can use [setGroupAttributes] to setGroupAttributes, [queryGroupAttributes] to queryGroupAttributes, and [queryAllGroupAttributes] to queryAllGroupAttributes.
  ///
  /// - [keys] The list of group attribute keys to delete.
  /// - [groupID] The target group ID.
  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
    List<String> keys,
    String groupID,
  );

  /// Query group attributes by keys.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, you can use this method to query the specified group attributes.
  /// Use cases: You need to query the scenarios to display the specified group attributes.
  /// When to call: After creating a ZIM instance with [create] and logging in with [login].
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: Through the callback [ZIMGroupAttributesQueriedResult] can get query attributes of the specified group of results.
  /// Related APIs: [queryAllGroupAttributes] Queries all group attributes.
  ///
  /// - [keys] The list of group attribute keys to query.
  /// - [groupID] The target group ID.
  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
    List<String> keys,
    String groupID,
  );

  /// Query all attributes of the group.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, you can use this method to query all group attributes.
  /// Use cases: Scenarios where all group attributes need to be queried.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Related callbacks: Through callback can get query [ZIMGroupAttributesQuriedCallback] all the results of the group of attributes.
  /// Related APIs: [queryGroupAttributes] Queries the attributes of the specified group.
  ///
  /// - [groupID] The target group ID.
  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
    String groupID,
  );

  /// Set the group member role.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, you can use this method to set the roles of group members.
  /// Use cases: The ZIM instance can be invoked after being created by [create] and logged in.
  /// When to call: If the primary role of a group is 1 and the default role of other members is 3, you can invoke this interface to change the role.
  /// Caution: The role of the group owner is 1, the role of the administrator is 2, and the role of the normal member is 3. You can modify it by calling this interface, but the role cannot be changed to 1. If you need to customize the role, it is recommended to set the value to 100 or higher, and its permissions will be the same as those of normal members.
  /// Restrictions: Non-group master unavailable.
  /// Related callbacks: Through the callback [ZIMGroupMemberRoleUpdatedResult] can be set up to get the results of the group of members of the role.
  ///
  /// - [role] The role value to set for the group member.
  /// - [forUserID] The user ID of the target group member.
  /// - [groupID] The target group ID.
  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
    int role,
    String forUserID,
    String groupID,
  );

  /// Set the group member nickname.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After a group is created, you can use this method to set nicknames for group members.
  /// Use cases: Nicknames need to be set for group members.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Caution: A group member nickname can contain a maximum of 100 characters.
  /// Restrictions: Available after login, unavailable after logout. The owner of a group can change his or her own nickname, while the members can change only their own nickname.
  /// Related callbacks: Through the callback [ZIMGroupMemberNicknameUpdatedResult] can be set up to get the results of the group members nickname.
  ///
  /// - [nickname] The new group member nickname.
  /// - [forUserID] The user ID of the target group member.
  /// - [groupID] The target group ID.
  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
    String nickname,
    String forUserID,
    String groupID,
  );

  /// Mute a group.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: Once a group is created, the group administrator can call this interface to implement group muting and unmuting.
  /// Use cases: After creating a group, users need to change the mute status of the group.
  /// When to call: This can be called after a ZIM instance is created using [create] and logged into the group.
  /// Restrictions: This can be called by the group owner and group administrators.
  /// Related callbacks: The result of changing the group mute status can be obtained through the [ZIMGroupMutedResult] callback. The updated group mute status information can be obtained through [onGroupMutedInfoUpdated].
  ///
  /// - [isMute] Whether to mute. [true] means mute, [false] means unmute.
  /// - [groupID] The target group ID.
  /// - [config] Group mute configuration.
  Future<ZIMGroupMutedResult> muteGroup(
    bool isMute,
    String groupID,
    ZIMGroupMuteConfig config,
  );

  /// Mute group members.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: Once a group is created, the group administrator can call this interface to implement group members muting and unmuting.
  /// Use cases: After creating a group, users need to change the mute status of the group members.
  /// When to call: This can be called after a ZIM instance is created using [create] and logged into the group.
  /// Restrictions: This can be called by the group owner and group administrators.
  /// Related callbacks: The result of changing the group members mute status can be obtained through the [ZIMGroupMembersMutedResult] callback. The updated group members mute status information can be obtained through [onGroupMemberInfoUpdated].
  ///
  /// - [isMute] Whether to mute. [true] means mute, [false] means unmute.
  /// - [userIDs] The list of user IDs to mute/unmute.
  /// - [groupID] The target group ID.
  /// - [config] Group member mute configuration.
  Future<ZIMGroupMembersMutedResult> muteGroupMembers(
    bool isMute,
    List<String> userIDs,
    String groupID,
    ZIMGroupMemberMuteConfig config,
  );

  /// Query the list of group muted members.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: After a group is created, you can use this method to query the group muted member list.
  /// Use cases: You need to obtain the specified group muted member list for display or interaction.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: Through the callback [ZIMGroupMembersMutedResult] can query the result of the group muted member list.
  ///
  /// - [groupID] The target group ID.
  /// - [config] Group muted member list query configuration.
  Future<ZIMGroupMemberMutedListQueriedResult> queryGroupMemberMutedList(
    String groupID,
    ZIMGroupMemberMutedListQueryConfig config,
  );

  /// Query the list of group message read members.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This method can query the specific read member list of a message sent by a group.
  /// Use cases: Developers can use this method to query the specific read member list of a message they send.
  /// When to call: Callable after login.
  /// Restrictions: only supports querying the messages sent by the local end, and the receipt status of the messages is not NONE and UNKNOWN. If the user is not in the group, or has been kicked out of the group, the corresponding member list cannot be found.
  /// Related callbacks: [ZIMGroupMessageReceiptMemberListQueriedResult].
  /// Related APIs: If you need to query the receipt status of a certain message or only need to query the read/unread count, you can query through the interface [queryMessageReceiptsInfo].
  ///
  /// @deprecated This API was deprecated in 3.1.0. Please use [queryGroupMessageReceiptMemberList] instead.
  /// - [message] The group message to query the read member list of.
  /// - [groupID] The target group ID.
  /// - [config] Group message receipt member query configuration.
  @Deprecated(
    'This API was deprecated in 3.1.0. Please use [queryGroupMessageReceiptMemberList] instead.',
  )
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
  queryGroupMessageReceiptReadMemberList(
    ZIMMessage message,
    String groupID,
    ZIMGroupMessageReceiptMemberQueryConfig config,
  );

  /// Query the list of group message unread members.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This method can query the specific unread member list of a message sent by a group.
  /// Use cases: Developers can use this method to query the specific unread member list of a message they send.
  /// When to call: Callable after login.
  /// Restrictions: only supports querying the messages sent by the local end, and the receipt status of the messages is not NONE. If the user is not in the group, or has been kicked out of the group, the corresponding member list cannot be found.
  /// Related callbacks: [ZIMGroupMessageReceiptMemberListQueriedResult].
  /// Related APIs: If you need to query the receipt status of a certain message or only need to query the read/unread count, you can query through the interface [queryMessageReceiptsInfo].
  ///
  /// @deprecated This API was deprecated in 3.1.0. Please use [queryGroupMessageReceiptMemberList] instead.
  /// - [message] The group message to query the unread member list of.
  /// - [groupID] The target group ID.
  /// - [config] Group message receipt member query configuration.
  @Deprecated(
    'This API was deprecated in 3.1.0. Please use [queryGroupMessageReceiptMemberList] instead.',
  )
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
  queryGroupMessageReceiptUnreadMemberList(
    ZIMMessage message,
    String groupID,
    ZIMGroupMessageReceiptMemberQueryConfig config,
  );

  /// Query the receipt member list of a group message.
  ///
  /// Available since: 3.1.0 and above.
  /// Description: This method can query the specific unread member list, read member list, or delivered member list of a message sent by yourself in a group.
  /// Use cases: Developers can use this method to query and display the specific receipt member lists of a message they sent, enabling the UI to separately show the unread, read, and delivered member lists for that message.
  /// Restrictions: Only supports querying messages sent by the local end, and the receipt status of the messages must not be NONE. If the user is not in the group, or has been kicked out of the group, the corresponding member list cannot be found.
  /// Caution: If you only need to query the receipt status of a message or just the read/unread count, use [queryMessageReceiptsInfo] instead.
  ///
  /// - [message] The group message to query the receipt member list of.
  /// - [groupID] The target group ID.
  /// - [count] The number of members to query per page, up to 100.
  /// - [config] Query configuration for the group message receipt member list.
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
  queryGroupMessageReceiptMemberList({
    required ZIMMessage message,
    required String groupID,
    required int count,
    ZIMGroupMessageReceiptMemberListQueryConfig? config,
  });

  /// Search local groups.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: This method is used to search for local groups.
  /// Use cases: When you need to search for local groups by keywords or other criteria, you can call this interface to search.
  /// When to call: After calling [login]
  /// Restrictions: Takes effect after login, becomes invalid after logout.
  /// Related callbacks: [ZIMGroupsSearchedResult].
  ///
  /// - [config] Configuration for searching groups.
  Future<ZIMGroupsSearchedResult> searchLocalGroups(
    ZIMGroupSearchConfig config,
  );

  /// Search local group members.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: This method is used to search for group members.
  /// Use cases: When you need to search for local group members by keywords or other criteria, you can call this interface to search.
  /// Restrictions: Takes effect after login, becomes invalid after logout.
  /// Related callbacks: [ZIMGroupMembersSearchedResult].
  ///
  /// - [groupID] Group ID of the joined group.
  /// - [config] The configuration for searching group members.
  Future<ZIMGroupMembersSearchedResult> searchLocalGroupMembers(
    String groupID,
    ZIMGroupMemberSearchConfig config,
  );

  /// Send an application to join the group.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group's joinMode is Auth, users can apply to join the group through this method.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [groupID] The group ID to apply to join.
  /// - [config] Group join application configuration.
  Future<ZIMGroupJoinApplicationSentResult> sendGroupJoinApplication(
    String groupID,
    ZIMGroupJoinApplicationSendConfig config,
  );

  /// Accept an application to join the group.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group's joinMode requires Auth, after an external user sends a group application, the group owner or administrator can agree to the application through this method.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [userID] The user ID of the applicant.
  /// - [groupID] The target group ID.
  /// - [config] Configuration for accepting the group join application.
  Future<ZIMGroupJoinApplicationAcceptedResult> acceptGroupJoinApplication(
    String userID,
    String groupID,
    ZIMGroupJoinApplicationAcceptConfig config,
  );

  /// Reject an application to join the group.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group's joinMode is Auth, the group owner or administrator can reject to the user's application to join the group through this method.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [userID] The user ID of the applicant.
  /// - [groupID] The target group ID.
  /// - [config] Configuration for rejecting the group join application.
  Future<ZIMGroupJoinApplicationRejectedResult> rejectGroupJoinApplication(
    String userID,
    String groupID,
    ZIMGroupJoinApplicationRejectConfig config,
  );

  /// Send an application to invite the group.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group's invitation verification mode requires approval by the invitee, group members can send invitations to the group through this method.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [userIDs] The list of user IDs to invite.
  /// - [groupID] The target group ID.
  /// - [config] Group invite application configuration.
  Future<ZIMGroupInviteApplicationsSentResult> sendGroupInviteApplications(
    List<String> userIDs,
    String groupID,
    ZIMGroupInviteApplicationSendConfig config,
  );

  /// Accept an application to invite to the group.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group's beInviteMode mode is Auth, users outside the group can accept the invitation through this method and become group members after receiving the group invitation.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [inviterUserID] The user ID of the inviter.
  /// - [groupID] The target group ID.
  /// - [config] Configuration for accepting the group invite application.
  Future<ZIMGroupInviteApplicationAcceptedResult> acceptGroupInviteApplication(
    String inviterUserID,
    String groupID,
    ZIMGroupInviteApplicationAcceptConfig config,
  );

  /// Reject an application to invite to the group.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: When a group's beInviteMode requires Auth, users invited to the group can reject the invitation through this method.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [inviterUserID] The user ID of the inviter.
  /// - [groupID] The target group ID.
  /// - [config] Configuration for rejecting the group invite application.
  Future<ZIMGroupInviteApplicationRejectedResult> rejectGroupInviteApplication(
    String inviterUserID,
    String groupID,
    ZIMGroupInviteApplicationRejectConfig config,
  );

  /// Query the group application list.
  ///
  /// Available since: 2.15.0 and above.
  /// Description: The query results include your own application to join the group and your application to be invited to join the group. When the user is a group owner or administrator, the query results will also include other people's applications to join the group and their own applications to invite others to the group.
  /// When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [config] Group application list query configuration.
  Future<ZIMGroupApplicationListQueriedResult> queryGroupApplicationList(
    ZIMGroupApplicationListQueryConfig config,
  );

  /// Initiate a call invitation.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: When the caller initiates a call invitation, the called party can use [callAccept] to accept the call invitation or [callReject] to reject the invitation.
  /// Use cases: When you need to initiate a call invitation, you can create a unique callid through this interface to maintain this call invitation.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Caution: The call invitation has a timeout period, and the call invitation will end when the timeout period expires.
  /// Related callbacks: [ZIMCallInvitationSentResult].
  ///
  /// - [invitees] The list of invitee user IDs.
  /// - [config] Call invitation configuration.
  Future<ZIMCallInvitationSentResult> callInvite(
    List<String> invitees,
    ZIMCallInviteConfig config,
  );

  /// Cancel the call invitation.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After the caller initiates a call invitation, the call invitation can be canceled through this interface before the timeout period.
  /// Use cases: When you need to cancel the call invitation initiated before, you can cancel the call invitation through this interface.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Caution: Canceling the call invitation after the timeout period of the call invitation expires will fail.
  /// Related callbacks: [ZIMCallCancelSentResult].
  ///
  /// - [invitees] The list of invitee user IDs to cancel the invitation for.
  /// - [callID] The call invitation ID to cancel.
  /// - [config] Call cancel configuration.
  Future<ZIMCallCancelSentResult> callCancel(
    List<String> invitees,
    String callID,
    ZIMCallCancelConfig config,
  );

  /// Accept the call invitation.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: When the calling party initiates a call invitation, the called party can accept the call invitation through this interface.
  /// Use cases: When you need to accept the call invitation initiated earlier, you can accept the call invitation through this interface.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Caution: The callee will fail to accept an uninvited callid.
  /// Related callbacks: [ZIMCallAcceptanceSentResult].
  ///
  /// - [callID] The call invitation ID to accept.
  /// - [config] Call accept configuration.
  Future<ZIMCallAcceptanceSentResult> callAccept(
    String callID,
    ZIMCallAcceptConfig config,
  );

  /// Reject the call invitation.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: When the calling party initiates a call invitation, the called party can reject the call invitation through this interface.
  /// Use cases: When you need to reject the call invitation initiated earlier, you can use this interface to reject the call invitation.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Caution: The callee will fail to reject the uninvited callid.
  /// Related callbacks: [ZIMCallRejectionSentResult].
  ///
  /// - [callID] The ID of the call invitation to be rejected.
  /// - [config] Related configuration for rejecting call invitations.
  Future<ZIMCallRejectionSentResult> callReject(
    String callID,
    ZIMCallRejectConfig config,
  );

  /// Invite other users to join the call invitation.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: In the advanced mode, when the master calls the call invitation, users in the call can continue to invite other users to join the call through the interface，Or after the called party accepts the advanced mode call invitation.
  /// When to call: After calling [callInvite] to initiate a call invitation in advanced mode.
  /// Caution: User calls that are not in the call will fail. ZIM SDK has no relevant business logic after accepting. Developers can customize the development logic after adding calls. By default, a call can contain a maximum of 9 users.
  /// Related callbacks: [ZIMCallingInvitationSentResult].
  ///
  /// - [invitees] The list of user IDs to invite into the call.
  /// - [callID] The current call invitation ID.
  /// - [config] Configuration for inviting during an active call.
  Future<ZIMCallingInvitationSentResult> callingInvite(
    List<String> invitees,
    String callID,
    ZIMCallingInviteConfig config,
  );

  /// Join an advanced mode call, or switch the main device for the advanced mode call (multi-terminal login only).
  ///
  /// Available since: 2.12.0.
  /// Description: After create an advanced mode call invitation, you can invoke this interface to join the call or switch the primary device.
  /// Use cases: Users who are not in the call join the call, and users who are already in the call switch to the primary device.
  /// When to call: Need to be invoked after logged in.
  ///
  /// - [callID] The call invitation ID to join.
  /// - [config] Call join configuration.
  Future<ZIMCallJoinSentResult> callJoin(
    String callID,
    ZIMCallJoinConfig config,
  );

  /// Quit the current call invitation.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: When the Lord's call initiates the invitation and is called and accepts it, the current call can be exited through the interface.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Caution: The callee will fail to quit the uninvited callid.
  /// Related callbacks: [ZIMCallQuitSentResult].
  ///
  /// - [callID] The call invitation ID to quit.
  /// - [config] Call quit configuration.
  Future<ZIMCallQuitSentResult> callQuit(
    String callID,
    ZIMCallQuitConfig config,
  );

  /// End the call invitation.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: End The call in advanced mode.
  /// When to call: The call was in advanced mode and the user status was Accepted.
  /// Caution: User calls that are not in the call will fail. ZIM SDK Does not have service logic after the call ends, and developers can customize the development logic after the end.
  /// Related callbacks: [ZIMCallEndSentResult].
  ///
  /// - [callID] The call invitation ID to end.
  /// - [config] Call end configuration.
  Future<ZIMCallEndSentResult> callEnd(String callID, ZIMCallEndConfig config);

  /// Query the call invitation list.
  ///
  /// Available since: 2.9.0 and above.
  /// Description: Users can call the call invitation list through the query.
  /// Use cases: Users can use the query call invitation list for interface display or other functions.
  /// When to call: Run [create] to create a ZIM instance, which can be invoked after login.
  /// Related callbacks: [ZIMCallInvitationListQueriedResult].
  ///
  /// - [config] Call invitation list query configuration.
  Future<ZIMCallInvitationListQueriedResult> queryCallInvitationList(
    ZIMCallInvitationQueryConfig config,
  );

  /// Add friends directly.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: Through this interface, a user with the specified userID can be added to the friend list.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [onFriendListChanged].
  ///
  /// - [userID] The user ID to add as a friend.
  /// - [config] Friend add configuration.
  Future<ZIMFriendAddedResult> addFriend(
    String userID,
    ZIMFriendAddConfig config,
  );

  /// Delete friends.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: Through this interface, the specified user can be deleted from the friend list.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [onFriendListChanged].
  ///
  /// - [userIDs] The list of friend user IDs to delete.
  /// - [config] Friend delete configuration.
  Future<ZIMFriendsDeletedResult> deleteFriends(
    List<String> userIDs,
    ZIMFriendDeleteConfig config,
  );

  /// Check friend relationships.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: Through this interface, you can check the friend relationship with the specified user.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendsRelationCheckedResult].
  ///
  /// - [userIDs] The list of user IDs to check friend relationships with.
  /// - [config] Friend relation check configuration.
  Future<ZIMFriendsRelationCheckedResult> checkFriendsRelation(
    List<String> userIDs,
    ZIMFriendRelationCheckConfig config,
  );

  /// Update friend alias.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: Through this interface, the specified userID user can update the alias.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendAliasUpdatedResult].
  ///
  /// - [friendAlias] The new friend alias.
  /// - [userID] The user ID of the friend to update the alias for.
  Future<ZIMFriendAliasUpdatedResult> updateFriendAlias(
    String friendAlias,
    String userID,
  );

  /// Update friend attributes.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: Through this interface, the specified userID user can update the attributes.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  ///
  /// - [friendAttributes] The friend attributes to update, in key-value pairs.
  /// - [userID] The user ID of the friend to update attributes for.
  Future<ZIMFriendAttributesUpdatedResult> updateFriendAttributes(
    Map<String, String> friendAttributes,
    String userID,
  );

  /// Query friend information in batches.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: If you need to query the information of a group of designated friends for display, you can query it through this interface.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendListQueriedResult].
  ///
  /// - [userIDs] The list of friend user IDs to query information for.
  Future<ZIMFriendsInfoQueriedResult> queryFriendsInfo(List<String> userIDs);

  /// Query the friends list.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: The list of friends that need to be paged can be queried through this interface.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendListQueriedResult].
  ///
  /// - [config] Friend list query configuration.
  Future<ZIMFriendListQueriedResult> queryFriendList(
    ZIMFriendListQueryConfig config,
  );

  /// Search local friends.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: Through this interface, you can search for local friend information based on keywords.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendsSearchedResult].
  ///
  /// - [config] Friend search configuration.
  Future<ZIMFriendsSearchedResult> searchLocalFriends(
    ZIMFriendSearchConfig config,
  );

  /// Send a friend application.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: When the user needs to initiate a friend application, he can initiate a friend application to the other party through [sendFriendApplication].
  /// Use cases: When you need to initiate a friend request for a user, you can call this interface.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Related callbacks: [onFriendApplicationListChanged].
  ///
  /// - [userID] The user ID to send the friend application to.
  /// - [config] Friend application configuration.
  Future<ZIMFriendApplicationSentResult> sendFriendApplication(
    String userID,
    ZIMFriendApplicationSendConfig config,
  );

  /// Accept a friend application.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: After receiving the friend application, accept the friend application through this interface.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendApplicationAcceptedResult].
  ///
  /// - [userID] The user ID of the friend application sender.
  /// - [config] Configuration for accepting the friend application.
  Future<ZIMFriendApplicationAcceptedResult> acceptFriendApplication(
    String userID,
    ZIMFriendApplicationAcceptConfig config,
  );

  /// Reject a friend application.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: After receiving the friend application, reject the friend application through this interface.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendApplicationRejectedResult].
  ///
  /// - [userID] The user ID of the friend application sender.
  /// - [config] Configuration for rejecting the friend application.
  Future<ZIMFriendApplicationRejectedResult> rejectFriendApplication(
    String userID,
    ZIMFriendApplicationRejectConfig config,
  );

  /// Query the friend application list.
  ///
  /// Available since: 2.14.0 or above.
  /// Description: If you need to paginate to query the list of friend applications, you can query through this interface.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMFriendApplicationListQueriedResult].
  ///
  /// - [config] Friend application list query configuration.
  Future<ZIMFriendApplicationListQueriedResult> queryFriendApplicationList(
    ZIMFriendApplicationListQueryConfig config,
  );

  /// Add users to the blacklist.
  ///
  /// Available since: 2.13.0 or above.
  /// Description: Through this interface, a user with the specified userID can be added to the blacklist.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMBlacklistUsersAddedResult].
  /// Restrictions: The number of userID passed in at one time cannot exceed 20.
  ///
  /// - [userIDs] The list of user IDs to add to the blacklist.
  Future<ZIMBlacklistUsersAddedResult> addUsersToBlacklist(
    List<String> userIDs,
  );

  /// Remove the user from the blacklist.
  ///
  /// Available since: 2.13.0 or above.
  /// Description: Through this interface, the user with the specified userID can be removed from the blacklist.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMBlacklistUsersRemovedResult].
  /// Restrictions: The number of userID passed in at one time cannot exceed 20.
  ///
  /// - [userIDs] The list of user IDs to remove from the blacklist.
  Future<ZIMBlacklistUsersRemovedResult> removeUsersFromBlacklist(
    List<String> userIDs,
  );

  /// Query the blacklist.
  ///
  /// Available since: 2.13.0 or above.
  /// Description: Query the blacklist.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMBlacklistQueriedResult].
  ///
  /// - [config] Blacklist query configuration.
  Future<ZIMBlacklistQueriedResult> queryBlacklist(
    ZIMBlacklistQueryConfig config,
  );

  /// Check if the user is on the blacklist.
  ///
  /// Available since: 2.13.0 or above.
  /// Description: Through this interface, you can check whether a certain userID is on the blacklist.
  /// When to call: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMBlacklistCheckedResult].
  ///
  /// - [userID] The user ID to check whether it is on the blacklist.
  Future<ZIMBlacklistCheckedResult> checkUserIsInBlacklist(String userID);

  /// Create a community.
  ///
  /// Available since: 3.0.0.
  /// Description: Create a community-type group that supports massive members interacting simultaneously.
  /// Use cases: Used to create a large-scale social group that supports up to 100,000 users chatting or interacting in the community at the same time.
  /// Related callbacks: The result of creating the community is obtained through the [ZIMCommunityCreatedResult] callback.
  ///
  /// - [communityInfo] Information for the community to be created.
  /// - [config] Create the relevant configuration of the community.
  Future<ZIMCommunityCreatedResult> createCommunity({
    required ZIMCommunityInfo communityInfo,
    ZIMCommunityCreateConfig? config,
  });

  /// Dismiss a community.
  ///
  /// Available since: 3.0.0.
  /// Description: After a community is created, the community owner can dismiss it through this interface.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Caution: Only the community owner can dismiss the community.
  /// Related callbacks: The result of dismissing the community is obtained through the [ZIMCommunityDismissedResult] callback.
  ///
  /// - [communityID] The ID of the community to dismiss.
  Future<ZIMCommunityDismissedResult> dismissCommunity({
    required String communityID,
  });

  /// Join a community.
  ///
  /// Available since: 3.0.0.
  /// Description: Users can join the specified community through this interface.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result of joining the community is obtained through the [ZIMCommunityJoinedResult] callback.
  ///
  /// - [communityID] The community ID to join.
  Future<ZIMCommunityJoinedResult> joinCommunity({required String communityID});

  /// Leave a community.
  ///
  /// Available since: 3.0.0.
  /// Description: After a user joins a community, they can leave through this interface.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result of leaving the community is obtained through the [ZIMCommunityLeftResult] callback.
  ///
  /// - [communityID] The community ID to leave.
  Future<ZIMCommunityLeftResult> leaveCommunity({required String communityID});

  /// Invite users into a community.
  ///
  /// Available since: 3.0.0.
  /// Description: Invite specified users to join the community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result of the invitation is obtained through the [ZIMCommunityUsersInvitedResult] callback.
  ///
  /// - [userIDs] The list of user IDs to invite.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityUsersInvitedResult> inviteUsersIntoCommunity({
    required List<String> userIDs,
    required String communityID,
  });

  /// Kick members from a community.
  ///
  /// Available since: 3.0.0.
  /// Description: Remove specified users from the community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Caution: Only the community owner and administrators can call this.
  /// Related callbacks: The result of kicking members is obtained through the [ZIMCommunityMembersKickedResult] callback.
  ///
  /// - [userIDs] The list of user IDs to kick from the community.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityMembersKickedResult> kickCommunityMembers({
    required List<String> userIDs,
    required String communityID,
  });

  /// Query the community list.
  ///
  /// Available since: 3.0.0.
  /// Description: Query the list of communities that the current user has joined.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The query result is obtained through the [ZIMCommunityListQueriedResult] callback.
  ///
  /// - [count] The number of communities to query.
  /// - [config] Community list query configuration (optional).
  Future<ZIMCommunityListQueriedResult> queryCommunityList({
    required int count,
    ZIMCommunityListQueryConfig? config,
  });

  /// Update the community name.
  ///
  /// Available since: 3.0.0.
  /// Description: Update the name of the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The update result is obtained through the [ZIMCommunityNameUpdatedResult] callback.
  ///
  /// - [communityName] The new community name.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityNameUpdatedResult> updateCommunityName({
    required String communityName,
    required String communityID,
  });

  /// Update the community avatar URL.
  ///
  /// Available since: 3.0.0.
  /// Description: Update the avatar URL of the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The update result is obtained through the [ZIMCommunityAvatarUrlUpdatedResult] callback.
  ///
  /// - [communityAvatarUrl] The new community avatar URL.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityAvatarUrlUpdatedResult> updateCommunityAvatarUrl({
    required String communityAvatarUrl,
    required String communityID,
  });

  /// Update the community notice.
  ///
  /// Available since: 3.0.0.
  /// Description: Update the notice content of the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The update result is obtained through the [ZIMCommunityNoticeUpdatedResult] callback.
  ///
  /// - [communityNotice] The new community notice content.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityNoticeUpdatedResult> updateCommunityNotice({
    required String communityNotice,
    required String communityID,
  });

  /// Update the community join mode.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: After a community is created, the community owner and administrators can use this method to update the community join mode.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityJoinModeUpdatedResult] callback.
  ///
  /// - [joinMode] The target join mode.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityJoinModeUpdatedResult> updateCommunityJoinMode({
    required ZIMCommunityJoinMode joinMode,
    required String communityID,
  });

  /// Update the message fetch count for community visitors.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: Users can update the count of messages to fetch as a community visitor through this interface.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: [ZIMCommunityVisitorFetchMessageCountUpdatedResult]
  ///
  /// - [count] The count of messages to fetch.
  /// - [communityID] The community ID.
  Future<ZIMCommunityVisitorFetchMessageCountUpdatedResult>
  updateCommunityVisitorFetchMessageCount({
    required int count,
    required String communityID,
  });

  /// Update the message fetch time duration for community visitors.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: Users can update the time duration for fetching messages as a community visitor through this interface.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: [ZIMCommunityVisitorFetchMessageDurationUpdatedResult]
  ///
  /// - [duration] The time duration for fetching messages, in seconds.
  /// - [communityID] The community ID.
  Future<ZIMCommunityVisitorFetchMessageDurationUpdatedResult>
  updateCommunityVisitorFetchMessageDuration({
    required int duration,
    required String communityID,
  });

  /// Set community attributes.
  ///
  /// Available since: 3.0.0.
  /// Description: Set custom attributes for the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityAttributesOperatedResult] callback.
  ///
  /// - [communityAttributes] The community attributes to set, in key-value pairs.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityAttributesOperatedResult> setCommunityAttributes({
    required Map<String, String> communityAttributes,
    required String communityID,
  });

  /// Delete community attributes.
  ///
  /// Available since: 3.0.0.
  /// Description: Delete custom attributes of the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The deletion result is obtained through the [ZIMCommunityAttributesOperatedResult] callback.
  ///
  /// - [keys] The list of community attribute keys to delete.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityAttributesOperatedResult> deleteCommunityAttributes({
    required List<String> keys,
    required String communityID,
  });

  /// Set the community notification status.
  ///
  /// Available since: 3.0.0.
  /// Description: Set the message notification status (such as Do Not Disturb) for the current user in the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityNotificationStatusSetResult] callback.
  ///
  /// - [status] The notification status to set.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityNotificationStatusSetResult>
  setCommunityNotificationStatus({
    required ZIMCommunityMessageNotificationStatus status,
    required String communityID,
  });

  /// Query community information.
  ///
  /// Available since: 3.0.0.
  /// Description: Query the detailed information of the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The query result is obtained through the [ZIMCommunityInfoQueriedResult] callback.
  ///
  /// - [communityID] The community ID to query information for.
  Future<ZIMCommunityInfoQueriedResult> queryCommunityInfo({
    required String communityID,
  });

  /// Update a community member's role.
  ///
  /// Available since: 3.0.0.
  /// Description: Update the role of the specified community member.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Caution: Only the community owner can call this.
  /// Related callbacks: The update result is obtained through the [ZIMCommunityMemberRoleUpdatedResult] callback.
  ///
  /// - [memberRole] The role value to set for the member.
  /// - [forUserID] The user ID of the target community member.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityMemberRoleUpdatedResult> updateCommunityMemberRole({
    required int memberRole,
    required String forUserID,
    required String communityID,
  });

  /// Transfer the community owner.
  ///
  /// Available since: 3.0.0.
  /// Description: The community owner can transfer ownership to a specified user through this method.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Caution: Only the community owner can call this.
  /// Related callbacks: The transfer result is obtained through the [ZIMCommunityOwnerTransferredResult] callback.
  ///
  /// - [toUserID] The user ID of the new community owner.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityOwnerTransferredResult> transferCommunityOwner({
    required String toUserID,
    required String communityID,
  });

  /// Query the community member list.
  ///
  /// Available since: 3.0.0.
  /// Description: Query the member list of the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The query result is obtained through the [ZIMCommunityMemberListQueriedResult] callback.
  ///
  /// - [communityID] The community ID to query the member list for.
  /// - [count] The number of members to query.
  /// - [config] Community member list query configuration (optional).
  Future<ZIMCommunityMemberListQueriedResult> queryCommunityMemberList({
    required String communityID,
    required int count,
    ZIMCommunityMemberListQueryConfig? config,
  });

  /// Query specific community members' information.
  ///
  /// Available since: 3.0.0.
  /// Description: Query the member information of specific users in the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The query result is obtained through the [ZIMCommunityMembersQueriedResult] callback.
  ///
  /// - [userIDs] The list of user IDs to query information for.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityMembersQueriedResult> queryCommunityMembers({
    required List<String> userIDs,
    required String communityID,
  });

  /// Enter a community as visitor.
  ///
  /// Available since: 3.2.0.
  /// Description: Users can join a specified community as a visitor through this interface.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result of enter the community is obtained through the [ZIMCommunityAsVisitorEnteredResult] callback.
  ///
  /// - [communityID] The community ID to enter.
  Future<ZIMCommunityAsVisitorEnteredResult> enterCommunityAsVisitor({
    required String communityID,
  });

  /// Quit a community as a visitor.
  ///
  /// Available since: 3.2.0.
  /// Description: After a user enter a community as visitor, they can leave the community through this interface.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result of leaving the community is obtained through the [ZIMCommunityAsVisitorQuitResult] callback.
  ///
  /// - [communityID] The community ID to quit.
  Future<ZIMCommunityAsVisitorQuitResult> quitCommunityAsVisitor({
    required String communityID,
  });

  /// Create a community channel.
  ///
  /// Available since: 3.0.0.
  /// Description: Create a chat channel within a community. The current version only supports creating public channels.
  /// Use cases: Used to distinguish different chat topics within a community, allowing community administrators to manage separately and gather users with the same interests under the same topic.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Caution: Only the community owner and community administrators can create channels in the community.
  ///
  /// - [channelInfo] Information for the community channel to be created.
  /// - [config] Create the relevant configuration of the community channel.
  Future<ZIMCommunityChannelCreatedResult> createCommunityChannel({
    required ZIMCommunityChannelInfo channelInfo,
    ZIMCommunityChannelCreateConfig? config,
  });

  /// Dismiss a community channel.
  ///
  /// Available since: 3.0.0.
  /// Description: Dismiss the specified channel in the community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The dismissal result is obtained through the [ZIMCommunityChannelDismissedResult] callback.
  ///
  /// - [channelID] The channel ID to dismiss.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityChannelDismissedResult> dismissCommunityChannel({
    required String channelID,
    required String communityID,
  });

  /// Update the community channel name.
  ///
  /// Available since: 3.0.0.
  /// Description: Update the name of the specified community channel.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The update result is obtained through the [ZIMCommunityChannelNameUpdatedResult] callback.
  ///
  /// - [channelName] The new channel name.
  /// - [channelID] The channel ID to update the name for.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityChannelNameUpdatedResult> updateCommunityChannelName({
    required String channelName,
    required String channelID,
    required String communityID,
  });

  /// Update the community channel avatar URL.
  ///
  /// Available since: 3.0.0.
  /// Description: Update the avatar URL of the specified community channel.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The update result is obtained through the [ZIMCommunityChannelAvatarUrlUpdatedResult] callback.
  ///
  /// - [channelAvatarUrl] The new channel avatar URL.
  /// - [channelID] The channel ID to update the avatar URL for.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityChannelAvatarUrlUpdatedResult>
  updateCommunityChannelAvatarUrl({
    required String channelAvatarUrl,
    required String channelID,
    required String communityID,
  });

  /// Update the community channel notice.
  ///
  /// Available since: 3.0.0.
  /// Description: Update the notice content of the specified community channel.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The update result is obtained through the [ZIMCommunityChannelNoticeUpdatedResult] callback.
  ///
  /// - [channelNotice] The new channel notice content.
  /// - [channelID] The channel ID to update the notice for.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityChannelNoticeUpdatedResult> updateCommunityChannelNotice({
    required String channelNotice,
    required String channelID,
    required String communityID,
  });

  /// Set community channel attributes.
  ///
  /// Available since: 3.0.0.
  /// Description: Set custom attributes for the specified community channel.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityChannelAttributesOperatedResult] callback.
  ///
  /// - [channelAttributes] The channel attributes to set, in key-value pairs.
  /// - [channelID] The target channel ID.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityChannelAttributesOperatedResult>
  setCommunityChannelAttributes({
    required Map<String, String> channelAttributes,
    required String channelID,
    required String communityID,
  });

  /// Delete community channel attributes.
  ///
  /// Available since: 3.0.0.
  /// Description: Delete custom attributes of the specified community channel.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The deletion result is obtained through the [ZIMCommunityChannelAttributesOperatedResult] callback.
  ///
  /// - [keys] The list of channel attribute keys to delete.
  /// - [channelID] The target channel ID.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityChannelAttributesOperatedResult>
  deleteCommunityChannelAttributes({
    required List<String> keys,
    required String channelID,
    required String communityID,
  });

  /// Query community channel information.
  ///
  /// Available since: 3.0.0.
  /// Description: Query the detailed information of multiple channels in the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The query result is obtained through the [ZIMCommunityChannelsInfoQueriedResult] callback.
  ///
  /// - [channelIDs] The list of channel IDs to query information for.
  /// - [communityID] The target community ID.
  Future<ZIMCommunityChannelsInfoQueriedResult> queryCommunityChannelsInfo({
    required List<String> channelIDs,
    required String communityID,
  });

  /// Query the community channel list.
  ///
  /// Available since: 3.0.0.
  /// Description: Query the channel list of the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The query result is obtained through the [ZIMCommunityChannelListQueriedResult] callback.
  ///
  /// - [communityID] The community ID to query the channel list for.
  /// - [count] The number of channels to query.
  /// - [config] Community channel list query configuration (optional).
  Future<ZIMCommunityChannelListQueriedResult> queryCommunityChannelList({
    required String communityID,
    required int count,
    ZIMCommunityChannelListQueryConfig? config,
  });

  /// Mute community channels.
  ///
  /// Available since: 3.0.0.
  /// Description: Mute or unmute channels in the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The operation result is obtained through the [ZIMCommunityChannelsMutedResult] callback.
  ///
  /// - [isMute] Whether to mute. true means mute, false means unmute.
  /// - [channelIDs] The list of channel IDs to mute/unmute.
  /// - [communityID] The target community ID.
  /// - [config] Community channel mute configuration (optional).
  Future<ZIMCommunityChannelsMutedResult> muteCommunityChannels({
    required bool isMute,
    required List<String> channelIDs,
    required String communityID,
    ZIMCommunityChannelMuteConfig? config,
  });

  /// Mute community members.
  ///
  /// Available since: 3.0.0.
  /// Description: Mute or unmute members in the specified community.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Caution: Only the community owner and administrators can call this.
  /// Related callbacks: The operation result is obtained through the [ZIMCommunityMembersMutedResult] callback.
  ///
  /// - [isMute] Whether to mute. true means mute, false means unmute.
  /// - [userIDs] The list of user IDs to mute/unmute.
  /// - [communityID] The target community ID.
  /// - [config] Community member mute configuration (optional).
  Future<ZIMCommunityMembersMutedResult> muteCommunityMembers({
    required bool isMute,
    required List<String> userIDs,
    required String communityID,
    ZIMCommunityMemberMuteConfig? config,
  });

  /// Send an application to join the community.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: When a community's joinMode is Auth, users can send an application to join the community through this method.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityJoinApplicationSentResult] callback.
  ///
  /// - [communityID] The community ID to apply to join.
  /// - [config] Community join application configuration.
  Future<ZIMCommunityJoinApplicationSentResult> sendCommunityJoinApplication({
    required String communityID,
    required ZIMCommunityJoinApplicationSendConfig config,
  });

  /// Query the self community application list.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: Query the community join applications submitted by the current user in all communities from the server page by page, returning from the newest to the oldest by application ID (applyID). The application list is not persisted locally.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in, and the network must be connected.
  /// Caution: The nextFlag is the pagination anchor (the applyID of the last application in the previous page). Pass 0 to the config's nextFlag to query from the latest page, and pass the nextFlag returned by the previous page callback to query the next page. The nextFlag returned by the callback being 0 means the list has been fully pulled.
  /// Related callbacks: The result is obtained through the [ZIMCommunitySelfApplicationListQueriedResult] callback.
  ///
  /// - [count] The number of applications to query at one time. It is advised to be no more than 30.
  /// - [config] Self community application list query configuration.
  Future<ZIMCommunitySelfApplicationListQueriedResult>
  queryCommunitySelfApplicationList({
    required int count,
    required ZIMCommunitySelfApplicationListQueryConfig config,
  });

  /// Cancel the community join application.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: Cancel the community join application submitted by the current user that is still awaiting response.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityJoinApplicationCancelledResult] callback.
  ///
  /// - [applyID] The unique ID of the community application to cancel.
  /// - [communityID] The target community ID.
  /// - [config] Configuration for canceling the community join application.
  Future<void> cancelCommunityJoinApplication({
    required int applyID,
    required String communityID,
    required ZIMCommunityJoinApplicationCancelConfig config,
  });

  /// Accept an application to join the community.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: The community owner and administrators can use this method to accept the community join application submitted by the specified user that is still awaiting response.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityJoinApplicationAcceptedResult] callback.
  ///
  /// - [userID] The ID of the user who submitted the application.
  /// - [communityID] The target community ID.
  /// - [applyID] The unique ID of the community application to accept.
  /// - [config] Configuration for accepting the community join application.
  Future<ZIMCommunityJoinApplicationAcceptedResult>
  acceptCommunityJoinApplication({
    required String userID,
    required String communityID,
    required int applyID,
    required ZIMCommunityJoinApplicationAcceptConfig config,
  });

  /// Reject an application to join the community.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: The community owner and administrators can use this method to reject the community join application submitted by the specified user that is still awaiting response.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in.
  /// Related callbacks: The result is obtained through the [ZIMCommunityJoinApplicationRejectedResult] callback.
  ///
  /// - [userID] The ID of the user who submitted the application.
  /// - [communityID] The target community ID.
  /// - [applyID] The unique ID of the community application to reject.
  /// - [config] Configuration for rejecting the community join application.
  Future<ZIMCommunityJoinApplicationRejectedResult>
  rejectCommunityJoinApplication({
    required String userID,
    required String communityID,
    required int applyID,
    required ZIMCommunityJoinApplicationRejectConfig config,
  });

  /// Query the community application list.
  ///
  /// Available since: 3.2.0 and above.
  /// Description: The community owner and administrators can use this method to query the community join applications under the specified community from the server page by page (including pending and processed applications), returning from the newest to the oldest.
  /// When to call: Can be called after creating a ZIM instance via [create] and logging in, and the network must be connected.
  /// Caution: Pass 0 to the config's nextFlag to query from the latest page, and pass the nextFlag returned by the previous page callback to query the next page. The nextFlag returned by the callback being 0 means the list has been fully pulled.
  /// Related callbacks: The result is obtained through the [ZIMCommunityApplicationListQueriedResult] callback.
  ///
  /// - [communityID] The target community ID.
  /// - [count] The number of applications to query at one time. It is advised to be no more than 30.
  /// - [config] Community application list query configuration.
  Future<ZIMCommunityApplicationListQueriedResult>
  queryCommunityApplicationList({
    required String communityID,
    required int count,
    required ZIMCommunityApplicationListQueryConfig config,
  });
}
