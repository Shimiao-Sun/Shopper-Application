import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopper/models/cart.dart';
import 'package:shopper/viewmodels/cart_page_viewmodel.dart';
import 'package:shopper/viewmodels/checkout_page_viewmodel.dart';
import '../models/account.dart';
import '../style/text_widget.dart';
import '../style/button_widget.dart';
import '../viewmodels/control_view_viewmodel.dart';
import '../models/ShippingDetails.dart';

ShippingDetails shippingDetails = ShippingDetails(
    streetAddress: "", suburb: "", state: "", postcode: 0, country: "");

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();

    ScreenUtil.init(context);
    double defaultScreenWidth = ScreenUtil.defaultSize.width;
    double defaultScreenHeight = ScreenUtil.defaultSize.height;

    return Scaffold(
        appBar: AppBar(
          title:
              Image.asset('assets/images/logo/shopper.png', fit: BoxFit.cover),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blue),
              onPressed: () {
                controlViewModel.cartIndex = 0;
                controlViewModel.changeCurrentScreen(3);
              }),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          const Padding(padding: EdgeInsets.only(top: 19, left: 10, right: 16)),
          Text.rich(
            TextSpan(
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600]),
                children: const [
                  WidgetSpan(
                    child: Icon(Icons.lock_outline),
                  ),
                  TextSpan(text: "Checkout")
                ]),
          ),
          // Icon( Icons.lock_outline),
          Expanded(
              child: shippingDetails.initialised
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        const TextWidget(
                            txt: "Saved Shipping Details",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            align: TextAlign.center),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const TextWidget(
                                    txt: "Address: ",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextWidget(
                                    txt: shippingDetails.streetAddress,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const TextWidget(
                                    txt: "Suburb: ",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextWidget(
                                    txt: shippingDetails.suburb,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const TextWidget(
                                    txt: "State: ",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextWidget(
                                    txt: shippingDetails.state,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const TextWidget(
                                    txt: "Postcode: ",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextWidget(
                                    txt: shippingDetails.postcode.toString(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const TextWidget(
                                    txt: "Country: ",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextWidget(
                                    txt: shippingDetails.country,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      buildShippingDetailsPopup(context));
                            },
                            child: const Text("Edit Shipping Details"))
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(
                          defaultScreenWidth / 20,
                          defaultScreenHeight / 30,
                          defaultScreenWidth / 20,
                          defaultScreenHeight / 2.75),
                      child: const ShippingCard())),
          const SizedBox(height: 50),
          const Divider(thickness: 1, height: 0),
          const SizedBox(height: 16),
          Center(
              child: ButtonWidget(
            buttonText: "Place Order",
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    buildOrderConfirmationPopup(context),
              );
            },
            height: 57,
            width: 300,
            textSize: 16,
            color: Colors.blue[600],
          )),
        ]));
  }
}

