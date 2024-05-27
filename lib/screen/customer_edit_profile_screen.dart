// ignore_for_file: use_build_context_synchronously


import 'package:finalprojectbarber/model/customer_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/k_components.dart';
import '../php_data/php_data.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class CustomerEditProfileScreen extends StatefulWidget {
  final CustomerInfo model;

  const CustomerEditProfileScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomerEditProfileScreenState createState() =>
      _CustomerEditProfileScreenState();
}

class _CustomerEditProfileScreenState extends State<CustomerEditProfileScreen> {
  late CustomerInfo model;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = true;
  bool isLoading = false;
  @override
  void initState() {
    model = widget.model;
    super.initState();
    firstNameController.text = model.customerFirstName;
    lastNameController.text = model.customerLastName;
    phoneController.text = model.customerPhone;
    emailController.text = model.customerEmail;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: Stack(
        children: <Widget>[
          DraggableScrollableSheet(
            maxChildSize: 1.0,
            minChildSize: 1.0,
            initialChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                height: AppTheme.fullHeight(context) * .5,
                padding: const EdgeInsets.only(
                  left: 19,
                  right: 19,
                  top: 16,
                ), //symmetric(horizontal: 19, vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const BackButton(
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Text(
                                  "แก้ไขข้อมูล",
                                  style:
                                      titleStyle.copyWith(color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: firstNameController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'ชื่อ',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: lastNameController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'นามสกุล',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: phoneController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'เบอร์โทรศัพท์',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: emailController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'อีเมล',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: passwordController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            obscureText: showPassword,
                            decoration: kTextFormFieldDecoration.copyWith(
                                labelText: 'รหัสผ่าน',
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    child: Icon(showPassword
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash))),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: LightColor.grey.withAlpha(150),
                          ),
                          child: const Icon(
                            Icons.update,
                            color: Color.fromARGB(255, 2, 158, 255),
                          ),
                        ).ripple(
                          () async {
                            if (firstNameController.text.isEmpty ||
                                lastNameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                phoneController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('ข้อผิดพลาด'),
                                    content: const Text(
                                        "กรุณากรอกข้อมูลให้ครบทุกช่อง"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('ตกลง'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              final customerModel = CustomerInfo(
                                customerId: model.customerId,
                                customerFirstName: firstNameController.text,
                                customerLastName: lastNameController.text,
                                customerPhone: phoneController.text,
                                customerEmail: emailController.text,
                                customerPassword: passwordController.text,
                              );
                              await editProfileCustomer(customerModel, context);
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ).vP16),
              );
            },
          ),
        ],
      ),
    );
  }
}
