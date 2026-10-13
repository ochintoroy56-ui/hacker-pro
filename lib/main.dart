import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tools.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: kBg,
  ));
  runApp(const HackerProApp());
}

const kGreen = Color(0xFF00FF88);
const kCyan = Color(0xFF4DE8FF);
const kBg = Color(0xFF030A07);
const kPanel = Color(0xFF08140F);

class HackerProApp extends StatelessWidget {
  const HackerProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hacker Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBg,
        colorScheme: const ColorScheme.dark(primary: kGreen),
      ),
      home: const Shell(),
    );
  }
}

// ================= মূল কাঠামো + নিচের নেভিগেশন =================
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: [
            HomeScreen(onOpenTools: () => setState(() => index = 1)),
            const ToolsScreen(),
            const ComingSoon(
                title: 'Terminal', step: 'Step 3', icon: Icons.terminal),
            const ComingSoon(
                title: 'Settings', step: 'Step 4', icon: Icons.settings),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kPanel,
          border: Border(top: BorderSide(color: kGreen.withOpacity(0.4))),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: kGreen,
          unselectedItemColor: Colors.white60,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view), label: 'Tools'),
            BottomNavigationBarItem(
                icon: Icon(Icons.terminal), label: 'Terminal'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class ComingSoon extends StatelessWidget {
  final String title;
  final String step;
  final IconData icon;
  const ComingSoon(
      {super.key, required this.title, required this.step, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kGreen, size: 60),
          const SizedBox(height: 14),
          Text(title,
              style: const TextStyle(
                  color: kGreen, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$step-এ বানানো হবে',
              style: const TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }
}

// ================= ছোট ছোট কমন উইজেট =================
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Panel(
      {super.key, required this.child, this.padding = const EdgeInsets.all(10)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: kPanel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kGreen.withOpacity(0.45)),
        boxShadow: [BoxShadow(color: kGreen.withOpacity(0.12), blurRadius: 10)],
      ),
      child: child,
    );
  }
}

class DemoChip extends StatelessWidget {
  const DemoChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: kGreen.withOpacity(0.6)),
      ),
      child: const Text('DEMO DATA',
          style: TextStyle(color: kGreen, fontSize: 9, letterSpacing: 0.5)),
    );
  }
}

