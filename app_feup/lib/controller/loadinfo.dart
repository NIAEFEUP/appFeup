import 'dart:async';
import 'package:app_feup/controller/local_storage/AppSharedPreferences.dart';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';
import 'package:app_feup/redux/actions.dart';
import 'package:tuple/tuple.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:redux/redux.dart';


Future loadUserInfoToState(store) {

  loadLocalUserInfoToState(store);
  return loadRemoteUserInfoToState(store);

}


Future loadRemoteUserInfoToState(Store<AppState> store){
  if(store.state.content['session'] == null){
    return null;
  }
  
  Completer<Null>
  userInfo = new Completer(),
      exams = new Completer(),
      schedule = new Completer(),
      printBalance = new Completer(),
      feesBalance = new Completer(),
      feesLimit = new Completer(),
      coursesStates = new Completer();
  store.dispatch(getUserInfo(userInfo));
  store.dispatch(getUserExams(exams));
  store.dispatch(getUserSchedule(schedule));
  store.dispatch(getUserPrintBalance(printBalance));
  store.dispatch(getUserFeesBalance(feesBalance));
  store.dispatch(getUserFeesNextLimit(feesLimit));
  store.dispatch(getUserCoursesState(coursesStates));
  return Future.wait([exams.future, schedule.future, printBalance.future, feesBalance.future, feesLimit.future, coursesStates.future, userInfo.future]);
}

void loadLocalUserInfoToState(store) async {
  Tuple2<String, String> userPersistentInfo = await AppSharedPreferences.getPersistentUserInfo();
  if(userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
    store.dispatch(updateStateBasedOnLocalUserExams());
    store.dispatch(updateStateBasedOnLocalUserLectures());
    store.dispatch(SetScheduleStatusAction(RequestStatus.SUCCESSFUL));
    store.dispatch(SetExamsStatusAction(RequestStatus.SUCCESSFUL));
  }
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}