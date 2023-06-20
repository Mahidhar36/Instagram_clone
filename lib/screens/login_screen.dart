import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/firebase/auth_cubit_state.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/sIgn_up.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LogInScreen extends StatefulWidget {
  static String route = "SignIn";

  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool visibility = false;
  String Email = "";
  String Password = "";
  late final FocusNode focusNode;
  late final AuthState state;
  final formKey = GlobalKey<FormState>();

  void submit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    context.read<AuthCubit>().SignIn(email: Email, password: Password);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (previous, current) {
            if (current is AuthError) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(current.message),
                duration: const Duration(seconds: 2),
              ));
            }
            if (current is AuthSignedIn) {
              Navigator.of(context).pushReplacementNamed(HomeScreen.route);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset("lib/assets/instagram.png"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          hintText: "Enter EmailAddress"),
                      onSaved: (value) {
                        Email = value!.trim();
                      },
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter the EmailAddress";
                        }
                      },
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: visibility,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Enter Password",
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              visibility = !visibility;
                            });
                          },
                          child: visibility
                              ? const Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                      onSaved: (value) {
                        Password = value!.trim();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter the Password";
                        }
                      },
                      onFieldSubmitted: (_) => submit(),
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        submit();
                      },
                      color: Colors.blue,
                      minWidth: 500,
                      child: const Text("Login"),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an Account?"),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                state = AuthInitial();
                              });
                              Navigator.of(context)
                                  .pushNamed(SignUpScreen.routname);
                            },
                            child: const Text("Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                )))
                      ],
                    ))
                  ]),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
