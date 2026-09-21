// ignore_for_file: file_names

class ShippingDetails {
  String streetAddress;
  String suburb;
  String state;
  int postcode;
  String country;
  bool initialised = false;

  ShippingDetails(
      {required this.streetAddress,
      required this.suburb,
      required this.state,
      required this.postcode,
      required this.country});
}

ShippingDetails demoShippingDetails = ShippingDetails(
    streetAddress: "123 Bob Avenue",
    suburb: "Sydney",
    state: "NSW",
    postcode: 2000,
    country: "Australia");
