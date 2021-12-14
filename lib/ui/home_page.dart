// ignore: unused_import
// ignore_for_file: unnecessary_null_comparison, avoid_unnecessary_containers

import 'dart:io';

import 'package:contact_book/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:contact_book/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper contactHelper = ContactHelper();

  List<Contact> listContacts = [];

  Contact c = Contact();

  @override
  void initState() {
    super.initState();
    _getAllContactsFromDB();
  }

  void _getAllContactsFromDB() {
    contactHelper.getAllContacts().then((list) {
      setState(() {
        listContacts = list as List<Contact>;
      });
    });
  }

  void _goToContactPage({Contact? contact}) async {
    Contact responseContact =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ContactPage(
        contact: contact,
      ),
    ));

    if (responseContact != null) {
      if (contact != null) {
        contactHelper.updateContact(responseContact);
        print(responseContact.toMap());
      } else {
        contactHelper.saveContact(responseContact);
      }
      _getAllContactsFromDB();
    }
  }

  void _showOptionsContact(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      launch("tel:${listContacts[index].phone}");
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Ligar",
                      style: TextStyle(color: Colors.amber, fontSize: 14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _goToContactPage(contact: listContacts[index]);
                    },
                    child: const Text(
                      "Editar",
                      style: TextStyle(color: Colors.amber, fontSize: 14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      contactHelper.deleteContact(listContacts[index].id);
                      setState(() {
                        Navigator.pop(context);

                        listContacts.removeAt(index);
                      });
                    },
                    child: const Text(
                      "Excluir",
                      style: TextStyle(color: Colors.amber, fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contactos',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
          itemCount: listContacts.length,
          itemBuilder: (context, index) => contactCard(context, index)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToContactPage();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }

  Widget contactCard(BuildContext contex, int index) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: GestureDetector(
        onTap: () {
          _showOptionsContact(context, index);
        },
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                    width: 98,
                    height: 98,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                        "images/pp.jpeg",
                      )),
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listContacts[index].name ?? "",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(listContacts[index].phone ?? ""),
                  Text(listContacts[index].email ?? ""),
                  Text("${listContacts[index].id}"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
