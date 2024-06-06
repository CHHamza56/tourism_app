// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_single_cascade_in_expression_statements, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class file_picker extends StatefulWidget {
  const file_picker({super.key});

  @override
  State<file_picker> createState() => _file_pickerState();
}

class _file_pickerState extends State<file_picker> {
  messag() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Image Uploaded',
      desc: '.........Image is Uploaded..........',
      // btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

  bool btn = true;
  TextEditingController name = TextEditingController();
  PlatformFile? pickedFile;
  Future file_pick() async {
    print("click");
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
      print(pickedFile!.name);
      print(pickedFile!.size / 1024);
    }
  }

  Future uploadFile() async {
    setState(() {
      btn = false;
    });
    print(btn);
    final uri =
        Uri.parse("https://learnadvice.000webhostapp.com/upload_image.php");
    var request = http.MultipartRequest('POST', uri);

    // Assuming 'name' is a TextEditingController
    request.fields['name'] = name.text;

    // Assuming 'pickedFile' is a File object obtained using an image picker
    var pic = await http.MultipartFile.fromPath('image', pickedFile!.path!);
    request.files.add(pic);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Convert the response to a JSON format
        var jsonResponse = await response.stream.bytesToString();
        var data = json.decode(jsonResponse);

        // Check the 'Success' field in the JSON data
        if (data["Success"]) {
          print("Image uploaded successfully");
          messag();
        } else {
          setState(() {
            btn = true;
          });
          print("Image upload failed");
        }
      } else {
        setState(() {
          btn = true;
        });
        print("network error");
        print("HTTP request failed. Status code: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        btn = true;
      });
      print("Error uploading image: $error");
    }
    setState(() {
      btn = true;
    });
    print(btn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Text(
                "Welcome to the app",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "File Picker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 31, 31, 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pick the file",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    file_pick();
                  },
                  child: Container(
                    width: 60,
                    height: 30,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 60, 45, 45)),
                    child: Icon(
                      Icons.file_upload,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: 220,
              height: 30,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color.fromARGB(255, 60, 45, 45)),
              child: Center(
                child: Text(
                  pickedFile == null ? "" : pickedFile!.name,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            // Container(
            //   child: Image.file(
            //     (File(pickedFile!.path!)),
            //   ),
            // ),
            Container(
              width: 220,
              child: TextFormField(
                controller: name,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    // style: TextStyle(color: Colors.pinkAccent),

                    fillColor: Colors.white,
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter your name",

                    // focusColor: Colors.white,
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 133, 132, 132))),
              ),
            ),
            btn
                ? GestureDetector(
                    onTap: () {
                      uploadFile();
                    },
                    child: Container(
                      width: 220,
                      height: 30,
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromARGB(255, 60, 45, 45)),
                      child: Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white), // Customizing color
                          strokeWidth: 5.0, // Customizing stroke width
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
