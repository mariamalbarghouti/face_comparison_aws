import 'package:faceid/app/modules/home/views/component/body.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Recognition'),
        centerTitle: true,
      ),
      body: const HomeBody(),
    );
  }
}
