
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_crud_test/bloc/users_bloc.dart';

import '../models/user.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UsersBloc? _usersBloc;

  @override
  void initState() {
    setState(() {
      
    });
    // TODO: implement initState
    BlocProvider.of<UsersBloc>(context, listen: false ).add(GetUsersFromDBEvent());
    _usersBloc = BlocProvider.of<UsersBloc>(context, listen: false );
    super.initState();
  }
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Test Users Crud'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/',
                );
              },
            ),
            ListTile(
              title: const Text('Users Api'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'usersapi',
                );
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (_ , UsersState state) {
          if (state is UsersLoadState) {
            if (state.users!.isEmpty) {
              return const Center(
                child: Text('Sin Usuarios'),
              );
            }
            return ListView.builder(
              itemCount: state.users!.length,
              itemBuilder: (BuildContext context,int index){
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(state.users![index].name),
                    subtitle: Text(state.users![index].dateOfBirth),
                    trailing: _buildUpdateDeleteButtons(state.users![index]),
                  );
              }
            );
          }

          // return const Center(
          //   child: Text('Sin Usuarios'),
          // );
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
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context,
              'addUser',
            );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
     
    );
  }

  Row _buildUpdateDeleteButtons(User displayedUser) {
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          color: Colors.orange,
          onPressed: () {
            _usersBloc!.completeFields(displayedUser);
            Navigator.pushNamed(context, 'editUser', arguments: displayedUser);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () {
              showAlertDialog(context, displayedUser);
          },
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, User user) {
  // Create button
  Widget okButton = TextButton(
    // color: Colors.red,
    child: const Text("Eliminar"),
    onPressed: () {
      _usersBloc!.dbProvider.deleteUser(user.id);
      _usersBloc!.add(GetUsersFromDBEvent());
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );

  // Create button
  Widget cancelButton = TextButton(
    child: const Text("Cancelar"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Eliminar usuario"),
    content: const Text("¿Estas seguro que quieres eliminar este usuario?"),
    actions: [cancelButton, okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

}





