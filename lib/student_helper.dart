// ignore_for_file: list_remove_unrelated_type

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentrecords/main.dart';
import 'package:studentrecords/student_model.dart';

ValueNotifier<List<Student>> stdList = ValueNotifier<List<Student>>([]);

List<String> gendrList = ["Male", "Female", "Other"];
List<String> domainList = [
  "Flutter",
  "MERN",
  "Python-Djngo",
  "Cyber Security",
  "Data Science",
  "Machine Learning",
  "Java",
  "GO-lang"
];

class StudentHelper extends ChangeNotifier {
  String? gen;
  String? dom;
  String? searchText;
  File? proImage;

  getSearch(String sText) {
    searchText = sText;
    getStudentList();
    notifyListeners();
  }

  getDomain(String domain) {
    dom = domain;

    notifyListeners();
  }

  getImage(File profile) {
    proImage = profile;
    notifyListeners();
  }

  getGender(String gender) {
    gen = gender;
    notifyListeners();
  }

  deleteStudent(int id) async {
    final studentBox = await Hive.openBox<Student>(hiveStudent);
    studentBox.delete(id);
    getStudentList();
  }

  getStudentList() async {
    final studentBox = await Hive.openBox<Student>(hiveStudent);
    final newList = List<Student>.from(studentBox.values);
    stdList.value = newList;
    stdList.notifyListeners();
  }

  onSave(Student value) async {
    final saveBox = await Hive.openBox<Student>(hiveStudent);
    stdList.value.clear();
    final id = await saveBox.add(value);
    final data = saveBox.get(id);

    await saveBox.put(
        id,
        Student(data!.name, data.age, data.gender, data.batch, data.profile,
            data.email, id));
    stdList.value.addAll(saveBox.values);
    stdList.notifyListeners();
  }
}
