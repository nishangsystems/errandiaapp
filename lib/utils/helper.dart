
// capitalize string function
import 'package:errandia/app/APi/apidomain%20&%20api.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

// capitalize all words in a string
String capitalizeAll(String s) {
  List<String> words = s.split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = capitalize(words[i]);
  }
  return words.join(' ');
}

// get the first letter of a string
String getFirstLetter(String s) => s[0].toUpperCase();

String getImagePath(String imagePath) {
  if (imagePath.startsWith("http")) {
    return imagePath;
  } else {
    print('image: ${apiDomain().imageDomain}/$imagePath');
    return '${apiDomain().imageDomain}/$imagePath';
  }
}