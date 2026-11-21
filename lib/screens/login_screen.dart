import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../theme/app_theme.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/logo_mark.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const LoginScreen({super.key, this.onBack});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _isLogin = true;
  bool _hidePassword = true;
  String _role = 'builder';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().length < 2) return 'Enter your name';
    return null;
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Enter a valid email';
  }

  String? _validatePassword(String? v) {
    if (v == null || v.length < 8) return 'At least 8 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _password.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthState>();
    final email = _email.text.trim();
    final password = _password.text;

    if (_isLogin) {
      await auth.signIn(email, password);
    } else {
      await auth.signUp(
        name: _name.text.trim(),
        email: email,
        password: password,
        role: _role,
      );
    }
  }

  void _toggleMode() {
    context.read<AuthState>().clearError();
    _confirm.clear();
    setState(() => _isLogin = !_isLogin);
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
  );

  Widget _eye() => IconButton(
    icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
    onPressed: () => setState(() => _hidePassword = !_hidePassword),
  );

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.onBack != null)
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                const SizedBox(height: 12),
                FadeSlideIn(
                  child: Row(
                    children: [
                      const LogoMark(size: 56),
                      const SizedBox(width: 14),
                      Text(
                        'Startup Team Builder',
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delayMs: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          _isLogin
                              ? 'Your idea needs a team.\nFind it here.'
                              : 'Create your\naccount.',
                          key: ValueKey(_isLogin),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pitch what you want to build, or join a team that '
                            'needs your skills. For AUCA students.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delayMs: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sign-up-only fields slide open and closed.
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.topCenter,
                        child: _isLogin
                            ? const SizedBox(width: double.infinity)
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Full name'),
                            TextFormField(
                              controller: _name,
                              textCapitalization:
                              TextCapitalization.words,
                              decoration: const InputDecoration(
                                  hintText: 'Your name'),
                              validator: _validateName,
                            ),
                            const SizedBox(height: 16),
                            _label('How will you use the app?'),
                            SizedBox(
                              width: double.infinity,
                              child: SegmentedButton<String>(
                                segments: const [
                                  ButtonSegment(
                                      value: 'builder',
                                      label: Text('Builder')),
                                  ButtonSegment(
                                      value: 'mentor',
                                      label: Text('Mentor')),
                                ],
                                selected: {_role},
                                onSelectionChanged: (s) =>
                                    setState(() => _role = s.first),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _role == 'builder'
                                  ? 'Pitch ideas or join a team with your skills.'
                                  : 'Guide teams and give feedback.',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      _label('Email'),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                        const InputDecoration(hintText: 'name@auca.ac.rw'),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      _label('Password'),
                      TextFormField(
                        controller: _password,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          hintText: 'At least 8 characters',
                          suffixIcon: _eye(),
                        ),
                        validator: _validatePassword,
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.topCenter,
                        child: _isLogin
                            ? const SizedBox(width: double.infinity)
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _label('Confirm password'),
                            TextFormField(
                              controller: _confirm,
                              obscureText: _hidePassword,
                              decoration: const InputDecoration(
                                  hintText: 'Type it again'),
                              validator: _validateConfirm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (auth.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      auth.error!,
                      style:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                FadeSlideIn(
                  delayMs: 300,
                  child: Column(
                    children: [
                      FilledButton(
                        onPressed: auth.busy ? null : _submit,
                        child: auth.busy
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(_isLogin ? 'Log in' : 'Create account'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: auth.busy ? null : _toggleMode,
                        child: Text(_isLogin
                            ? 'Create an account'
                            : 'I already have an account'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}