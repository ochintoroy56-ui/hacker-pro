import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';

const kNotice =
    'সিমুলেশন মাত্র — এটা আসল হ্যাকিং নয়। কোনো ডিভাইস বা নেটওয়ার্কে কিছুই হচ্ছে না।';

class ToolDef {
  final String name;
  final String desc;
  final IconData icon;
  final Widget Function() page;
  const ToolDef(this.name, this.desc, this.icon, this.page);
}

// ---------- ১২টা টুলের তালিকা ----------
final List<ToolDef> allTools = [
  ToolDef('Wi-Fi Scanner', 'Find nearby networks', Icons.wifi,
      () => const SimPage(title: 'Wi-Fi Scanner', lines: wifiLines)),
  ToolDef('Port Scanner', 'Check open ports', Icons.router,
      () => const SimPage(title: 'Port Scanner', lines: portLines)),
  ToolDef('Network Mapper', 'List devices on network', Icons.hub,
      () => const SimPage(title: 'Network Mapper', lines: mapLines)),
  ToolDef('Vulnerability Scan', 'Check weak points', Icons.bug_report,
      () => const SimPage(title: 'Vulnerability Scan', lines: vulnLines)),
  ToolDef('Password Cracker', 'Animation with your word', Icons.password,
      () => const CrackerPage()),
  ToolDef('Packet Sniffer', 'Watch network packets', Icons.sensors,
      () => const SimPage(title: 'Packet Sniffer', lines: sniffLines)),
  ToolDef('DNS Lookup', 'Domain to IP', Icons.dns,
      () => const SimPage(title: 'DNS Lookup', lines: dnsLines)),
  ToolDef('Ping Tool', 'Test connection speed', Icons.network_ping,
      () => const SimPage(title: 'Ping Tool', lines: pingLines)),
  ToolDef('Traceroute', 'Follow the route', Icons.alt_route,
      () => const SimPage(title: 'Traceroute', lines: traceLines)),
  ToolDef('System Info', 'Device details (demo)', Icons.memory,
      () => const SimPage(title: 'System Info', lines: sysLines)),
  ToolDef('Cipher Lab', 'Caesar cipher encode/decode', Icons.enhanced_encryption,
      () => const CipherPage()),
  ToolDef('Matrix Rain', 'Falling code screen', Icons.grain,
      () => const MatrixPage()),
  ToolDef('Password Check', 'How strong is it?', Icons.lock_outline,
      () => const PasswordCheckPage()),
  ToolDef('Facebook Security', 'Account safety checkup', Icons.facebook,
      () => const CheckupPage(
            title: 'Facebook Security',
            icon: Icons.facebook,
            intro: 'তোমার Facebook অ্যাকাউন্ট কতটা নিরাপদ, নিজে মিলিয়ে দেখো। যেগুলো করেছ সেগুলোতে টিক দাও।',
            items: [
              'শক্ত ও অন্য কোথাও ব্যবহার না করা পাসওয়ার্ড দিয়েছি',
              'Two-factor authentication (2-ধাপের ভেরিফিকেশন) চালু আছে',
              'Login alerts চালু আছে',
              '"Where you\'re logged in" দেখে অচেনা ডিভাইস লগআউট করেছি',
              'অচেনা লিংক বা মেসেজে কখনো পাসওয়ার্ড দিই না',
              'অচেনা অ্যাপ বা ওয়েবসাইটের লগইন-অ্যাক্সেস সরিয়েছি',
              'রিকভারি ফোন নম্বর ও ইমেইল ঠিক আছে',
            ],
          )),
  ToolDef('Instagram Security', 'Account safety checkup', Icons.camera_alt_outlined,
      () => const CheckupPage(
            title: 'Instagram Security',
            icon: Icons.camera_alt_outlined,
            intro: 'তোমার Instagram অ্যাকাউন্ট নিরাপদ রাখার ধাপগুলো মিলিয়ে দেখো।',
            items: [
              'শক্ত ও আলাদা পাসওয়ার্ড ব্যবহার করছি',
              'Two-factor authentication চালু আছে',
              'Login activity দেখে অচেনা ডিভাইস লগআউট করেছি',
              '"ফলোয়ার বাড়ানোর" বা "ভেরিফাই করার" সাইটে পাসওয়ার্ড দিইনি',
              'Instagram-এর নামে আসা অচেনা ইমেইল/মেসেজের লিংকে ক্লিক করি না',
              'রিকভারি ইমেইল ও ফোন নম্বর ঠিক আছে',
            ],
          )),
  ToolDef('Gmail Security', 'Account safety checkup', Icons.mail_outline,
      () => const CheckupPage(
            title: 'Gmail Security',
            icon: Icons.mail_outline,
            intro: 'Gmail হলো অনেক অ্যাকাউন্টের চাবি। এটা নিরাপদ থাকলে বাকিগুলোও নিরাপদ থাকে।',
            items: [
              'শক্ত পাসওয়ার্ড দিয়েছি, যা অন্য কোথাও ব্যবহার করি না',
              '2-Step Verification চালু আছে',
              'Google-এর Security Checkup একবার করেছি',
              'রিকভারি ফোন নম্বর ও ইমেইল আপডেট করা আছে',
              'অচেনা অ্যাপ/সাইটের অ্যাক্সেস সরিয়েছি',
              'ফিশিং ইমেইল (ভুয়া "আপনার অ্যাকাউন্ট বন্ধ হবে") চিনতে পারি',
            ],
          )),
  ToolDef('Free Fire Security', 'Account safety checkup', Icons.sports_esports,
      () => const CheckupPage(
            title: 'Free Fire Security',
            icon: Icons.sports_esports,
            intro: 'গেম অ্যাকাউন্ট চুরি হওয়া খুব সাধারণ ঘটনা। এই ধাপগুলো মেনে চলো।',
            items: [
              'অ্যাকাউন্ট Facebook/Google/Apple-এর সাথে লিংক (bind) করা আছে',
              'লিংক করা অ্যাকাউন্টে শক্ত পাসওয়ার্ড ও 2-ধাপ ভেরিফিকেশন আছে',
              '"ফ্রি ডায়মন্ড" বা "হ্যাক" সাইটে লগইন করি না',
              'মড/হ্যাক APK ব্যবহার করি না (ব্যান ও ভাইরাসের ঝুঁকি)',
              'ডায়মন্ড শুধু অফিসিয়াল টপ-আপ থেকে কিনি',
              'OTP বা পাসওয়ার্ড কাউকে দিই না, বন্ধুকেও না',
            ],
          )),
  ToolDef('PUBG Security', 'Account safety checkup', Icons.sports_esports_outlined,
      () => const CheckupPage(
            title: 'PUBG Security',
            icon: Icons.sports_esports_outlined,
            intro: 'গেম অ্যাকাউন্ট আর ইন-গেম কেনাকাটা নিরাপদ রাখার ধাপগুলো দেখো।',
            items: [
              'অ্যাকাউন্ট Facebook/Google ইত্যাদির সাথে লিংক করা আছে',
              'লিংক করা অ্যাকাউন্টে শক্ত পাসওয়ার্ড ও 2-ধাপ ভেরিফিকেশন আছে',
              'UC শুধু অফিসিয়াল শপ থেকে কিনি',
              'চিট/হ্যাক অ্যাপ ব্যবহার করি না (ব্যান ও ম্যালওয়্যারের ঝুঁকি)',
              '"ফ্রি UC" লিংকে পাসওয়ার্ড বা OTP দিই না',
              'গেমের বন্ধুকেও লগইন তথ্য দিই না',
            ],
          )),
];

