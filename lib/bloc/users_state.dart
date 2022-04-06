part of 'users_bloc.dart';

@immutable
abstract class UsersState {
  final List<User>? users;

  const UsersState({
    this.users
  });
}

class UsersInitialState extends UsersState {
  const UsersInitialState() : super(users: null);
}

class UsersLoadState extends UsersState {
  final List<User> allUsers;

  const UsersLoadState(this.allUsers) : super(users: allUsers);
}

class UsersLoadStateFromApi extends UsersState {
  final List<User> allUsers;

  const UsersLoadStateFromApi(this.allUsers) : super(users: allUsers);
}

class UsersApiLoadState extends UsersState {
  final List<Datum> usersapi;

  const UsersApiLoadState(this.usersapi);
}
