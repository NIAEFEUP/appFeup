import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

/// Returns the current fees balance of the account.
///
/// The fees `balance` of the account is returned in 
/// String format followed by ' €'.
Future<String> parseFeesBalance(http.Response response) async {
  final document = parse(response.body);

  final String balanceString =
      document.querySelector('span#span_saldo_total').text;

  final String balance = balanceString + ' €';

  return balance;
}

/// Returns the current balance of the account.
///
/// If the table from which the parsing is done
/// has only one `line` (there is no fee), the String 
/// 'Sem data' is returned.
Future<String> parseFeesNextLimit(http.Response response) async {
  final document = parse(response.body);

  final lines = document.querySelectorAll('#tab0 .tabela tr');

  if (lines.length < 2) {
    return 'Sem data';
  }
  final String limit = lines[1].querySelectorAll('.data')[1].text;

  return limit;
}
