import 'package:example_formfield/base_object.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown_form_field.dart';

const List<BaseObject> mdTypesList = [
  BaseObject(id: 1, name: 'SomeObject #0'),
  BaseObject(id: 2, name: 'SomeObject #1'),
  BaseObject(id: 4, name: 'SomeObject #2'),
  BaseObject(id: 5, name: 'SomeObject #3'),
  BaseObject(id: 6, name: 'SomeObject #4'),
  BaseObject(id: 8, name: 'SomeObject #5'),
];

class ObjectData {
  String mdFactoryNumber = '5366-75';
  BaseObject mdDefaultType = mdTypesList[3];
  BaseObject mdInitType = mdTypesList[5];

  String consumerName = 'Ivan Ivanov';
  String consumerAccountNumber = '123234456';
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ObjectEdit(title: 'Search Dropdown FormField Demo'),
    );
  }
}

class ObjectEdit extends StatefulWidget {
  ObjectEdit({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ObjectEditState createState() => _ObjectEditState();
}

class _ObjectEditState extends State<ObjectEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autovalidate = false;

  ObjectData objectData = ObjectData();

  void _handleSave() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      print('Please fix the errors in red before submitting.');
    } else {
      form.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            //padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Text(
                    'DROPDOWN',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(thickness: 2.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      DropdownButtonFormField<BaseObject>(
                        decoration: InputDecoration(
                          labelText: 'DEFAULT Dropdown',
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                        ).applyDefaults(Theme.of(context).inputDecorationTheme),
                        items: mdTypesList.map<DropdownMenuItem<BaseObject>>(
                            (BaseObject item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.name),
                          );
                        }).toList(),
                        value: objectData.mdInitType,
                        onChanged: (value) => print('Value changed to $value'),
                        onSaved: (value) {
                          print('DEFAULT = $value');
                        },
                      ),
                      const SizedBox(height: 12.0),
                      SearchDropdownFormFieldCustom(
                        labelText: 'SEARCHABLE Dropdown',
                        searchTitle: Text(
                          'Справочник "Приборы учета"',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                        items: mdTypesList,
                        defaultValue: objectData.mdDefaultType,
                        initialValue: objectData.mdInitType,
                        onChanged: (value) => print('Value changed to $value'),
                        onSaved: (value) {
                          print('SEARCH = $value');
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: const Text('SUBMIT'),
                    onPressed: _handleSave,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
