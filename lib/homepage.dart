import 'dart:developer';
import 'dart:io';

import 'package:chat_bot/widgets/msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api_key});
  final String? api_key;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final msg = TextEditingController();

  final FocusNode msgnode = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generateContent =
      [];
  late GenerativeModel model;
  late ChatSession chat;
  final ScrollController scrollController = ScrollController();
  final isLoad = false;
  XFile? img;
  File? selectImage;
  @override
  void initState() {
    model = GenerativeModel(
      apiKey: widget.api_key.toString(),
      model: 'gemini-1.5-flash-latest',
    );
    chat = model.startChat();
    super.initState();
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(microseconds: 750),
            curve: Curves.easeInOutCirc));
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xffFFFFFF),
        title: const Row(
          children: [
            Text("Bud"),
            Text(
              "d",
              style: TextStyle(color: Color(0xff9FE2BF)),
            ),
            Text("y"),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child: widget.api_key?.isNotEmpty ?? false
                        ? ListView.builder(
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              final msg = _generateContent[index];
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: MasgWidgets(
                                  iamge: msg.image,
                                  fromuser: msg.fromUser,
                                  text: msg.text,
                                ),
                              );
                            },
                            itemCount: _generateContent.length,
                          )
                        : ListView(
                            children: const [Text("No API KEY found!!")],
                          )),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          onSubmitted: msgSubmitted,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            hintText: "Type here..",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: InkWell(
                                onTap: () {
                                  pickImage();
                                },
                                child: const Icon(Icons.image)),
                          ),
                          controller: msg,
                          autofocus: true,
                          focusNode: msgnode,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      // ignore: prefer_const_constructors
                      shape: CircleBorder(),
                      onPressed: () {
                        msgSubmitted(msg.text.trim());
                      },
                      child: const Icon(Icons.send),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> msgSubmitted(String msge) async {
    log('fun pass1');
    try {
      _generateContent.add((image: null, fromUser: true, text: msge));
      final respose = await chat.sendMessage(Content.text(msge));
      final text = respose.text;
      _generateContent.add((image: null, fromUser: false, text: text));
      if (text == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something Went Worng!!")));
        log('$text');
      } else {
        setState(() {
          scrollDown();
        });
      }
    } catch (e) {
      log('$e');
    } finally {
      msg.clear();
      msgnode.requestFocus();
    }
  }

  pickImage() async {
    img = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
    if (img != null) {
      try {
        selectImage = File(img!.path);
        final byte = await img!.readAsBytes();
        final content = [
          Content.multi([TextPart(msg.text), DataPart('image.jpeg', byte)]),
        ];
        _generateContent
            .add((image: Image.memory(byte), fromUser: true, text: msg.text));

        var response = await model.generateContent(content);
        var text = response.text;
        _generateContent.add((image: null, fromUser: false, text: text));
        if (text == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something Went Worng!!")));
          log('$text');
        } else {
          setState(() {
            scrollDown();
          });
        }
      } catch (e) {
        log('$e');
      } finally {
        msg.clear();
        msgnode.requestFocus();
      }
    } else {
      print("image errror");
    }
  }
}
