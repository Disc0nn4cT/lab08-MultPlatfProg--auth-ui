import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// Патерни для ч/б-друку
enum PatternKind { xHatch, stripes, dots }

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PatternKind _pattern = PatternKind.xHatch;

  void _cyclePattern() {
    setState(() {
      _pattern = PatternKind.values[(_pattern.index + 1) % PatternKind.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(seedColor: Colors.indigo);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 08 — Auth Themed + Patterns',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: cs,
        appBarTheme: AppBarTheme(
          backgroundColor: cs.surfaceVariant,
          foregroundColor: cs.onSurfaceVariant,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cs.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: cs.outline),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: cs.primary, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: SignInScreen(pattern: _pattern, onChangePattern: _cyclePattern),
    );
  }
}

/// ------------------------------
/// 1) SIGN IN
/// ------------------------------
class SignInScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const SignInScreen({super.key, required this.pattern, required this.onChangePattern});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();

  @override
  void dispose() { _email.dispose(); _pass.dispose(); super.dispose(); }

  void _dialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Message'),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final cs  = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        actions: [
          TextButton(
            onPressed: widget.onChangePattern,
            child: Text('Pattern: ${widget.pattern.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
        flexibleSpace: PatternHeader(pattern: widget.pattern),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlutterLogo(size: 84),
                const SizedBox(height: 16),
                Text('Flutter', textAlign: TextAlign.center, style: txt.titleLarge),
                const SizedBox(height: 24),

                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', hintText: 'name@example.com'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),

                PatternButton(
                  pattern: widget.pattern,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignupScreen(
                          pattern: widget.pattern,
                          onChangePattern: widget.onChangePattern,
                        ),
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: PatternButton.filled(
                        pattern: widget.pattern,
                        onPressed: () => _dialog('Login: need to implement'),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PatternButton.outline(
                        pattern: widget.pattern,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResetPasswordScreen(
                                pattern: widget.pattern,
                                onChangePattern: widget.onChangePattern,
                              ),
                            ),
                          );
                        },
                        child: const Text('Reset password'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Text(
                  'Патерни видно на ч/б друці: X-hatch / Stripes / Dots',
                  style: txt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.7)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------
/// 2) SIGN UP
/// ------------------------------
class SignupScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const SignupScreen({super.key, required this.pattern, required this.onChangePattern});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name  = TextEditingController();
  final _email = TextEditingController();
  final _pass  = TextEditingController();

  @override
  void dispose() { _name.dispose(); _email.dispose(); _pass.dispose(); super.dispose(); }

  void _dialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Message'),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        actions: [
          TextButton(
            onPressed: widget.onChangePattern,
            child: Text('Pattern: ${widget.pattern.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
        flexibleSpace: PatternHeader(pattern: widget.pattern),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlutterLogo(size: 72),
                const SizedBox(height: 16),

                TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),

                PatternButton.filled(
                  pattern: widget.pattern,
                  onPressed: () => _dialog('Registration: need to implement'),
                  child: const Text('Create account'),
                ),
                const SizedBox(height: 12),
                PatternButton.outline(
                  pattern: widget.pattern,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------
/// 3) RESET PASSWORD
/// ------------------------------
class ResetPasswordScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const ResetPasswordScreen({super.key, required this.pattern, required this.onChangePattern});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _email = TextEditingController();
  @override
  void dispose() { _email.dispose(); super.dispose(); }

  void _dialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Message'),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        actions: [
          TextButton(
            onPressed: widget.onChangePattern,
            child: Text('Pattern: ${widget.pattern.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
        flexibleSpace: PatternHeader(pattern: widget.pattern),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlutterLogo(size: 72),
                const SizedBox(height: 16),

                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 20),

                PatternButton.filled(
                  pattern: widget.pattern,
                  onPressed: () => _dialog('Reset link sent (demo)'),
                  child: const Text('Send reset link'),
                ),
                const SizedBox(height: 12),
                PatternButton.outline(
                  pattern: widget.pattern,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------
/// Спільна “патернова” шапка (для AppBar)
/// ------------------------------
class PatternHeader extends StatelessWidget implements PreferredSizeWidget {
  final PatternKind pattern;
  const PatternHeader({super.key, required this.pattern});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: .999,
        child: PatternBox(
          pattern: pattern,
          gap: 10,
          stroke: 1.6,
          opacity: .18,
        ),
      ),
    );
  }
}

/// ------------------------------
/// Патерн-підкладка + кнопки
/// ------------------------------
class PatternBox extends StatelessWidget {
  final PatternKind pattern;
  final double gap;
  final double stroke;
  final double opacity;
  final BorderRadius? radius;

  const PatternBox({
    super.key,
    required this.pattern,
    this.gap = 8,
    this.stroke = 1.5,
    this.opacity = .12,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PatternPainter(
        pattern: pattern,
        gap: gap,
        stroke: stroke,
        color: Colors.black.withOpacity(opacity),
      ),
      child: SizedBox.expand(
        child: radius == null ? null : ClipRRect(borderRadius: radius!, child: const SizedBox.expand()),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final PatternKind pattern;
  final double gap;
  final double stroke;
  final Color color;

  _PatternPainter({required this.pattern, required this.gap, required this.stroke, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    switch (pattern) {
      case PatternKind.xHatch:
        for (double y = 0; y < size.height; y += gap) {
          for (double x = 0; x < size.width; x += gap) {
            canvas.drawLine(Offset(x, y), Offset(x + gap * .6, y + gap * .6), paint);
            canvas.drawLine(Offset(x + gap * .6, y), Offset(x, y + gap * .6), paint);
          }
        }
        break;
      case PatternKind.stripes:
        for (double d = -size.height; d < size.width; d += gap) {
          canvas.drawLine(Offset(d, 0), Offset(d + size.height, size.height), paint);
        }
        break;
      case PatternKind.dots:
        final dotPaint = Paint()..color = color..style = PaintingStyle.fill;
        for (double y = 0; y < size.height; y += gap) {
          for (double x = 0; x < size.width; x += gap) {
            canvas.drawCircle(Offset(x + gap * .3, y + gap * .3), stroke, dotPaint);
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter old) =>
      old.pattern != pattern || old.gap != gap || old.stroke != stroke || old.color != color;
}

class PatternButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final PatternKind pattern;
  final double radius;
  final EdgeInsets padding;

  const PatternButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.pattern,
    this.radius = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  const PatternButton.filled({
    super.key,
    required this.child,
    required this.onPressed,
    required this.pattern,
    this.radius = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  const PatternButton.outline({
    super.key,
    required this.child,
    required this.onPressed,
    required this.pattern,
    this.radius = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: cs.outline, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: cs.surface.withOpacity(.45),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: PatternBox(
                    pattern: pattern,
                    gap: 10,
                    stroke: 1.4,
                    opacity: .18,
                    radius: BorderRadius.circular(radius),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: padding.vertical / 2),
                child: Center(
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
