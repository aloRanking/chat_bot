import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:chatbot/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String messageTxt;
  final messageTextController = TextEditingController();
  List<ChatMessage> messages = <ChatMessage>[];

  void queryResponse(query) async {
    messageTextController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/flutterbot.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    var res = response.getListMessage().length-1;
    for(int i = 0; i<= res; i ++) {

      ChatMessage mssg = ChatMessage(text: response.getListMessage()[i]['text']['text'][0], isMe: false,);


      setState(() {

        messages.insert(0,mssg);
      });

      print(response.getListMessage()[i]['text']['text'][0]);



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat Bot'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index){
                  return messages[index];                },
              ),
            ),
          ),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
//Do something with the user input.
                      messageTxt = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                FlatButton(
                  onPressed: () {


                    var mssg = ChatMessage(text: messageTxt, isMe: true,);

                    setState(() {
                      messages.insert(0,mssg);
                    });
                    queryResponse(messageTxt);

                    messageTextController.clear();

                  },
                  child: Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  ChatMessage({this.sender, this.text, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
      color: isMe ? Color.fromRGBO(225, 255, 199, 1.0) : null,
      child: Text(text, textAlign: isMe ? TextAlign.right : TextAlign.left),
    );
  }
}

/*
*/
