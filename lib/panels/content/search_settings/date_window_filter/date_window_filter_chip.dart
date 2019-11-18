import 'package:flutter/material.dart';

class DateWindowFilterChip extends StatelessWidget {

  final String formattedDate;
  final VoidCallback onPressed;

  DateWindowFilterChip({this.formattedDate, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  ActionChip(
      avatar: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.calendar_today,
          color: Theme.of(context).accentColor,
          size: 13.0,
        ),
      ),
      label: Text(
        formattedDate,
        style: Theme.of(context).primaryTextTheme.subtitle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
    );
  }

}
