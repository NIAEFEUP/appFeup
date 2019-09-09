import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BugReportForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BugReportFormState();
  }
}

class BugReportFormState extends State<BugReportForm> {

  static final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<int>> bugList = [];
  int _selectedBug = 0;

  @override
  Widget build(BuildContext context) {
    loadBugClassList();

    return new Form(
      key: _formKey,
      child: new ListView(
          children: getFormWidget(context)
      )
    );
  }


  void loadBugClassList() {
    bugList = [];
    bugList.add(new DropdownMenuItem(
      child: new Text('Mosca'),
      value: 0,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Mosquito'),
      value: 1,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Escaravelho'),
      value: 2,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Aranha'),
      value: 3,
    ));
  }

  List<Widget> getFormWidget(BuildContext context) {
    List<Widget> formWidget = new List();

    formWidget.add(DropdownBugSelectWidget(context));
    formWidget.add(BugDescriptionWidget(context));
    formWidget.add(SubmitButton());

    return formWidget;
  }

  Widget DropdownBugSelectWidget(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 40, top: 20),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'Seleciona o tipo de bug',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          new Row(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.only(right:15),
                  child: new Icon(Icons.bug_report)
                ),
                Expanded(
                    child: new DropdownButton(
                      hint: new Text('Seleciona o tipo de bug'),
                      items: bugList,
                      value: _selectedBug,
                      onChanged: (value) {
                        setState(() {
                          _selectedBug = value;
                        });
                      },
                      isExpanded: true,
                    )
                )
              ]
          )
        ],
      ),

    );
  }

  Widget BugDescriptionWidget(BuildContext context) {
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'Descreve o bug',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          new Row(
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.only(right:15),
                    child: new Icon(Icons.description)
                ),
                Expanded(
                    child: new TextFormField(
                      // margins
                      minLines: 1,
                      maxLines: 30,
                      decoration: const InputDecoration(
                        hintText: 'Descrição do bug encontrado',
                        labelText: 'Descrição',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Descreve lá o bug sefachavor';
                        }
                        return null;
                      },
                    )
                )
              ]
          )
        ],
      ),

    );
  }

  Widget SubmitButton() {
    return new Container(
      margin: new EdgeInsets.only(top: 50),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        onPressed: () {

          if (_formKey.currentState.validate()) {

            

          }
        },
        child: Text(
          'Enviar',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
          ),
        ),
        color: Colors.deepOrange,
      )
    );
  }

}