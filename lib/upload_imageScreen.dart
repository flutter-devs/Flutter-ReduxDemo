import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux_example/imageView.dart';
import 'package:flutter_redux_example/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File _image;
  bool _uploadInProgress = false;

  Future selectImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (_image != null)
              Flexible(
                flex: 9,
                child: Image.file(_image),
              )
            else
              Flexible(
                flex: 9,
                child: Center(
                  child: Text("No Image Selected"),
                ),
              ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.photo_library),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Select File"),
                      ],
                    ),
                    onPressed: () => selectImage(),
                  ),
                  if (_image != null)
                    Mutation(
                      options: MutationOptions(
                        document: uploadImage,
                      ),
                      builder: (RunMutation runMutation, QueryResult result) {
                        return Material(
                          child: FlatButton(
                            child: _isLoadingInProgress(),
                            onPressed: () {
                              setState(() {
                                _uploadInProgress = true;
                              });

                              var byteData = _image.readAsBytesSync();

                              var multipartFile = MultipartFile.fromBytes(
                                'photo',
                                byteData,
                                filename: '${DateTime.now().second}.jpg',
                                contentType: MediaType("image", "jpg"),
                              );

                              runMutation(<String, dynamic>{
                                "file": multipartFile,
                              });
                            },
                          ),
                        );
                      },
                      onCompleted: (d) {
                        print(d);
                        setState(() {
                          _uploadInProgress = false;
                        });
                      },
                      update: (cache, results) {
                        var message = results.hasErrors
                            ? '${results.errors.join(", ")}'
                            : "Image was uploaded successfully!";

                        if (!results.hasErrors) {
                          setState(() {
                            _image = null;
                          });
                        }
//                        final snackBar = SnackBar(content: Text(message));
//                        Scaffold.of(context).showSnackBar(snackBar);
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  content: Text(message),
                                  actions: <Widget>[
                                    CupertinoButton(
                                        child: Text("View"),
                                        onPressed: () {
                                          String s = results.data
                                              .toString()
                                              .replaceAll("{upload: ", "")
                                              .replaceAll("}", "");
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => ImageView(
                                                      "http://letsinspire.aeologic.com/admin/storage/${s}")));
                                        }),
                                    CupertinoButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                ));
                      },
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _isLoadingInProgress() {
    return _uploadInProgress
        ? CircularProgressIndicator()
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.file_upload),
              SizedBox(
                width: 5,
              ),
              Text("Upload File"),
            ],
          );
  }
}
