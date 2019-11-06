import 'package:flutter/material.dart';

import 'date_window_filter/date_window_filter.dart';

enum SelectedFilter { date_window, live, past_period }

const filterText = <SelectedFilter, String>{
  SelectedFilter.date_window: 'Upcoming',
  SelectedFilter.live: 'Live',
  SelectedFilter.past_period: 'Previous',
};

class FilterSelector extends StatefulWidget {
  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  SelectedFilter _filter = SelectedFilter.date_window;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Filter by:',
              style: Theme.of(context).primaryTextTheme.button,
            ),
            SizedBox(width: 10.0),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryVariant,
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 140,
              height: 40,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SelectedFilter>(
                  value: _filter,
                  elevation: 4,
                  isExpanded: false,
                  style: Theme.of(context).primaryTextTheme.button,
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: Theme.of(context).accentColor,
                  ),
                  items: <DropdownMenuItem<SelectedFilter>>[
                    for (SelectedFilter filter in SelectedFilter.values)
                      DropdownMenuItem(
                          value: filter, child: Text(filterText[filter]))
                  ],
                  onChanged: (newFilter) {
                    setState(() {
                      _filter = newFilter;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        DateWindowFilter(),
        SizedBox(height: 10.0),
        Divider(
          color: Theme.of(context).colorScheme.primaryVariant,
          thickness: 3.0,
        ),
        SizedBox(height: 10.0),

      ],
    );
  }

  bool _isSelected(SelectedFilter filter) => filter == _filter;
}
