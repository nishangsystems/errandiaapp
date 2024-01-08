import 'package:errandia/app/modules/subscribers/model/subscriber_model.dart';
import 'package:get/get.dart';

class subscriber_controller extends GetxController {
  RxInt selectedCounter = 0.obs;
  void cancel() {
    selectedCounter.value = 0;
    for (int i = 0; i < subscriber_list.length; i++) {
      subscriber_list[i].isSelected = false;
    }
  }

  RxList<subscriber_model> subscriber_list = <subscriber_model>[
    subscriber_model(
      name: 'Dyna Will',
      subscribedDate: '12 Apr 2023',
      msgCounter: 3,
      isSelected: false,
    ),
    subscriber_model(
      name: 'Ezequiel Haag',
      subscribedDate: '20 Apr 2023',
      msgCounter: 6,
      isSelected: false,
    ),
    subscriber_model(
      name: 'Flo Murray',
      subscribedDate: '30 Apr 2023',
      msgCounter: 8,
      isSelected: false,
    ),
    subscriber_model(
      name: 'Dyna Will',
      subscribedDate: '12 Apr 2023',
      msgCounter: 3,
      isSelected: false,
    ),
    subscriber_model(
      name: 'Ezequiel Haag',
      subscribedDate: '20 Apr 2023',
      msgCounter: 6,
      isSelected: false,
    ),
    subscriber_model(
      name: 'Flo Murray',
      subscribedDate: '30 Apr 2023',
      msgCounter: 8,
      isSelected: false,
    ),
  ].obs;
}