class ShippingCard extends StatelessWidget {
  const ShippingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => buildShippingDetailsPopup(context),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                    child: Text(
                      "Shipping",
                      style: TextStyle(color: Colors.blue[600], fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      "Add shipping address",
                      style:
                          TextStyle(color: Colors.blueGrey[600], fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildShippingDetailsPopup(BuildContext context) {
  ControlViewModel controlViewModel = context.watch<ControlViewModel>();

  final addressController = TextEditingController();
  String addressErrorText = '';
  bool addressRedUnderLine = false;

  final suburbController = TextEditingController();
  String suburbErrorText = '';
  bool suburbRedUnderLine = false;

  String stateErrorText = '';
  bool stateRedUnderLine = false;

  final postcodeController = TextEditingController();
  String postcodeErrorText = '';
  bool postcodeRedUnderLine = false;

  String countryErrorText = '';
  bool countryRedUnderLine = false;

  String? selectedState;
  String? selectedCountry;

  if (shippingDetails.initialised) {
    addressController.text = shippingDetails.streetAddress;
    suburbController.text = shippingDetails.suburb;
    postcodeController.text = shippingDetails.postcode.toString();
    selectedState = shippingDetails.state;
    selectedCountry = shippingDetails.country;
  }

  return AlertDialog(
    scrollable: true,
    title: Text(
      'Enter Shipping Details',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue[600],
      ),
    ),
    content:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Street Address',
                  enabledBorder: addressRedUnderLine
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))
                      : const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                )),
            Text(addressErrorText, style: const TextStyle(color: Colors.red)),
            TextField(
                controller: suburbController,
                decoration: InputDecoration(
                  hintText: 'Suburb',
                  enabledBorder: suburbRedUnderLine
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))
                      : const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                )),
            Text(suburbErrorText, style: const TextStyle(color: Colors.red)),
            DropdownButton<String>(
                value: selectedState,
                onChanged: (newState) {
                  setState(() {
                    selectedState = newState;
                  });
                },
                items: <String>[
                  'NSW',
                  'VIC',
                  'QLD',
                  'WA',
                  'SA',
                  'TAS',
                  'ACT',
                  'NT'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text("State/Territory"),
                menuMaxHeight: 200.0,
                underline: stateRedUnderLine
                    ? Container(height: 1, color: Colors.red)
                    : Container(height: 1, color: Colors.blue)),
            Text(stateErrorText, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: postcodeController,
              decoration: InputDecoration(
                hintText: 'Postcode',
                enabledBorder: postcodeRedUnderLine
                    ? const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))
                    : const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
              ),
              keyboardType: TextInputType.number,
            ),
            Text(postcodeErrorText, style: const TextStyle(color: Colors.red)),
            DropdownButton<String>(
                value: selectedCountry,
                onChanged: (newCountry) {
                  setState(() {
                    selectedCountry = newCountry;
                  });
                },
                items: <String>['Australia'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text("Country/Region"),
                menuMaxHeight: 200.0,
                underline: countryRedUnderLine
                    ? Container(height: 1, color: Colors.red)
                    : Container(height: 1, color: Colors.blue)),
            Text(countryErrorText, style: const TextStyle(color: Colors.red)),
            Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        bool canExit = true;

                        if (addressController.value.text.isEmpty) {
                          canExit = false;
                          setState(() => addressRedUnderLine = true);
                          setState(() => addressErrorText =
                              "Please Enter a Street Address");
                        } else {
                          setState(() => addressRedUnderLine = false);
                          setState(() => addressErrorText = "");
                        }

                        if (suburbController.value.text.isEmpty) {
                          canExit = false;
                          setState(() => suburbRedUnderLine = true);
                          setState(
                              () => suburbErrorText = "Please Enter a Suburb");
                        } else {
                          setState(() => suburbRedUnderLine = false);
                          setState(() => suburbErrorText = "");
                        }

                        if (postcodeController.value.text.isEmpty) {
                          canExit = false;
                          setState(() => postcodeRedUnderLine = true);
                          setState(() =>
                              postcodeErrorText = "Please Enter a Postcode");
                        } else {
                          setState(() => postcodeRedUnderLine = false);
                          setState(() => postcodeErrorText = "");
                        }

                        if (selectedState == null) {
                          canExit = false;
                          setState(() => stateRedUnderLine = true);
                          setState(
                              () => stateErrorText = "Please Select a State");
                        } else {
                          setState(() => stateRedUnderLine = false);
                          setState(() => stateErrorText = "");
                        }

                        if (selectedCountry == null) {
                          canExit = false;
                          setState(() => countryRedUnderLine = true);
                          setState(
                              () => countryErrorText = "Please Select a State");
                        } else {
                          setState(() => countryRedUnderLine = false);
                          setState(() => countryErrorText = "");
                        }

                        if (canExit) {
                          shippingDetails.streetAddress =
                              addressController.value.text;
                          shippingDetails.suburb = suburbController.value.text;
                          shippingDetails.postcode =
                              int.parse(postcodeController.value.text);
                          shippingDetails.state = selectedState.toString();
                          shippingDetails.country = selectedCountry.toString();
                          shippingDetails.initialised = true;
                          controlViewModel.changeCurrentScreen(5);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save')),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'))
                ])
          ]);
    }),
  );
}

Widget buildOrderConfirmationPopup(BuildContext context) {
  ControlViewModel controlViewModel = context.watch<ControlViewModel>();
  CartViewModel cartViewModel = context.watch<CartViewModel>();
  CheckoutViewModel checkoutViewModel = context.watch<CheckoutViewModel>();

  Widget confirmButton = ElevatedButton(
      onPressed: () async {
        if (shippingDetails.initialised) {
          int buyerId = await checkoutViewModel.getUserId(Account.user);
          bool success = await checkoutViewModel.saveOrderDetails(
              cartViewModel.carts,
              buyerId,
              shippingDetails); // To get actual Seller and Buyer IDs
          if (success) {
            cartViewModel.clearCart();
            controlViewModel.changeCurrentScreen(6);
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
            final scaffold = ScaffoldMessenger.of(context);
            scaffold.showSnackBar(SnackBar(
              content: const Text(
                  'Order Placement Failed! Please try again later.',
                  textAlign: TextAlign.center),
              backgroundColor: Colors.red[600],
            ));
          }
        }
      },
      child: const Text("Confirm"));

  Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Go Back"));

  return AlertDialog(
    scrollable: true,
    title: Text(
      'Confirm Order',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue[600],
      ),
    ),
    content:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text("Items",
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue[600],
          )),
      for (var i in cartViewModel.carts)
        Text(
            "- ${i.numOfItem}x ${i.product.title} (\$${i.product.price * i.numOfItem})"),
      const SizedBox(height: 5),
      Text(
        "Total Price: \$${Cart.totalPrice(cartViewModel.carts)}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      const SizedBox(height: 15),
      Text("Shipping Details",
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue[600],
          )),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: shippingDetails.initialised
            ? <Widget>[
                Row(
                  children: <Widget>[
                    const Text(
                      "Address: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(shippingDetails.streetAddress)
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      "Suburb: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(shippingDetails.suburb)
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      "State: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(shippingDetails.state)
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      "Postcode: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(shippingDetails.postcode.toString())
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      "Country: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(shippingDetails.country)
                  ],
                ),
              ]
            : <Widget>[
                const Text(
                  "Please Enter Shipping Details",
                  style: TextStyle(color: Colors.red),
                )
              ],
      ),
    ]),
    actions: [
      confirmButton,
      cancelButton,
    ],
  );
}
