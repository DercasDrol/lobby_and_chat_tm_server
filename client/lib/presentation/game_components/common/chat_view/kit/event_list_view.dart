import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/chat_event.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/user_info.dart';
import 'package:mars_flutter/presentation/core/string_to_color.dart';
import 'package:url_launcher/url_launcher.dart';

//TODO: try change full rebuild to add new messages to the list
class EventListView extends StatelessWidget {
  final double width;
  final double height;
  final List<ChatEvent> events;
  final bool Function(ChatEvent) isCurrentUserSender;
  final bool Function(String) isUserOnline;
  const EventListView({
    super.key,
    required this.width,
    required this.events,
    required this.isCurrentUserSender,
    required this.height,
    required this.isUserOnline,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();
    final Duration timeOffset = DateTime.timestamp().timeZoneOffset;

    Widget createChatEventView(ChatEvent message) {
      final mTime = message.timestamp.add(timeOffset);
      final user = UserInfo.tryGetUserInfoById(message.senderId);
      final avatarUrl = user?.avatarUrl ?? '';
      final nameToShow = user?.name ?? message.senderId;
      final action = message.eventType.toChatString();

      final getAvatarView = () => Container(
            margin: EdgeInsets.only(right: 5),
            child: Tooltip(
              message: nameToShow +
                  (isUserOnline(message.senderId)
                      ? " is online"
                      : " is offline") +
                  ".\nClick to open Discord profile",
              child: Stack(
                alignment: isCurrentUserSender(message)
                    ? Alignment.topRight
                    : Alignment.topLeft,
                children: [
                  TapRegion(
                    onTapInside: (_) => launchUrl(
                        Uri.parse(DISCORD_USER_URL + message.senderId)),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: avatarUrl != ''
                          ? NetworkImage(DISCORD_AVATAR_URL +
                              message.senderId +
                              "/" +
                              avatarUrl)
                          : null,
                      backgroundColor: avatarUrl == ''
                          ? ColorUtils.stringToColor(message.senderId)
                          : null,
                      child: avatarUrl == ''
                          ? Text(user?.name[0].toUpperCase() ?? "?",
                              style: TextStyle(color: Colors.white, shadows: [
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                ),
                                Shadow(
                                  blurRadius: 6.0,
                                  color: Colors.black,
                                ),
                              ]))
                          : null,
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                      color: isUserOnline(message.senderId)
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );

      final getUserMessageView = () => Container(
            margin: EdgeInsets.only(top: 3, bottom: 3, right: 5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow[100],
            ),
            constraints: BoxConstraints(maxWidth: width * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${mTime.hour}:${mTime.minute}:${mTime.second}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                Text('${message.text}',
                    style: TextStyle(color: Colors.black, fontSize: 16))
              ],
            ),
          );

      final getTechnicalMessageView = () => Text(
            '$nameToShow $action the chat',
            style: TextStyle(fontSize: 13, color: Colors.grey[300]),
            textAlign: TextAlign.center,
          );

      return message.eventType == ChatEventType.MESSAGE
          ? Row(
              mainAxisAlignment: isCurrentUserSender(message)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (!isCurrentUserSender(message)) getAvatarView(),
                getUserMessageView(),
                if (isCurrentUserSender(message)) getAvatarView(),
              ],
            )
          : getTechnicalMessageView();
    }

    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height,
          maxHeight: height,
          maxWidth: width,
        ),
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          reverse: true,
          cacheExtent: 100,
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            var message = events[events.length - index - 1];
            return createChatEventView(message);
          },
        ));
  }
}
