import 'package:flutter/material.dart';

class ReasonDropdown extends StatelessWidget {
  ReasonDropdown(
      {@required this.dropdownValue,
      @required this.setDropdownValue,
      @required this.reasons});
  final Function setDropdownValue;
  final String dropdownValue;
  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        hint: Text('Wybierz powód'),
        isExpanded: true,
        value: dropdownValue,
        items: reasons
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (value) {
          setDropdownValue(value);
          // if (value == 'Inne') {
          //   Scaffold.of(context).showSnackBar(SnackBar(
          //       content: Text(
          //           "Po wybraniu opcji 'Inne' konieczne są dodatkowe informacje")));
          // }
        });
  }
}
