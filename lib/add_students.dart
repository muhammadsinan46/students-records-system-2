// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studentrecords/main.dart';
import 'package:studentrecords/student_helper.dart';
import 'package:studentrecords/student_model.dart';

class AddStudent extends StatelessWidget {
  AddStudent(
      {super.key, required this.isEdit, this.index, this.id, this.stdrecords});
  int? index;
  int? id;
  bool isEdit = false;
  Student? stdrecords;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final dataHelper = Provider.of<StudentHelper>(context, listen: false);
        dataHelper.proImage = null;
    if (isEdit) {
      dataHelper.gen = stdrecords!.gender;
      dataHelper.dom = stdrecords!.batch;
      nameController.text = stdrecords!.name;
      ageController.text = stdrecords!.age;
      emailController.text = stdrecords!.email;
      dataHelper.proImage = File(stdrecords!.profile);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Consumer<StudentHelper>(
        builder: (context, values, child) => SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 200,
                    width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async {
                          final profileImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          File imagePath = File(profileImage!.path);
                          values.getImage(imagePath);
                        },
                        child: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          height: 150,
                          width: 150,
                          child: values.proImage != null
                              ? Image.file(
                                  values.proImage!,
                                  fit: BoxFit.fill,
                                )
                              : const Icon(
                                  Icons.person_add,
                                  size: 70,
                                ),
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'full name',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromRGBO(53, 136, 200, 1)),
                            borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.length > 2||value.isEmpty) {
                        return 'enter valid age ';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    decoration: InputDecoration(
                        hintText: 'age',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromRGBO(53, 136, 200, 1)),
                            borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "gender",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0)),
                    height: 180,
                    width: double.maxFinite,
                    child: ListView.builder(
                        itemCount: gendrList.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            title: Text(gendrList[index]),
                            value: gendrList[index],
                            groupValue: values.gen,
                            onChanged: (value) {
                              values.getGender(value!.toString());
                            },
                          );
                        }),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter your domain';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'domain',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(53, 136, 200, 1)),
                              borderRadius: BorderRadius.circular(10.0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0))),
                      items: domainList.map((String domain) {
                        return DropdownMenuItem(
                            value: domain, child: Text(domain));
                      }).toList(),
                      onChanged: (String? domain) {
                        values.getDomain(domain!);
                      }),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "please enter valid email",
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'email',
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()&& values.proImage!=null) {
                          _formKey.currentState!.save();

                          if (isEdit) {
                            stdrecords!.name = nameController.text;
                            stdrecords!.age = ageController.text;
                            stdrecords!.gender = values.gen!;
                            stdrecords!.batch = values.dom!;
                            stdrecords!.email = emailController.text;
                            stdrecords!.profile = values.proImage!.path;

                            final updateBox =
                                await Hive.openBox<Student>(hiveStudent);
                            await updateBox.put(id, stdrecords!);
                            stdList.notifyListeners();
                          } else {
                            addToList(
                                name: nameController.text,
                                age: ageController.text,
                                gender: values.gen!,
                                batch: values.dom!,
                                email: emailController.text,
                                profile: values.proImage!.path);
                          }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated successfully")));
                          values.proImage = null;
                          Navigator.of(context).pop();
                        } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill out the form")));
                        }
                      },
                      child: const Text("Save"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addToList({
    required String name,
    required String age,
    required String gender,
    required String batch,
    required String profile,
    required String email,
  }) async {
    final value = Student(name, age, gender, batch, profile, email, -1);
    await StudentHelper().onSave(value);
  }
}