// ================= হোম স্ক্রিন =================
class HomeScreen extends StatefulWidget {
  final VoidCallback onOpenTools;
  const HomeScreen({super.key, required this.onOpenTools});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Random rnd = Random();
  final List<String> boot = const [
    'Initializing Hacker Pro v2.5.0...',
    'Loading modules...',
    'Checking system services...',
    'All systems online.',
    'Ready for your command...',
  ];
  final List<String> term = [];
  Timer? bootTimer;
  Timer? clockTimer;
  double cpu = 0.34, ram = 0.52, storage = 0.64;
  int seed = 1;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    startBoot();
    clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
        seed++;
        if (seed % 2 == 0) {
          cpu = (cpu + (rnd.nextDouble() - 0.5) * 0.12).clamp(0.15, 0.85).toDouble();
          ram = (ram + (rnd.nextDouble() - 0.5) * 0.06).clamp(0.3, 0.8).toDouble();
        }
      });
    });
  }

  void startBoot() {
    bootTimer?.cancel();
    term.clear();
    bootTimer = Timer.periodic(const Duration(milliseconds: 700), (t) {
      if (term.length >= boot.length) {
        t.cancel();
        return;
      }
      setState(() => term.add(boot[term.length]));
    });
  }

  @override
  void dispose() {
    bootTimer?.cancel();
    clockTimer?.cancel();
    super.dispose();
  }

  String get timeText {
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  String get dateText {
    const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d[now.weekday - 1]}, ${m[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          header(),
          const SizedBox(height: 10),
          terminalRow(),
          const SizedBox(height: 10),
          statsRow(),
          const SizedBox(height: 10),
          globalNetwork(),
          const SizedBox(height: 12),
          openTools(),
          const SizedBox(height: 12),
          statusTiles(),
          const SizedBox(height: 10),
          const Text(
            'সব তথ্য ডেমো/নকল — এটা আসল হ্যাকিং টুল নয়।',
            style: TextStyle(color: Colors.amber, fontSize: 11),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ---------- হেডার ----------
  Widget header() {
    return Panel(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kGreen, width: 1.5),
              boxShadow: [BoxShadow(color: kGreen.withOpacity(0.4), blurRadius: 10)],
            ),
            child: const Icon(Icons.security, color: kGreen, size: 26),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5),
                      children: [
                        TextSpan(text: 'HACKER ', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'PRO', style: TextStyle(color: kGreen)),
                      ],
                    ),
                  ),
                ),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('EXPLORE • SCAN • ANALYZE • CONTROL',
                      style: TextStyle(color: kCyan, fontSize: 10, letterSpacing: 1)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kGreen.withOpacity(0.5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('● v2.5.0',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                Text('Android 14', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- টার্মিনাল + ডান পাশের কার্ড ----------
  Widget terminalRow() {
    return SizedBox(
      height: 215,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Panel(
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    bottom: 6,
                    child: Opacity(
                      opacity: 0.55,
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: CustomPaint(painter: GlobePainter()),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.terminal, color: kGreen, size: 16),
                          SizedBox(width: 6),
                          Text('SYSTEM TERMINAL',
                              style: TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const Divider(color: Color(0x5500FF88), height: 12),
                      Expanded(
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (final l in term)
                              Text('[+] $l',
                                  style: const TextStyle(
                                      color: kGreen, fontFamily: 'monospace', fontSize: 10.5, height: 1.5)),
                            const Text('root@hacker:~\$ █',
                                style: TextStyle(color: kGreen, fontFamily: 'monospace', fontSize: 11)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            bootTimer?.cancel();
                            setState(() => term.clear());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: kGreen.withOpacity(0.6)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete_outline, color: kGreen, size: 13),
                                SizedBox(width: 4),
                                Text('CLEAR', style: TextStyle(color: kGreen, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(child: miniCard(Icons.wifi, 'NETWORK', 'Connected', '192.168.1.5')),
                const SizedBox(height: 6),
                Expanded(child: miniCard(Icons.battery_charging_full, 'BATTERY', '78%', null, progress: 0.78)),
                const SizedBox(height: 6),
                Expanded(child: miniCard(Icons.shield_outlined, 'SECURITY', 'Normal', null)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget miniCard(IconData icon, String title, String value, String? sub,
      {double? progress}) {
    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: kGreen, size: 22),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(value,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                if (sub != null)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 9)),
                  ),
                if (progress != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: LinearProgressIndicator(
                        value: progress, color: kGreen, backgroundColor: Colors.white12, minHeight: 4),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- CPU / RAM / STORAGE / TIME ----------
  Widget statsRow() {
    return SizedBox(
      height: 98,
      child: Row(
        children: [
          Expanded(child: statCard(Icons.memory, 'CPU', cpu, 1)),
          const SizedBox(width: 6),
          Expanded(child: statCard(Icons.developer_board, 'RAM', ram, 2)),
          const SizedBox(width: 6),
          Expanded(child: statCard(Icons.storage, 'STORAGE', storage, 3)),
          const SizedBox(width: 6),
          Expanded(
            child: Panel(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.access_time, color: kGreen, size: 14),
                      SizedBox(width: 3),
                      Text('TIME', style: TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(timeText,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 3),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(dateText, style: const TextStyle(color: Colors.white60, fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statCard(IconData icon, String title, double v, int sd) {
    return Panel(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kGreen, size: 14),
              const SizedBox(width: 3),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(title,
                      style: const TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text('${(v * 100).round()}%',
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          LinearProgressIndicator(value: v, color: kGreen, backgroundColor: Colors.white12, minHeight: 4),
          const Spacer(),
          SizedBox(
            height: 22,
            width: double.infinity,
            child: CustomPaint(painter: SparkPainter(sd * 100 + seed ~/ 3)),
          ),
        ],
      ),
    );
  }

  // ---------- Global Network + Recent Activity ----------
  Widget globalNetwork() {
    const acts = [
      ['07:24', 'App started', 'HACKER PRO v2.5.0'],
      ['07:22', 'Bluetooth enabled', 'Scanning...'],
      ['07:20', 'Network check', 'Connected'],
      ['07:15', 'Permissions granted', 'All required'],
    ];
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.public, color: kGreen, size: 16),
              SizedBox(width: 6),
              Text('GLOBAL NETWORK',
                  style: TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 12)),
              Spacer(),
              DemoChip(),
            ],
          ),
          const Divider(color: Color(0x5500FF88), height: 14),
          SizedBox(
            height: 110,
            child: Row(
              children: [
                const SizedBox(
                  width: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatLine('Nodes', '12'),
                      StatLine('Active', '5'),
                      StatLine('Latency', '42 ms'),
                      StatLine('Packets', '1.2k'),
                    ],
                  ),
                ),
                Expanded(child: CustomPaint(painter: MapPainter(), child: const SizedBox.expand())),
              ],
            ),
          ),
          const Divider(color: Color(0x5500FF88), height: 16),
          const Text('RECENT ACTIVITY',
              style: TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 11)),
          const SizedBox(height: 6),
          for (final a in acts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, color: kGreen, size: 8),
                  const SizedBox(width: 8),
                  Text(a[0], style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a[1], style: const TextStyle(color: Colors.white, fontSize: 12)),
                        Text(a[2], style: const TextStyle(color: Colors.white54, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------- OPEN TOOLS / ARSENAL ----------
  Widget openTools() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: widget.onOpenTools,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(colors: [
            kGreen.withOpacity(0.22),
            kGreen.withOpacity(0.06),
          ]),
          border: Border.all(color: kGreen, width: 1.6),
          boxShadow: [BoxShadow(color: kGreen.withOpacity(0.35), blurRadius: 14)],
        ),
        child: const Row(
          children: [
            Icon(Icons.gps_fixed, color: kGreen, size: 34),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OPEN TOOLS / ARSENAL',
                      style: TextStyle(color: kGreen, fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(height: 2),
                  Text('Access 18 powerful tools',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.keyboard_double_arrow_right, color: kGreen, size: 28),
          ],
        ),
      ),
    );
  }

  // ---------- নিচের ৪টা স্ট্যাটাস টাইল ----------
  Widget statusTiles() {
    Widget tile(IconData icon, String title, String status) {
      return Expanded(
        child: Panel(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            children: [
              Icon(icon, color: kGreen, size: 26),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle, color: kGreen, size: 7),
                  const SizedBox(width: 4),
                  Text(status, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tile(Icons.language, 'NETWORK STATUS', 'Online'),
        const SizedBox(width: 6),
        tile(Icons.bluetooth, 'BLUETOOTH', 'Enabled'),
        const SizedBox(width: 6),
        tile(Icons.mic_none, 'AUDIO SYSTEM', 'Ready'),
        const SizedBox(width: 6),
        tile(Icons.verified_user_outlined, 'SECURITY', 'Normal'),
      ],
    );
  }
}

class StatLine extends StatelessWidget {
  final String label;
  final String value;
  const StatLine(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ================= ছবি আঁকার painter =================
class GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) / 2 - 2;
    final line = Paint()
      ..color = kGreen.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(colors: [
          kGreen.withOpacity(0.25),
          kGreen.withOpacity(0.04),
        ]).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawCircle(c, r, line..strokeWidth = 1.4);
    line.strokeWidth = 0.7;
    for (final f in [-0.6, -0.3, 0.0, 0.3, 0.6]) {
      final y = c.dy + f * r;
      final hw = sqrt(r * r - (f * r) * (f * r));
      canvas.drawLine(Offset(c.dx - hw, y), Offset(c.dx + hw, y), line);
    }
    for (final k in [1, 2, 3]) {
      canvas.drawOval(Rect.fromCenter(center: c, width: 2 * r * k / 4, height: 2 * r), line);
    }
    final rnd = Random(7);
    final pts = <Offset>[];
    for (int i = 0; i < 12; i++) {
      final a = rnd.nextDouble() * 2 * pi;
      final d = sqrt(rnd.nextDouble()) * r * 0.9;
      pts.add(c + Offset(cos(a) * d, sin(a) * d));
    }
    final link = Paint()
      ..color = Colors.redAccent.withOpacity(0.6)
      ..strokeWidth = 0.7;
    for (int i = 0; i < pts.length - 1; i += 2) {
      canvas.drawLine(pts[i], pts[i + 1], link);
    }
    for (int i = 0; i < pts.length; i++) {
      canvas.drawCircle(pts[i], 2, Paint()..color = i % 3 == 0 ? Colors.redAccent : kGreen);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = kGreen.withOpacity(0.10)
      ..strokeWidth = 0.6;
    for (double x = 0; x < size.width; x += 18) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 18) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final rnd = Random(11);
    final pts = List.generate(
      22,
      (_) => Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
    );
    final link = Paint()
      ..color = kGreen.withOpacity(0.35)
      ..strokeWidth = 0.7;
    for (int i = 0; i < pts.length; i++) {
      for (int j = i + 1; j < pts.length; j++) {
        if ((pts[i] - pts[j]).distance < size.width * 0.28) {
          canvas.drawLine(pts[i], pts[j], link);
        }
      }
    }
    for (int i = 0; i < pts.length; i++) {
      canvas.drawCircle(
        pts[i],
        i % 7 == 0 ? 3 : 2,
        Paint()..color = i % 7 == 0 ? Colors.redAccent : kGreen,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SparkPainter extends CustomPainter {
  final int seed;
  SparkPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    final path = Path();
    const n = 22;
    for (int i = 0; i < n; i++) {
      final x = size.width * i / (n - 1);
      final y = size.height * (0.15 + 0.75 * rnd.nextDouble());
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = kGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant SparkPainter old) => old.seed != seed;
}
