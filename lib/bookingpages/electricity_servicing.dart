import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sajilo/navpages/navscreens/navhandling.dart';
import 'package:sajilo/services/auth.dart';

class ElectricityAnimationPage extends CupertinoPageRoute {
   ElectricityAnimationPage()
      : super(builder: (BuildContext context) => new ElectricityBooking());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(
        opacity: animation, child: new ElectricityBooking());
  }
}

class ElectricityBooking extends StatefulWidget {
  @override
  _ElectricityBookingState createState() => _ElectricityBookingState();
}

class _ElectricityBookingState extends State<ElectricityBooking> {
  TextEditingController _nameController,
      _addressController,
      _wardController,
      _mobilenumberController;

  DatabaseReference _ref;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _wardController = TextEditingController();
    _mobilenumberController = TextEditingController();

    _ref = FirebaseDatabase.instance.reference().child('BookingInfo');
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _mobilenumberController.dispose();
    _wardController.dispose();
    _addressController.dispose();
  }

  Widget build(BuildContext context) {
    AuthService data = Provider.of<AuthService>(context);
    DateTime now = DateTime.now();
    return new Scaffold(
      backgroundColor: Colors.teal,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            leading: BackButton(
              color: Colors.black,
            ),
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              titlePadding: EdgeInsets.only(top: 4.0),
              title: Text(
                "Electricity Reparing",
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
              centerTitle: true,
              background: Image.asset('assets/appbarimage/electricity.jpg',
                  fit: BoxFit.cover),
            ),
            centerTitle: true,
          ),
          SliverFillRemaining(
              hasScrollBody: true,
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 18.0,
                  ),

                  //Full Name
                  TextFormField(
                    controller: _nameController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Example:Jon Legend',
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.account_circle),
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen)),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),

                  //Address
                  TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add_location),
                      hintText: 'Example: Bhairahawa,Rupandehi',
                      labelText: 'Enter Address',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen)),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),

                  //Ward No.
                  TextFormField(
                    controller: _wardController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.blur_linear),
                      hintText: 'Example: Ward-10',
                      labelText: 'Enter Ward Number',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen)),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                  ),

                  SizedBox(
                    height: 12.0,
                  ),
//

                  TextFormField(
                    controller: _mobilenumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_iphone,
                      ),
                      hintText: 'Example: 98********',
                      labelText: 'Enter Mobile Number',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen)),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                  ),

                  SizedBox(height: 12.0),

                  Text(
                    "Give your location access",
                    style: TextStyle(fontFamily: 'Rubik', fontSize: 16.0),
                  ),

                  //Location Button
                  IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.indigo,
                        size: 30.0,
                      ),
                      onPressed: () {}),

                  SizedBox(
                    height: 15.0,
                  ),

                  //Book Button
                  ElevatedButton(
                    //color: Colors.redAccent,
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _addressController.text.isEmpty ||
                          _wardController.text.isEmpty ||
                          _mobilenumberController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: new Text(
                                    "Error",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: new Text(
                                    "Please fill up all the description before booking",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'))
                                  ],
                                ));
                      } else
                        saveBooking(data.userInfo, data.userID,now);
                    },
                    child: Text(
                      'Book Service',
                      style:
                          TextStyle(fontFamily: 'Rubik', color: Colors.white),
                    ),
                  )
                ]),
              ))
        ],
      ),
    );
  }

  void saveBooking(String a, String userID,now) {
    String name = _nameController.text;
    String address = _addressController.text;
    String ward = _wardController.text;
    String mobilenumber = _mobilenumberController.text;
    String service = "Electricity Reparing";
    String emailid = a;
    String bookingstatus = 'Pending';
    String y = now.toString();

    Map<String, String> bookinginfo = {
      'name': name,
      'address': address,
      'ward': ward,
      'mobilenumber': mobilenumber,
      'service': service,
      'email': emailid,
      'UserId': userID,
      'BookingStatus': bookingstatus,
      'BookedTimeAndDate':y,
    };
    _ref.push().set(bookinginfo);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0)),
              backgroundColor: Colors.blueGrey[200],
              title: new Text(
                "ThankYou",
                style:
                    TextStyle(fontFamily: 'Rubik', backgroundColor: Colors.red),
                textAlign: TextAlign.center,
              ),
              content: new Text(
                "You Have Successfully booked Electricity Reparing Service.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>NavHome()));
                     Flushbar(
                       icon: Icon(Icons.done_all_sharp,size: 32.0,color: Colors.blue,),
                       title: 'Successfully Booked',
                       message: 'Electricity reparing services',
                       flushbarPosition: FlushbarPosition.TOP,
                       duration: Duration(seconds: 2),
                       flushbarStyle: FlushbarStyle.FLOATING,
                     ).show(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(fontSize: 16.0),
                    ))
              ],
            ));
  }
}
