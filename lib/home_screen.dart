// ignore_for_file: must_be_immutable


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studentrecords/add_students.dart';

import 'package:studentrecords/search-Screen.dart';
import 'package:studentrecords/student_helper.dart';
import 'package:studentrecords/student_model.dart';


class HomeScreen extends StatelessWidget {
const  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("STUDENTS RECORDS"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const  SearchScreen()));
            },
          )
        ],
      ),
      body: SizedBox(
          child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: stdList,
            builder: (context, List<Student> studentList, child) {
              return ListView.builder(
                  itemCount: studentList.length,
                  itemBuilder: (context, index) {
                    final student = studentList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddStudent(
                            isEdit: true,
                              stdrecords: student,
                              index: index,
                              id: student.id),
                        ));
                      },
                      child: Card(
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(File(student.profile)),
                            ),
                            title: Text(studentList[index].name),
                            subtitle: Text(studentList[index].batch),
                            trailing: IconButton(
                              onPressed: () {
                                StudentHelper().deleteStudent(student.id);
                              },
                              icon: const Icon(Icons.delete),
                            )),
                      ),
                    );
                  });
            },
          ))
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>  AddStudent(isEdit: false,)));
          },
          child: const Row(children: [Icon(Icons.add), Text("Add Student")]),
        ),
      ),
    );
  }
}
