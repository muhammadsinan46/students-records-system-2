import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class Student{

  @HiveField(0)
   String name;
    @HiveField(1)
   String age;
    @HiveField(2)
   String batch;
    @HiveField(3)
   String gender;
    @HiveField(4)
   String profile;
      @HiveField(5)
   int id;
      @HiveField(6)
       String email;


 Student(this.name, this.age, this.batch, this.gender, this.profile, this.email, this.id);
}