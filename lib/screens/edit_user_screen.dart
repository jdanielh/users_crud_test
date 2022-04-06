import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:users_crud_test/bloc/users_bloc.dart';
import 'package:users_crud_test/models/user.dart';

class EditUserScreen extends StatefulWidget {
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _controller;
 
   UsersBloc? _usersBloc;
  // Note args;

  String? name;
  DateTime? selectedDate;
  String? selectedValue;
  String? formattedDate;
  int? currentUserId;
  
  @override
  void initState() {
    super.initState();
    _usersBloc = BlocProvider.of<UsersBloc>(context, listen: false );

    _controller = TextEditingController(text: _usersBloc!.userName);
      selectedValue = _usersBloc!.userSex.toString();
      currentUserId = _usersBloc!.userId;

    selectedDate = _usersBloc!.userBirthday;



    setState(() {});
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Mujer"),value: "0"),
      const DropdownMenuItem(child: Text("Hombre"),value: "1"),

    ];
    return menuItems;
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!, // Refer step 1
      firstDate: DateTime(1980),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
    }
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
              title: const Text('Editar Usuario'),
            ),
        body: Form(
        key: _formKey,
        child: Column(
          children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(  
                icon: Icon(Icons.person),  
                hintText: 'Escribe tu nombre',  
                labelText: 'Name',  
              ), 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Es obligatorio el nombre';
                  }
                  return null;
                },
              ),
              DropdownButton(
                icon: const Icon(Icons.man),
                value: selectedValue,
                onChanged: (String? newValue){
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems
              ),
              Text(
                "${selectedDate?.toLocal()}".split(' ')[0],
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context), // Refer step 3
                child: const Text(
                  'Cambiar Fecha de nacimiento',
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
             
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                 setState(() {
                   
                 });

                  // User user = User(id: currentUserId, dateOfBirth: AddUserToDBEvent(DateFormat('yyyy-MM-dd').format(selectedDate!),   name: _controller!.text, sex: int.parse(selectedValue!));
                
                  var dateFormatter = DateFormat('yyyy-MM-dd');
                  String formattedDate = dateFormatter.format(selectedDate!);
                  User user = User(name: _controller!.text, sex: int.parse(selectedValue!), dateOfBirth: formattedDate, id: currentUserId );
                  // print(user);
                    _usersBloc!.add(UpdateUserFromDBEvent(user));
                    _usersBloc!.add(GetUsersFromDBEvent());
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Actualizar'),
              ),
            ),
          ],
        ),
      ));
  }
}
