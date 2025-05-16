import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading    = false;
  String? _error;
  bool _isRegister = false;

  // Cinematic palette with neon-magenta accent
  static const kBgColor      = Color(0xFF0B132B); // Ink-blue
  static const kCardColor    = Color(0xFF1C2541); // Deep slate
  static const kFieldColor   = Color(0xFF263D58); // Muted navy
  static const kAccentColor  = Color(0xFFFF4081); // Neon magenta

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text;

    try {
      if (_isRegister) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          _emailCtrl.clear();
          _passCtrl.clear();
          setState(() {
            _isRegister = false;
            _error = 'Account created! Please log in.';
          });
        }
      } else {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);
      }
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Unexpected error—please try again.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isRegister ? 'Sign Up' : 'Login';

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kCardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            color: kCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email field
                    TextFormField(
                      controller: _emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kFieldColor,
                        prefixIcon:
                        const Icon(Icons.email, color: kAccentColor),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter your email';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kFieldColor,
                        prefixIcon:
                        const Icon(Icons.lock, color: kAccentColor),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Enter your password';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Error message
                    if (_error != null) ...[
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Submit button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kCardColor,
                        ),
                      )
                          : Text(
                        title,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Toggle link
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => setState(() {
                        _isRegister = !_isRegister;
                        _error = null;
                      }),
                      style: TextButton.styleFrom(
                        foregroundColor: kAccentColor,
                      ),
                      child: Text(
                        _isRegister
                            ? 'Have an account? Login'
                            : 'Create new account',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
