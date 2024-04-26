import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import 'package:mars_flutter/data/client_cards_parser.dart';

import 'package:mars_flutter/data/ma_parser.dart';

import 'package:mars_flutter/presentation/core/bloc_observer.dart';

import 'package:mars_flutter/presentation/mars_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  Bloc.observer = AppBlocObserver();

  ClientCardsParser.parse();

  MilestoneAwardParser.parse();
  runApp(MarsApp());
}
