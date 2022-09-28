import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as File;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class Utility {
  static Future<String> ImageString(String imgUrl, String imageId) async {
    final url = Uri.parse(imgUrl);
    final response = await http.get(url);
    final bytes = response.bodyBytes;
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/$imageId.jpg';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File.File file = new File.File(filePathAndName); // <-- 2
    file.writeAsBytesSync(bytes);
    print(file);
    return file.path;
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
