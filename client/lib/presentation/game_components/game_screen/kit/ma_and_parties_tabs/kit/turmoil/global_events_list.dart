import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/TurmoilModel.dart';
import 'package:mars_flutter/domain/model/turmoil/globalEvents/ClientGlobalEvent.dart';
import 'package:mars_flutter/presentation/game_components/common/global_event/event_view.dart';

class GlobalEventsList extends StatelessWidget {
  final TurmoilModel turmoilModel;
  const GlobalEventsList({super.key, required this.turmoilModel});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: [
        if (turmoilModel.distant != null)
          EventView(
            event: ClientGlobalEvent.fromEventName(turmoilModel.distant!),
            useMiniSize: true,
          ),
        if (turmoilModel.coming != null)
          EventView(
            event: ClientGlobalEvent.fromEventName(turmoilModel.coming!),
            useMiniSize: true,
          ),
        if (turmoilModel.current != null)
          EventView(
            event: ClientGlobalEvent.fromEventName(turmoilModel.current!),
            useMiniSize: true,
          ),
      ],
    );
  }
}
