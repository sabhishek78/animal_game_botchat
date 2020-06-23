import 'chat_bubble.dart';
import "dart:async";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'animal_tree.dart';

class QNA extends StatefulWidget {
  @override
  _QNAState createState() => _QNAState();
}

class _QNAState extends State<QNA> {
  final myController = TextEditingController();
  bool lastChatBubbleIsBot = true;
  bool createNodeProcessStarted = false;
   AnimalTree myTree = AnimalTree();
  Animal root ;
  Animal previousNode ;
  Animal currentNode ;
  bool reachedEndOfTree = false;
  bool distinguishQuestionAsked = false;
  bool yesOrNoForDistinguishQuestionAsked = false;
  Animal newQuestionNode;
  Animal newAnswerNode;
  Animal tempNode;
  String newAnimalName;
  @override
  void initState() {
    root= myTree.createAnimalTree();
    previousNode= myTree.previousNode;
    currentNode= root;
    reachedEndOfTree = false;
    distinguishQuestionAsked = false;
    yesOrNoForDistinguishQuestionAsked = false;
    createNodeProcessStarted = false;
    chatStatements
        .add(Statement(question: currentNode.questionText, isBot: true));
    super.initState();
  }
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  void reset() {
    print("Inside reset");
     currentNode = root;
     previousNode = myTree.previousNode;
    reachedEndOfTree = false;
    distinguishQuestionAsked = false;
    yesOrNoForDistinguishQuestionAsked = false;
    createNodeProcessStarted = false;
    chatStatements
        .add(Statement(question: currentNode.questionText, isBot: true));
  }

  List<Statement> chatStatements = [];

  void handleSend(String userResponse) async {
    print("Inside handle Send");
    chatStatements.add(Statement(
      isBot: false,
      question: userResponse,
    ));
    print("UserResponse=$userResponse");
    print("reachedEndOfTree=$reachedEndOfTree");
    print("distinguishQuestionAsked=$distinguishQuestionAsked");
    print("yesOrNoForDistinguishQuestionAsked=$yesOrNoForDistinguishQuestionAsked");
    print("createNodeProcessStared=$createNodeProcessStarted");
    myController.clear();
    lastChatBubbleIsBot = false;
    if (mounted) {
      setState(() {});
    }
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    print("hi");
    if (yesOrNoForDistinguishQuestionAsked) {
      print('linking nodes');
      if (userResponse == 'yes') {
        tempNode = currentNode; //save currentNode
        currentNode = newQuestionNode;
        currentNode.yesNode = newAnswerNode; //response yes
        currentNode.noNode = tempNode;
        previousNode.noNode = currentNode;
        print("New yes node added");
      } else if (userResponse == 'no') {
        tempNode = currentNode; //save currentNode
        currentNode = newQuestionNode;
        currentNode.noNode = newAnswerNode; //response yes
        currentNode.yesNode = tempNode;
        previousNode.noNode = currentNode;
        print("New no node added");
      }
      chatStatements.add(Statement(isBot: true, question: 'TREE UPDATED'));
      lastChatBubbleIsBot = true;
      setState(() {});
      reset();
      return;
    }
    if (distinguishQuestionAsked) {
      newQuestionNode=Animal('$userResponse','');
      print("New Question Node Created");
      chatStatements.add(Statement(
          isBot: true,
          question: 'Is the answer yes or no for $newAnimalName?'));
      lastChatBubbleIsBot = true;
      setState(() {});
      yesOrNoForDistinguishQuestionAsked = true;
      createNodeProcessStarted = false;
      reachedEndOfTree = false;
    }
    if (createNodeProcessStarted) {
      newAnswerNode = Animal('','$userResponse');
      print("New AnswerNode Created");
       newAnimalName = userResponse;
      chatStatements.add(Statement(
          isBot: true,
          question:
              'What question would distinguish between a ${currentNode.name} and a $newAnimalName?'));

      lastChatBubbleIsBot = true;
      setState(() {});
      distinguishQuestionAsked = true;
    }
    if (reachedEndOfTree) {
      if (userResponse == 'yes') {
        chatStatements.add(Statement(isBot: true, question: "END OF GAME"));
        lastChatBubbleIsBot = true;
        setState(() {});
        reset();
        return;
      }
      if (userResponse == 'no') {
        chatStatements.add(Statement(
            isBot: true, question: "OOPS !! LOOKS LIKE I NEED TO IMPROVE!!"));
        await Future.delayed(const Duration(milliseconds: 1000));
        chatStatements
            .add(Statement(isBot: true, question: "What is the Animal?"));
        lastChatBubbleIsBot = true;
        setState(() {});
        createNodeProcessStarted = true;
      }
      return;
    }

      if (userResponse == "yes") {
        previousNode = currentNode;
        // save previous node
        currentNode = currentNode.yesNode;
      } else if (userResponse == "no") {
        previousNode = currentNode; // save previous node
        currentNode = currentNode.noNode;
      }
    if (currentNode.yesNode != null && currentNode.noNode != null) {
      print("Reached a Question Node");
      chatStatements.add(Statement(
          isBot: true,
          question: currentNode.questionText));
      lastChatBubbleIsBot = true;
      setState(() {});
    }
    if (currentNode.yesNode == null &&
        currentNode.noNode == null &&
        !distinguishQuestionAsked) {
      print("reached answerNode");
      reachedEndOfTree = true;
      chatStatements.add(
          Statement(isBot: true, question: " Is it a ${currentNode.name}"));
      lastChatBubbleIsBot = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var children2 = <Widget>[
      Expanded(
        child: ListView(
          reverse: true,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: chatStatements
              .map((statement) {
                return ChatBubble(
                  isUserBot: statement.isBot,
                  text: statement.question,
                );
              })
              .toList()
              .reversed
              .toList(),
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              child: TextField(
                enabled: lastChatBubbleIsBot,
                controller: myController,
                decoration: InputDecoration(
                    hintText: whatHintText(),
                    contentPadding: EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0)),
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.grey,
              ),
              onPressed: () {
                handleSend(myController.text);
              }),
        ],
      ),
    ];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Animal Game'),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(
          children: children2,
        ),
      ),
    );
  }

  dynamic get currentController {
    return myController;
  }

  void updateChoices(String choices) {
    myController.text = choices;
  }
}

class Statement {
  String question;
  bool isBot;
  List<String> preDeterminedResponses;

  Statement({
    this.question,
    this.isBot,
    this.preDeterminedResponses = const [],
  });
}

String whatHintText() {
  return "Enter Your Response";
}
