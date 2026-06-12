import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _displayName = "";
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _displayName = prefs.getString('displayName') ?? "User";
      _nameController.text = _displayName;
    });
  }

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', _nameController.text);

    if (!mounted) return;

    setState(() {
      _displayName = _nameController.text;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Name updated")));
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<void> _resetAll() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("This will delete all tasks. Continue?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageService.clearTasks();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!mounted) return;

      setState(() {
        _darkMode = false;
        _displayName = "User";
        _nameController.text = "User";
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All data reset")));
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
                _saveDarkMode(value);
              },
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Display Name: $_displayName"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Update Display Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(onPressed: _saveName, child: const Text("Save")),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _resetAll,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Reset All Data"),
            ),

            const SizedBox(height: 40),

            TextButton(onPressed: _logout, child: const Text("Logout")),
          ],
        ),
      ),
    );
  }
}
