import 'package:app_feup/controller/homePage.dart';
import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../widgets/ExamCard.dart';
import 'ProfilePageView.dart';
import '../widgets/NavigationDrawer.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key, @required store}) : super(key: key) {
        loadUserInfoToState(store);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Área Pessoal", textAlign: TextAlign.start),
        actions: <Widget>[
          FlatButton(
            onPressed: () => {Navigator.pushReplacement(context,new MaterialPageRoute(builder: (__) => new ProfilePageView()))},
            child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://dei.fe.up.pt/gig/wp-content/uploads/sites/4/2017/02/AAS_Jorn-1.jpg")
                  )
                )
              ),
          ),
        ],),
      drawer: new NavigationDrawer(),
      body: createScrollableCardView(context),
      floatingActionButton: createActionButton(context),
    );
  }

  Widget createActionButton(BuildContext context){
    return new FloatingActionButton(
      onPressed: () => {}, //Add FAB functionality here
      tooltip: 'Add widget',
      child: new Icon(Icons.add),
    );
  }

  Widget createScrollableCardView(BuildContext context){
    return new ListView(

        shrinkWrap: false,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new GenericCard(
            title: "Exames"
            , child: new ExamCard()

          //Cards go here

          )],
      );
  }
}