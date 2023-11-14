import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../../../providers.dart';

class ConfirmButtonWidget extends ConsumerWidget {
  final MovementDto _movementDto;

  const ConfirmButtonWidget(this._movementDto);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementNotifier = ref.watch(movementNotifierProvider(_movementDto));
    return InkWell(
      onTap: () {
        if (_movementDto.isComplete) {
          movementNotifier.save();
          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(
            msg: 'Vul eerst het vervoermiddel in',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16 * f),
        child: Icon(
          Icons.check,
          size: 26 * f,
          color: _movementDto.isComplete ? Colors.white : Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
