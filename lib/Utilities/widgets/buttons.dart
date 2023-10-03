import 'package:flutter/material.dart';
import 'package:x_money_manager/utilities/colors.dart';
// ignore: camel_case_types
class cancelButton extends StatelessWidget {
  const cancelButton({
    super.key,
    required  this.onPressed,
    this.label,
  }) ;
  final String? label;
  final void Function() onPressed;
  get title=> label ?? 'CANCEL';
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: kShrineBrown900,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
      ),
      child: Text(title) ,
    );
  }
}


class saveButton extends StatelessWidget {
  const saveButton({
    super.key,
    required  this.onPressed,
    this.label,
  }) ;
  final String? label;
  final void Function() onPressed;
  get title=> label ?? 'NEXT';
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: kShrineBrown900,
                    backgroundColor: kShrinePink100,
                    elevation: 8.0,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                  ),
                  child: Text(title),
                );
  }
}

class floatingButton extends StatelessWidget {
  const floatingButton({
    super.key,
    required  this.onPressed,
    required  this.child,
  });
  final void Function() onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: kShrineBrown900,
      backgroundColor: kShrinePink100,
      onPressed:onPressed,
      child:child,// const Icon(Icons.add),
    );
  }
}

