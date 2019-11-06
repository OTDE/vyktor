import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/blocs.dart';
import '../../../../services/services.dart';

import 'date_window_filter_chip.dart';

class DateWindowFilterButtons extends StatefulWidget {
  final Widget Function(BuildContext, Widget) datePickerTheme;

  DateWindowFilterButtons({this.datePickerTheme});

  @override
  _DateWindowFilterButtonsState createState() =>
      _DateWindowFilterButtonsState();
}

class _DateWindowFilterButtonsState extends State<DateWindowFilterButtons> {
  int _startAfterDate = 0;
  int _startBeforeDate = 0;

  @override
  void initState() {
    // Date invariants:
    //
    // - After date must not be before now
    // - Before date must not be before the after date
    Settings().getStartAfterDate().then((afterDate) {
      if(_isBeforeNow(afterDate)) {
        Settings().clearStartAfterDate().then((e) {
          Settings().getStartAfterDate().then((newDate) {
            afterDate = newDate;
          });
        });
        Settings().getStartBeforeDate().then((beforeDate) {
          if(beforeDate < afterDate) {
            Settings().clearStartBeforeDate().then((e) {
              Settings().getStartBeforeDate().then((newDate) {
                beforeDate = newDate;
              });
            });
          }
            setState(() {
              _startBeforeDate = beforeDate;
            });
        });
      }
      setState(() {
        _startAfterDate = afterDate;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DateWindowFilterChip(
          formattedDate: _toFormattedDate(_startBeforeDate),
          onPressed: () async {
            // AfterDate invariant:
            // - No earlier than yesterday
            // - No later than 1 day before the "before" date.
            var selectedDate = await showDatePicker(
              context: context,
              builder: widget.datePickerTheme,
              initialDate: DateTime.fromMillisecondsSinceEpoch(_startAfterDate),
              firstDate: DateTime.now().subtract(Duration(days: 1)),
              lastDate: DateTime.fromMillisecondsSinceEpoch(_startBeforeDate),
            );
            if (selectedDate == null) return;
            _startAfterDate = selectedDate.millisecondsSinceEpoch;
            await Settings().setStartBeforeDate(_startAfterDate);
            Loading().isNow(true);
            mapBloc.dispatch(RefreshMarkerData());
            setState(() {});
          },
        ),
        SizedBox(width: 10),
        DateWindowFilterChip(
          formattedDate: _toFormattedDate(_startAfterDate),
          onPressed: () async {
            // BeforeDate picker invariant:
            // - No earlier than 1 day after the "after" date
            // - No later than 1 year from now.
            var selectedDate = await showDatePicker(
              context: context,
              builder: widget.datePickerTheme,
              initialDate:
                  DateTime.fromMillisecondsSinceEpoch(_startBeforeDate),
              firstDate: DateTime.fromMillisecondsSinceEpoch(_startAfterDate)
                  .add(Duration(days: 1)),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (selectedDate == null) return;
            _startBeforeDate = selectedDate.millisecondsSinceEpoch;
            await Settings().setStartBeforeDate(_startBeforeDate);
            Loading().isNow(true);
            mapBloc.dispatch(RefreshMarkerData());
            setState(() {});
          },
        )
      ],
    );
  }

  /// Formats a unix [timestamp] into a mm/dd/yyyy date string.
  String _toFormattedDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.month}/${date.day}/${date.year}';
  }

  bool _isBeforeNow(int timestamp) => timestamp < DateTime.now().millisecondsSinceEpoch;
}
