
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rs_auth/greating.dart';
import 'package:rs_auth/storage_methos.dart';
import 'package:rs_auth/utils.dart';
import 'package:uuid/uuid.dart';

import 'input_text.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController adminuidcontroller = TextEditingController();


  bool _isloading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    namecontroller.dispose();
    emailcontroller.dispose();
    phonecontroller.dispose();
    _image=null;
  }

  Future<String> storage ()async{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String res = "some error occure";
    DateTime currentDate = DateTime.now();

    try {
      final uid = Uuid().v1();
      if (EmailValidator.validate(emailcontroller.text) == true) {
        if(phonecontroller.text.trim().length>=10) {
          if (namecontroller.text.isNotEmpty &&
              emailcontroller.text.isNotEmpty &&
              phonecontroller.text.isNotEmpty &&
              adminuidcontroller.text.isNotEmpty) {
            setState(() {
              _isloading = true;
            });
            String custprofileUrl = _image != null ? await StorageMethods()
                .uploadImageToStorage("customerprofile", _image!) : '';
            await _firestore.collection('admin').doc(
                adminuidcontroller.text.trim()).collection('customers')
                .doc(uid)
                .set({
              'uid': uid,
              'name': namecontroller.text.trim(),
              'email': emailcontroller.text.trim(),
              'phone': phonecontroller.text.trim(),
              'profile': custprofileUrl,
              'date': DateTime(currentDate.year, currentDate.month, currentDate.day)
                  .toString(),
            });
            setState(() {
              _isloading = false;
              namecontroller.text = '';
              emailcontroller.text = '';
              phonecontroller.text = '';
            });
            res = "success";
            return res;
          }
        }
        else {
          res = 'phone number is not valid';
        }
      }
      else {
        res = 'Email is not valid';
      }


      return res;
    }
    catch(e){
      res = "some error occure $e";
      return res;
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    adminuidcontroller.text = Uri.base.queryParameters['uid'] ?? 'uid';
    print(adminuidcontroller.text);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title:kIsWeb ? Container(): Text('Add New Customer'),
          backgroundColor:const Color.fromRGBO(0, 0, 0, 1),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            padding: MediaQuery.of(context).size.width > 600
                ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                      backgroundColor: Colors.white,
                    )
                        : const CircleAvatar(
                      radius: 64,
                      backgroundImage:NetworkImage('https://cdn-icons-png.flaticon.com/128/3106/3106921.png'),
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(hint: "Enter Your Name", icon: const Icon(Icons.person), controller: namecontroller, textInputType: TextInputType.text,),
                const SizedBox(
                  height: 12,
                ),
                InputText(hint: "Enter Your email", icon: const Icon(Icons.email), controller: emailcontroller, textInputType: TextInputType.text,),

                const SizedBox(
                  height: 12,
                ),
                IntlPhoneField(
                  showCountryFlag: true,
                  dropdownIcon: Icon(Icons.arrow_drop_down),
                  decoration: InputDecoration(
                    hintText: "Phone",
                    // filled: true,
                      border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                    )
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (text)=>setState(() {
                    phonecontroller.text =text.completeNumber;
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          )),),
                    child: _isloading==true ? const Center(child: CircularProgressIndicator(color: Colors.white,)) : const Center(child: Text("Submit",style: TextStyle(fontSize: 18),)),
                  ),
                  onTap: ()async{
                    String res = await storage();
                    showSnackbar(context, res);
                    if(res=='success'){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Greating()));
                    }
                    // print(res);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

