import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'general_page_view.dart';

/// TODO: CHANGE THIS DOC
/// Generic class implementation for the user's personal page view.
abstract class UnnamedPageView extends GeneralPageViewState {
  @override
  getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: this.refreshState(context, body),
    );
  }
}
