import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movement/color_pallet.dart';
import 'package:movement/extentions.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../infrastructure/services/localization_service.dart';
import 'util/date_extensions.dart';
import 'widgets/time_picker_widget.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(DateTime, DateTime) onComplete;
  final bool enableDateInFuture;
  final bool startWithEndDate;

  DatePickerWidget({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onComplete,
    this.enableDateInFuture = false,
    this.startWithEndDate = false,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> with TickerProviderStateMixin {
  late final TabController tabController;
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    tabController = TabController(initialIndex: widget.startWithEndDate ? 1 : 0, length: 2, vsync: this);
  }

  void updateStartTime(DateTime dateTime) {
    if (dateTime.isAfter(DateTime.now()) && widget.enableDateInFuture == false) dateTime = DateTime.now();
    setState(() {
      startDate = dateTime;
      if (startDate.isAfter(endDate)) endDate = startDate;
    });
  }

  void updateEndTime(DateTime dateTime) {
    if (dateTime.isAfter(DateTime.now()) && widget.enableDateInFuture == false) dateTime = DateTime.now();
    setState(() {
      endDate = dateTime;
      if (endDate.isBefore(startDate)) startDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 292 * y,
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorColor: ColorPallet.primaryColor,
            labelColor: ColorPallet.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                  height: 65 * y,
                  text:
                      'Begin:\n${DateFormat('EEEE', AppLocalizations.of(context).locale.languageCode).format(startDate).toCapitalize()} ${startDate.toPaddedString()}'),
              Tab(
                  height: 65 * y,
                  text:
                      'Eind:\n${DateFormat('EEEE', AppLocalizations.of(context).locale.languageCode).format(endDate).toCapitalize()} ${endDate.toPaddedString()}'),
            ],
          ),
          SizedBox(height: 30 * y),
          SizedBox(
            height: 183 * y,
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 100 * y,
                      child: TimePickerWidget(
                        date: startDate,
                        onChanged: updateStartTime,
                        maxDate: widget.enableDateInFuture ? null : DateTime.now(),
                      ),
                    ),
                    DayPickerWidget(
                      startDate,
                      updateStartTime,
                      widget.enableDateInFuture,
                    ),
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0 * x),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: EdgeInsets.all(8.0 * f),
                              child: Text('Annuleren', style: TextStyle(color: ColorPallet.primaryColor, fontWeight: FontWeight.w500, fontSize: 15.5 * f)),
                            ),
                          ),
                          InkWell(
                            onTap: () => tabController.animateTo(1),
                            child: Padding(
                              padding: EdgeInsets.all(8.0 * f),
                              child: Text('Volgende', style: TextStyle(color: ColorPallet.primaryColor, fontWeight: FontWeight.w500, fontSize: 15.5 * f)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 100 * y,
                      child: TimePickerWidget(
                        date: endDate,
                        onChanged: updateEndTime,
                        maxDate: widget.enableDateInFuture ? null : DateTime.now(),
                      ),
                    ),
                    DayPickerWidget(
                      endDate,
                      updateEndTime,
                      widget.enableDateInFuture,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0 * x),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => tabController.animateTo(0),
                            child: Padding(
                              padding: EdgeInsets.all(8.0 * f),
                              child: Text('Vorige', style: TextStyle(color: ColorPallet.primaryColor, fontWeight: FontWeight.w500, fontSize: 15.5 * f)),
                            ),
                          ),
                          InkWell(
                            onTap: (() {
                              Navigator.of(context).pop();
                              widget.onComplete(startDate, endDate);
                            }),
                            child: Padding(
                              padding: EdgeInsets.all(8.0 * f),
                              child: Text('Gereed', style: TextStyle(color: ColorPallet.primaryColor, fontWeight: FontWeight.w500, fontSize: 15.5 * f)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DayPickerWidget extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) onChanged;
  final bool enableDateInFuture;

  const DayPickerWidget(this.date, this.onChanged, this.enableDateInFuture);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45 * y,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => onChanged(date.subtract(Duration(days: 1))),
            child: Icon(Icons.arrow_back_ios, color: ColorPallet.darkTextColor.withOpacity(0.7), size: 20 * f),
          ),
          Text(DateFormat('EEEE', AppLocalizations.of(context).locale.languageCode).format(date).toCapitalize(),
              style: TextStyle(color: ColorPallet.darkTextColor, fontSize: 16 * f, fontWeight: FontWeight.w600)),
          (enableDateInFuture == false && DateTime.now().isSameDay(date) == false)
              ? InkWell(
                  onTap: () => onChanged(date.add(Duration(days: 1))),
                  child: Icon(Icons.arrow_forward_ios, color: ColorPallet.darkTextColor.withOpacity(0.7), size: 20 * f),
                )
              : SizedBox(width: 30 * x)
        ],
      ),
    );
  }
}
