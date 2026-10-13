import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';
import 'tools.dart';

class TermLine {
  final String text;
  final Color color;
  const TermLine(this.text, this.color);
}

const termBanner = [
  '╔════════════════════════════╗',
  '║   HACKER PRO  v2.5.0       ║',
  '║   Simulation Terminal      ║',
  '╚════════════════════════════╝',
  "Type 'help' to see commands.",
];

const termChips = ['help', 'scan', 'sysinfo', 'tools', 'ping', 'matrix', 'banner', 'clear'];

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController ctrl = TextEditingController();
  final ScrollController sc = ScrollController();
  final FocusNode focus = FocusNode();
  final Random rnd = Random();
  final List<TermLine> lines = [];
  final List<TermLine> pending = [];
  final List<String> history = [];
  int hIdx = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    emit(termBanner);
    timer = Timer.periodic(const Duration(milliseconds: 70), (_) {
      if (pending.isEmpty) return;
      setState(() => lines.add(pending.removeAt(0)));
      scrollDown();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    ctrl.dispose();
    sc.dispose();
    focus.dispose();
    super.dispose();
  }

  void emit(List<String> texts, [Color c = kGreen]) {
    for (final t in texts) {
      pending.add(TermLine(t, c));
    }
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (sc.hasClients) sc.jumpTo(sc.position.maxScrollExtent);
    });
  }

  String caesar(String s, int k) {
    return String.fromCharCodes(s.runes.map((c) {
      if (c >= 65 && c <= 90) return (c - 65 + k) % 26 + 65;
      if (c >= 97 && c <= 122) return (c - 97 + k) % 26 + 97;
      return c;
    }));
  }

  void run(String raw) {
    final input = raw.trim();
    if (input.isEmpty) return;
    history.add(input);
    hIdx = history.length;
    pending.add(TermLine('root@hacker:~\$ $input', Colors.white));

    final parts = input.split(RegExp(r'\s+'));
    final cmd = parts.first.toLowerCase();
    final args = parts.skip(1).toList();

    switch (cmd) {
      case 'help':
        emit([
          'Available commands:',
          '  help      show this list',
          '  whoami    current user',
          '  pwd       current folder',
          '  ls        list files',
          '  date      date and time',
          '  sysinfo   device info (demo)',
          '  ifconfig  network info (demo)',
          '  scan      network scan (simulation)',
          '  ping [h]  ping a host (simulation)',
          '  tools     list app tools',
          '  echo <t>  print text',
          '  cipher <shift> <text>   Caesar cipher',
          '  matrix    code rain',
          '  history   previous commands',
          '  banner    show banner',
          '  about     about this terminal',
          '  clear     clear screen',
        ]);
        break;
      case 'whoami':
        emit(['root (demo user)']);
        break;
      case 'pwd':
        emit(['/home/hacker']);
        break;
      case 'ls':
        emit(['tools/   reports/   notes.txt']);
        break;
      case 'date':
        emit([DateTime.now().toString()]);
        break;
      case 'sysinfo':
        emit([
          'Device    : Android Phone',
          'OS        : Android 14',
          'CPU       : 8 cores',
          'RAM       : 4 GB',
          'Storage   : 64 GB',
          '(sample values, not real)',
        ]);
        break;
      case 'ifconfig':
        emit([
          'wlan0: flags=UP,RUNNING',
          '   inet 192.168.1.5  netmask 255.255.255.0',
          '   gateway 192.168.1.1',
          '(sample values, not real)',
        ]);
        break;
      case 'scan':
        emit([
          '[*] Scanning 192.168.1.0/24 (simulation)...',
          '[+] 192.168.1.1    Router',
          '[+] 192.168.1.5    This phone',
          '[+] 192.168.1.12   Laptop',
          '[+] 192.168.1.23   Smart TV',
          '[*] Done. 4 devices (demo data).',
        ]);
        break;
      case 'ping':
        var host = args.isEmpty ? '8.8.8.8' : args.first;
        if (host.length > 40) host = host.substring(0, 40);
        emit(['PING $host (simulation)']);
        for (int i = 0; i < 4; i++) {
          emit(['64 bytes from $host: time=${15 + rnd.nextInt(25)} ms']);
        }
        emit(['4 sent, 4 received, 0% loss (demo data)']);
        break;
      case 'tools':
        emit(['Arsenal tools (${allTools.length}):']);
        for (int i = 0; i < allTools.length; i++) {
          emit(['  ${(i + 1).toString().padLeft(2)}. ${allTools[i].name}']);
        }
        break;
      case 'echo':
        emit([args.join(' ')]);
        break;
      case 'cipher':
        if (args.length < 2 || int.tryParse(args.first) == null) {
          emit(['usage: cipher <shift> <text>'], Colors.amber);
        } else {
          final k = int.parse(args.first) % 26;
          final text = args.skip(1).join(' ');
          emit(['encoded: ${caesar(text, k)}']);
        }
        break;
      case 'matrix':
        const chars = '01ABCDEF#@\$%&*+=<>';
        for (int r = 0; r < 8; r++) {
          final s = StringBuffer();
          for (int i = 0; i < 28; i++) {
            s.write(rnd.nextInt(3) == 0 ? chars[rnd.nextInt(chars.length)] : ' ');
          }
          emit([s.toString()]);
        }
        break;
      case 'history':
        for (int i = 0; i < history.length; i++) {
          emit(['  ${i + 1}  ${history[i]}']);
        }
        break;
      case 'banner':
        emit(termBanner);
        break;
      case 'about':
        emit([
          'Hacker Pro Terminal v2.5.0',
          'এটা শেখা ও মজার জন্য বানানো সিমুলেশন টার্মিনাল।',
          'কোনো আসল হ্যাকিং বা নেটওয়ার্ক অ্যাক্সেস হয় না।',
        ]);
        break;
      case 'exit':
        emit(["নিচের বার থেকে অন্য ট্যাবে যাও।"], Colors.amber);
        break;
      case 'clear':
        lines.clear();
        pending.clear();
        break;
      default:
        emit(['command not found: $cmd  (type help)'], Colors.redAccent);
    }
    ctrl.clear();
    setState(() {});
    scrollDown();
    focus.requestFocus();
  }

  void prev() {
    if (history.isEmpty) return;
    if (hIdx > 0) hIdx--;
    ctrl.text = history[hIdx];
    ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
  }

  void next() {
    if (history.isEmpty) return;
    if (hIdx < history.length - 1) {
      hIdx++;
      ctrl.text = history[hIdx];
      ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
    } else {
      hIdx = history.length;
      ctrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.terminal, color: kGreen, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('TERMINAL',
                      style: TextStyle(
                          color: kGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.amber.withOpacity(0.7)),
                  ),
                  child: const Text('SIMULATION',
                      style: TextStyle(color: Colors.amber, fontSize: 9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPanel,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGreen.withOpacity(0.4)),
              ),
              child: ListView.builder(
                controller: sc,
                itemCount: lines.length,
                itemBuilder: (context, i) {
                  return SelectableText(
                    lines[i].text,
                    style: TextStyle(
                      color: lines[i].color,
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in termChips)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(c,
                          style: const TextStyle(color: kGreen, fontSize: 12)),
                      backgroundColor: kPanel,
                      side: BorderSide(color: kGreen.withOpacity(0.5)),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => run(c),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: kPanel,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kGreen.withOpacity(0.6)),
            ),
            child: Row(
              children: [
                const Text('\$',
                    style: TextStyle(
                        color: kGreen,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    focusNode: focus,
                    onSubmitted: run,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.send,
                    cursorColor: kGreen,
                    style: const TextStyle(color: kGreen, fontFamily: 'monospace'),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'type a command',
                      hintStyle: TextStyle(color: Colors.white30),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up, color: kGreen),
                  onPressed: prev,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: kGreen),
                  onPressed: next,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: kGreen),
                  onPressed: () => run(ctrl.text),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
