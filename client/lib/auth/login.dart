import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:client/utils/error_handling.dart';
import 'package:client/widgets/reactive_text_field.dart';
import 'package:client/models/user.dart';
import 'package:client/auth/register.dart';
import 'package:client/config/app_config.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ReactiveTextInputState> _usernameKey =
      GlobalKey<ReactiveTextInputState>();
  final GlobalKey<ReactiveTextInputState> _passwordKey =
      GlobalKey<ReactiveTextInputState>();

  @override
  void initState() {}
  @override
  void dispose() {
    super.dispose();
  }

  void logIn() async {
    final usernameRes = _usernameKey.currentState?.getText();
    final passwordRes = _passwordKey.currentState?.getText();

    String? username;
    String? password;

    if (usernameRes is Ok<String, String>) {
      username = usernameRes.value;
    }
    if (passwordRes is Ok<String, String>) {
      password = passwordRes.value;
    }

    if (username == null || password == null) {
      return;
    }

    var user = await User.loginUser(
      username: username,
      password: password,
      endpoint: AppConfig.loginEndpoint,
    );

    if (user is Ok<User, String>) {
      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(user.value);
        Navigator.pushReplacementNamed(context, RouteConfig.mainMenu);
      }
    } else if (user is Err<User, String>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration failed at ${{AppConfig.loginEndpoint}} with message: ${user.error.toString()}',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 14.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFF1C1C1C),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Sign In to continue',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color(0xFF1C1C1C),
                ),
              ),
              SizedBox(height: 26),
              ReactiveTextInput(
                key: _usernameKey,
                obscureText: false,
                labelText: "Username",
                evaluateInput: (String text) {
                  final validators = <Result<String, String> Function(String)>[
                    ReactiveValidator.notEmpty,
                    ReactiveValidator.noSpaces,
                    ReactiveValidator.lowercaseOnly,
                    (v) => ReactiveValidator.requiredLength(v, 5, 30),
                  ];
                  return chainValidators(text, validators);
                },
              ),
              SizedBox(height: 16),
              ReactiveTextInput(
                key: _passwordKey,
                obscureText: true,
                labelText: "Password",
                evaluateInput: (String text) {
                  final validators = <Result<String, String> Function(String)>[
                    ReactiveValidator.notEmpty,
                    (v) => ReactiveValidator.requiredLength(v, 8, 40),
                  ];
                  return chainValidators(text, validators);
                },
              ),
              SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton(
                  onPressed: logIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B62FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 26),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Forgot Password?',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF87879D),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Forgot Password tapped');
                      },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xFF87879D),
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(
                          color: Color(0xFF87879D),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, RouteConfig.register);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: defaultStyle,
                  children: <TextSpan>[
                    TextSpan(text: 'By clicking Logging in, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Terms of Service"');
                        },
                    ),
                    TextSpan(text: ' and that you have read our '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Privacy Policy"');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
