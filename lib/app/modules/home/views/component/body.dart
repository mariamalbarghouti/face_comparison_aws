import 'dart:io';

import 'package:faceid/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBody extends GetView<HomeController> {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      children: [
        // Faces
        Row(children: [
          Expanded(
            child: GetBuilder<HomeController>(
                id: "image",
                builder: (controller) {
                  return Container(
                    height: 300,
                    color: const Color.fromARGB(255, 245, 65, 143),
                    child: (controller.image != null)
                        ? Image.file(File(controller.image?.path ?? ""))
                        : IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () async =>
                                await controller.fetchImage(),
                          ),
                  );
                }),
          ),
          // Spacer(),
          const SizedBox(width: 10),
          Expanded(
            child: GetBuilder<HomeController>(
                id: "photo",
                builder: (controller) {
                  return Container(
                    height: 300,
                    color: const Color.fromARGB(255, 245, 65, 143),
                    child: (controller.photo != null)
                        ? Image.file(File(controller.photo?.path ?? ""))
                        : IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () async =>
                                await controller.fetchPhotoToBeCompared(),
                          ),
                  );
                }),
          ),
        ]),
        // Button
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async => await controller.compareFaces(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.teal,
                  ),
                ),
                child: GetBuilder<HomeController>(
                  id:"compare",
                  builder: (controller) {
                    return (controller.isCompareButtonClicked)
                        ? Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Compare Faces');
                  }
                ),
              ),
              const SizedBox(height: 16),
              GetBuilder<HomeController>(
                  id: "similarity",
                  builder: (controller) {
                    return Row(
                      children: [
                        Text('Similarity: ${controller.similarity}%'),
                        if (controller.isSamePerson==true)
                          Icon(
                            Icons.check,
                            color: Colors.green[200],
                          ),
                        if (controller.isSamePerson == false)
                          Icon(
                            Icons.close,
                            color: Colors.red[200],
                          ),
                      ],
                    );
                  }),
              GetBuilder<HomeController>(
                  id: "clear",
                  builder: (controller) {
                    return TextButton(
                      onPressed: () async => await controller.clear(),
                      child: const Text(
                        "Clear",
                        style: TextStyle(color: Colors.teal),
                      ),
                    );
                  }),
            ]),
          ),
        ),
      ],
    );
  }
}
