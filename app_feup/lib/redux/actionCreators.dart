import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../model/AppState.dart';
import 'actions.dart';
import 'package:redux/redux.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/LoginPageModel.dart';

ThunkAction<AppState> login(username, password, faculty, persistentSession) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new SetLoginStatusAction(LoginStatus.BUSY));
      final Map<String, dynamic> session = await NetworkRouter.login(username, password, faculty, persistentSession);
      print(session);
      store.dispatch(new SaveLoginDataAction(session));
      if (session['authenticated']){
        store.dispatch(getUserExams());
        store.dispatch(new SetLoginStatusAction(LoginStatus.SUCCESSFUL));
      } else {
        store.dispatch(new SetLoginStatusAction(LoginStatus.FAILED));
      }
    } catch (e) {
      store.dispatch(new SetLoginStatusAction(LoginStatus.FAILED));
    }
  };
}

ThunkAction<AppState> fetchProfile() {
  return (Store<AppState> store) async {
    try {
      final Map<String, dynamic> profile = await NetworkRouter.getProfile(store.state.content['session']);
      print(profile); //just to supress warning for now
    } catch (e) {
      print(e);
    }
  };
}

ThunkAction<AppState> getUserExams() {
  return (Store<AppState> store) async {
    //need to get student course here

    List<Exam> exams = await examsGet("https://sigarra.up.pt/feup/pt/exa_geral.mapa_de_exames?p_curso_id=742");

    store.dispatch(new SetExamsAction(exams));
  };
}

ThunkAction<AppState> getUserSchedule() {
  return (Store<AppState> store) async {
    //need to get student schedule here

//    List<Lecture> lectures = await scheduleGet("");    TODO Later when login works

    List<Lecture> lectures = new List();

    lectures.add(new Lecture("SOPE", "TP", 0, "14:00", 4, "B310", "FHFC"));
    lectures.add(new Lecture("BDAD", "TE", 0, "17:00", 2, "B001", "CTL"));
    lectures.add(new Lecture("BDAD", "TP", 0, "18:00", 4, "B301", "JPMM"));

    lectures.add(new Lecture("LPOO", "TE", 1, "16:00", 4, "B022", "AOR"));

    lectures.add(new Lecture("CAL", "TE", 2, "08:30", 2, "B001", "RR"));
    lectures.add(new Lecture("BDAD", "TE", 2, "09:30", 2, "B001", "CTL"));
    lectures.add(new Lecture("SOPE", "TE", 2, "10:30", 2, "B001", "JAS"));
    lectures.add(new Lecture("CGRA", "TP", 2, "11:30", 4, "B310", "AFCC"));

    lectures.add(new Lecture("LPOO", "TP", 3, "14:00", 6, "B203", "FFC"));
    lectures.add(new Lecture("SOPE", "TE", 3, "17:00", 2, "B001", "JAS"));

    lectures.add(new Lecture("CGRA", "TE", 4, "14:00", 4, "B003", "AAS"));
    lectures.add(new Lecture("CAL", "TE", 4, "16:00", 2, "B003", "RR"));
    lectures.add(new Lecture("CAL", "TP", 4, "17:00", 4, "B107", "LFT"));

    store.dispatch(new SetScheduleAction(lectures));
  };
}

ThunkAction<AppState> updateSelectedPage(new_page) {
  return (Store<AppState> store) async {
    store.dispatch(new UpdateSelectedPageAction(new_page));
  };
}