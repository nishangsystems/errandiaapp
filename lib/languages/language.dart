import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'appName': 'Errandia',
          'Business': 'Business',
          'Update Business Location':'Update Business Location',
          'Edit Profile': 'Edit Profile',
          'Update Location': 'Update Location',
        },
        'fr_CA': {
          'appName': 'Errandia',
          'Business': 'Entreprise',
          'Update Business Location':'Mettre à jour la localisation de l\'entreprise',
          'Update Location': 'Mettre à jour la localisation',
        },
      };
}
