import 'package:flutter/material.dart';

class LoadingIcon extends StatelessWidget {

  const LoadingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryVariant,
          style: BorderStyle.solid,
          width: 4.0,
        ),
      ),
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }

}
