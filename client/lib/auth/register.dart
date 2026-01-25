import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:client/utils/error_handling.dart';
import 'package:client/widgets/reactive_text_field.dart';
import 'package:client/models/user.dart';
import 'package:client/auth/login.dart';
import 'package:client/config/app_config.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/user_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ReactiveTextInputState> _usernameKey =
      GlobalKey<ReactiveTextInputState>();
  final GlobalKey<ReactiveTextInputState> _passwordKey =
      GlobalKey<ReactiveTextInputState>();
  final GlobalKey<ReactiveTextInputState> _emailKey =
      GlobalKey<ReactiveTextInputState>();

  @override
  void initState() {}
  @override
  void dispose() {
    super.dispose();
  }

  void Register() async {
    final usernameRes = _usernameKey.currentState?.getText();
    final passwordRes = _passwordKey.currentState?.getText();
    final emailRes = _emailKey.currentState?.getText();

    String? username;
    String? password;
    String? email;

    if (usernameRes is Ok<String, String>) {
      username = usernameRes.value;
    }
    if (passwordRes is Ok<String, String>) {
      password = passwordRes.value;
    }
    if (emailRes is Ok<String, String>) {
      email = emailRes.value;
    }

    if (username == null || password == null || email == null) {
      return;
    }

    var user = await User.registerUser(
      username: username,
      email: email,
      password: password,
      endpoint: AppConfig.registerEndpoint,
    );
    if (user is Ok<User, String>) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(user.value);

      Navigator.pushReplacementNamed(context, RouteConfig.mainMenu);
    } else if (user is Err<User, String>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration failed at ${AppConfig.registerEndpoint} with message: ${user.error.toString()}',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 14.0,
    );
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Register to the app!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
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
                key: _emailKey,
                obscureText: false,
                labelText: "Email",
                evaluateInput: (String text) {
                  final validators = <Result<String, String> Function(String)>[
                    ReactiveValidator.notEmpty,
                    ReactiveValidator.email,
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
                  onPressed: Register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B62FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 26),

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
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(
                          color: Color(0xFF87879D),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, RouteConfig.login);
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
