// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentrecords/student_helper.dart';
import 'package:studentrecords/student_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class ProfileScreen extends StatelessWidget {
final Student stdrecords;
final int index;
final int id;
    ProfileScreen({
    Key?key,
    required this.stdrecords,
    required this.index,
    required this.id


  }):super(key: key);
       var nameController = TextEditingController();
    var ageController = TextEditingController();
    var emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
      final dataHelper = Provider.of<StudentHelper>(context, listen: false);
      dataHelper.gen = stdrecords.gender;
      dataHelper.dom =stdrecords.batch;
      nameController.text =  stdrecords.name;
     ageController.text = stdrecords.age;
     emailController.text = stdrecords.email;
     dataHelper.proImage = File(stdrecords.profile);
    return Consumer<StudentHelper>(
      
      
      builder: (context, values, child) {
        return  Scaffold(
        appBar: AppBar(
          title: const Text('PROFILE'),
        ),
        body: Card(
          color: const Color.fromARGB(255, 217, 235, 233),
          margin: const EdgeInsets.all(12),
          child:  ListView(
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
                        dataHelper.getImage(imagePath);
                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        height: 150,
                        width: 150,
                        child: dataHelper.proImage != null
                            ? Image.file(
                                dataHelper.proImage!,
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
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: "full name",
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Color.fromRGBO(53, 136, 200, 1)),
                          borderRadius: BorderRadius.circular(10.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  decoration: InputDecoration(
                      hintText: 'age',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Color.fromRGBO(53, 136, 200, 1)),
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
                            dataHelper.getGender(value!.toString());
                          },
                        );
                      }),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value:domainList[index] ,
                    decoration: InputDecoration(
                       
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromRGBO(53, 136, 200, 1)),
                            borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0))),
                    items: domainList.map((String domain) {
                      return DropdownMenuItem(
                          value: domain, child: Text(domain));
                    }).toList(),
                    onChanged: (String? domain) {
                      dataHelper.getDomain(domain!);
                    }),
                const SizedBox(height: 10),
                TextField(
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
                    onPressed: () {
                      updateList(
                          name: nameController.text,
                          age: ageController.text,
                          gender: values.gen!,
                          batch: values.dom!,
                          email: emailController.text,
                          profile: values.proImage!.path);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Save"))
              ],
            ),
        ),
      );
      },
    
    );
  }
    updateList({
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