const wifiLines = [
  '[*] Starting Wi-Fi adapter...',
  '[*] Scanning channels 1-13...',
  '[+] HomeNet_5G       -42 dBm  WPA2',
  '[+] Neighbor_WiFi    -61 dBm  WPA2',
  '[+] Cafe_Free        -70 dBm  OPEN',
  '[+] Office_Secure    -75 dBm  WPA3',
  '[*] Scan finished. 4 networks (demo data).',
];

const portLines = [
  '[*] Target: 192.168.0.1 (sample)',
  '[*] Scanning ports 1-1024...',
  '[+] 22   open   SSH',
  '[+] 53   open   DNS',
  '[+] 80   open   HTTP',
  '[+] 443  open   HTTPS',
  '[-] 1020 other ports closed',
  '[*] Scan complete (demo data).',
];

const mapLines = [
  '[*] Mapping network...',
  '[+] 192.168.0.1    Router',
  '[+] 192.168.0.12   Laptop',
  '[+] 192.168.0.23   Smart TV',
  '[+] 192.168.0.31   Mobile',
  '[*] 4 devices found (demo data).',
];

const vulnLines = [
  '[*] Loading vulnerability database...',
  '[*] Checking outdated software...',
  '[!] Warning: weak password policy',
  '[!] Warning: updates not installed',
  '[+] Firewall enabled',
  '[+] Tip: turn on 2-step verification',
  '[*] Report ready (demo data).',
];

