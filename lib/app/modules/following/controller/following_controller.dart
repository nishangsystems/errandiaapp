import 'package:errandia/app/modules/following/model/following_model.dart';
import 'package:get/get.dart';

class following_controller extends GetxController{
  RxInt selectedCounter =0.obs;
  RxList<following_model> following_list=<following_model>[
    following_model(
      isSelected: false,
      location: 'Malingo Junction, Molyko - Bu',
      name: 'Nishang Systems',
      picurl: 'assets/images/featured_buiseness_icon/nishang.png',
      button_is_open: false,
    ),

    following_model(
      isSelected: false,
      location: 'Malingo Junction, Molyko - Bu',
      name: 'Yara Food Mall',
      picurl: 'assets/images/featured_buiseness_icon/plumbing.png',
      button_is_open: false,
    ),
    following_model(
      isSelected: false,
      location: 'Malingo Junction, Molyko - Bu',
      name: 'The Mechanic shop',
      picurl: 'assets/images/featured_buiseness_icon/mechanic.png',
      button_is_open: false,
    ),
    following_model(
      isSelected: false,
      location: 'Malingo Junction, Molyko - Bu',
      name: 'The Barber Shop Systems',
      picurl: 'assets/images/featured_buiseness_icon/barber.png',
      button_is_open: false,
    ),
    
  ].obs;
}