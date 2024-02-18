
// capitalize string function
import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String sanitizedPath = imagePath.trim().replaceAll(RegExp(r'^"|"$'), '');
  if (sanitizedPath.startsWith("http")) {
    return sanitizedPath;
  } else {
    String finalUrl = '${apiDomain().imageDomain}/$sanitizedPath';
    print('image: $finalUrl');
    return finalUrl;
  }
}

// launch caller
Future<void> launchCaller(String number) async {
  var url = Uri(scheme: 'tel', path: number);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

// launch url
Future<void> mlaunchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
    throw 'can not launch $uri';
  }
}