const sniffLines = [
  '[*] Listening on wlan0 (simulation)...',
  '[+] TCP  192.168.0.12 -> 142.250.x.x   443  len=1420',
  '[+] UDP  192.168.0.31 -> 8.8.8.8       53   len=74',
  '[+] TCP  192.168.0.23 -> 151.101.x.x   443  len=980',
  '[+] ICMP 192.168.0.1  -> 192.168.0.12  echo reply',
  '[*] Captured 4 packets (sample data).',
];

const dnsLines = [
  '[*] Query: example.com (sample)',
  '[+] A      93.184.216.34',
  '[+] AAAA   2606:2800:220:1:248:1893:25c8:1946',
  '[+] NS     a.iana-servers.net',
  '[*] Lookup finished (demo data).',
];

const pingLines = [
  'PING 8.8.8.8 (simulation)',
  '64 bytes: time=21 ms',
  '64 bytes: time=19 ms',
  '64 bytes: time=24 ms',
  '64 bytes: time=20 ms',
  '4 sent, 4 received, 0% loss (demo data).',
];

const traceLines = [
  'Tracing route (simulation)...',
  ' 1   192.168.0.1      2 ms',
  ' 2   10.10.0.1        9 ms',
  ' 3   172.16.4.1      18 ms',
  ' 4   8.8.8.8         24 ms',
  'Trace complete (demo data).',
];

const sysLines = [
  '[*] Collecting system info...',
  'Device    : Android Phone',
  'RAM       : 4 GB',
  'Storage   : 64 GB',
  'Network   : Wi-Fi connected',
  '[*] Done (sample values, not real).',
];

// ---------- ছোট নোটিশ ----------
class SimNotice extends StatelessWidget {
  const SimNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.12),
        border: Border.all(color: Colors.amber.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(kNotice,
          style: TextStyle(color: Colors.amber, fontSize: 12)),
    );
  }
}

Widget toolScaffold(String title, Widget body) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: kBg,
      foregroundColor: kGreen,
    ),
    body: SafeArea(
      child: Padding(padding: const EdgeInsets.all(12), child: body),
    ),
  );
}

