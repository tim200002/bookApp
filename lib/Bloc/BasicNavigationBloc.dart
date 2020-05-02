//This Bloc ist there to Handle the Main Screen so at the beginnning overview and Detail, later evtl. stats
//Subroutehandling happends via Navigator.push()
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavigationEvents{}

class NavigateToMainScreen extends NavigationEvents{}

class NavigateToListScreen extends NavigationEvents{}

abstract class NavigationStates{}

class StateMainScreen extends NavigationStates{}

class StateListScreen extends NavigationStates{}

class BasicNavigationBloc extends Bloc<NavigationEvents,NavigationStates>{
  @override
  NavigationStates get initialState=>StateListScreen();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async*{
    if (event is NavigateToMainScreen){
      yield StateMainScreen();
    }
    else if(event is NavigateToListScreen){
      yield StateListScreen();
    }
  }
}