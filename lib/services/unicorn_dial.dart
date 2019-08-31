import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

/// Based on the Unicorn Dial widget by Tiago Martins. Rather than
/// using this as a dependency, I'm choosing to modify it to fit my needs.
/// The repo states that the code is licensed under the MIT license, but doesn't
/// link one, so for his and my sake, I'm including a generated copy of it here:

// Copyright (c) 2018 Tiago Martins
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

class UnicornOrientation {
  static const HORIZONTAL = 0;
  static const VERTICAL = 1;
}

class UnicornButton extends FloatingActionButton {
  final FloatingActionButton currentButton;
  final String labelText;
  final TextStyle labelTextStyle;
  final Color labelBackgroundColor;
  final Color labelShadowColor;
  final bool labelHasShadow;
  final bool hasLabel;

  UnicornButton(
      {this.currentButton,
      this.labelText,
      this.labelTextStyle,
      this.labelBackgroundColor,
      this.labelShadowColor,
      this.labelHasShadow = true,
      this.hasLabel = false})
      : assert(currentButton != null);

  // make this a getter?
  Widget returnLabel() {
    return Container(
        decoration: BoxDecoration(
            boxShadow: this.labelHasShadow
                ? [
                    new BoxShadow(
                      color: this.labelShadowColor ??
                          Color.fromRGBO(204, 204, 204, 1.0),
                      blurRadius: 3.0,
                    ),
                  ]
                : null,
            color: this.labelBackgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(3.0)), //color: Colors.white,
        padding: EdgeInsets.all(9.0),
        child: Text(this.labelText,
            style: this.labelTextStyle ??
                TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(119, 119, 119, 1.0))));
  }

  Widget build(BuildContext context) {
    return this.currentButton;
  }
}

class UnicornDialer extends StatefulWidget {
  final int orientation;
  final Icon parentButton;
  final Icon finalButtonIcon;
  final bool hasBackground;
  final Color parentButtonBackground;
  final Color parentButtonForeground;
  final List<UnicornButton> childButtons;
  final int animationDuration;
  final int mainAnimationDuration;
  final double childPadding;
  final Color backgroundColor;
  final Function onMainButtonPressed;
  final Function onBackgroundPressed;
  final Object parentHeroTag;
  final double bottomPadding;
  final double rightPadding;

  UnicornDialer(
      {this.parentButton,
      this.parentButtonBackground,
      this.parentButtonForeground,
      this.childButtons,
      this.onMainButtonPressed,
      this.onBackgroundPressed,
      this.orientation = 1,
      this.hasBackground = true,
      this.backgroundColor = Colors.white30,
      this.parentHeroTag = "parent",
      this.finalButtonIcon,
      this.animationDuration = 180,
      this.mainAnimationDuration = 200,
      this.childPadding = 4.0,
      this.bottomPadding = 0.0,
      this.rightPadding = 0.0})
      : assert(parentButton != null);

  _UnicornDialer createState() => _UnicornDialer();
}

