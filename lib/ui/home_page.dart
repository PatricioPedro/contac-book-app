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

enum OrderBy { orderFromAtoZ, orderFromAZtoA }

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
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () {
              PopupMenuButton<OrderBy>(
                  itemBuilder: (context) => <PopupMenuEntry<OrderBy>>[
                        const PopupMenuItem<OrderBy>(
                          child: Text("Ordenar de A-Z"),
                          value: OrderBy.orderFromAtoZ,
                        ),
                        const PopupMenuItem<OrderBy>(
                          child: Text("Ordenar de Z-A"),
                          value: OrderBy.orderFromAZtoA,
                        ),
                      ],
                  onSelected: orderbyName);
            },
            icon: const Icon(Icons.more_vert_rounded),
            color: Colors.black,
          )
        ],
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

  void orderbyName(OrderBy result) {
    switch (result) {
      case OrderBy.orderFromAtoZ:
        listContacts.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!);
        });
        break;
      case OrderBy.orderFromAZtoA:
        listContacts.sort((a, b) {
          return b.name!.toLowerCase().compareTo(a.name!);
        });

        break;
      default:
    }
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: listContacts[index].img != null
                          ? FileImage(File(listContacts[index].img!))
                          : const AssetImage(
                              "images/pp.png",
                            ) as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listContacts[index].name ?? "",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(listContacts[index].phone ?? ""),
                    Text(listContacts[index].email ?? ""),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
