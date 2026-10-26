import 'dart:convert';

import '../../../zego_zim.dart';
import '../zim_engine.dart';
import '../zim_manager.dart';

class ZIMEventHandlerWeb {
  static void eventListener(dynamic event) {
    ZIMEngine? zim = ZIMManager.engineMap[event['handle']];
    if (zim == null) return;

    final eventType = event['ev'];
    final data = eventType == 'experimentalEventReceived'
        ? event['data']
        : json.decode(event['data']);

    try {
      switch (eventType) {
        /// MARK: - Main
        case 'error':
          if (ZIMEventHandler.onError == null) return;
          ZIMEventHandler.onError!(
              zim, ZIMError(code: data['code'], message: data['message']));
          break;
        case 'experimentalEventReceived':
          if (ZIMEventHandler.onExperimentalEventReceived == null) return;
          ZIMEventHandler.onExperimentalEventReceived!(zim, data);
          break;
        case 'connectionStateChanged':
          if (ZIMEventHandler.onConnectionStateChanged == null) return;
          ZIMEventHandler.onConnectionStateChanged!(
              zim,
              ZIMConnectionStateExtension.mapValue[data['state']]!,
              ZIMConnectionEventExtension.mapValue[data['event']]!,
              data['extendedData'] != null && data['extendedData'] != ''
                  ? json.decode(data['extendedData'])
                  : {});
          break;
        case 'tokenWillExpire':
          if (ZIMEventHandler.onTokenWillExpire == null) return;
          ZIMEventHandler.onTokenWillExpire!(zim, data['second']);
          break;
        case 'userInfoUpdated':
          if (ZIMEventHandler.onUserInfoUpdated == null) return;
          ZIMEventHandler.onUserInfoUpdated!(
              zim, ZIMUserFullInfo.fromMap(data['info']));
          break;
        case 'userStatusUpdated':
          if (ZIMEventHandler.onUserStatusUpdated == null) return;
          ZIMEventHandler.onUserStatusUpdated!(
              zim,
              (data['userStatusList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMUserStatus.fromMap(x))
                  .toList());
          break;
        case 'userRuleUpdated':
          if (ZIMEventHandler.onUserRuleUpdated == null) return;
          ZIMEventHandler.onUserRuleUpdated!(
              zim, ZIMUserRule.fromMap(data['userRule']));
          break;

        /// MARK: - Conversation
        case 'conversationChanged':
          if (ZIMEventHandler.onConversationChanged == null) return;
          ZIMEventHandler.onConversationChanged!(
              zim,
              (data['infoList'] as List).cast<Map>().map((x) {
                // action: added, deleted, updated
                // event:  added, updated, disabled, deleted
                // var v = x['action'];
                // if (v == 1) {
                //   x['event'] = 3;
                // } else if (v == 2) {
                //   x['event'] =
                //       x['type'] == 2 && x['isConversationDisabled'] == true
                //           ? 2
                //           : 1;
                // } else {
                //   x['event'] = v;
                // }
                return ZIMConversationChangeInfo.fromMap(x);
              }).toList());
          break;
        case 'conversationSyncStateChanged':
          if (ZIMEventHandler.onConversationSyncStateChanged == null) return;
          ZIMEventHandler.onConversationSyncStateChanged!(
              zim, ZIMConversationSyncStateExtension.mapValue[data['state']]!);
          break;
        case 'conversationsAllDeleted':
          if (ZIMEventHandler.onConversationsAllDeleted == null) return;
          ZIMEventHandler.onConversationsAllDeleted!(
              zim, ZIMConversationsAllDeletedInfo.fromMap(data));
          break;
        case 'conversationTotalUnreadMessageCountUpdated':
          if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated ==
              null) return;
          ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(
              zim, data['totalUnreadMessageCount']);
          break;
        case 'conversationMessageReceiptChanged':
          if (ZIMEventHandler.onConversationMessageReceiptChanged == null)
            return;
          ZIMEventHandler.onConversationMessageReceiptChanged!(
              zim,
              (data['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessageReceiptInfo.fromMap(x))
                  .toList());
          break;

        /// MARK: - Message
        case 'broadcastMessageReceived':
          if (ZIMEventHandler.onBroadcastMessageReceived == null) return;
          ZIMEventHandler.onBroadcastMessageReceived!(
              zim, ZIMDataUtils.parseZIMMessageFromMap(data['message']));
          break;
        case 'messageReceived':
          if (ZIMEventHandler.onMessageReceived == null) return;
          ZIMEventHandler.onMessageReceived!(
              zim, ZIMMessageReceivedEventResult.fromMap(data));
          break;
        case 'peerMessageReceived':
          if (ZIMEventHandler.onPeerMessageReceived == null) return;
          ZIMEventHandler.onPeerMessageReceived!(
              zim,
              (data['messageList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
                  .toList(),
              ZIMMessageReceivedInfo.fromMap(data['info']),
              data['fromConversationID']);
          break;
        case 'groupMessageReceived':
          if (ZIMEventHandler.onGroupMessageReceived == null) return;
          ZIMEventHandler.onGroupMessageReceived!(
              zim,
              (data['messageList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
                  .toList(),
              ZIMMessageReceivedInfo.fromMap(data['info']),
              data['fromConversationID']);
          break;
        case 'roomMessageReceived':
          if (ZIMEventHandler.onRoomMessageReceived == null) return;
          ZIMEventHandler.onRoomMessageReceived!(
              zim,
              (data['messageList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
                  .toList(),
              ZIMMessageReceivedInfo.fromMap(data['info']),
              data['fromConversationID']);
          break;
        case 'messageSentStatusChanged':
          if (ZIMEventHandler.onMessageSentStatusChanged == null) return;
          ZIMEventHandler.onMessageSentStatusChanged!(
              zim,
              (data['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessageSentStatusChangeInfo.fromMap(x))
                  .toList());
          break;
        case 'messageDeleted':
          if (ZIMEventHandler.onMessageDeleted == null) return;
          ZIMEventHandler.onMessageDeleted!(
              zim, ZIMMessageDeletedInfo.fromMap(data));
          break;
        case 'messageEdited':
          if (ZIMEventHandler.onMessageEdited == null) return;
          ZIMEventHandler.onMessageEdited!(
              zim,
              (data['messageList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
                  .toList());
          break;
        case 'messageReceiptChanged':
          if (ZIMEventHandler.onMessageReceiptChanged == null) return;
          ZIMEventHandler.onMessageReceiptChanged!(
              zim,
              (data['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessageReceiptInfo.fromMap(x))
                  .toList());
          break;
        case 'messageRevokeReceived':
          if (ZIMEventHandler.onMessageRevokeReceived == null) return;

          ZIMEventHandler.onMessageRevokeReceived!(
              zim,
              (data['messageList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x)
                      as ZIMRevokeMessage)
                  .toList());
          break;
        case 'messageReactionsChanged':
          if (ZIMEventHandler.onMessageReactionsChanged == null) return;
          ZIMEventHandler.onMessageReactionsChanged!(
              zim, ZIMMessageReactionsChangedEventResult.fromMap(data));
          break;
        case 'messageRepliedCountChanged':
          if (ZIMEventHandler.onMessageRepliedCountChanged == null) return;
          ZIMEventHandler.onMessageRepliedCountChanged!(
              zim,
              (data['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessageRootRepliedCountInfo.fromMap(x))
                  .toList());
          break;
        case 'messageRepliedInfoChanged':
          if (ZIMEventHandler.onMessageRepliedInfoChanged == null) return;
          ZIMEventHandler.onMessageRepliedInfoChanged!(
              zim,
              (data['messageList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
                  .toList());
          break;
        case 'messagePinStatusChanged':
          if (ZIMEventHandler.onMessagePinStatusChanged == null) return;
          ZIMEventHandler.onMessagePinStatusChanged!(
              zim,
              (data['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessagePinStatusChangeInfo.fromMap(x))
                  .toList());
          break;

        /// MARK: - Room
        case 'roomStateChanged':
          if (ZIMEventHandler.onRoomStateChanged == null) return;
          ZIMEventHandler.onRoomStateChanged!(
              zim,
              ZIMRoomStateExtension.mapValue[data['state']]!,
              ZIMRoomEventExtension.mapValue[data['event']]!,
              data['extendedData'] != null && data['extendedData'] != ''
                  ? json.decode(data['extendedData'])
                  : {},
              data['roomID']);
          break;
        case 'roomMemberJoined':
          if (ZIMEventHandler.onRoomMemberJoined == null) return;
          ZIMEventHandler.onRoomMemberJoined!(
              zim,
              (data['memberList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMUserInfo.fromMap(x))
                  .toList(),
              data['roomID']);
          break;
        case 'roomMemberLeft':
          if (ZIMEventHandler.onRoomMemberLeft == null) return;
          ZIMEventHandler.onRoomMemberLeft!(
              zim,
              (data['memberList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMUserInfo.fromMap(x))
                  .toList(),
              data['roomID']);
          break;
        case 'roomAttributesUpdated':
          if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

          String roomID = data['roomID'];
          data['infos'].forEach((info) {
            ZIMEventHandler.onRoomAttributesUpdated!(
                zim, ZIMRoomAttributesUpdateInfo.fromMap(info), roomID);
          });

          break;
        case 'roomAttributesBatchUpdated':
          if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;
          ZIMEventHandler.onRoomAttributesBatchUpdated!(
              zim,
              (data['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMRoomAttributesUpdateInfo.fromMap(x))
                  .toList(),
              data['roomID']);
          break;
        case 'roomMemberAttributesUpdated':
          if (ZIMEventHandler.onRoomMemberAttributesUpdated == null) return;
          ZIMEventHandler.onRoomMemberAttributesUpdated!(
              zim,
              (data['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMRoomMemberAttributesUpdateInfo.fromMap(x))
                  .toList(),
              ZIMRoomOperatedInfo.fromMap(data['operatedInfo']),
              data['roomID']);
          break;

        /// MARK: - Group
        case 'groupStateChanged':
          if (ZIMEventHandler.onGroupStateChanged == null) return;
          ZIMEventHandler.onGroupStateChanged!(
              zim,
              ZIMGroupStateExtension.mapValue[data['state']]!,
              ZIMGroupEventExtension.mapValue[data['event']]!,
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              ZIMGroupFullInfo.fromMap(data['groupInfo']));
          break;
        case 'groupNameUpdated':
          if (ZIMEventHandler.onGroupNameUpdated == null) return;
          ZIMEventHandler.onGroupNameUpdated!(
              zim,
              data['groupName'],
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;
        case 'groupAvatarUrlUpdated':
          if (ZIMEventHandler.onGroupAvatarUrlUpdated == null) return;

          ZIMEventHandler.onGroupAvatarUrlUpdated!(
              zim,
              data['groupAvatarUrl'],
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;
        case 'groupNoticeUpdated':
          if (ZIMEventHandler.onGroupNoticeUpdated == null) return;
          ZIMEventHandler.onGroupNoticeUpdated!(
              zim,
              data['groupNotice'],
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;
        case 'groupAliasUpdated':
          if (ZIMEventHandler.onGroupAliasUpdated == null) return;
          ZIMEventHandler.onGroupAliasUpdated!(
              zim, data['groupAlias'], data['operatedUserID'], data['groupID']);
          break;
        case 'groupAttributesUpdated':
          if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

          ZIMEventHandler.onGroupAttributesUpdated!(
              zim,
              (data['infoList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupAttributesUpdateInfo.fromMap(x))
                  .toList(),
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;
        case 'groupMutedInfoUpdated':
          if (ZIMEventHandler.onGroupMutedInfoUpdated == null) return;
          ZIMEventHandler.onGroupMutedInfoUpdated!(
              zim,
              ZIMGroupMuteInfo.fromMap(data['mutedInfo']),
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;
        case 'groupVerifyInfoUpdated':
          if (ZIMEventHandler.onGroupVerifyInfoUpdated == null) return;
          ZIMEventHandler.onGroupVerifyInfoUpdated!(
              zim,
              ZIMGroupVerifyInfo.fromMap(data['verifyInfo']),
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;
        case 'groupApplicationListChanged':
          if (ZIMEventHandler.onGroupApplicationListChanged == null) return;
          ZIMEventHandler.onGroupApplicationListChanged!(
              zim,
              (data['applicationList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupApplicationInfo.fromMap(x))
                  .toList(),
              ZIMGroupApplicationListChangeActionExtension
                  .mapValue[data['action']]!);
          break;
        case 'groupApplicationUpdated':
          if (ZIMEventHandler.onGroupApplicationUpdated == null) return;
          ZIMEventHandler.onGroupApplicationUpdated!(
              zim,
              (data['applicationList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupApplicationInfo.fromMap(x))
                  .toList());
          break;
        case 'groupMemberStateChanged':
          if (ZIMEventHandler.onGroupMemberStateChanged == null) return;
          ZIMEventHandler.onGroupMemberStateChanged!(
              zim,
              ZIMGroupMemberStateExtension.mapValue[data['state']]!,
              ZIMGroupMemberEventExtension.mapValue[data['event']]!,
              (data['userList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupMemberInfo.fromMap(x))
                  .toList(),
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;
        case 'groupMemberInfoUpdated':
          if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;
          ZIMEventHandler.onGroupMemberInfoUpdated!(
              zim,
              (data['userList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupMemberInfo.fromMap(x))
                  .toList(),
              ZIMGroupOperatedInfo.fromMap(data['operatedInfo']),
              data['groupID']);
          break;

        /// MARK: - Community
        case 'communityListChanged':
          if (ZIMEventHandler.onCommunityListChanged == null) return;
          ZIMEventHandler.onCommunityListChanged!(
              zim, ZIMCommunityListChangedEventResult.fromMap(data));
          break;
        case 'communitySelfApplicationListChanged':
          if (ZIMEventHandler.onCommunitySelfApplicationListChanged == null)
            return;
          ZIMEventHandler.onCommunitySelfApplicationListChanged!(zim,
              ZIMCommunitySelfApplicationListChangedEventResult.fromMap(data));
          break;
        case 'communityApplicationListChanged':
          if (ZIMEventHandler.onCommunityApplicationListChanged == null) return;
          ZIMEventHandler.onCommunityApplicationListChanged!(
              zim, ZIMCommunityApplicationListChangedEventResult.fromMap(data));
          break;
        case 'communityInfoUpdated':
          if (ZIMEventHandler.onCommunityInfoUpdated == null) return;
          ZIMEventHandler.onCommunityInfoUpdated!(
              zim, ZIMCommunityInfoUpdatedEventResult.fromMap(data));
          break;
        case 'communityChannelListChanged':
          if (ZIMEventHandler.onCommunityChannelListChanged == null) return;
          ZIMEventHandler.onCommunityChannelListChanged!(
              zim, ZIMCommunityChannelListChangedEventResult.fromMap(data));
          break;
        case 'communityChannelInfoUpdated':
          if (ZIMEventHandler.onCommunityChannelInfoUpdated == null) return;
          ZIMEventHandler.onCommunityChannelInfoUpdated!(
              zim, ZIMCommunityChannelInfoUpdatedEventResult.fromMap(data));
          break;
        case 'communityMemberStateChanged':
          if (ZIMEventHandler.onCommunityMemberStateChanged == null) return;
          ZIMEventHandler.onCommunityMemberStateChanged!(
              zim, ZIMCommunityMemberStateChangedEventResult.fromMap(data));
          break;
        case 'communityMemberInfoUpdated':
          if (ZIMEventHandler.onCommunityMemberInfoUpdated == null) return;
          ZIMEventHandler.onCommunityMemberInfoUpdated!(
              zim, ZIMCommunityMemberInfoUpdatedEventResult.fromMap(data));
          break;

        /// MARK: - Call
        case 'callInvitationCreated':
          if (ZIMEventHandler.onCallInvitationCreated == null) return;
          ZIMEventHandler.onCallInvitationCreated!(
              zim, ZIMCallInvitationCreatedInfo.fromMap(data), data['callID']);
          break;
        case 'callInvitationReceived':
          if (ZIMEventHandler.onCallInvitationReceived == null) return;
          ZIMEventHandler.onCallInvitationReceived!(
              zim, ZIMCallInvitationReceivedInfo.fromMap(data), data['callID']);
          break;
        case 'callInvitationCancelled':
          if (ZIMEventHandler.onCallInvitationCancelled == null) return;
          ZIMEventHandler.onCallInvitationCancelled!(zim,
              ZIMCallInvitationCancelledInfo.fromMap(data), data['callID']);
          break;
        case 'callInvitationTimeout':
          if (ZIMEventHandler.onCallInvitationTimeout == null) return;
          ZIMEventHandler.onCallInvitationTimeout!(
              zim, ZIMCallInvitationTimeoutInfo.fromMap(data), data['callID']);
          break;
        case 'callInvitationEnded':
          if (ZIMEventHandler.onCallInvitationEnded == null) return;
          ZIMEventHandler.onCallInvitationEnded!(
              zim, ZIMCallInvitationEndedInfo.fromMap(data), data['callID']);
          break;
        case 'callUserStateChanged':
          if (ZIMEventHandler.onCallUserStateChanged == null) return;
          ZIMEventHandler.onCallUserStateChanged!(
              zim, ZIMCallUserStateChangeInfo.fromMap(data), data['callID']);
          break;

        /// MARK: - Friend
        case 'blacklistChanged':
          if (ZIMEventHandler.onBlacklistChanged == null) return;
          ZIMEventHandler.onBlacklistChanged!(
              zim,
              (data['userList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMUserInfo.fromMap(x))
                  .toList(),
              ZIMBlacklistChangeActionExtension.mapValue[data['action']]!);
          break;
        case 'friendListChanged':
          if (ZIMEventHandler.onFriendListChanged == null) return;
          ZIMEventHandler.onFriendListChanged!(
              zim,
              (data['friendList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMFriendInfo.fromMap(x))
                  .toList(),
              ZIMFriendListChangeActionExtension.mapValue[data['action']]!);
          break;
        case 'friendInfoUpdated':
          if (ZIMEventHandler.onFriendInfoUpdated == null) return;
          ZIMEventHandler.onFriendInfoUpdated!(
              zim,
              (data['friendList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMFriendInfo.fromMap(x))
                  .toList());
          break;
        case 'friendApplicationListChanged':
          if (ZIMEventHandler.onFriendApplicationListChanged == null) return;
          ZIMEventHandler.onFriendApplicationListChanged!(
              zim,
              (data['applicationList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMFriendApplicationInfo.fromMap(x))
                  .toList(),
              ZIMFriendApplicationListChangeActionExtension
                  .mapValue[data['action']]!);
          break;
        case 'friendApplicationUpdated':
          if (ZIMEventHandler.onFriendApplicationUpdated == null) return;
          ZIMEventHandler.onFriendApplicationUpdated!(
              zim,
              (data['applicationList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMFriendApplicationInfo.fromMap(x))
                  .toList());
          break;
      }
    } catch (e, s) {
      print('[ZIMEventHandlerError]: $eventType, $e, $s, ${event['data']}');
    }
  }
}
