import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopper/views/order_page.dart';
import '../style/button_widget.dart';
import '../viewmodels/control_view_viewmodel.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    ScreenUtil.init(context);

    return Scaffold(
        appBar: AppBar(
          title:
              Image.asset('assets/images/logo/shopper.png', fit: BoxFit.cover),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 50, left: 10, right: 16),
              ),
              Center(
                child: Text(
                  "Order Placed!",
                  style: TextStyle(color: Colors.blue[600], fontSize: 35),
                ),
              ),
              const SizedBox(height: 10),
              Icon(Icons.check_circle_rounded,
                  size: 200.0, color: Colors.blue[600]),
              const SizedBox(height: 15),
              const Center(
                  child: Text("Thank you for shopping with us.",
                      style: TextStyle(fontSize: 20))),
              const SizedBox(height: 35),
              Center(
                  child: ButtonWidget(
                      buttonText: "Homepage",
                      onPressed: () {
                        controlViewModel.changeCurrentScreen(0);
                      },
                      height: 57,
                      width: 300,
                      textSize: 16,
                      color: Colors.blue[600])),
              const SizedBox(height: 15),
              Center(
                  child: ButtonWidget(
                      buttonText: "Your Orders",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderPage()));
                      },
                      height: 57,
                      width: 300,
                      textSize: 16,
                      color: Colors.blue[600]))
            ]));
  }
}
