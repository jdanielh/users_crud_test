part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUsersFromDBEvent extends UsersEvent {
  // final List<User> users; 

  // GetUsersFromDBEvent(this.users);
}

class AddUserToDBEvent extends UsersEvent {
  final String name; 
  final int sex; 
  final String dateOfBirth; 

  AddUserToDBEvent(this.dateOfBirth, this.name, this.sex);
}


class UpdateUserFromDBEvent extends UsersEvent {
  final User user;

  UpdateUserFromDBEvent(this.user);
}

class DeleteUserFromDBEvent extends UsersEvent {
  final int user_id; 

  DeleteUserFromDBEvent(this.user_id);
}

class GetUsersFromApi extends UsersEvent {
  // final List<Datum> users;
  // GetUsersFromApi(this.users);
}

// class UsersErrorState extends UsersEvent {

// }
