import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class DatePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final double size;
  final Function(DateTime selectedDate) onChange;

  DatePicker({@required this.startDate, @required this.endDate, this.size = 75, this.onChange});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<DateTime> days = [];
  int _index = 0;
  DateTime _date;

  ScrollController _controller;

  get size => widget.size;

  get startDate => widget.startDate;

  get date => _date;

  @override
  void initState() {
    super.initState();
    getDaysInBetween();
    _index = _jumpDays();

    _controller = new ScrollController();
    Timer(Duration(seconds: 0), () => jump());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getDaysInBetween() {
    for (int i = 0; i <= widget.endDate.difference(widget.startDate).inDays; i++) {
      days.add(widget.startDate.add(Duration(days: i)));
    }
  }

  int _jumpDays() {
    return Jiffy().diff(startDate, Units.DAY);
  }

  void jump() {
    if (!_controller.hasClients) return;

    int days = _jumpDays() - 1;

    _controller.jumpTo(days * size);
  }

  BorderSide _normalBorderSide() {
    return BorderSide(color: Colors.black26, width: 1);
  }

  BorderSide _selectedBorderSide() {
    return BorderSide(color: Color(0xFF4186E4), width: 5);
  }

  handleSelect(int index) {
    setState(() => _index = index);
    widget.onChange(days[index]);
  }

  Widget _buildDate(int index) {
    Jiffy date = Jiffy(days[index]);

    return GestureDetector(
      onTap: () => handleSelect(index),
      child: Container(
        padding: EdgeInsets.all(8),
        width: size,
        decoration: BoxDecoration(
          color: _index == index ? Color(0xFF4186E4).withOpacity(0.12) : null,
          border: Border(
            right: _normalBorderSide(),
            top: _normalBorderSide(),
            bottom: _index == index ? _selectedBorderSide() : _normalBorderSide(),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(date.format('dd'), style: TextStyle(fontWeight: FontWeight.w700, color: (Color(0xFF4186E4)), fontSize: 30),),
            Text(date.format('EEE'), style: TextStyle(fontWeight: FontWeight.w600, color: (Color(0xFFB1BCD0)), fontSize: 13),),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      child: ListView.builder(
        // itemExtent: width,
        controller: _controller,
        itemCount: days.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => _buildDate(index),
      ),
    );
  }
}
