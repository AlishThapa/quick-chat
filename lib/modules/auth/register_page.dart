import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickchat/modules/auth/login.dart';
import 'package:quickchat/modules/auth/utils/auth_gate.dart';
import 'package:quickchat/modules/auth/utils/auth_service.dart';
import 'package:quickchat/modules/auth/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isObscured = true;
  bool isConfirmPWObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPWController = TextEditingController();

  //text editing controllers for name phone and address
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isLoading = false;

  File? _imageFile; // Add this variable to store the selected image file

// Add a method to pick an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              SvgPicture.asset('assets/image/logo.svg', height: 200),
              const SizedBox(height: 15),
              Text(
                'Let\'s create an account for you',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Icon(Icons.camera_alt, size: 40, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 10),
              LoginTextField(
                controller: _nameController,
                text: 'Name',
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(height: 10),
              LoginTextField(
                controller: _emailController,
                text: 'Email',
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(height: 10),
              LoginTextField(
                controller: _passwordController,
                text: 'Password',
                obscureText: isObscured,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              LoginTextField(
                controller: _confirmPWController,
                text: 'Confirm Password',
                obscureText: isConfirmPWObscured,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(isConfirmPWObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isConfirmPWObscured = !isConfirmPWObscured;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              LoginTextField(
                controller: _phoneController,
                text: 'Phone',
                prefixIcon: const Icon(Icons.phone),
              ),
              const SizedBox(height: 10),
              LoginTextField(
                controller: _addressController,
                text: 'Address',
                prefixIcon: const Icon(Icons.location_on),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_passwordController.text == _confirmPWController.text) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await AuthService().signUpWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              address: _addressController.text.trim(),
                              imageFile: _imageFile,
                            );
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthGate()));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Registration failed: ${e.toString()}")),
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Passwords do not match'),
                          ));
                          return;
                        }
                      },
                child: isLoading
                    ? CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary)
                    : Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                      ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                child: Text(
                  'Already have an account? Log in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
