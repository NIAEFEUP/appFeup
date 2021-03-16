import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

/// Returns the current balance of the account.
///
/// The balance of the account is returned in 
/// String format followed by ' €'.
Future<String> getPrintsBalance(http.Response response) async {
  final document = parse(response.body);

  final String balanceString =
      document.querySelector('div#conteudoinner > .info').text;

  final String balance = balanceString.split(': ')[1];

  return balance;
}
