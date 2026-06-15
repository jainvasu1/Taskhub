import 'package:flutter/material.dart';

ValueNotifier<int> incompleteTaskCount = ValueNotifier<int>(0); 

//its a bridge between home screen and task screen so we can updated the task notifier.