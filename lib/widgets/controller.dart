import 'package:get/get.dart';


class UIController extends GetxController {

  var containerHeight = 60.0.obs;


  void changeContainerHeight(RxDouble value) {
    containerHeight.value = value.value;
  }

}