// ================= Tools Arsenal স্ক্রিন =================
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Panel(
            child: Row(
              children: [
                const Icon(Icons.gps_fixed, color: kGreen, size: 28),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOOLS ARSENAL',
                          style: TextStyle(
                              color: kGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                      Text('18 tools • simulations & security checks',
                          style: TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ),
                const DemoChip(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const SimNotice(),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
              ),
              itemCount: allTools.length,
              itemBuilder: (context, i) {
                final t = allTools[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => t.page()),
                  ),
                  child: Panel(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(t.icon, color: kGreen, size: 30),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(t.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ),
                        const SizedBox(height: 3),
                        Text(t.desc,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 10.5)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= সাধারণ সিমুলেশন পেজ =================
class SimPage extends StatefulWidget {
  final String title;
  final List<String> lines;
  const SimPage({super.key, required this.title, required this.lines});

  @override
  State<SimPage> createState() => _SimPageState();
}

class _SimPageState extends State<SimPage> {
  final List<String> shown = [];
  final ScrollController sc = ScrollController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() {
    timer?.cancel();
    setState(() => shown.clear());
    timer = Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (shown.length >= widget.lines.length) {
        t.cancel();
        setState(() {});
        return;
      }
      setState(() => shown.add(widget.lines[shown.length]));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (sc.hasClients) sc.jumpTo(sc.position.maxScrollExtent);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = shown.length >= widget.lines.length;
    return toolScaffold(
      widget.title,
      Column(
        children: [
          const SimNotice(),
          LinearProgressIndicator(
            value: shown.length / widget.lines.length,
            color: kGreen,
            backgroundColor: kPanel,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPanel,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kGreen.withOpacity(0.3)),
              ),
              child: ListView(
                controller: sc,
                children: [
                  for (final l in shown)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(l,
                          style: const TextStyle(
                              color: kGreen,
                              fontFamily: 'monospace',
                              fontSize: 12.5)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (done)
            ElevatedButton.icon(
              onPressed: start,
              icon: const Icon(Icons.refresh),
              label: const Text('Run again'),
            ),
        ],
      ),
    );
  }
}

// ================= Password Cracker (শুধু অ্যানিমেশন) =================
class CrackerPage extends StatefulWidget {
  const CrackerPage({super.key});

  @override
  State<CrackerPage> createState() => _CrackerPageState();
}

class _CrackerPageState extends State<CrackerPage> {
  final TextEditingController ctrl = TextEditingController(text: 'bangladesh');
  final Random rnd = Random();
  static const chars = 'abcdefghijklmnopqrstuvwxyz0123456789@#\$%&*';
  Timer? timer;
  String display = '';
  int locked = 0;
  bool running = false;

  void start() {
    final target = ctrl.text.trim();
    if (target.isEmpty) return;
    timer?.cancel();
    locked = 0;
    running = true;
    int tick = 0;
    timer = Timer.periodic(const Duration(milliseconds: 70), (t) {
      tick++;
      if (tick % 8 == 0 && locked < target.length) locked++;
      final s = StringBuffer();
      for (int i = 0; i < target.length; i++) {
        s.write(i < locked ? target[i] : chars[rnd.nextInt(chars.length)]);
      }
      setState(() => display = s.toString());
      if (locked >= target.length) {
        t.cancel();
        setState(() => running = false);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = ctrl.text.trim();
    final done = !running && locked > 0 && locked >= target.length;
    return toolScaffold(
      'Password Cracker',
      SingleChildScrollView(
        child: Column(
          children: [
            const SimNotice(),
            const Text(
              'নিজের একটা শব্দ লেখো। অ্যাপ শুধু অ্যানিমেশন দেখাবে। এটা কোনো আসল পাসওয়ার্ড ভাঙে না।',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type any word',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              display,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: done ? kGreen : Colors.redAccent,
                fontFamily: 'monospace',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10),
            if (done)
              const Text('✔ Animation finished (everything is fake)',
                  style: TextStyle(color: kGreen)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: running ? null : start,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Cipher Lab (সত্যিকারের Caesar cipher, নিরীহ) =================
class CipherPage extends StatefulWidget {
  const CipherPage({super.key});

  @override
  State<CipherPage> createState() => _CipherPageState();
}

class _CipherPageState extends State<CipherPage> {
  final TextEditingController ctrl = TextEditingController(text: 'Hello Hacker Pro');
  double shift = 3;

  String caesar(String s, int k) {
    return String.fromCharCodes(s.runes.map((c) {
      if (c >= 65 && c <= 90) return (c - 65 + k) % 26 + 65;
      if (c >= 97 && c <= 122) return (c - 97 + k) % 26 + 97;
      return c;
    }));
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final k = shift.round();
    final encoded = caesar(ctrl.text, k);
    final decoded = caesar(ctrl.text, 26 - k);
    return toolScaffold(
      'Cipher Lab',
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Caesar cipher হলো পুরনো আমলের সহজ কোড-ভাষা। প্রতিটা অক্ষর কয়েক ধাপ সরিয়ে লেখা হয়। শেখার জন্য মজার একটা টুল।',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your text',
              ),
            ),
            const SizedBox(height: 12),
            Text('Shift: $k', style: const TextStyle(color: kGreen)),
            Slider(
              value: shift,
              min: 1,
              max: 25,
              divisions: 24,
              activeColor: kGreen,
              onChanged: (v) => setState(() => shift = v),
            ),
            const SizedBox(height: 8),
            resultBox('Encoded (shift +$k)', encoded),
            const SizedBox(height: 10),
            resultBox('Decoded (shift -$k)', decoded),
          ],
        ),
      ),
    );
  }

  Widget resultBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPanel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGreen.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: kGreen, fontFamily: 'monospace', fontSize: 16)),
        ],
      ),
    );
  }
}

// ================= Matrix Rain =================
class MatrixPage extends StatefulWidget {
  const MatrixPage({super.key});

  @override
  State<MatrixPage> createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  final Random rnd = Random();
  static const chars = '01ABCDEF#@\$%&*+=<>';
  final List<String> rows = [];
  Timer? timer;
  int cols = 30;
  int maxRows = 40;

  String makeRow() {
    final s = StringBuffer();
    for (int i = 0; i < cols; i++) {
      s.write(rnd.nextInt(3) == 0 ? chars[rnd.nextInt(chars.length)] : ' ');
    }
    return s.toString();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 90), (_) {
      setState(() {
        rows.insert(0, makeRow());
        if (rows.length > maxRows) rows.removeLast();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix Rain',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kBg,
        foregroundColor: kGreen,
      ),
      body: LayoutBuilder(builder: (context, c) {
        cols = (c.maxWidth / 12).floor();
        maxRows = (c.maxHeight / 18).floor();
        return ClipRect(
          child: Column(
            children: [
              for (int i = rows.length - 1; i >= 0; i--)
                Opacity(
                  opacity: (1 - i / (maxRows == 0 ? 1 : maxRows))
                      .clamp(0.1, 1.0)
                      .toDouble(),
                  child: Text(rows[i],
                      maxLines: 1,
                      style: const TextStyle(
                          color: kGreen,
                          fontFamily: 'monospace',
                          fontSize: 16,
                          height: 1.1)),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ================= অ্যাকাউন্ট সিকিউরিটি চেকলিস্ট =================
class CheckupPage extends StatefulWidget {
  final String title;
  final IconData icon;
  final String intro;
  final List<String> items;
  const CheckupPage({
    super.key,
    required this.title,
    required this.icon,
    required this.intro,
    required this.items,
  });

  @override
  State<CheckupPage> createState() => _CheckupPageState();
}

class _CheckupPageState extends State<CheckupPage> {
  late final List<bool> done = List.filled(widget.items.length, false);

  @override
  Widget build(BuildContext context) {
    final count = done.where((d) => d).length;
    final score = count / widget.items.length;
    final Color color = score >= 1
        ? kGreen
        : (score >= 0.6 ? Colors.amber : Colors.redAccent);
    final String msg = score >= 1
        ? 'দারুণ! তোমার অ্যাকাউন্ট অনেক নিরাপদ।'
        : (score >= 0.6
            ? 'ভালো অবস্থা। বাকি ধাপগুলোও করে ফেলো।'
            : 'ঝুঁকি আছে। নিচের ধাপগুলো করে নাও।');
    return toolScaffold(
      widget.title,
      Column(
        children: [
          Panel(
            child: Row(
              children: [
                Icon(widget.icon, color: kGreen, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.intro,
                      style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Security score: ${(score * 100).round()}%',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('$count / ${widget.items.length}',
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: score,
            color: color,
            backgroundColor: Colors.white12,
            minHeight: 6,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(msg, style: TextStyle(color: color, fontSize: 12.5)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, i) {
                return CheckboxListTile(
                  value: done[i],
                  activeColor: kGreen,
                  checkColor: Colors.black,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (v) => setState(() => done[i] = v ?? false),
                  title: Text(widget.items[i],
                      style: const TextStyle(color: Colors.white, fontSize: 13.5)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= Password Strength Check (আসল, ফোনেই চলে) =================
class PasswordCheckPage extends StatefulWidget {
  const PasswordCheckPage({super.key});

  @override
  State<PasswordCheckPage> createState() => _PasswordCheckPageState();
}

class _PasswordCheckPageState extends State<PasswordCheckPage> {
  final TextEditingController ctrl = TextEditingController();
  bool hide = true;

  int score(String p) {
    int s = 0;
    if (p.length >= 8) s++;
    if (p.length >= 12) s++;
    if (p.length >= 16) s++;
    if (RegExp(r'[a-z]').hasMatch(p)) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) s++;
    final l = p.toLowerCase();
    if (l.contains('password') || l.contains('123456') || l.contains('qwerty')) {
      s -= 3;
    }
    if (s < 0) s = 0;
    if (s > 7) s = 7;
    return s;
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = ctrl.text;
    final s = score(p);
    String label;
    Color color;
    if (p.isEmpty) {
      label = 'কিছু লিখে দেখো';
      color = Colors.white54;
    } else if (s <= 2) {
      label = 'খুবই দুর্বল';
      color = Colors.redAccent;
    } else if (s <= 4) {
      label = 'মোটামুটি, আরও শক্ত করো';
      color = Colors.orange;
    } else if (s == 5) {
      label = 'ভালো';
      color = Colors.amber;
    } else {
      label = 'অনেক শক্ত';
      color = kGreen;
    }
    return toolScaffold(
      'Password Check',
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'পাসওয়ার্ড কতটা শক্ত তা দেখো। সবকিছু তোমার ফোনেই হয়, কোথাও পাঠানো হয় না। তবু আসল পাসওয়ার্ডের বদলে একই ধরনের নমুনা লিখে দেখাই ভালো।',
              style: TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              obscureText: hide,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Type a password to test',
                suffixIcon: IconButton(
                  icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => hide = !hide),
                ),
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: p.isEmpty ? 0 : s / 7,
              color: color,
              backgroundColor: Colors.white12,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            const Text('শক্ত পাসওয়ার্ডের টিপস:',
                style: TextStyle(color: kGreen, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text(
              '• কমপক্ষে ১২ অক্ষর রাখো\n'
              '• বড় হাতের, ছোট হাতের অক্ষর, সংখ্যা ও চিহ্ন মেশাও\n'
              '• নাম, জন্মতারিখ বা 123456 ব্যবহার করো না\n'
              '• প্রতিটা অ্যাকাউন্টে আলাদা পাসওয়ার্ড দাও\n'
              '• ৩-৪টা এলোমেলো শব্দ জুড়ে লম্বা বাক্য বানানো সহজ ও শক্ত',
              style: TextStyle(color: Colors.white70, height: 1.6, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
