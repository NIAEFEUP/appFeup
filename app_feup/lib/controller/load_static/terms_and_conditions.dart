import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

/// Returns the content of the Terms and Conditions file.
/// 
/// If this operation is unsuccessful, an error message is returned.
Future<String> readTermsAndConditions() async {
  try {
    return await rootBundle.loadString('assets/text/TermsAndConditions.md');
  } catch (e) {
    return 'Could not load terms and conditions. Please try again later';
  }
}

Future<bool> updateTermsAndConditionsAcceptancePreference() async {
  final hash = await AppSharedPreferences.getTermsAndConditionHash();
  final acceptance = await AppSharedPreferences.areTermsAndConditionsAccepted();
  final termsAndConditions = await readTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  if (hash == null) {
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    return true;
  }

  if (currentHash != hash) {
    await AppSharedPreferences.setTermsAndConditionsAcceptance(false);
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  }

  return currentHash != hash || !acceptance;
}

Future<void> acceptTermsAndConditions() async {
  final termsAndConditions = await readTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  await AppSharedPreferences.setTermsAndConditionsAcceptance(true);
}
