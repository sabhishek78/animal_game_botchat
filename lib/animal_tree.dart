import 'dart:io';
class Animal {
  String questionText;
  Animal yesNode;
  Animal noNode;
  String name;
  Animal(this.questionText, this.name);
}

class AnimalTree {
  Animal root;
  Animal previousNode;
  createAnimalTree() {
    Animal first = Animal("Can it Fly?", null);
    Animal second = Animal("Can it Swim", null);
    Animal third = Animal("Can it climb trees?", null);
    Animal fourth = Animal(null, "Duck");
    Animal fifth = Animal(null, "Parrot");
    Animal sixth = Animal(null, "Monkey");
   Animal seventh = Animal(null,"Lion");
//    Animal eighth = Animal(null, "Dog");
//    Animal ninth = Animal("Is it taller than 2 meters?",null);
//    Animal tenth = Animal(null, "Giraffe");
//    Animal eleventh = Animal(null, "Fox");
    first.yesNode = second;
    first.noNode = third;
    second.yesNode = fourth;
    second.noNode = fifth;
    third.yesNode = sixth;
    third.noNode = seventh;

//    second.yesNode = fourth;
//    second.noNode = fifth;
//    third.yesNode = sixth;
//    third.noNode = seventh;

//    seventh.yesNode = eighth;
//    seventh.noNode = ninth;
//    ninth.yesNode = tenth;
//    ninth.noNode = eleventh;
    fourth.yesNode = null;
    fourth.noNode = null;
    fifth.yesNode = null;
    fifth.noNode = null;
    sixth.yesNode = null;
    sixth.noNode = null;
    seventh.yesNode = null;
    seventh.noNode = null;
//    eighth.yesNode = null;
//    eighth.noNode = null;
//    tenth.noNode = null;
//    tenth.noNode = null;
//    eleventh.yesNode = null;
//    eleventh.noNode = null;

    return first;
  }
  createNewNode(Animal currentNode, Animal previousNode) {
    print("What is the animal?");
    String newAnimal = stdin.readLineSync();
    Animal newAnswerNode = Animal("", " ${newAnimal}?"); //New Node Created
    print("What question would distinguish between a ${currentNode.name} and a ${newAnimal}?");
    String newQuestion = stdin.readLineSync();
    Animal newQuestionNode = Animal("${newQuestion}", "");
    print("Is the answer 'yes' or 'no' for a ${newAnimal}?");
    String response = stdin.readLineSync();
    if (response == 'yes') {
      Animal tempNode=currentNode;//save currentNode
      currentNode=newQuestionNode;
      currentNode.yesNode=newAnswerNode;//response yes
      currentNode.noNode=tempNode;
      previousNode.noNode = currentNode;

      print("New yes node added");
    } else if (response == 'no') {
      Animal tempNode=currentNode;//save currentNode
      currentNode=newQuestionNode;
      currentNode.noNode=newAnswerNode;//response yes
      currentNode.yesNode=tempNode;
      previousNode.noNode = currentNode;
      print("New no node added");
    }
  }

  void traverseTree(Animal currentNode, Animal previousNode) {
    while (currentNode.yesNode != null || currentNode.noNode != null) {
      print("${currentNode.questionText}");
      String response = stdin.readLineSync();
      if (response == "yes") {
        previousNode = currentNode;
        // save previous node
        currentNode = currentNode.yesNode;
      } else if (response == "no") {
        previousNode = currentNode; // save previous node
        currentNode = currentNode.noNode;
      }
    }
    print(" Is it a ${currentNode.name}");
    String response = stdin.readLineSync();
    if (response == "yes") {
      print("End of Game!");
    } else if (response == "no") {
      print("Oops looks like I need to improve!");
      createNewNode(currentNode, previousNode);
    }
    return;
  }
}
