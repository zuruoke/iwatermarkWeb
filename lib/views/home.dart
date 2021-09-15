import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iwatermark/helpers/constants.dart';
import 'package:iwatermark/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Uint8List? _pickedFile;
  bool _isLoading = false;
  String? _filename;

  _uploadImage() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (_result != null) {
      setState(() {
        _pickedFile = _result.files.first.bytes;
        _filename = _result.files.first.name;
      });
    }
  }

  _uploadToFirebase() {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    appState
        .uploadImageToFirebaseStorage(_pickedFile!, _filename!)
        .then((String url) {
      setState(() {
        _isLoading = false;
        print(url);
      });
    });
  }

  _registerButton() {
    return TextButton(
      onPressed: () {},
      child: 'Register'.text.white.xl.wide.center.make(),
      style: TextButton.styleFrom(
          backgroundColor: decorationColor,
          elevation: 3.0,
          padding: EdgeInsets.symmetric(horizontal: horizontalSmallPadding),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }

  _headerDesktop() {
    final Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 0.05 * size.width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            'Iwatermark'.text.black.xl.wide.center.make(),
            SizedBox(width: 0.01 * size.width),
            'Home'.text.black.xl.wide.center.make(),
            SizedBox(width: 0.001 * size.width),
            'How it works'.text.black.xl.wide.center.make(),
            SizedBox(width: 0.001 * size.width),
            'Developers'.text.black.xl.wide.center.make(),
            SizedBox(
              width: 0.01 * size.width,
            ),
            'Login'.text.black.xl.wide.center.make(),
            _registerButton()
          ],
        ));
  }

  _decorContainer() {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.05 * size.width),
      alignment: Alignment.center,
      height: 0.7 * size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: lightGreen),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          'Watermark'.text.black.bold.xl3.wide.center.make(),
          'Removal Tool'.text.black.bold.xl3.wide.center.make(),
          SizedBox(
            height: 0.1 * size.height,
          ),
          _uploadContainer()
        ],
      ),
    );
  }

  _uploadContainer() {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: 0.3 * size.height,
      width: 0.3 * size.width,
      padding: EdgeInsets.symmetric(
          horizontal: horizontalSmallPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: (_pickedFile != null && _filename != null)
          ? Container(
              height: 0.1 * size.height,
              width: 0.1 * size.width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    _pickedFile!,
                    fit: BoxFit.fitWidth,
                    height: 0.1 * size.height,
                    width: 0.1 * size.width,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: _isLoading
                          ? CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.pink,
                            )
                          : _textButton('Remove Watermark', _uploadToFirebase))
                ],
              ))
          : Container(
              alignment: Alignment.center,
              height: 0.1 * size.height,
              width: 0.1 * size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalSmallPadding,
                  vertical: verticalPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: .1),
              ),
              child: _textButton('Choose Image', _uploadImage)),
    );
  }

  _textButton(String text, void Function()? onPressed) {
    return Container(
        height: 30,
        width: 118,
        decoration: BoxDecoration(
            color: decorationColor, borderRadius: BorderRadius.circular(8)),
        child: TextButton(
          style: TextButton.styleFrom(elevation: 2.0),
          onPressed: onPressed,
          child: text.text.white.xs.wide.center.make(),
        ));
  }

  _lineDecoration() {
    return Container(
      height: 5,
      width: 200,
      decoration: BoxDecoration(
          color: decorationColor, borderRadius: BorderRadius.circular(5)),
    );
  }

  _body() {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        _headerDesktop(),
        SizedBox(
          height: 0.1 * size.height,
        ),
        _decorContainer(),
        SizedBox(
          height: 0.1 * size.height,
        ),
        'EXAMPLES'.text.black.bold.xl4.wide.center.make(),
        const SizedBox(
          height: 5,
        ),
        _lineDecoration(),
        SizedBox(
          height: 0.05 * size.height,
        ),
        Container(
            height: 0.5 * size.height,
            width: size.width,
            child: _flexContainer()),
        SizedBox(
          height: 0.05 * size.height,
        ),
        "Thanks for scrolling, ".richText.semiBold.black.withTextSpanChildren(
            ["that's all folks.".textSpan.gray500.make()]).make(),
        10.heightBox,
        30.heightBox,
        "Made with Flutter Web with Love".text.blueGray800.make(),
      ],
    );
  }

  _flexContainer() {
    final Size size = MediaQuery.of(context).size;
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
          child: VxSwiper(
        //enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        items: [
          Image.asset(
            'assets/input.png',
            height: 0.5 * size.height,
            width: 0.5 * size.width,
          ),
          Image.asset(
            'assets/output.png',
            height: 0.5 * size.height,
            width: 0.5 * size.width,
          ),
          Image.asset(
            'assets/input1.jpeg',
            height: 0.5 * size.height,
            width: 0.5 * size.width,
          ),
          Image.asset(
            'assets/output1.png',
            height: 0.5 * size.height,
            width: 0.5 * size.width,
          )
        ],
        height: 0.5 * size.height,
        viewportFraction: 0.35,
        autoPlay: true,
        autoPlayAnimationDuration: 1.seconds,
      ))
    ]).p4().h(0.5 * size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: verticalPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [if (!context.isMobile) _body()],
          ),
        ),
      ),
    );
  }
}
