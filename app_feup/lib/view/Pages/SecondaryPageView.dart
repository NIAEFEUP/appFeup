import 'package:flutter/material.dart';
import 'GeneralPageView.dart';
import 'package:uni/view/Widgets/SecondaryPageBackButton.dart';

abstract class SecondaryPageViewState extends GeneralPageViewState{

  @override
  Widget build(BuildContext context) {
    return this.getScaffold(
        context,
        this.bodyWrapper(context)
    );
  }

  Widget bodyWrapper(BuildContext context){
    return new SecondaryPageBackButton(
        context: context,
        child: this.getBody(context)
    );
  }
}