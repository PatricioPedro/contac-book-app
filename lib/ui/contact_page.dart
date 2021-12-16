// ignore_for_file: avoid_print
import 'dart:io';

import 'package:contact_book/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ContactPage extends StatefulWidget {
  Contact? contact;

  ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact editedContact;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final _imgPicker = ImagePicker();
  bool _isEdited = false;

  final nameNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      editedContact = Contact.fromMap(widget.contact!.toMap());

      nameController.text = editedContact.name!;
      emailController.text = editedContact.email!;
      phoneController.text = editedContact.phone!;
    } else {
      editedContact = Contact();
    }
  }

  Future<bool> _requestPop() {
    if (_isEdited) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Descartar alterações?"),
                content:
                    const Text("Vai perder todas as alterações do formulario"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Ok"))
                ],
              ));

      return Future.value(true);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            editedContact.name ?? "Contacto",
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.blue,
              statusBarColor: Colors.black),
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return BottomSheet(
                                onClosing: () {},
                                builder: (context) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              _imgPicker
                                                  .pickImage(
                                                      source:
                                                          ImageSource.camera)
                                                  .then((file) {
                                                setState(() {
                                                  editedContact.img =
                                                      file?.path;
                                                });
                                              });
                                            },
                                            icon: const Icon(Icons.photo)),
                                        IconButton(
                                            onPressed: () {
                                              _imgPicker
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery)
                                                  .then((file) {
                                                setState(() {
                                                  editedContact.img =
                                                      file?.path;
                                                });
                                              });
                                            },
                                            icon: const Icon(Icons.camera))
                                      ],
                                    ));
                          });
                    },
                    child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: editedContact.img != null
                                ? FileImage(File(editedContact.img!))
                                : const AssetImage("images/pp.png")
                                    as ImageProvider,
                          ),
                        )),
                  ),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        editedContact.name = text;
                        // ignore: avoid_print
                        _isEdited = true;
                      });
                    },
                    controller: nameController,
                    focusNode: nameNode,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: "Nome",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        )),
                  ),
                  TextField(
                    onChanged: (text) {
                      editedContact.phone = text;
                      _isEdited = true;
                    },
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: "Telefone",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        )),
                  ),
                  TextField(
                    onChanged: (text) {
                      editedContact.email = text;
                      _isEdited = true;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        )),
                  ),
                  Container(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                          onPressed: () {
                            if (editedContact.name != null &&
                                editedContact.name!.isNotEmpty) {
                              Navigator.of(context).pop(editedContact);
                            } else {
                              FocusScope.of(context).requestFocus(nameNode);
                            }
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.amber),
                          child: const Text(
                            "Salvar",
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          )))
                ]),
          ),
        ),
      ),
    );
  }
}
