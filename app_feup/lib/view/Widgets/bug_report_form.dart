import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:uni/view/Widgets/form_text_field.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/view/Widgets/toast_message.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart' show rootBundle;

class BugReportForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BugReportFormState();
  }
}

/// Manages the 'Bugs and Suggestions' section of the app
class BugReportFormState extends State<BugReportForm> {
  final String _postUrl =
      'https://api.github.com/repos/NIAEFEUP/project-schrodinger/issues';
  final String _issueLabel = 'In-app bug report';

  static final _formKey = GlobalKey<FormState>();

  final Map<int, Tuple2<String, String>> bugDescriptions = {
    0: Tuple2<String, String>('Detalhe visual', 'Visual detail'),
    1: Tuple2<String, String>('Erro', 'Error'),
    2: Tuple2<String, String>('Sugestão de funcionalidade', 'Suggestion'),
    3: Tuple2<String, String>(
        'Comportamento inesperado', 'Unexpected behaviour'),
    4: Tuple2<String, String>('Outro', 'Other'),
  };
  List<DropdownMenuItem<int>> bugList = [];

  static int _selectedBug = 0;
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController descriptionController =
      TextEditingController();

  String ghToken = '';

  bool _isButtonTapped = false;

  BugReportFormState() {
    if (ghToken == '') loadGHKey();
    loadBugClassList();
  }

  void loadBugClassList() {
    bugList = [];

    bugDescriptions.forEach((int key, Tuple2<String, String> tup) =>
        {bugList.add(DropdownMenuItem(child: Text(tup.item1), value: key))});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, child: ListView(children: getFormWidget(context)));
  }

  List<Widget> getFormWidget(BuildContext context) {
    final List<Widget> formWidget = [];

    formWidget.add(bugReportTitle(context));
    formWidget.add(bugReportIntro(context));
    formWidget.add(dropdownBugSelectWidget(context));
    formWidget.add(FormTextField(
      titleController,
      Icons.title,
      minLines: 1,
      maxLines: 2,
      description: 'Título',
      labelText: 'Breve identificação do problema',
      bottomMargin: 30.0,
    ));

    formWidget.add(FormTextField(
      descriptionController,
      Icons.description,
      minLines: 1,
      maxLines: 30,
      description: 'Descrição',
      labelText: 'Bug encontrado, como o reproduzir, etc',
      bottomMargin: 30.0,
    ));

    formWidget.add(submitButton(context));

    return formWidget;
  }

  /// Returns a widget for the title of the bug report form
  Widget bugReportTitle(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Row(
          children: <Widget>[
            Icon(Icons.bug_report,
                color: Theme.of(context).accentColor, size: 50.0),
            Expanded(
                child: Text(
              'Bugs e Sugestões',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            )),
            Icon(Icons.bug_report,
                color: Theme.of(context).accentColor, size: 50.0),
          ],
        ));
  }

  /// Returns a widget for the overview text of the bug report form
  Widget bugReportIntro(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      padding: EdgeInsets.only(bottom: 20),
      child: Center(
        child: Text('''Encontraste algum Bug na aplicação?\nTens alguma
             sugestão para a app?\nConta-nos para que nós possamos melhorar!''',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center),
      ),
    );
  }

  /// Returns a widget for the dropdown displayed when the user tries to choose
  /// the type of bug on the form
  Widget dropdownBugSelectWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Seleciona o tipo de ocorrência',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.bug_report,
                  color: Theme.of(context).accentColor,
                )),
            Expanded(
                child: DropdownButton(
              hint: Text('Seleciona o tipo de ocorrência'),
              items: bugList,
              value: _selectedBug,
              onChanged: (value) {
                setState(() {
                  _selectedBug = value;
                });
              },
              isExpanded: true,
            ))
          ])
        ],
      ),
    );
  }

  /// Returns a widget for the button to send the bug report
  Widget submitButton(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate() && !_isButtonTapped) {
            submitBugReport();
          }
        },
        child: Text('Enviar'),
      ),
    );
  }

  /// Submits the user's bug report
  ///
  /// If unsuccessful, the user receives an error message
  void submitBugReport() {
    setState(() {
      _isButtonTapped = true;
    });

    final String bugLabel = bugDescriptions[_selectedBug] == null
        ? 'Unidentified bug'
        : bugDescriptions[_selectedBug].item2;
    final Map data = {
      'headline6': titleController.text,
      'body': descriptionController.text,
      'labels': [_issueLabel, bugLabel]
    };

    final url = _postUrl;
    http
        .post(url.toUri(),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $ghToken'
            },
            body: json.encode(data))
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      String msg;
      if (statusCode < 200 || statusCode > 400) {
        Logger().e('Error ' + statusCode.toString() + ' while posting bug');
        msg = 'Ocorreu um erro no envio';
      } else {
        Logger().i('Successfully submitted bug report.');
        msg = 'Enviado com sucesso';

        clearForm();

        Navigator.pop(context);
        setState(() {
          _isButtonTapped = false;
        });
      }

      FocusScope.of(context).requestFocus(FocusNode());
      ToastMessage.display(context, msg);
      setState(() {
        _isButtonTapped = false;
      });
    }).catchError((error) {
      Logger().e(error);
      FocusScope.of(context).requestFocus(FocusNode());

      final String msg =
          (error is SocketException) ? 'Falha de rede' : 'Ocorreu um erro';
      ToastMessage.display(context, msg);
      setState(() {
        _isButtonTapped = false;
      });
    });
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();

    setState(() {
      _selectedBug = 0;
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  void loadGHKey() async {
    final Map<String, dynamic> dataMap =
        await parseJsonFromAssets('assets/env/env.json');
    this.ghToken = dataMap['gh_token'];
  }
}
