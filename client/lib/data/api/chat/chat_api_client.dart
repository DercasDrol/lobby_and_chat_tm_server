import 'dart:convert';

import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/common/socket.dart';
import 'package:flutter/foundation.dart';
import 'package:mars_flutter/data/jwt.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/chat_event.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/user_info.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatUserList {
  final String chatRoom;
  final Set<String> usersIds;

  ChatUserList(this.usersIds, this.chatRoom);

  factory ChatUserList.fromJson(Map<String, dynamic> json) {
    return ChatUserList(
      Set<String>.from(json['usersIds']),
      json['chatRoom'],
    );
  }
}

class ChatAPIClient {
  final _socket = getNewSocketInstance('4002');
  final ValueNotifier<String?> jwt;
  final ValueNotifier<bool> isChatConnectionOk = ValueNotifier(false);
  final Map<String /*chatRoomKey*/,
          Map<String /*uniqKey*/, void Function(Map<int, ChatEvent>)>>
      _onEventSubscribers = {};
  final List<String> _roomsToJoinWithReconnect = [];

  String? _userId = null;
  String? get userId => _userId;
  final List<String> joinedRooms = [];
  final Map<String /*chatRoomKey*/, ChatEvent> _lastSavedJoinOrLeaveEvent = {};
  final Map<String, void Function()> _onUsersInfosSubscribers = {};
  final Map<String, void Function(Set<String /*UserInfo.id*/ > usersIds)>
      _onOnlineUsersListChangesSubscribers = {};

  void subscribeRoomOnReconnect(String room) {
    _roomsToJoinWithReconnect.add(room);
  }

  void unsubscribeRoomOnReconnect(String room) {
    _roomsToJoinWithReconnect.remove(room);
  }

  void subscribeOnOnlineUsersListChanges(
      void Function(Set<String> usersIds) onOnlineUsersListChanges,
      String room) {
    _onOnlineUsersListChangesSubscribers[room] = onOnlineUsersListChanges;
  }

  void unsubscribeOnOnlineUsersListChanges(String room) {
    _onOnlineUsersListChangesSubscribers.remove(room);
  }

  void subscribeOnUsersInfos(void Function() onUsersInfos, String room) {
    _onUsersInfosSubscribers[room] = onUsersInfos;
  }

  void unsubscribeOnUsersInfos(String room) {
    _onUsersInfosSubscribers.remove(room);
  }

  void subscribeOnEvents(
    void Function(Map<int, ChatEvent>) onEvent,
    String roomKey,
    String uniqKey,
  ) {
    final roomSubsctiptions = _onEventSubscribers[roomKey] ?? {};
    roomSubsctiptions[uniqKey] = onEvent;
    _onEventSubscribers[roomKey] = roomSubsctiptions;
  }

  void unsubscribeOnEvents(String roomKey, String uniqKey) {
    final roomSubsctiptions = _onEventSubscribers[roomKey] ?? {};
    roomSubsctiptions.remove(uniqKey);
    _onEventSubscribers[roomKey] = roomSubsctiptions;
  }

