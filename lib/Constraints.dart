import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Color Regbg=const Color.fromRGBO(12, 12, 12, 1);
Color Regcon= const Color.fromRGBO(40, 40, 40, 1);
Color RegText= const Color.fromRGBO(179, 179, 179, 1);
double heading = 25;
double range=5;
String university_filter="";
String college_filter="";
String course_filter="";
String branch_filter="";
String year_filter="";
String section_filter="";
String subject_filter = '';
int all=0;
Position tecloc= Position.fromMap({'latitude': 0.0, 'longitude': 0.0});
Map<String,dynamic> usermodel={};

bool upload_marks=true;