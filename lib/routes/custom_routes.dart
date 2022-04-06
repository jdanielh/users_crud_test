import 'package:flutter/material.dart';
import 'package:users_crud_test/screens/add_user_screen.dart';
import 'package:users_crud_test/screens/edit_user_screen.dart';
import 'package:users_crud_test/screens/users_screen.dart';
import '../screens/home_screen.dart';

var customRoutes = <String, WidgetBuilder>{
 '/': (context) => const HomeScreen(title: 'Users Crud'),
 'addUser': (context) => AddUserScreen(),
 'editUser': (context) => EditUserScreen(),
 'usersapi': (context) => const UsersSCreen(),
};