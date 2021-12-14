import 'package:contact_book/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper contactHelper = ContactHelper();
  Contact contact = Contact();

  @override
  void initState() {
    super.initState();
    contact.name = "Patricio Pedro";
    contact.email = "patriciowilderbarros@gmail.com";
    contact.phone = "+244932735271";
    contact.img = "test.png";
    contactHelper.getAllContacts().then((value) {
      // ignore: avoid_print
      print(value);
    });
    contactHelper.closeDB();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
