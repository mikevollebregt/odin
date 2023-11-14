import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';

import '../../../../color_pallet.dart';
import '../../../../infrastructure/notifiers/responsive_ui.dart';
import '../../../../providers.dart';
import '../../../routing/routes.dart';
import '../../../widgets/date_picker_widget/date_picker_widget.dart';

class FancyFab extends ConsumerStatefulWidget {
  const FancyFab();
  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends ConsumerState<FancyFab> with SingleTickerProviderStateMixin {
  _FancyFabState();
  late final DateTime timePickerDate;
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56;

  @override
  void initState() {
    timePickerDate = getTimePickerDate();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });

    Tween<double>(begin: 0, end: 1).animate(_animationController);
    _buttonColor = ColorTween(
      begin: ColorPallet.primaryColor,
      end: const Color(0xFFDB7758),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 1),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0, 0.75, curve: _curve),
    ));
    super.initState();
  }

  DateTime getTimePickerDate() {
    final overviewDate = ref.read(dayOverviewNotifierProvider).day;
    if (DateTime.now().day == overviewDate.day) return DateTime.now();
    return overviewDate.add(Duration(hours: 12));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget addLocation(WidgetRef ref, BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      AnimatedOpacity(
        opacity: isOpened ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.77), borderRadius: BorderRadius.all(Radius.circular(5))),
            padding: EdgeInsets.all(10 * f),
            margin: EdgeInsets.only(right: 10 * x),
            child: const Text(
              'Locatie toevoegen',
              style: TextStyle(color: Colors.white),
            )),
      ),
      FloatingActionButton(
        backgroundColor: ColorPallet.primaryColor,
        elevation: 0,
        heroTag: 'location_details',
        onPressed: () {
          animate();
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return DatePickerWidget(
                initialStartDate: timePickerDate,
                initialEndDate: timePickerDate,
                onComplete: (DateTime startDate, DateTime endDate) =>
                    Routes.RouteToPage('stopDetailsPage', context, ref: ref, startDate: startDate, endDate: endDate),
              );
            },
          );
        },
        child: const FaIcon(
          FontAwesomeIcons.locationDot,
          color: Colors.white,
        ),
      )
    ]);
  }

  Widget addMovement(WidgetRef ref, BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      AnimatedOpacity(
        opacity: isOpened ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.77), borderRadius: BorderRadius.all(Radius.circular(5))),
            padding: EdgeInsets.all(10 * f),
            margin: EdgeInsets.only(right: 10 * x),
            child: const Text(
              'Verplaatsing toevoegen',
              style: TextStyle(color: Colors.white),
            )),
      ),
      FloatingActionButton(
        backgroundColor: ColorPallet.primaryColor,
        elevation: 0,
        heroTag: 'movement_details',
        onPressed: () {
          animate();
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return DatePickerWidget(
                initialStartDate: timePickerDate,
                initialEndDate: timePickerDate,
                onComplete: (DateTime startDate, DateTime endDate) =>
                    Routes.RouteToPage('movementDetailsPage', context, ref: ref, startDate: startDate, endDate: endDate),
              );
            },
          );
        },
        child: const FaIcon(
          FontAwesomeIcons.route,
          color: Colors.white,
        ),
      )
    ]);
  }

  Widget toggle() {
    return Container(
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: SimpleAnimatedIcon(
          color: Colors.white,
          startIcon: Icons.add,
          endIcon: Icons.close,
          progress: _animationController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isOpened ? Transform(transform: Matrix4.translationValues(0, _translateButton.value * 2.0, 0), child: addLocation(ref, context)) : Container(),
        isOpened ? Transform(transform: Matrix4.translationValues(0, _translateButton.value, 0), child: addMovement(ref, context)) : Container(),
        toggle(),
      ],
    );
  }
}
