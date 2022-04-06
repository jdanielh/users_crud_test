
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_crud_test/bloc/users_bloc.dart';

import '../models/user.dart';



class UsersSCreen extends StatefulWidget {
  const UsersSCreen({Key? key}) : super(key: key);


  @override
  State<UsersSCreen> createState() => _UsersSCreenState();
}

class _UsersSCreenState extends State<UsersSCreen> {
  UsersBloc? _usersBloc;

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<UsersBloc>(context, listen: false ).add(GetUsersFromApi());
    _usersBloc = BlocProvider.of<UsersBloc>(context, listen: false );
    super.initState();
  }
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text("Usuarios de Api"),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (_ , UsersState state) {
          if (state is UsersApiLoadState) {
            if (state.usersapi.isEmpty) {
              return const Center(
                child: Text('Sin Usuarios'),
              );
            }
            return ListView.builder(
              itemCount: state.usersapi.length,
              itemBuilder: (BuildContext context,int index){
                  return SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(state.usersapi[index].avatar),
            ),
            Text(
              state.usersapi[index].firstName,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              state.usersapi[index].lastName,
              style: TextStyle(
                fontFamily: 'Source Sans Pro',
                color: Colors.teal.shade100,
                fontSize: 20.0,
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
              width: 150.0,
              child: Divider(
                color: Colors.teal.shade100,
              ),
            ),
            Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading:const  Icon(
                    Icons.phone,
                    color: Colors.teal,
                  ),
                  title: Text(
                    '+44 123 456 789',
                    style: TextStyle(
                      color: Colors.teal.shade900,
                      fontFamily: 'Source Sans Pro',
                      fontSize: 20.0,
                    ),
                  ),
                )),
            Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.email,
                    color: Colors.teal,
                  ),
                  title: Text(
                    state.usersapi[index].email,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.teal.shade900,
                        fontFamily: 'Source Sans Pro'),
                  ),
                ))
          ],
        )
    );
              }
            );
          }

          return Dialog(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 CircularProgressIndicator(),
                 Text("Cargando")
              ],
            ),
          );
        }
      ),
    );
  }

 
}







