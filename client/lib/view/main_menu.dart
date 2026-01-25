import 'package:client/view/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:client/models/user.dart';
import 'package:client/auth/login.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/config/app_config.dart';
import 'package:client/widgets/login_required.dart';
import 'package:client/utils/error_handling.dart';
import 'package:toastification/toastification.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/widgets/carousel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:client/widgets/toast.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  User? _user;
  List<Widget>? _widgetOptions;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Do not access InheritedWidgets (like Provider) here. Initialization
    // that depends on them must happen in didChangeDependencies.
    initialize();
  }

  void initializeWidgets() {
    setState(() {
      _widgetOptions = <Widget>[
        HomePage(user: _user),
        ProductList(apiUri: AppConfig.productsEndpoint),
        ProfilePage(currentUser: _user),
      ];
      _isLoading = false;
    });
  }

  FlutterSecureStorage _storage = FlutterSecureStorage();
  void initialize() async {
    String token = await _storage.read(key: AppConfig.sessionToken) ?? '';

    Result<User, String> resultUser = await User.restoreFromSession(
      token: token,
      endpoint: AppConfig.userRestoreEndpoint,
    );
    if (resultUser is Ok<User, String>) {
      _user = resultUser.value;
      initializeWidgets();
    } else if (resultUser is Err<User, String>) {
      debugPrint('Error restoring user: ${resultUser.error}');
      initializeWidgets();
      GFToast.showToast(
        'Error! ${resultUser.error}', // Combine title + message
        context,
        toastPosition:
            GFToastPosition.BOTTOM, // GFToast uses toastPosition, not Alignment
        toastDuration: 6, // Set duration to 6 seconds
        backgroundColor: GFColors.DANGER, // Red for error
        textStyle: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
      );
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  void _handleLogout(BuildContext context) async {
    bool success = await User.logout();
    if (success) {
      Navigator.pushReplacementNamed(context, RouteConfig.mainMenu);
    } else {
      showCustomToast(
        context: context,
        message: 'Logout failed. Please try again later.',
        title: 'Logout Failed',
        duration: const Duration(seconds: 6),
        alignment: Alignment.topCenter,
        type: ToastificationType.error,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, RouteConfig.settings);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Text('Shoppenheimer'),
            ),
            ListTile(
              title: Text('Mock Arithmetic!'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArithmeticWidget()),
                );
              },
            ),
            ListTile(
              title: Text.rich(
                TextSpan(
                  text: 'Log out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

              onTap: () {
                _handleLogout(context);
              },
            ),
            // Add more items as needed
          ],
        ),
      ),

      body: Center(
        child:
            _widgetOptions?.elementAt(_selectedIndex) ??
            const CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Products',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.user != null)
                Text('Hello ${widget.user!.username} and welcome to my app!')
              else
                Text('Welcome Guest'),
              CarouselWidget(
                items: [
                  CarouselItem(text: 'One', color: Colors.red),
                  CarouselItem(text: 'Two', color: Colors.blue),
                  CarouselItem(text: 'Three', color: Colors.green),
                  CarouselItem(text: 'Four', color: Colors.orange),
                  CarouselItem(text: 'Five', color: Colors.purple),
                ],
                height: 250,
                autoPlay: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  final User? currentUser;

  const ProfilePage({super.key, required this.currentUser});
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return LoginRequiredWidget();
    }
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          SizedBox(height: 16),

          Text(
            'Hello, ${currentUser!.username}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Text(
            'Email: ${currentUser!.email}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class ArithmeticWidget extends StatefulWidget {
  @override
  _ArithmeticWidgetState createState() => _ArithmeticWidgetState();
}

class _ArithmeticWidgetState extends State<ArithmeticWidget> {
  int _a = 0;
  int _b = 0;
  String _result = "";

  void _add() {
    setState(() {
      _result = (_a + _b).toString();
    });
  }

  void _subtract() {
    setState(() {
      _result = (_a - _b).toString();
    });
  }

  void _multiply() {
    setState(() {
      _result = (_a * _b).toString();
    });
  }

  void _divide() {
    setState(() {
      if (_b == 0) {
        _result = "Can not divide by 0!";
        return;
      }
      _result = (_a / _b).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arithmetic"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Enter first number'),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() => _a = int.tryParse(value) ?? 0),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Enter second number'),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() => _b = int.tryParse(value) ?? 0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _add, child: Text('Add')),
              SizedBox(width: 10),
              ElevatedButton(onPressed: _subtract, child: Text('Subtract')),
              SizedBox(width: 10),
              ElevatedButton(onPressed: _divide, child: Text('Divide')),
              SizedBox(width: 10),
              ElevatedButton(onPressed: _multiply, child: Text('Multiply')),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 20),
          Text('Result: $_result', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
