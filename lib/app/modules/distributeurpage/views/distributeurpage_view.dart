import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/distributeurpage_controller.dart';

class DistributeurpageView extends GetView<DistributeurpageController> {
  const DistributeurpageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DistributeurpageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DistributeurpageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