class _UnicornDialer extends State<UnicornDialer>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _parentController;

  bool isOpen = false;
  var _isPressed = false;

  @override
  void initState() {
    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration));

    this._parentController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.mainAnimationDuration));

    super.initState();
  }

  @override
  dispose() {
    this._animationController.dispose();
    this._parentController.dispose();
    super.dispose();
  }

  Future<void> mainActionButtonOnPressed() {
    if (this._animationController.isDismissed) {
      return this._animationController.forward();
    } else {
      return this._animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    this._animationController.reverse();

    var hasChildButtons =
        widget.childButtons != null && widget.childButtons.length > 0;

    if (!this._parentController.isAnimating) {
      if (this._parentController.isCompleted) {
        this._parentController.forward().then((s) {
          this._parentController.reverse().then((e) {
            this._parentController.forward();
          });
        });
      }
      if (this._parentController.isDismissed) {
        this._parentController.reverse().then((s) {
          this._parentController.forward();
        });
      }
    }

    var mainFAB = AnimatedBuilder(
        animation: this._parentController,
        builder: (BuildContext context, Widget child) {
          return Transform(
              transform: new Matrix4.diagonal3(vector.Vector3(
                  _parentController.value,
                  _parentController.value,
                  _parentController.value)),
              alignment: FractionalOffset.center,
              child: FloatingActionButton(
                  isExtended: false,
                  heroTag: widget.parentHeroTag,
                  backgroundColor: widget.parentButtonBackground,
                  foregroundColor: widget.parentButtonForeground,
                  onPressed: () async {
                    // Async exit pattern if the button is pressed too quick
                    if (_isPressed) {
                      return;
                    }
                    _isPressed = true;
                    await mainActionButtonOnPressed();
                    if (widget.onMainButtonPressed != null) {
                      await widget.onMainButtonPressed();
                    }
                    _isPressed = false;
                  },
                  child: !hasChildButtons
                      ? widget.parentButton
                      : AnimatedBuilder(
                          animation: this._animationController,
                          builder: (BuildContext context, Widget child) {
                            return Transform(
                              transform: new Matrix4.rotationZ(
                                  this._animationController.value * 0.8),
                              alignment: FractionalOffset.center,
                              child: new Icon(
                                  this._animationController.isDismissed
                                      ? widget.parentButton.icon
                                      : widget.finalButtonIcon == null
                                          ? Icons.close
                                          : widget.finalButtonIcon.icon),
                            );
                          })));
        });

    if (hasChildButtons) {
      var mainFloatingButton = AnimatedBuilder(
          animation: this._animationController,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(
                angle: this._animationController.value * 0.8, child: mainFAB);
          });

      var childButtonsList = widget.childButtons == null ||
              widget.childButtons.length == 0
          ? List<Widget>()
          : List.generate(widget.childButtons.length, (index) {
              var intervalValue = index == 0
                  ? 0.9
                  : ((widget.childButtons.length - index) /
                          widget.childButtons.length) -
                      0.2;

              intervalValue =
                  intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue;

              var childFAB = FloatingActionButton(
                  onPressed: () {
                    if (widget.childButtons[index].currentButton.onPressed !=
                        null) {
                      widget.childButtons[index].currentButton.onPressed();
                    }

                    this._animationController.reverse();
                  },
                  child: widget.childButtons[index].currentButton.child,
                  heroTag: widget.childButtons[index].currentButton.heroTag,
                  backgroundColor:
                      widget.childButtons[index].currentButton.backgroundColor,
                  mini: widget.childButtons[index].currentButton.mini,
                  tooltip: widget.childButtons[index].currentButton.tooltip,
                  key: widget.childButtons[index].currentButton.key,
                  elevation: widget.childButtons[index].currentButton.elevation,
                  foregroundColor:
                      widget.childButtons[index].currentButton.foregroundColor,
                  highlightElevation: widget
                      .childButtons[index].currentButton.highlightElevation,
                  isExtended:
                      widget.childButtons[index].currentButton.isExtended,
                  shape: widget.childButtons[index].currentButton.shape);

              return Positioned(
                right: widget.orientation == UnicornOrientation.VERTICAL
                    ? widget.childButtons[index].currentButton.mini ? 4.0 : 0.0
                    : ((widget.childButtons.length - index) * 55.0) + 15,
                bottom: widget.orientation == UnicornOrientation.VERTICAL
                    ? ((widget.childButtons.length - index) * 55.0) + 15
                    : 8.0,
                child: Row(children: [
                  ScaleTransition(
                      scale: CurvedAnimation(
                        parent: this._animationController,
                        curve:
                            Interval(intervalValue, 1.0, curve: Curves.linear),
                      ),
                      alignment: FractionalOffset.center,
                      child: (!widget.childButtons[index].hasLabel) ||
                              widget.orientation ==
                                  UnicornOrientation.HORIZONTAL
                          ? Container()
                          : Container(
                              padding:
                                  EdgeInsets.only(right: widget.childPadding),
                              child: widget.childButtons[index].returnLabel())),
                  ScaleTransition(
                      scale: CurvedAnimation(
                        parent: this._animationController,
                        curve:
                            Interval(intervalValue, 1.0, curve: Curves.linear),
                      ),
                      alignment: FractionalOffset.center,
                      child: childFAB)
                ]),
              );
            });

      var unicornDialWidget = Container(
        margin: widget.bottomPadding != 0
            ? EdgeInsets.only(
                bottom: widget.bottomPadding, right: widget.rightPadding)
            : null,
        height: double.infinity,
        width: double.infinity,
        child: Stack(
            //fit: StackFit.expand,
            alignment: Alignment.bottomRight,
            overflow: Overflow.visible,
            children: <Widget>[
              ...(childButtonsList.toList()
                ..add(Positioned(
                    right: null, bottom: null, child: mainFloatingButton)))
            ]),
      );

      var modal = ScaleTransition(
          scale: CurvedAnimation(
            parent: this._animationController,
            curve: Interval(1.0, 1.0, curve: Curves.linear),
          ),
          alignment: FractionalOffset.center,
          child: GestureDetector(
              onTap: () {
                if(widget.onBackgroundPressed != null) {
                  widget.onBackgroundPressed();
                }
                mainActionButtonOnPressed();
              },
              child: Container(
                alignment: Alignment.topLeft,
                color: widget.backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )));

      return widget.hasBackground
          ? Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: [
                  Positioned(right: -16.0, bottom: -16.0, child: modal),
                  unicornDialWidget
                ])
          : unicornDialWidget;
    }

    return mainFAB;
  }
}
