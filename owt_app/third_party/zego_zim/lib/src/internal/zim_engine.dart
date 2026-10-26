import 'dart:async';

import 'package:flutter/services.dart';

import '../zim_api.dart';
import '../zim_defines.dart';
import 'zim_common_data.dart';
//import 'zim_defines_extension.dart';
import 'zim_manager.dart';

class ZIMEngine implements ZIM {
  String handle;
  int appID;
  String appSign;
  MethodChannel channel;
  ZIMEngine(
      {required this.handle,
      required this.channel,
      required this.appID,
      required this.appSign});

  @override
  destroy() {
    if (ZIMManager.destroyEngine(handle)) {
      channel.invokeMethod("destroy", {"handle": handle});
      // TODO: Remove another map
      // ZIMEventHandlerImpl.unregisterEventHandler();
    }
  }

  @override
  Future<void> login(String userID, ZIMLoginConfig config) async {
    return await channel.invokeMethod("login",
        {"handle": handle, "userID": userID, "config": config.toMap()});
  }

  @override
  logout() {
    channel.invokeMethod('logout', {"handle": handle});
  }

  @override
  Future<void> uploadLog() async {
    return await channel.invokeMethod('uploadLog', {"handle": handle});
  }

  @override
  Future<ZIMTokenRenewedResult> renewToken(String token) async {
    Map resultMap = await channel
        .invokeMethod('renewToken', {'handle': handle, 'token': token});
    return ZIMTokenRenewedResult.fromMap(resultMap);
  }

  @override
  Future<String> callExperimentalAPI(String params) async {
    String resultMap = await channel.invokeMethod(
        'callExperimentalAPI', {'handle': handle, 'params': params});
    return resultMap;
  }

