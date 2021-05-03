import 'package:cowin/function.dart';
import 'package:flutter/material.dart';

class StateSelect extends StatefulWidget {
  @override
  _StateSelectState createState() => _StateSelectState();
}

var stateindex;
var cityindex;
var disName;
var disId;
int flag = 0;

class _StateSelectState extends State<StateSelect> {
  String dropdownValue;
  String dropdownDis;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cowin tracker (18-45)"),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              );
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: DropdownButton<String>(
                        hint: Text("State"),
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) async {
                          setState(() {
                            stateindex = (snapshot.data.indexOf(newValue));
                            dropdownValue = newValue;
                          });
                          var x =
                              await fetchCowinDistrict(stateindex.toString());
                          disName = x[0];
                          disId = x[1];
                          flag = 1;
                        },
                        items: snapshot.data
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    flag == 1
                        ? DropdownButton<String>(
                            hint: Text(dropdownDis),
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValues) {
                              setState(() {
                                // cityindex = (x[0].indexOf(newValue));
                                dropdownDis = newValues;
                              });
                              int i = 0;
                              for (var item in disName) {
                                if (dropdownDis == item) {
                                  cityindex = disId[i];
                                  break;
                                }
                                i++;
                              }
                            },
                            items: disName
                                .map<DropdownMenuItem<String>>((String values) {
                              return DropdownMenuItem<String>(
                                value: values,
                                child: Text(values),
                              );
                            }).toList(),
                          )
                        : Container(),
                    ElevatedButton(
                        onPressed: () {
                          if (cityindex != null)
                            Navigator.pushNamed(context, "/tracker",
                                arguments: cityindex);
                        },
                        child: Text("Confirm the selections")),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: fetchCowinStates(),
      ),
    );
  }
}