  ChatAPIClient(this.jwt) {
    _socket.onConnect((_) {
      logger.d('ChatAPIClient connected');
      isChatConnectionOk.value = true;
      _roomsToJoinWithReconnect.forEach((room) => joinToChatRoom(room));
    });

    _socket.onDisconnect((_) {
      logger.d('disconnected  from chat server');
      joinedRooms.clear();
      isChatConnectionOk.value = false;
    });

    _socket.onConnectError((err) {
      logger.d('ChatAPIClient onConnectError error: $err');
      jwt.value = null;
      _socket.disconnect();
    });

    _socket.on('events', (eventsFromServer) {
      logger.d('ChatAPIClient events: $eventsFromServer');
      Iterable l = jsonDecode(eventsFromServer);
      final List<ChatEvent> events =
          l.map((e) => ChatEvent.fromJson(e)).toList();
      events.forEach((event) {
        final bufferEventTime =
            _lastSavedJoinOrLeaveEvent[event.chatRoom]?.timestamp;
        if ((event.eventType == ChatEventType.JOIN ||
                event.eventType == ChatEventType.LEAVE) &&
            ((bufferEventTime != null &&
                    event.timestamp.isAfter(bufferEventTime)) ||
                bufferEventTime == null)) {
          _lastSavedJoinOrLeaveEvent[event.chatRoom] = event;
        }
      });
      _onEventSubscribers.forEach((roomKey, onEventMap) {
        final Map<int, ChatEvent> eventsMap = Map<int, ChatEvent>.fromIterable(
          events.where((event) => event.chatRoom == roomKey),
          key: (event) => event.id,
          value: (event) => event,
        );
        onEventMap.values.forEach((onEvent) => onEvent(eventsMap));
      });
    });

    _socket.on('users_infos', (usersInfos) {
      logger.d('ChatAPIClient users_infos: $usersInfos');
      Iterable l = jsonDecode(usersInfos);
      final List<UserInfo> userInfos =
          l.map((e) => UserInfo.fromJson(e)).toList();
      final Map<String, UserInfo> usersInfosMap =
          Map<String, UserInfo>.fromIterable(
        userInfos,
        key: (userInfo) => (userInfo as UserInfo).id,
        value: (userInfo) => userInfo,
      );
      UserInfo.addUsersInfos(usersInfosMap);
      if (_onUsersInfosSubscribers.entries.isNotEmpty)
        _onUsersInfosSubscribers.entries.first.value();
    });

    _socket.on('online_users_list_changes', (chatUserListJson) {
      logger.d('ChatAPIClient online_users_list_changes: $chatUserListJson');
      ChatUserList chatUserList = ChatUserList.fromJson(
          jsonDecode(chatUserListJson as String) as Map<String, dynamic>);
      _onOnlineUsersListChangesSubscribers
          .forEach((roomKey, onOnlineUsersListChanges) {
        if (chatUserList.chatRoom == roomKey)
          onOnlineUsersListChanges(chatUserList.usersIds);
      });
    });

    jwt.addListener(() => initConnectionToChatServer(jwt.value));
  }

  void dispose() {
    _socket.dispose();
    jwt.dispose();
    isChatConnectionOk.dispose();
  }

  void initConnectionToChatServer(String? jwt) {
    logger.d('ChatAPIClient initConnectionToChatServer: $jwt');
    if (jwt != null && jwt != '') {
      _userId = getUserIdFromJwt(jwt);
      if (_socket.connected) _socket.disconnect();
      _socket.io.options['query'] = {'jwt': jwt};
      _socket.connect();
    } else {
      if (_socket.connected) _socket.disconnect();
    }
  }

  void joinToChatRoom(String chatRoom) {
    logger.d(chatRoom);
    if (chatRoom != '' && !joinedRooms.contains(chatRoom)) {
      _socket.emit('join', chatRoom);
      joinedRooms.add(chatRoom);
      /* if (_leaveEventsBuffer.containsKey(chatRoom) &&
          DateTime.now().difference(_leaveEventsBuffer[chatRoom]!).inSeconds <
              1) {
        _leaveEventsBuffer.remove(chatRoom);
        return;
      } else {
        _joinEventsBuffer[chatRoom] = DateTime.now();
      }*/
    }
  }

  void leaveChatRoom(String chatRoom) {
    logger.d(chatRoom);
    if (chatRoom != '') {
      _socket.emit('leave', chatRoom);
      joinedRooms.removeWhere((joinedRoom) => joinedRoom == chatRoom);
      /*if (_joinEventsBuffer.containsKey(chatRoom) &&
          DateTime.now().difference(_joinEventsBuffer[chatRoom]!).inSeconds <
              1) {
        _joinEventsBuffer.remove(chatRoom);
        return;
      } else {
        _leaveEventsBuffer[chatRoom] = DateTime.now();
      }*/
    }
  }

  void askUserInfos(Set<String> UserIds) {
    if (UserIds.isNotEmpty) {
      _socket.emit('get_users_infos', jsonEncode(UserIds.toList()));
    }
  }

  void sendMessage(String messageText, String chatRoom) {
    logger.d(messageText);
    if (messageText != '') {
      Map<String, String> messagePost = {
        'text': messageText,
        'chatRoom': chatRoom,
      };
      _socket.emit('chat', utf8.encode(jsonEncode(messagePost)));
    }
  }
}