  @override
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
      List<String> userIDs, ZIMUserInfoQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryUsersInfo',
        {'handle': handle, 'userIDs': userIDs, 'config': config.toMap()});

    return ZIMUsersInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMUserExtendedDataUpdatedResult> updateUserExtendedData(
      String extendedData) async {
    Map resultMap = await channel.invokeMethod('updateUserExtendedData',
        {'handle': handle, 'extendedData': extendedData});
    return ZIMUserExtendedDataUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(
      String userAvatarUrl) async {
    Map resultMap = await channel.invokeMethod('updateUserAvatarUrl',
        {'handle': handle, 'userAvatarUrl': userAvatarUrl});
    return ZIMUserAvatarUrlUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMUserNameUpdatedResult> updateUserName(String userName) async {
    Map resultMap = await channel.invokeMethod(
        'updateUserName', {'handle': handle, 'userName': userName});
    return ZIMUserNameUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMUserOfflinePushRuleUpdatedResult> updateUserOfflinePushRule(
      ZIMUserOfflinePushRule offlinePushRule) async {
    Map resultMap = await channel.invokeMethod('updateUserOfflinePushRule', {
      'handle': handle,
      'offlinePushRule': offlinePushRule.toMap(),
    });
    return ZIMUserOfflinePushRuleUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMUserCustomStatusUpdatedResult> updateUserCustomStatus(
      {required String customStatus,
      ZIMUserCustomStatusUpdateConfig? config}) async {
    Map resultMap = await channel.invokeMethod('updateUserCustomStatus', {
      'handle': handle,
      'customStatus': customStatus,
      'config': config?.toMap() ?? ZIMUserCustomStatusUpdateConfig().toMap()
    });
    return ZIMUserCustomStatusUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<void> updateUserBadge({required int badge}) async {
    return await channel
        .invokeMethod('updateUserBadge', {'handle': handle, 'badge': badge});
  }

  @override
  Future<ZIMUsersStatusQueriedResult> queryUsersStatus(
      List<String> userIDs) async {
    Map resultMap = await channel.invokeMethod(
        'queryUsersStatus', {'handle': handle, 'userIDs': userIDs});
    return ZIMUsersStatusQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMSelfUserInfoQueriedResult> querySelfUserInfo() async {
    Map resultMap =
        await channel.invokeMethod('querySelfUserInfo', {'handle': handle});

    return ZIMSelfUserInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMUsersStatusSubscribedResult> subscribeUsersStatus(
      List<String> userIDs, ZIMUserStatusSubscribeConfig config) async {
    Map resultMap = await channel.invokeMethod('subscribeUsersStatus',
        {'handle': handle, 'userIDs': userIDs, 'config': config.toMap()});
    return ZIMUsersStatusSubscribedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMUsersStatusUnsubscribedResult> unsubscribeUsersStatus(
      List<String> userIDs) async {
    Map resultMap = await channel.invokeMethod(
        'unsubscribeUsersStatus', {'handle': handle, 'userIDs': userIDs});
    return ZIMUsersStatusUnsubscribedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMSubscribedUserStatusListQueriedResult>
      querySubscribedUserStatusList(
          ZIMSubscribedUserStatusQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('querySubscribedUserStatusList',
        {'handle': handle, 'config': config.toMap()});
    return ZIMSubscribedUserStatusListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config,
      [ZIMConversationFilterOption? option]) async {
    Map resultMap = await channel.invokeMethod('queryConversationList', {
      'handle': handle,
      'config': config.toMap(),
      'option': option?.toMap()
    });
    return ZIMConversationListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationDeletedResult> deleteConversation(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMConversationDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteConversation', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'config': config.toMap()
    });
    return ZIMConversationDeletedResult.fromMap(resultMap);
  }

  @override
  Future<void> deleteAllConversations(
      ZIMConversationDeleteConfig config) async {
    return await channel.invokeMethod(
        'deleteAllConversations', {'handle': handle, 'config': config.toMap()});
  }

  @override
  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversationID, ZIMConversationType conversationType) async {
    Map resultMap =
        await channel.invokeMethod('clearConversationUnreadMessageCount', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMConversationUnreadMessageCountClearedResult.fromMap(resultMap);
  }

  @override
  Future<void> clearConversationTotalUnreadMessageCount() async {
    return await channel
        .invokeMethod('clearConversationTotalUnreadMessageCount', {
      'handle': handle,
    });
  }

  @override
  Future<ZIMConversationTotalUnreadMessageCountQueriedResult>
      queryConversationTotalUnreadMessageCount(
          ZIMConversationTotalUnreadMessageCountQueryConfig config) async {
    Map resultMap = await channel.invokeMethod(
        'queryConversationTotalUnreadMessageCount',
        {'handle': handle, 'config': config.toMap()});
    return ZIMConversationTotalUnreadMessageCountQueriedResult.fromMap(
        resultMap);
  }

  @override
  Future<ZIMConversationPinnedListQueriedResult> queryConversationPinnedList(
      ZIMConversationQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryConversationPinnedList',
        {'handle': handle, 'config': config.toMap()});
    return ZIMConversationPinnedListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationPinnedStateUpdatedResult> updateConversationPinnedState(
      bool isPinned,
      String conversationID,
      ZIMConversationType conversationType) async {
    Map resultMap =
        await channel.invokeMethod('updateConversationPinnedState', {
      'handle': handle,
      'isPinned': isPinned,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMConversationPinnedStateUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationQueriedResult> queryConversation(
      String conversationID, ZIMConversationType conversationType) async {
    Map resultMap = await channel.invokeMethod('queryConversation', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMConversationQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationsSearchedResult> searchLocalConversations(
      ZIMConversationSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalConversations',
        {'handle': handle, 'config': config.toMap()});
    return ZIMConversationsSearchedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
          ZIMConversationNotificationStatus status,
          String conversationID,
          ZIMConversationType conversationType) async {
    Map resultMap =
        await channel.invokeMethod('setConversationNotificationStatus', {
      'handle': handle,
      'status': status.value,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMConversationNotificationStatusSetResult.fromMap(resultMap);
  }

  /*@override
  Future<ZIMConversationNotificationStatusSetResult>
      setCommunityChannelNotificationStatus(
    ZIMConversationNotificationStatus status,
    String communityID,
    String communityChannelID,
  ) async {
    Map resultMap =
        await channel.invokeMethod('setCommunityChannelNotificationStatus', {
      'handle': handle,
      'status': status.value,
      'communityID': communityID,
      'communityChannelID': communityChannelID
    });
    return ZIMConversationNotificationStatusSetResult.fromMap(resultMap);
  }*/

  @override
  Future<ZIMCommunityNotificationStatusSetResult>
      setCommunityNotificationStatus(
          {required ZIMCommunityMessageNotificationStatus status,
          required String communityID}) async {
    Map resultMap = await channel.invokeMethod('setCommunityNotificationStatus',
        {'handle': handle, 'status': status.value, 'communityID': communityID});
    return ZIMCommunityNotificationStatusSetResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationMessageReceiptReadSentResult>
      sendConversationMessageReceiptRead(
          String conversationID, ZIMConversationType conversationType) async {
    Map resultMap =
        await channel.invokeMethod('sendConversationMessageReceiptRead', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMConversationMessageReceiptReadSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationDraftSetResult> setConversationDraft(String draft,
      String conversationID, ZIMConversationType conversationType) async {
    Map resultMap = await channel.invokeMethod('setConversationDraft', {
      'handle': handle,
      'draft': draft,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMConversationDraftSetResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationMarkSetResult> setConversationMark(
      int markType, bool enable, List<ZIMConversationBaseInfo> infos) async {
    Map resultMap = await channel.invokeMethod('setConversationMark', {
      'handle': handle,
      'markType': markType,
      'enable': enable,
      'infos': infos.map((item) => item.toMap()).toList()
    });
    return ZIMConversationMarkSetResult.fromMap(resultMap);
  }

  @override
  Future<ZIMConversationMessageDestructDurationSetResult>
      setConversationMessageDestructDuration(
          {required int duration,
          required String conversationID,
          required ZIMConversationType conversationType}) async {
    Map resultMap =
        await channel.invokeMethod('setConversationMessageDestructDuration', {
      'handle': handle,
      'duration': duration,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMConversationMessageDestructDurationSetResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendPeerMessage(
      ZIMMessage message, String toUserID, ZIMMessageSendConfig config) async {
    return sendMessage(message, toUserID, ZIMConversationType.peer, config);
  }

  @override
  Future<ZIMMessageSentResult> sendGroupMessage(
      ZIMMessage message, String toGroupID, ZIMMessageSendConfig config) async {
    return sendMessage(message, toGroupID, ZIMConversationType.group, config);
  }

  @override
  Future<ZIMMessageSentResult> sendRoomMessage(
      ZIMMessage message, String toRoomID, ZIMMessageSendConfig config) async {
    return sendMessage(message, toRoomID, ZIMConversationType.room, config);
  }

  @override
  Future<ZIMMediaDownloadedResult> downloadMediaFile(
      ZIMMessage message,
      ZIMMediaFileType fileType,
      ZIMMediaDownloadConfig config,
      ZIMMediaDownloadingProgress? progress) async {
    Map resultMap;
    if (progress != null) {
      int progressID = ZIMCommonData.getSequence();
      ZIMCommonData.mediaDownloadingProgressMap[progressID] = progress;
      resultMap = await channel.invokeMethod('downloadMediaFile', {
        'handle': handle,
        'message': message.toMap(),
        'fileType': fileType.value,
        'config': config.toMap(),
        'progressID': progressID
      });
      ZIMCommonData.mediaDownloadingProgressMap.remove(progressID);
    } else {
      resultMap = await channel.invokeMethod('downloadMediaFile', {
        'handle': handle,
        'message': message.toMap(),
        'fileType': fileType.value,
        'config': config.toMap(),
      });
    }
    return ZIMMediaDownloadedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendMediaMessage(
      ZIMMediaMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      ZIMMediaMessageSendNotification? notification) async {
    int messageID = ZIMCommonData.getSequence();
    ZIMCommonData.messsageMap[messageID] = message;

    int? messageAttachedCallbackID;
    int? mediaUploadingCallbackID;
    int? multipleMediaUploadingCallbackID;
    if (notification?.onMessageAttached != null) {
      messageAttachedCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.zimMessageAttachedCallbackMap[messageAttachedCallbackID] =
          notification!.onMessageAttached!;
    }
    if (notification?.onMediaUploadingProgress != null) {
      mediaUploadingCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.mediaUploadingProgressMap[mediaUploadingCallbackID] =
          notification!.onMediaUploadingProgress!;
    }
    try {
      Map resultMap = await channel.invokeMethod('sendMessage', {
        'handle': handle,
        'message': message.toMap(),
        'toConversationID': toConversationID,
        'conversationType': conversationType.value,
        'config': config.toMap(),
        'messageID': messageID,
        'messageAttachedCallbackID': messageAttachedCallbackID,
        'mediaUploadingCallbackID': mediaUploadingCallbackID,
        'multipleMediaUploadingCallbackID': multipleMediaUploadingCallbackID,
      });
      return ZIMMessageSentResult.fromMap(resultMap);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.messsageMap.remove(messageID);
      ZIMCommonData.zimMessageAttachedCallbackMap
          .remove(messageAttachedCallbackID);
      ZIMCommonData.mediaUploadingProgressMap.remove(mediaUploadingCallbackID);
    }
  }

  @override
  Future<ZIMMessageSentResult> sendMessage(
      ZIMMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      [ZIMMessageSendNotification? notification]) async {
    int messageID = ZIMCommonData.getSequence();
    ZIMCommonData.messsageMap[messageID] = message;

    int? messageAttachedCallbackID;
    int? mediaUploadingCallbackID;
    int? multipleMediaUploadingCallbackID;
    if (notification?.onMessageAttached != null) {
      messageAttachedCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.zimMessageAttachedCallbackMap[messageAttachedCallbackID] =
          notification!.onMessageAttached!;
    }
    if (notification?.onMediaUploadingProgress != null) {
      mediaUploadingCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.mediaUploadingProgressMap[mediaUploadingCallbackID] =
          notification!.onMediaUploadingProgress!;
    }
    if (notification?.onMultipleMediaUploadingProgress != null) {
      multipleMediaUploadingCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.multipleMediaUploadingProgressMap[
              multipleMediaUploadingCallbackID] =
          notification!.onMultipleMediaUploadingProgress!;
    }
    try {
      Map resultMap = await channel.invokeMethod('sendMessage', {
        'handle': handle,
        'message': message.toMap(),
        'toConversationID': toConversationID,
        'conversationType': conversationType.value,
        'config': config.toMap(),
        'messageID': messageID,
        'messageAttachedCallbackID': messageAttachedCallbackID,
        'mediaUploadingCallbackID': mediaUploadingCallbackID,
        'multipleMediaUploadingCallbackID': multipleMediaUploadingCallbackID,
      });
      return ZIMMessageSentResult.fromMap(resultMap);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.messsageMap.remove(messageID);
      ZIMCommonData.zimMessageAttachedCallbackMap
          .remove(messageAttachedCallbackID);
      ZIMCommonData.mediaUploadingProgressMap.remove(mediaUploadingCallbackID);
      ZIMCommonData.multipleMediaUploadingProgressMap
          .remove(multipleMediaUploadingCallbackID);
    }
  }

  @override
  Future<ZIMMessageSentResult> replyMessage(
      ZIMMessage message,
      ZIMMessage toOriginalMessage,
      ZIMMessageSendConfig config,
      ZIMMessageSendNotification? notification) async {
    int messageID = ZIMCommonData.getSequence();
    ZIMCommonData.messsageMap[messageID] = message;

    int? messageAttachedCallbackID;
    int? mediaUploadingCallbackID;
    int? multipleMediaUploadingCallbackID;
    if (notification?.onMessageAttached != null) {
      messageAttachedCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.zimMessageAttachedCallbackMap[messageAttachedCallbackID] =
          notification!.onMessageAttached!;
    }
    if (notification?.onMediaUploadingProgress != null) {
      mediaUploadingCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.mediaUploadingProgressMap[mediaUploadingCallbackID] =
          notification!.onMediaUploadingProgress!;
    }
    if (notification?.onMultipleMediaUploadingProgress != null) {
      multipleMediaUploadingCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.multipleMediaUploadingProgressMap[
              multipleMediaUploadingCallbackID] =
          notification!.onMultipleMediaUploadingProgress!;
    }
    try {
      Map resultMap = await channel.invokeMethod('replyMessage', {
        'handle': handle,
        'message': message.toMap(),
        'toOriginalMessage': toOriginalMessage.toMap(),
        'config': config.toMap(),
        'messageID': messageID,
        'messageAttachedCallbackID': messageAttachedCallbackID,
        'mediaUploadingCallbackID': mediaUploadingCallbackID,
        'multipleMediaUploadingCallbackID': multipleMediaUploadingCallbackID
      });
      return ZIMMessageSentResult.fromMap(resultMap);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.messsageMap.remove(messageID);
      ZIMCommonData.zimMessageAttachedCallbackMap
          .remove(messageAttachedCallbackID);
      ZIMCommonData.mediaUploadingProgressMap.remove(mediaUploadingCallbackID);
      ZIMCommonData.multipleMediaUploadingProgressMap
          .remove(multipleMediaUploadingCallbackID);
    }
  }

  @override
  Future<ZIMMessageEditedResult> editMessage(
      ZIMMessage message,
      ZIMMessageEditConfig config,
      ZIMMessageSendNotification? notification) async {
    int messageID = ZIMCommonData.getSequence();
    ZIMCommonData.messsageMap[messageID] = message;

    int? messageAttachedCallbackID;
    int? multipleMediaUploadingCallbackID;
    if (notification?.onMessageAttached != null) {
      messageAttachedCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.zimMessageAttachedCallbackMap[messageAttachedCallbackID] =
          notification!.onMessageAttached!;
    }
    if (notification?.onMultipleMediaUploadingProgress != null) {
      multipleMediaUploadingCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.multipleMediaUploadingProgressMap[
              multipleMediaUploadingCallbackID] =
          notification!.onMultipleMediaUploadingProgress!;
    }
    try {
      Map configMap = {};
      Map resultMap = await channel.invokeMethod('editMessage', {
        'handle': handle,
        'message': message.toMap(),
        'config': configMap,
        'messageID': messageID,
        'messageAttachedCallbackID': messageAttachedCallbackID,
        'multipleMediaUploadingCallbackID': multipleMediaUploadingCallbackID
      });
      return ZIMMessageEditedResult.fromMap(resultMap);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.messsageMap.remove(messageID);
      ZIMCommonData.zimMessageAttachedCallbackMap
          .remove(messageAttachedCallbackID);
      ZIMCommonData.multipleMediaUploadingProgressMap
          .remove(multipleMediaUploadingCallbackID);
    }
  }

  @override
  Future<ZIMMessageQueriedResult> queryHistoryMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryHistoryMessage', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'config': config.toMap()
    });
    return ZIMMessageQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageDeletedResult> deleteAllMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteAllMessage', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'config': config.toMap()
    });
    return ZIMMessageDeletedResult.fromMap(resultMap);
  }

  @override
  Future<void> deleteAllConversationMessages(
      ZIMMessageDeleteConfig config) async {
    return await channel.invokeMethod('deleteAllConversationMessages',
        {'handle': handle, 'config': config.toMap()});
  }

  @override
  Future<ZIMMessageDeletedResult> deleteMessages(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteMessages', {
      'handle': handle,
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'config': config.toMap()
    });
    return ZIMMessageDeletedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageInsertedResult> insertMessageToLocalDB(
      ZIMMessage message,
      String conversationID,
      ZIMConversationType conversationType,
      String senderUserID) async {
    int messageID = ZIMCommonData.getSequence();
    ZIMCommonData.messsageMap[messageID] = message;
    try {
      Map resultMap = await channel.invokeMethod('insertMessageToLocalDB', {
        'handle': handle,
        'message': message.toMap(),
        'messageID': messageID,
        'conversationID': conversationID,
        'conversationType': conversationType.value,
        'senderUserID': senderUserID
      });
      return ZIMMessageInsertedResult.fromMap(resultMap);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.messsageMap.remove(messageID);
    }
  }

  @override
  Future<ZIMMessageReceiptsReadSentResult> sendMessageReceiptsRead(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType) async {
    Map resultMap = await channel.invokeMethod('sendMessageReceiptsRead', {
      'handle': handle,
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMMessageReceiptsReadSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageReceiptsInfoQueriedResult> queryMessageReceiptsInfo(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType) async {
    Map resultMap = await channel.invokeMethod('queryMessageReceiptsInfo', {
      'handle': handle,
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMMessageReceiptsInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageRevokedResult> revokeMessage(
      ZIMMessage message, ZIMMessageRevokeConfig config) async {
    Map resultMap = await channel.invokeMethod('revokeMessage', {
      'handle': handle,
      'message': message.toMap(),
      'config': config.toMap()
    });
    return ZIMMessageRevokedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageLocalExtendedDataUpdatedResult>
      updateMessageLocalExtendedData(
          String localExtendedData, ZIMMessage message) async {
    Map resultMap =
        await channel.invokeMethod('updateMessageLocalExtendedData', {
      'handle': handle,
      'localExtendedData': localExtendedData,
      'message': message.toMap()
    });
    return ZIMMessageLocalExtendedDataUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageReactionAddedResult> addMessageReaction(
      {required String reactionType,
      required ZIMMessage message,
      ZIMMessageReactionAddConfig? config}) async {
    Map resultMap = await channel.invokeMethod('addMessageReaction', {
      'handle': handle,
      'reactionType': reactionType,
      'message': message.toMap(),
      'config': config?.toMap() ?? ZIMMessageReactionAddConfig().toMap()
    });
    return ZIMMessageReactionAddedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageReactionDeletedResult> deleteMessageReaction(
      {required String reactionType, required ZIMMessage message}) async {
    Map resultMap = await channel.invokeMethod('deleteMessageReaction', {
      'handle': handle,
      'reactionType': reactionType,
      'message': message.toMap()
    });
    return ZIMMessageReactionDeletedResult.fromMap(resultMap);
  }

  @override
  Future<void> deleteMessageAllReactions({required ZIMMessage message}) async {
    return await channel.invokeMethod('deleteMessageAllReactions',
        {'handle': handle, 'message': message.toMap()});
  }

  @override
  Future<ZIMMessageReactionUserListQueriedResult> queryMessageReactionUserList(
      ZIMMessage message, ZIMMessageReactionUserQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryMessageReactionUserList', {
      'handle': handle,
      'message': message.toMap(),
      'config': config.toMap(),
    });
    return ZIMMessageReactionUserListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessagesSearchedResult> searchLocalMessages(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalMessages', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'config': config.toMap()
    });
    return ZIMMessagesSearchedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessagesGlobalSearchedResult> searchGlobalLocalMessages(
      ZIMMessageSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchGlobalLocalMessages',
        {'handle': handle, 'config': config.toMap()});
    return ZIMMessagesGlobalSearchedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCombineMessageDetailQueriedResult> queryCombineMessageDetail(
      ZIMCombineMessage message) async {
    Map resultMap = await channel.invokeMethod('queryCombineMessageDetail',
        {'handle': handle, 'message': message.toMap()});
    return ZIMCombineMessageDetailQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageQueriedResult> queryMessages(List<int> messageSeqs,
      String conversationID, ZIMConversationType conversationType) async {
    Map resultMap = await channel.invokeMethod('queryMessages', {
      'handle': handle,
      'messageSeqs': messageSeqs,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMMessageQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMMessageRepliedListQueriedResult> queryMessageRepliedList(
      ZIMMessage message, ZIMMessageRepliedListQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryMessageRepliedList', {
      'handle': handle,
      'message': message.toMap(),
      'config': config.toMap()
    });
    return ZIMMessageRepliedListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<void> cancelSendingMessage(
      ZIMMessage message, ZIMSendingMessageCancelConfig config) async {
    Map configMap = {};
    return await channel.invokeMethod('cancelSendingMessage',
        {'handle': handle, 'message': message.toMap(), 'config': configMap});
  }

  @override
  Future<void> pinMessage(
      {required ZIMMessage message,
      required bool isPinned,
      ZIMMessagePinConfig? config}) async {
    return await channel.invokeMethod('pinMessage', {
      'handle': handle,
      'message': message.toMap(),
      'isPinned': isPinned,
      'config': config?.toMap() ?? ZIMMessagePinConfig().toMap()
    });
  }

  @override
  Future<ZIMPinnedMessageListQueriedResult> queryPinnedMessageList(
      String conversationID, ZIMConversationType conversationType) async {
    Map resultMap = await channel.invokeMethod('queryPinnedMessageList', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType': conversationType.value
    });
    return ZIMPinnedMessageListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<void> clearLocalFileCache(ZIMFileCacheClearConfig config) async {
    return await channel.invokeMethod(
        'clearLocalFileCache', {'handle': handle, 'config': config.toMap()});
  }

  @override
  Future<ZIMFileCacheQueriedResult> queryLocalFileCache(
      ZIMFileCacheQueryConfig config) async {
    Map resultMap = await channel.invokeMethod(
        'queryLocalFileCache', {'handle': handle, 'config': config.toMap()});
    return ZIMFileCacheQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomCreatedResult> createRoom(ZIMRoomInfo roomInfo,
      [ZIMRoomAdvancedConfig? config]) async {
    Map resultMap;
    if (config == null) {
      resultMap = await channel.invokeMethod(
          'createRoom', {'handle': handle, 'roomInfo': roomInfo.toMap()});
    } else {
      resultMap = await channel.invokeMethod('createRoomWithConfig', {
        'handle': handle,
        'roomInfo': roomInfo.toMap(),
        'config': config.toMap()
      });
    }
    return ZIMRoomCreatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomJoinedResult> joinRoom(String roomID) async {
    Map resultMap = await channel
        .invokeMethod('joinRoom', {'handle': handle, 'roomID': roomID});
    return ZIMRoomJoinedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomEnteredResult> enterRoom(
      ZIMRoomInfo roomInfo, ZIMRoomAdvancedConfig config) async {
    Map resultMap;
    resultMap = await channel.invokeMethod('enterRoom', {
      'handle': handle,
      'roomInfo': roomInfo.toMap(),
      'config': config.toMap()
    });
    //}
    return ZIMRoomEnteredResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomSwitchedResult> switchRoom(
      String fromRoomID,
      ZIMRoomInfo toRoomInfo,
      bool isCreateWhenRoomNotExisted,
      ZIMRoomAdvancedConfig config) async {
    Map resultMap;
    resultMap = await channel.invokeMethod('switchRoom', {
      'handle': handle,
      'fromRoomID': fromRoomID,
      'toRoomInfo': toRoomInfo.toMap(),
      'isCreateWhenRoomNotExisted': isCreateWhenRoomNotExisted,
      'config': config.toMap()
    });

    return ZIMRoomSwitchedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomLeftResult> leaveRoom(String roomID) async {
    Map resultMap = await channel
        .invokeMethod('leaveRoom', {'handle': handle, 'roomID': roomID});
    return ZIMRoomLeftResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomAllLeftResult> leaveAllRoom() async {
    Map resultMap =
        await channel.invokeMethod('leaveAllRoom', {'handle': handle});
    return ZIMRoomAllLeftResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
      String roomID, ZIMRoomMemberQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryRoomMemberList',
        {'handle': handle, 'roomID': roomID, 'config': config.toMap()});
    return ZIMRoomMemberQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomMembersQueriedResult> queryRoomMembers(
      List<String> userIDs, String roomID) async {
    Map resultMap = await channel.invokeMethod('queryRoomMembers',
        {'handle': handle, 'roomID': roomID, 'userIDs': userIDs});
    return ZIMRoomMembersQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
      String roomID) async {
    Map resultMap = await channel.invokeMethod(
        'queryRoomOnlineMemberCount', {'handle': handle, 'roomID': roomID});
    return ZIMRoomOnlineMemberCountQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomAttributesOperatedResult> setRoomAttributes(
      Map<String, String> roomAttributes,
      String roomID,
      ZIMRoomAttributesSetConfig config) async {
    Map resultMap = await channel.invokeMethod('setRoomAttributes', {
      'handle': handle,
      'roomAttributes': roomAttributes,
      'roomID': roomID,
      'config': config.toMap()
    });
    return ZIMRoomAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomAttributesOperatedResult> deleteRoomAttributes(
      List<String> keys,
      String roomID,
      ZIMRoomAttributesDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteRoomAttributes', {
      'handle': handle,
      'keys': keys,
      'roomID': roomID,
      "config": config.toMap()
    });
    return ZIMRoomAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  void beginRoomAttributesBatchOperation(
      String roomID, ZIMRoomAttributesBatchOperationConfig config) async {
    return await channel.invokeMethod('beginRoomAttributesBatchOperation',
        {'handle': handle, 'roomID': roomID, 'config': config.toMap()});
  }

  @override
  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
      String roomID) async {
    Map resultMap = await channel.invokeMethod(
        'endRoomAttributesBatchOperation',
        {'handle': handle, 'roomID': roomID});
    return ZIMRoomAttributesBatchOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(
      String roomID) async {
    Map resultMap = await channel.invokeMethod(
        'queryRoomAllAttributes', {'handle': handle, 'roomID': roomID});
    return ZIMRoomAttributesQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomMembersAttributesOperatedResult> setRoomMembersAttributes(
      Map<String, String> attributes,
      List<String> userIDs,
      String roomID,
      ZIMRoomMemberAttributesSetConfig config) async {
    Map resultMap = await channel.invokeMethod('setRoomMembersAttributes', {
      'handle': handle,
      'attributes': attributes,
      'roomID': roomID,
      'userIDs': userIDs,
      'config': config.toMap()
    });
    return ZIMRoomMembersAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomMemberAttributesListQueriedResult>
      queryRoomMemberAttributesList(
          String roomID, ZIMRoomMemberAttributesQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryRoomMemberAttributesList',
        {'handle': handle, 'roomID': roomID, 'config': config.toMap()});
    return ZIMRoomMemberAttributesListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMRoomMembersAttributesQueriedResult> queryRoomMembersAttributes(
      List<String> userIDs, String roomID) async {
    Map resultMap = await channel.invokeMethod('queryRoomMembersAttributes',
        {'handle': handle, 'roomID': roomID, 'userIDs': userIDs});
    return ZIMRoomMembersAttributesQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupCreatedResult> createGroup(
      ZIMGroupInfo groupInfo, List<String> userIDs,
      [ZIMGroupAdvancedConfig? config]) async {
    Map resultMap = await channel.invokeMethod('createGroup', {
      'handle': handle,
      'groupInfo': groupInfo.toMap(),
      'userIDs': userIDs,
      'config': config?.toMap()
    });
    return ZIMGroupCreatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupDismissedResult> dismissGroup(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('dismissGroup', {'handle': handle, 'groupID': groupID});
    return ZIMGroupDismissedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupJoinedResult> joinGroup(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('joinGroup', {'handle': handle, 'groupID': groupID});
    return ZIMGroupJoinedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupLeftResult> leaveGroup(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('leaveGroup', {'handle': handle, 'groupID': groupID});
    return ZIMGroupLeftResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
      List<String> userIDs, String groupID) async {
    Map resultMap = await channel.invokeMethod('inviteUsersIntoGroup',
        {'handle': handle, 'userIDs': userIDs, 'groupID': groupID});
    return ZIMGroupUsersInvitedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
      List<String> userIDs, String groupID) async {
    Map resultMap = await channel.invokeMethod('kickGroupMembers',
        {'handle': handle, 'userIDs': userIDs, 'groupID': groupID});
    return ZIMGroupMemberKickedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
      String toUserID, String groupID) async {
    Map resultMap = await channel.invokeMethod('transferGroupOwner',
        {'handle': handle, 'toUserID': toUserID, 'groupID': groupID});
    return ZIMGroupOwnerTransferredResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupNameUpdatedResult> updateGroupName(
      String groupName, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupName',
        {'handle': handle, 'groupName': groupName, 'groupID': groupID});
    return ZIMGroupNameUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupAvatarUrlUpdatedResult> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupAvatarUrl', {
      'handle': handle,
      'groupAvatarUrl': groupAvatarUrl,
      'groupID': groupID
    });
    return ZIMGroupAvatarUrlUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupAliasUpdatedResult> updateGroupAlias(
      String groupAlias, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupAlias',
        {'handle': handle, 'groupAlias': groupAlias, 'groupID': groupID});
    return ZIMGroupAliasUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
      String groupNotice, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupNotice',
        {'handle': handle, 'groupNotice': groupNotice, 'groupID': groupID});
    return ZIMGroupNoticeUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupJoinModeUpdatedResult> updateGroupJoinMode(
      ZIMGroupJoinMode mode, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupJoinMode',
        {'handle': handle, 'mode': mode.value, 'groupID': groupID});
    return ZIMGroupJoinModeUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupInviteModeUpdatedResult> updateGroupInviteMode(
      ZIMGroupInviteMode mode, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupInviteMode',
        {'handle': handle, 'mode': mode.value, 'groupID': groupID});
    return ZIMGroupInviteModeUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupBeInviteModeUpdatedResult> updateGroupBeInviteMode(
      ZIMGroupBeInviteMode mode, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupBeInviteMode',
        {'handle': handle, 'mode': mode.value, 'groupID': groupID});
    return ZIMGroupBeInviteModeUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('queryGroupInfo', {'handle': handle, 'groupID': groupID});
    return ZIMGroupInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
      Map<String, String> groupAttributes, String groupID) async {
    Map resultMap = await channel.invokeMethod('setGroupAttributes', {
      'handle': handle,
      'groupAttributes': groupAttributes,
      'groupID': groupID
    });
    return ZIMGroupAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
      List<String> keys, String groupID) async {
    Map resultMap = await channel.invokeMethod('deleteGroupAttributes',
        {'handle': handle, 'keys': keys, 'groupID': groupID});
    return ZIMGroupAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
      List<String> keys, String groupID) async {
    Map resultMap = await channel.invokeMethod('queryGroupAttributes',
        {'handle': handle, 'keys': keys, 'groupID': groupID});
    return ZIMGroupAttributesQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
      String groupID) async {
    Map resultMap = await channel.invokeMethod(
        'queryGroupAllAttributes', {'handle': handle, 'groupID': groupID});
    return ZIMGroupAttributesQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
      int role, String forUserID, String groupID) async {
    Map resultMap = await channel.invokeMethod('setGroupMemberRole', {
      'handle': handle,
      'role': role,
      'forUserID': forUserID,
      'groupID': groupID
    });
    return ZIMGroupMemberRoleUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
      String nickname, String forUserID, String groupID) async {
    Map resultMap = await channel.invokeMethod('setGroupMemberNickname', {
      'handle': handle,
      'nickname': nickname,
      'forUserID': forUserID,
      'groupID': groupID
    });
    return ZIMGroupMemberNicknameUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
      String userID, String groupID) async {
    Map resultMap = await channel.invokeMethod('queryGroupMemberInfo',
        {'handle': handle, 'userID': userID, 'groupID': groupID});
    return ZIMGroupMemberInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMemberCountQueriedResult> queryGroupMemberCount(
      String groupID) async {
    Map resultMap = await channel.invokeMethod(
        'queryGroupMemberCount', {'handle': handle, 'groupID': groupID});
    return ZIMGroupMemberCountQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupListQueriedResult> queryGroupList(
      {int? count, ZIMGroupListQueryConfig? config}) async {
    Map resultMap = await channel.invokeMethod('queryGroupList',
        {'handle': handle, 'count': count, 'config': config?.toMap()});
    return ZIMGroupListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
      String groupID, ZIMGroupMemberQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryGroupMemberList',
        {'handle': handle, 'groupID': groupID, 'config': config.toMap()});
    return ZIMGroupMemberListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
      queryGroupMessageReceiptReadMemberList(ZIMMessage message, String groupID,
          ZIMGroupMessageReceiptMemberQueryConfig config) async {
    Map resultMap =
        await channel.invokeMethod('queryGroupMessageReceiptReadMemberList', {
      'handle': handle,
      'message': message.toMap(),
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupMessageReceiptMemberListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
      queryGroupMessageReceiptUnreadMemberList(
          ZIMMessage message,
          String groupID,
          ZIMGroupMessageReceiptMemberQueryConfig config) async {
    Map resultMap =
        await channel.invokeMethod('queryGroupMessageReceiptUnreadMemberList', {
      'handle': handle,
      'message': message.toMap(),
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupMessageReceiptMemberListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
      queryGroupMessageReceiptMemberList({
    required ZIMMessage message,
    required String groupID,
    required int count,
    ZIMGroupMessageReceiptMemberListQueryConfig? config,
  }) async {
    Map resultMap =
        await channel.invokeMethod('queryGroupMessageReceiptMemberList', {
      'handle': handle,
      'message': message.toMap(),
      'groupID': groupID,
      'count': count,
      'config': config?.toMap() ??
          ZIMGroupMessageReceiptMemberListQueryConfig().toMap()
    });
    return ZIMGroupMessageReceiptMemberListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupsSearchedResult> searchLocalGroups(
      ZIMGroupSearchConfig config) async {
    Map resultMap = await channel.invokeMethod(
        'searchLocalGroups', {'handle': handle, 'config': config.toMap()});
    return ZIMGroupsSearchedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMembersSearchedResult> searchLocalGroupMembers(
      String groupID, ZIMGroupMemberSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalGroupMembers',
        {'handle': handle, 'groupID': groupID, 'config': config.toMap()});
    return ZIMGroupMembersSearchedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMutedResult> muteGroup(
      bool isMute, String groupID, ZIMGroupMuteConfig config) async {
    Map resultMap = await channel.invokeMethod('muteGroup', {
      'handle': handle,
      'isMute': isMute,
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupMutedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMembersMutedResult> muteGroupMembers(
      bool isMute,
      List<String> userIDs,
      String groupID,
      ZIMGroupMemberMuteConfig config) async {
    Map resultMap = await channel.invokeMethod('muteGroupMembers', {
      'handle': handle,
      'isMute': isMute,
      'userIDs': userIDs,
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupMembersMutedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupMemberMutedListQueriedResult> queryGroupMemberMutedList(
      String groupID, ZIMGroupMemberMutedListQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryGroupMemberMutedList',
        {'handle': handle, 'groupID': groupID, 'config': config.toMap()});
    return ZIMGroupMemberMutedListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupInviteApplicationsSentResult> sendGroupInviteApplications(
      List<String> userIDs,
      String groupID,
      ZIMGroupInviteApplicationSendConfig config) async {
    Map resultMap = await channel.invokeMethod('sendGroupInviteApplications', {
      'handle': handle,
      'userIDs': userIDs,
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupInviteApplicationsSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupInviteApplicationAcceptedResult> acceptGroupInviteApplication(
      String inviterUserID,
      String groupID,
      ZIMGroupInviteApplicationAcceptConfig config) async {
    Map resultMap = await channel.invokeMethod('acceptGroupInviteApplication', {
      'handle': handle,
      'inviterUserID': inviterUserID,
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupInviteApplicationAcceptedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupInviteApplicationRejectedResult> rejectGroupInviteApplication(
      String inviterUserID,
      String groupID,
      ZIMGroupInviteApplicationRejectConfig config) async {
    Map resultMap = await channel.invokeMethod('rejectGroupInviteApplication', {
      'handle': handle,
      'groupID': groupID,
      'inviterUserID': inviterUserID,
      'config': config.toMap()
    });
    return ZIMGroupInviteApplicationRejectedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupJoinApplicationSentResult> sendGroupJoinApplication(
      String groupID, ZIMGroupJoinApplicationSendConfig config) async {
    Map resultMap = await channel.invokeMethod('sendGroupJoinApplication',
        {'handle': handle, 'groupID': groupID, 'config': config.toMap()});
    return ZIMGroupJoinApplicationSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupJoinApplicationAcceptedResult> acceptGroupJoinApplication(
      String userID,
      String groupID,
      ZIMGroupJoinApplicationAcceptConfig config) async {
    Map resultMap = await channel.invokeMethod('acceptGroupJoinApplication', {
      'handle': handle,
      'userID': userID,
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupJoinApplicationAcceptedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupJoinApplicationRejectedResult> rejectGroupJoinApplication(
      String userID,
      String groupID,
      ZIMGroupJoinApplicationRejectConfig config) async {
    Map resultMap = await channel.invokeMethod('rejectGroupJoinApplication', {
      'handle': handle,
      'userID': userID,
      'groupID': groupID,
      'config': config.toMap()
    });
    return ZIMGroupJoinApplicationRejectedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMGroupApplicationListQueriedResult> queryGroupApplicationList(
      ZIMGroupApplicationListQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryGroupApplicationList',
        {'handle': handle, 'config': config.toMap()});
    return ZIMGroupApplicationListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallInvitationSentResult> callInvite(
      List<String> invitees, ZIMCallInviteConfig config) async {
    Map resultMap = await channel.invokeMethod('callInvite',
        {'handle': handle, 'invitees': invitees, 'config': config.toMap()});
    return ZIMCallInvitationSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallCancelSentResult> callCancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    Map resultMap = await channel.invokeMethod('callCancel', {
      'handle': handle,
      'invitees': invitees,
      'callID': callID,
      'config': config.toMap()
    });
    return ZIMCallCancelSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallAcceptanceSentResult> callAccept(
      String callID, ZIMCallAcceptConfig config) async {
    Map resultMap = await channel.invokeMethod('callAccept',
        {'handle': handle, 'callID': callID, 'config': config.toMap()});
    return ZIMCallAcceptanceSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallRejectionSentResult> callReject(
      String callID, ZIMCallRejectConfig config) async {
    Map resultMap = await channel.invokeMethod('callReject',
        {'handle': handle, 'callID': callID, 'config': config.toMap()});
    return ZIMCallRejectionSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallEndSentResult> callEnd(
      String callID, ZIMCallEndConfig config) async {
    Map resultMap = await channel.invokeMethod('callEnd',
        {'handle': handle, 'callID': callID, 'config': config.toMap()});
    return ZIMCallEndSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallQuitSentResult> callQuit(
      String callID, ZIMCallQuitConfig config) async {
    Map resultMap = await channel.invokeMethod('callQuit',
        {'handle': handle, 'callID': callID, 'config': config.toMap()});
    return ZIMCallQuitSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallingInvitationSentResult> callingInvite(List<String> invitees,
      String callID, ZIMCallingInviteConfig config) async {
    Map resultMap = await channel.invokeMethod('callingInvite', {
      'handle': handle,
      'invitees': invitees,
      'callID': callID,
      'config': config.toMap()
    });
    return ZIMCallingInvitationSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallInvitationListQueriedResult> queryCallInvitationList(
      ZIMCallInvitationQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryCallInvitationList',
        {'handle': handle, 'config': config.toMap()});
    return ZIMCallInvitationListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCallJoinSentResult> callJoin(
      String callID, ZIMCallJoinConfig config) async {
    Map resultMap = await channel.invokeMethod('callJoin',
        {'handle': handle, 'callID': callID, 'config': config.toMap()});
    return ZIMCallJoinSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendApplicationAcceptedResult> acceptFriendApplication(
      String userID, ZIMFriendApplicationAcceptConfig config) async {
    Map resultMap = await channel.invokeMethod('acceptFriendApplication',
        {'handle': handle, 'userID': userID, 'config': config.toMap()});
    return ZIMFriendApplicationAcceptedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendAddedResult> addFriend(
      String userID, ZIMFriendAddConfig config) async {
    Map resultMap = await channel.invokeMethod('addFriend', {
      'handle': handle,
      'userID': userID,
      'config': config.toMap(),
    });
    return ZIMFriendAddedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMBlacklistUsersAddedResult> addUsersToBlacklist(
      List<String> userIDs) async {
    Map resultMap = await channel.invokeMethod('addUsersToBlacklist', {
      'handle': handle,
      'userIDs': userIDs,
    });
    return ZIMBlacklistUsersAddedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendsRelationCheckedResult> checkFriendsRelation(
      List<String> userIDs, ZIMFriendRelationCheckConfig config) async {
    Map resultMap = await channel.invokeMethod('checkFriendsRelation', {
      'handle': handle,
      'userIDs': userIDs,
      'config': config.toMap(),
    });
    return ZIMFriendsRelationCheckedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMBlacklistCheckedResult> checkUserIsInBlacklist(
      String userID) async {
    Map resultMap = await channel.invokeMethod('checkUserIsInBlacklist', {
      'handle': handle,
      'userID': userID,
    });
    return ZIMBlacklistCheckedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendsDeletedResult> deleteFriends(
      List<String> userIDs, ZIMFriendDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteFriends', {
      'handle': handle,
      'userIDs': userIDs,
      'config': config.toMap(),
    });
    return ZIMFriendsDeletedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMBlacklistQueriedResult> queryBlacklist(
      ZIMBlacklistQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryBlacklist', {
      'handle': handle,
      'config': config.toMap(),
    });
    return ZIMBlacklistQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMBlacklistUsersRemovedResult> removeUsersFromBlacklist(
      List<String> userIDs) async {
    Map resultMap = await channel.invokeMethod('removeUsersFromBlacklist', {
      'handle': handle,
      'userIDs': userIDs,
    });
    return ZIMBlacklistUsersRemovedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendApplicationSentResult> sendFriendApplication(
      String userID, ZIMFriendApplicationSendConfig config) async {
    Map resultMap = await channel.invokeMethod('sendFriendApplication', {
      'handle': handle,
      'userID': userID,
      'config': config.toMap(),
    });
    return ZIMFriendApplicationSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendAliasUpdatedResult> updateFriendAlias(
      String friendAlias, String userID) async {
    Map resultMap = await channel.invokeMethod('updateFriendAlias', {
      'handle': handle,
      'friendAlias': friendAlias,
      'userID': userID,
    });
    return ZIMFriendAliasUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendAttributesUpdatedResult> updateFriendAttributes(
      Map<String, String> friendAttributes, String userID) async {
    Map resultMap = await channel.invokeMethod('updateFriendAttributes', {
      'handle': handle,
      'friendAttributes': friendAttributes,
      'userID': userID,
    });
    return ZIMFriendAttributesUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendApplicationListQueriedResult> queryFriendApplicationList(
      ZIMFriendApplicationListQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryFriendApplicationList', {
      'handle': handle,
      'config': config.toMap(),
    });
    return ZIMFriendApplicationListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendsSearchedResult> searchLocalFriends(
      ZIMFriendSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalFriends', {
      'handle': handle,
      'config': config.toMap(),
    });
    return ZIMFriendsSearchedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendListQueriedResult> queryFriendList(
      ZIMFriendListQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryFriendList', {
      'handle': handle,
      'config': config.toMap(),
    });
    return ZIMFriendListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendsInfoQueriedResult> queryFriendsInfo(
      List<String> userIDs) async {
    Map resultMap = await channel.invokeMethod('queryFriendsInfo', {
      'handle': handle,
      'userIDs': userIDs,
    });
    return ZIMFriendsInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMFriendApplicationRejectedResult> rejectFriendApplication(
      String userID, ZIMFriendApplicationRejectConfig config) async {
    Map resultMap = await channel.invokeMethod('rejectFriendApplication', {
      'handle': handle,
      'userID': userID,
      'config': config.toMap(),
    });
    return ZIMFriendApplicationRejectedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityCreatedResult> createCommunity(
      {required ZIMCommunityInfo communityInfo,
      ZIMCommunityCreateConfig? config}) async {
    Map resultMap = await channel.invokeMethod('createCommunity', {
      'handle': handle,
      'communityInfo': communityInfo.toMap(),
      'config': config?.toMap() ?? ZIMCommunityCreateConfig().toMap()
    });
    return ZIMCommunityCreatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityDismissedResult> dismissCommunity(
      {required String communityID}) async {
    Map resultMap = await channel.invokeMethod(
        'dismissCommunity', {'handle': handle, 'communityID': communityID});
    return ZIMCommunityDismissedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityJoinedResult> joinCommunity(
      {required String communityID}) async {
    Map resultMap = await channel.invokeMethod('joinCommunity', {
      'handle': handle,
      'communityID': communityID,
    });
    return ZIMCommunityJoinedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityLeftResult> leaveCommunity(
      {required String communityID}) async {
    Map resultMap = await channel.invokeMethod(
        'leaveCommunity', {'handle': handle, 'communityID': communityID});
    return ZIMCommunityLeftResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityAsVisitorEnteredResult> enterCommunityAsVisitor(
      {required String communityID}) async {
    Map resultMap = await channel.invokeMethod('enterCommunityAsVisitor', {
      'handle': handle,
      'communityID': communityID,
    });
    return ZIMCommunityAsVisitorEnteredResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityAsVisitorQuitResult> quitCommunityAsVisitor(
      {required String communityID}) async {
    Map resultMap = await channel.invokeMethod('quitCommunityAsVisitor',
        {'handle': handle, 'communityID': communityID});
    return ZIMCommunityAsVisitorQuitResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityVisitorFetchMessageCountUpdatedResult>
      updateCommunityVisitorFetchMessageCount(
          {required int count, required String communityID}) async {
    Map resultMap = await channel.invokeMethod(
        'updateCommunityVisitorFetchMessageCount',
        {'handle': handle, 'count': count, 'communityID': communityID});
    return ZIMCommunityVisitorFetchMessageCountUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityVisitorFetchMessageDurationUpdatedResult>
      updateCommunityVisitorFetchMessageDuration(
          {required int duration, required String communityID}) async {
    Map resultMap = await channel.invokeMethod(
        'updateCommunityVisitorFetchMessageDuration',
        {'handle': handle, 'duration': duration, 'communityID': communityID});
    return ZIMCommunityVisitorFetchMessageDurationUpdatedResult.fromMap(
        resultMap);
  }

  @override
  Future<ZIMCommunityListQueriedResult> queryCommunityList(
      {required int count, ZIMCommunityListQueryConfig? config}) async {
    Map resultMap = await channel.invokeMethod('queryCommunityList', {
      'handle': handle,
      'count': count,
      'config': config?.toMap() ?? ZIMCommunityListQueryConfig().toMap()
    });
    return ZIMCommunityListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityNameUpdatedResult> updateCommunityName(
      {required String communityName, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('updateCommunityName', {
      'handle': handle,
      'communityName': communityName,
      'communityID': communityID
    });
    return ZIMCommunityNameUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityAvatarUrlUpdatedResult> updateCommunityAvatarUrl(
      {required String communityAvatarUrl, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('updateCommunityAvatarUrl', {
      'handle': handle,
      'communityAvatarUrl': communityAvatarUrl,
      'communityID': communityID
    });
    return ZIMCommunityAvatarUrlUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityNoticeUpdatedResult> updateCommunityNotice(
      {required String communityNotice, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('updateCommunityNotice', {
      'handle': handle,
      'communityNotice': communityNotice,
      'communityID': communityID
    });
    return ZIMCommunityNoticeUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityJoinModeUpdatedResult> updateCommunityJoinMode(
      {required ZIMCommunityJoinMode joinMode,
      required String communityID}) async {
    Map resultMap = await channel.invokeMethod('updateCommunityJoinMode', {
      'handle': handle,
      'joinMode': joinMode.value,
      'communityID': communityID
    });
    return ZIMCommunityJoinModeUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityJoinApplicationSentResult> sendCommunityJoinApplication(
      {required String communityID,
      required ZIMCommunityJoinApplicationSendConfig config}) async {
    Map resultMap = await channel.invokeMethod('sendCommunityJoinApplication', {
      'handle': handle,
      'communityID': communityID,
      'config': config.toMap()
    });
    return ZIMCommunityJoinApplicationSentResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunitySelfApplicationListQueriedResult>
      queryCommunitySelfApplicationList(
          {required int count,
          required ZIMCommunitySelfApplicationListQueryConfig config}) async {
    Map resultMap = await channel.invokeMethod(
        'queryCommunitySelfApplicationList',
        {'handle': handle, 'count': count, 'config': config.toMap()});
    return ZIMCommunitySelfApplicationListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<void> cancelCommunityJoinApplication(
      {required int applyID,
      required String communityID,
      required ZIMCommunityJoinApplicationCancelConfig config}) async {
    return await channel.invokeMethod('cancelCommunityJoinApplication', {
      'handle': handle,
      'communityID': communityID,
      'applyID': applyID,
      'config': config.toMap()
    });
  }

  @override
  Future<ZIMCommunityJoinApplicationAcceptedResult>
      acceptCommunityJoinApplication(
          {required String userID,
          required String communityID,
          required int applyID,
          required ZIMCommunityJoinApplicationAcceptConfig config}) async {
    Map resultMap =
        await channel.invokeMethod('acceptCommunityJoinApplication', {
      'handle': handle,
      'userID': userID,
      'communityID': communityID,
      'applyID': applyID,
      'config': config.toMap()
    });
    return ZIMCommunityJoinApplicationAcceptedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityJoinApplicationRejectedResult>
      rejectCommunityJoinApplication(
          {required String userID,
          required String communityID,
          required int applyID,
          required ZIMCommunityJoinApplicationRejectConfig config}) async {
    Map resultMap =
        await channel.invokeMethod('rejectCommunityJoinApplication', {
      'handle': handle,
      'userID': userID,
      'communityID': communityID,
      'applyID': applyID,
      'config': config.toMap()
    });
    return ZIMCommunityJoinApplicationRejectedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityApplicationListQueriedResult>
      queryCommunityApplicationList(
          {required String communityID,
          required int count,
          required ZIMCommunityApplicationListQueryConfig config}) async {
    Map resultMap =
        await channel.invokeMethod('queryCommunityApplicationList', {
      'handle': handle,
      'communityID': communityID,
      'count': count,
      'config': config.toMap()
    });
    return ZIMCommunityApplicationListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityAttributesOperatedResult> setCommunityAttributes(
      {required Map<String, String> communityAttributes,
      required String communityID}) async {
    Map resultMap = await channel.invokeMethod('setCommunityAttributes', {
      'handle': handle,
      'communityAttributes': communityAttributes,
      'communityID': communityID
    });
    return ZIMCommunityAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityAttributesOperatedResult> deleteCommunityAttributes(
      {required List<String> keys, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('deleteCommunityAttributes',
        {'handle': handle, 'keys': keys, 'communityID': communityID});
    return ZIMCommunityAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityInfoQueriedResult> queryCommunityInfo(
      {required String communityID}) async {
    Map resultMap = await channel.invokeMethod(
        'queryCommunityInfo', {'handle': handle, 'communityID': communityID});
    return ZIMCommunityInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityUsersInvitedResult> inviteUsersIntoCommunity(
      {required List<String> userIDs, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('inviteUsersIntoCommunity',
        {'handle': handle, 'userIDs': userIDs, 'communityID': communityID});
    return ZIMCommunityUsersInvitedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityMembersKickedResult> kickCommunityMembers(
      {required List<String> userIDs, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('kickCommunityMembers',
        {'handle': handle, 'userIDs': userIDs, 'communityID': communityID});
    return ZIMCommunityMembersKickedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityMemberRoleUpdatedResult> updateCommunityMemberRole(
      {required int memberRole,
      required String forUserID,
      required String communityID}) async {
    Map resultMap = await channel.invokeMethod('updateCommunityMemberRole', {
      'handle': handle,
      'memberRole': memberRole,
      'forUserID': forUserID,
      'communityID': communityID
    });
    return ZIMCommunityMemberRoleUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityOwnerTransferredResult> transferCommunityOwner(
      {required String toUserID, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('transferCommunityOwner',
        {'handle': handle, 'toUserID': toUserID, 'communityID': communityID});
    return ZIMCommunityOwnerTransferredResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityMemberListQueriedResult> queryCommunityMemberList(
      {required String communityID,
      required int count,
      int? nextFlag,
      ZIMCommunityMemberListQueryConfig? config}) async {
    Map resultMap = await channel.invokeMethod('queryCommunityMemberList', {
      'handle': handle,
      'communityID': communityID,
      'count': count,
      'config': config?.toMap() ?? ZIMCommunityMemberListQueryConfig().toMap()
    });
    return ZIMCommunityMemberListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityMembersQueriedResult> queryCommunityMembers(
      {required List<String> userIDs, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('queryCommunityMembers', {
      'handle': handle,
      'communityID': communityID,
      'userIDs': userIDs,
    });
    return ZIMCommunityMembersQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelCreatedResult> createCommunityChannel(
      {required ZIMCommunityChannelInfo channelInfo,
      ZIMCommunityChannelCreateConfig? config}) async {
    Map resultMap = await channel.invokeMethod('createCommunityChannel', {
      'handle': handle,
      'channelInfo': channelInfo.toMap(),
      'config': config?.toMap() ?? ZIMCommunityChannelCreateConfig().toMap()
    });
    return ZIMCommunityChannelCreatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelDismissedResult> dismissCommunityChannel(
      {required String channelID, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('dismissCommunityChannel',
        {'handle': handle, 'channelID': channelID, 'communityID': communityID});
    return ZIMCommunityChannelDismissedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelNameUpdatedResult> updateCommunityChannelName(
      {required String channelName,
      required String channelID,
      required String communityID}) async {
    Map resultMap = await channel.invokeMethod('updateCommunityChannelName', {
      'handle': handle,
      'channelName': channelName,
      'channelID': channelID,
      'communityID': communityID
    });
    return ZIMCommunityChannelNameUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelAvatarUrlUpdatedResult>
      updateCommunityChannelAvatarUrl(
          {required String channelAvatarUrl,
          required String channelID,
          required String communityID}) async {
    Map resultMap =
        await channel.invokeMethod('updateCommunityChannelAvatarUrl', {
      'handle': handle,
      'channelAvatarUrl': channelAvatarUrl,
      'channelID': channelID,
      'communityID': communityID
    });
    return ZIMCommunityChannelAvatarUrlUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelNoticeUpdatedResult> updateCommunityChannelNotice(
      {required String channelNotice,
      required String channelID,
      required String communityID}) async {
    Map resultMap = await channel.invokeMethod('updateCommunityChannelNotice', {
      'handle': handle,
      'channelNotice': channelNotice,
      'channelID': channelID,
      'communityID': communityID
    });
    return ZIMCommunityChannelNoticeUpdatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelAttributesOperatedResult>
      setCommunityChannelAttributes(
          {required Map<String, String> channelAttributes,
          required String channelID,
          required String communityID}) async {
    Map resultMap =
        await channel.invokeMethod('setCommunityChannelAttributes', {
      'handle': handle,
      'channelAttributes': channelAttributes,
      'channelID': channelID,
      'communityID': communityID
    });
    return ZIMCommunityChannelAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelAttributesOperatedResult>
      deleteCommunityChannelAttributes(
          {required List<String> keys,
          required String channelID,
          required String communityID}) async {
    Map resultMap =
        await channel.invokeMethod('deleteCommunityChannelAttributes', {
      'handle': handle,
      'keys': keys,
      'channelID': channelID,
      'communityID': communityID
    });
    return ZIMCommunityChannelAttributesOperatedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelsInfoQueriedResult> queryCommunityChannelsInfo(
      {required List<String> channelIDs, required String communityID}) async {
    Map resultMap = await channel.invokeMethod('queryCommunityChannelsInfo', {
      'handle': handle,
      'channelIDs': channelIDs,
      'communityID': communityID
    });
    return ZIMCommunityChannelsInfoQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelListQueriedResult> queryCommunityChannelList(
      {required String communityID,
      required int count,
      ZIMCommunityChannelListQueryConfig? config}) async {
    Map resultMap = await channel.invokeMethod('queryCommunityChannelList', {
      'handle': handle,
      'communityID': communityID,
      'count': count,
      'config': config?.toMap() ?? ZIMCommunityChannelListQueryConfig().toMap()
    });
    return ZIMCommunityChannelListQueriedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityMembersMutedResult> muteCommunityMembers(
      {required bool isMute,
      required List<String> userIDs,
      required String communityID,
      ZIMCommunityMemberMuteConfig? config}) async {
    Map resultMap = await channel.invokeMethod('muteCommunityMembers', {
      'handle': handle,
      'isMute': isMute,
      'userIDs': userIDs,
      'communityID': communityID,
      'config': config?.toMap() ?? ZIMCommunityMemberMuteConfig().toMap()
    });
    return ZIMCommunityMembersMutedResult.fromMap(resultMap);
  }

  @override
  Future<ZIMCommunityChannelsMutedResult> muteCommunityChannels(
      {required bool isMute,
      required List<String> channelIDs,
      required String communityID,
      ZIMCommunityChannelMuteConfig? config}) async {
    Map resultMap = await channel.invokeMethod('muteCommunityChannels', {
      'handle': handle,
      'isMute': isMute,
      'channelIDs': channelIDs,
      'communityID': communityID,
      'config': config?.toMap() ?? ZIMCommunityChannelMuteConfig().toMap()
    });
    return ZIMCommunityChannelsMutedResult.fromMap(resultMap);
  }
}
