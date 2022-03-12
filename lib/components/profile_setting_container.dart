import 'package:flutter/material.dart';

class profileSettingContainer extends StatelessWidget {
  profileSettingContainer(
      {required this.hint,
      required this.value,
      required this.valueList,
      required this.onChanged});
  String hint;
  String? value;
  List valueList;
  Function(Object?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: value == null ? Colors.black54 : Color(0xef27AC84),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: DropdownButton(
            elevation: 0,
            isExpanded: true,
            hint: Text(hint),
            value: value,
            items: valueList.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            underline: Container(),
          ),
        ),
      ),
    );
  }
}
