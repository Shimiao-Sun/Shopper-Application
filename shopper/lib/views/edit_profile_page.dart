import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/account.dart';
import 'package:shopper/style/text_form_field_widget.dart';
import 'package:shopper/viewmodels/account_page_viewmodel.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    String newFirstName = "";
    String newLastName = "";
    final formKey = GlobalKey<FormState>();

    AccountViewModel accountViewModel = context.watch<AccountViewModel>();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        body: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
              ),
              Center(
                child: Text(
                  "Editing Profile",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormFieldWidget(
                  hintText: Account.user.firstName,
                  minLines: 1,
                  maxLines: 1,
                  prefixIcon: const Icon(Icons.person_outline),
                  isPasswordField: false,
                  validator: (val) {
                    if (val.isNotEmpty) {
                      newFirstName = val;
                    }

                    return null;
                  }),
              const SizedBox(
                height: 13,
              ),
              TextFormFieldWidget(
                  hintText: Account.user.lastName,
                  minLines: 1,
                  maxLines: 1,
                  prefixIcon: const Icon(Icons.person_outline),
                  isPasswordField: false,
                  validator: (val) {
                    if (val.isNotEmpty) {
                      newLastName = val;
                    }
                    return null;
                  }),
              const SizedBox(
                height: 13,
              ),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    List<int> results = await accountViewModel.editProfile(
                        newFirstName, newLastName);

                    if (results[0] == 0 && results[1] == 0) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("No updated"),
                              content:
                                  const Text("No profile updates happened"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Back to Profile Page"))
                              ],
                            );
                          });
                    } else {
                      String temp = "";
                      if (results[0] == 1) {
                        temp += "FirstName Updated\n";
                      }
                      if (results[1] == 1) {
                        temp += "LastName Updated\n";
                      }

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Profile updated"),
                              content: Text(temp),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Back to Profile Page"))
                              ],
                            );
                          });
                    }
                  }
                },
                child: const Text("Update"),
              )),
            ])));
  }
}
