import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:users_crud_test/models/user.dart';
import 'package:users_crud_test/models/userapi.dart';
import 'package:users_crud_test/providers/db_provider.dart';

import '../network/network.dart';
import '../network/service.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  DBProvider dbProvider = DBProvider();
  String? userName;
  int? userSex;
  DateTime? userBirthday;
  int? userId;

  Future<void> completeFields(User user) async {
      try {
        userName = user.name;
        userSex = user.sex;
        userBirthday = DateTime.parse(user.dateOfBirth);
        userId = user.id;

      } catch (e) {
        // emit(NotesError('Ocurrio un error inesperado'));
      }
    }


  UsersBloc() : super(const UsersInitialState()) {
    on<GetUsersFromDBEvent>((event, emit) async {
      var users = await dbProvider.users();
      emit(UsersLoadState(users));
    });
    on<AddUserToDBEvent>((event, emit) async {
      var user = User(
        name: event.name,
        sex: event.sex,
        dateOfBirth: event.dateOfBirth
        // dateOfBirth: ${event.dateOfBirth.year.toString().padLeft(4, '0')}-${event.dateOfBirth.month.toString().padLeft(2, '0')}-${event.dateOfBirth.day.toString().padLeft(2, '0')}
      );

      await dbProvider.insertUser(user);
    });
    on<DeleteUserFromDBEvent>((event, emit) async {
      await dbProvider.deleteUser(event.user_id);
    });
    on<UpdateUserFromDBEvent>((event, emit) async {
      var user = event.user;

      await dbProvider.updateUser(user);
    });

    on<GetUsersFromApi>((event, emit) async {
      var response = await Network.get(Service.users);
      print(response.code);

      if (response.code == 200) {
        // List<News> listNews = response.value.cast<News>();
        // print(response.value[0]);
        // List<Datum> listUsers = response.value.map((val) => Datum( id: val['id'], email: val['email'], firstName: val['first_name'], lastName: val['last_name'], avatar: val['avatar'])).toList();
        // List<Datum> listUsers = userApiFromJson(response.value.);
        // UserApi userList = userApiFromJson(response.value["data"]);
        List<Datum> listUsers = List.from(response.value["data"]).map((e) => Datum.fromJson(e)).toList();

        // List<Datum> listUsers = List.from(response.value["data"].map)

        print(listUsers);
        emit(UsersApiLoadState(listUsers));
      } 

    });

    


  }
}
