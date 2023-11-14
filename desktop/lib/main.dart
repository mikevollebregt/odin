import 'dart:ffi';
import 'dart:io';

import 'package:desktop/infastructure/repositories/dtos/location_map_dto.dart';
import 'package:desktop/presentation/day_list.dart';
import 'package:desktop/presentation/location_map.dart';
import 'package:desktop/presentation/theme/appTheme.dart';
import 'package:desktop/presentation/theme/themes.dart';
import 'package:desktop/providers.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as d;

import 'infastructure/notifiers/generic_notifier.dart';

void main() {
  open.overrideFor(OperatingSystem.windows, _openOnWindows);

  if (Platform.isWindows) {
    final db = d.sqlite3.openInMemory();
    db.dispose();
  }

  runApp(const ProviderScope(child: MyApp()));
}

DynamicLibrary _openOnWindows() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final script = File(Platform.script.toFilePath());
  final libraryNextToScript = File('${script.path.replaceFirst("main.dart", "")}\\sqlite\\sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript.path);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appThemeData[AppTheme.StandardTheme],
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const DayList(),
        )

        // SizedBox(
        //   width: MediaQuery.of(context).size.width * 0.25,
        //   height: MediaQuery.of(context).size.height * 0.6,
        //   child: _buildRawMap(),
        // ),
        // const SizedBox(
        //   width: 10,
        // ),
        // SizedBox(
        //   width: MediaQuery.of(context).size.width * 0.25,
        //   height: MediaQuery.of(context).size.height * 0.6,
        //   child: _buildTomMap(),
        // )
      ],
    ));
  }

  Widget _buildRawMap() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(testcaseRawDetailNotifierProvider);
      if (state is Loaded<LocationMapDTO>) {
        return LocationMap(state.loadedObject);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  // Widget _buildAlgoMap() {
  //   return Consumer(builder: (context, ref, child) {
  //     final state = ref.watch(testcaseAlgoDetailNotifierProvider);
  //     if (state is Loaded<LocationMapDTO>) {
  //       return LocationMap(state.loadedObject);
  //     } else {
  //       return const CircularProgressIndicator();
  //     }
  //   });
  // }

  Widget _buildTomMap() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(testcaseTomAlgoDetailNotifierProvider);
      if (state is Loaded<LocationMapDTO>) {
        return LocationMap(state.loadedObject);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
