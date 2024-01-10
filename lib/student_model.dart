import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class Student{

  @HiveField(0)
  final String name;
    @HiveField(1)
  final String age;
    @HiveField(2)
  final String batch;
    @HiveField(3)
  final String gender;
    @HiveField(4)
  final String profile;
      @HiveField(5)
  final int id;
      @HiveField(6)
      final String email;


const Student(this.name, this.age, this.batch, this.gender, this.profile, this.email, this.id);
}