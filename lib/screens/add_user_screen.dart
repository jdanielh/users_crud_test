import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_crud_test/bloc/users_bloc.dart';
import 'package:intl/intl.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  UsersBloc? _usersBloc;
  
  String? name;
  String? dateOfBirth;
  String? sex;
  @override
  void initState() {
    setState(() {
      
    });
     _usersBloc = BlocProvider.of<UsersBloc>(context, listen: false );
    super.initState();
  }
  String selectedValue = "0";
  DateTime selectedDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
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
      initialDate: selectedDate, // Refer step 1
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
      appBar:AppBar(
            centerTitle: true,
              title: const Text('Crear Usuario'),
            ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
              TextFormField(
                controller: nameController,
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
                "${selectedDate.toLocal()}".split(' ')[0],
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
                    _usersBloc!.add(AddUserToDBEvent(DateFormat('yyyy-MM-dd').format(selectedDate), nameController.text, int.parse(selectedValue)));
                    _usersBloc!.add(GetUsersFromDBEvent());
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Crear'),
              ),
            ),
          ],
        ),
      )
    );
  }
}
