import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Where registered users are stored (cleared when the app restarts)
Map<String, String> passwords = {}; // email -> password
Map<String, String> names = {}; // email -> full name

// ---------------- LOOK AND FEEL ----------------
// Change this one colour to restyle the whole app
const Color accent = Color(0xFF2F4B7C);
const Color background = Color(0xFFF3F4F6);

// Style for all text fields: light grey, rounded, thin border
InputDecoration fieldStyle(String label) {
  OutlineInputBorder border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    border: border(Colors.grey.shade300, 1),
    enabledBorder: border(Colors.grey.shade300, 1),
    focusedBorder: border(accent, 1.5),
  );
}

// Style for all main buttons: rounded and flat
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: accent,
  foregroundColor: Colors.white,
  minimumSize: const Size.fromHeight(50),
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

// Small helper to show a message at the bottom of the screen
void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

// Centered title with a grey line under it
Widget heading(String title, String subtitle) {
  return Column(
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fori',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: accent),
        scaffoldBackgroundColor: background,
      ),
      home: const LoginPage(),
    );
  }
}

// ---------------- PAGE LAYOUT ----------------
// Every page uses this: a white card in the middle of the screen
class CardPage extends StatelessWidget {
  final List<Widget> children;

  const CardPage({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- LOGIN PAGE ----------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage(context, 'Please fill in all fields');
    } else if (passwords[email] == password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(name: names[email]!)),
      );
    } else {
      showMessage(context, 'Wrong email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPage(
      children: [
        heading('Welcome back', 'Log in to your account'),
        const SizedBox(height: 28),
        TextField(
          controller: emailController,
          decoration: fieldStyle('Email'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: fieldStyle('Password'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: buttonStyle,
          onPressed: login,
          child: const Text('Log in', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: const Text(
            "Don't have an account? Sign up",
            style: TextStyle(color: accent),
          ),
        ),
      ],
    );
  }
}

// ---------------- REGISTER PAGE ----------------
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  void register() {
    String name = nameController.text.trim();
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text;
    String confirm = confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showMessage(context, 'Please fill in all fields');
    } else if (!email.contains('@')) {
      showMessage(context, 'Enter a valid email');
    } else if (password.length < 6) {
      showMessage(context, 'Password must be at least 6 characters');
    } else if (password != confirm) {
      showMessage(context, 'Passwords do not match');
    } else if (passwords.containsKey(email)) {
      showMessage(context, 'This email is already registered');
    } else {
      passwords[email] = password;
      names[email] = name;
      showMessage(context, 'Account created! Please log in');
      Navigator.pop(context); // go back to login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPage(
      children: [
        heading('Create your account', 'It only takes a minute'),
        const SizedBox(height: 28),
        TextField(
          controller: nameController,
          decoration: fieldStyle('Full name'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: emailController,
          decoration: fieldStyle('Email'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: fieldStyle('Password'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: confirmController,
          obscureText: true,
          decoration: fieldStyle('Confirm password'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: buttonStyle,
          onPressed: register,
          child: const Text('Create account', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Already have an account? Log in',
            style: TextStyle(color: accent),
          ),
        ),
      ],
    );
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatelessWidget {
  final String name;

  const HomePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return CardPage(
      children: [
        heading('Hello, $name', 'You are logged in'),
        const SizedBox(height: 28),
        ElevatedButton(
          style: buttonStyle,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('Log out', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}