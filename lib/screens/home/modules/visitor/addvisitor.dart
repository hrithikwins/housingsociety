import 'package:flutter/material.dart';
import 'package:housingsociety/screens/home/modules/visitor/reusabletextfield.dart';
import 'package:housingsociety/services/database.dart';
import 'package:housingsociety/shared/constants.dart';

class AddVisitor extends StatefulWidget {
  static const String id = 'add_visitor';
  final String name;
  final String wing;
  final String flatno;
  final String purpose;
  final String mobileNo;
  final int flag;
  final TimeOfDay selectedTimeIn;
  final TimeOfDay selectedTimeOut;
  final String docid;
  AddVisitor(
      {this.name,
      this.wing,
      this.flatno,
      this.purpose,
      this.mobileNo,
      this.flag,
      this.selectedTimeIn,
      this.selectedTimeOut,
      this.docid});

  @override
  _AddVisitorState createState() => _AddVisitorState();
}

class _AddVisitorState extends State<AddVisitor> {
  String name = '', wing = '', flatno = '', purpose = '', mobileNo = '';
  TimeOfDay selectedTimeIn = TimeOfDay.now();
  TimeOfDay selectedTimeOut;

  Future selectTimeIn(BuildContext context) async {
    TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTimeIn);
    if (picked != null) {
      setState(() {
        selectedTimeIn = picked;
      });
    }
  }

  Future selectTimeOut(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTimeOut ?? TimeOfDay(hour: 0, minute: 0));
    if (picked != null) {
      setState(() {
        selectedTimeOut = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.flag == 0) {
      name = widget.name;
      wing = widget.wing;
      flatno = widget.flatno;
      purpose = widget.purpose;
      mobileNo = widget.mobileNo;
      selectedTimeIn = widget.selectedTimeIn;
      selectedTimeOut = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Visitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            ReusableTextField(
              maxlines: null,
              labelText: 'Name',
              prefixIcon: Icon(Icons.perm_identity),
              initialValue: widget.flag == 0 ? widget.name : name,
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            ReusableTextField(
              labelText: 'Mobile No',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(Icons.call),
              initialValue: widget.flag == 0 ? widget.mobileNo : mobileNo,
              maxLength: 10,
              onChanged: (val) {
                setState(() {
                  mobileNo = val;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                    child: ReusableTextField(
                  labelText: 'Wing',
                  prefixIcon: Icon(Icons.apartment),
                  initialValue: widget.flag == 0 ? widget.wing : wing,
                  onChanged: (val) {
                    setState(() {
                      wing = val;
                    });
                  },
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ReusableTextField(
                    labelText: 'Flat No.',
                    initialValue: widget.flag == 0 ? widget.flatno : flatno,
                    onChanged: (val) {
                      setState(() {
                        flatno = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            ReusableTextField(
              labelText: 'Purpose',
              maxlines: null,
              prefixIcon: Icon(Icons.work),
              initialValue: widget.flag == 0 ? widget.purpose : purpose,
              onChanged: (val) {
                setState(() {
                  purpose = val;
                });
              },
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      selectTimeIn(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: kTurquoise,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'In  ' + selectedTimeIn.format(context),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      selectTimeOut(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: kTurquoise,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        selectedTimeOut == null
                            ? Text(
                                'Out  ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Out  ' + selectedTimeOut.format(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: name != '' &&
            wing != '' &&
            flatno != '' &&
            purpose != '' &&
            mobileNo.length > 9,
        child: FloatingActionButton(
          child: Icon(
            Icons.done,
          ),
          onPressed: () {
            if (widget.flag == 0) {
              DatabaseService().updateVisitor(
                  name,
                  mobileNo,
                  wing,
                  flatno,
                  purpose,
                  selectedTimeIn.format(context),
                  selectedTimeOut.format(context),
                  widget.docid);
            } else {
              if (selectedTimeOut == null) {
                DatabaseService().addVisitor(name, mobileNo, wing, flatno,
                    purpose, selectedTimeIn.format(context), '');
              } else {
                DatabaseService().addVisitor(
                  name,
                  mobileNo,
                  wing,
                  flatno,
                  purpose,
                  selectedTimeIn.format(context),
                  selectedTimeOut.format(context),
                );
              }
            }

            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
