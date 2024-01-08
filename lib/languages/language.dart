import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'appName': 'Errandia',
          'Business': 'Business',
          'Update Buiseness Location':'Update Buiseness Location',
          'Edit Profile': 'Edit Profile'
        },
        'fr_CA': {
          'appName': 'Errandia',
          'Business': 'Entreprise',
          'Update Buiseness Location':'Mettre à jour l\'emplacement de l\'entreprise'
        },
      };
}
