import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Sonu Agarwal";
  String position = "Developer";
  String photoUrl = "https://i.pravatar.cc/150?img=3";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      name = prefs.getString("profileName") ?? name;
      position = prefs.getString("profilePosition") ?? position;
      photoUrl = prefs.getString("profilePhoto") ?? photoUrl;
    });
  }

  Future<void> _saveProfile(
    String newName,
    String newPos,
    String newPhoto,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("profileName", newName);
    await prefs.setString("profilePosition", newPos);
    await prefs.setString("profilePhoto", newPhoto);

    if (!mounted) return;

    setState(() {
      name = newName;
      position = newPos;
      photoUrl = newPhoto;
    });
  }

  // Stats
  Widget _buildStat(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _divider() {
    return const SizedBox(height: 40, child: VerticalDivider(thickness: 1));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar with GestureDetector
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tap to change photo")),
                );
              },
              onLongPress: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Remove photo?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Remove"),
                      ),
                    ],
                  ),
                );

                if (!mounted) return;

                if (confirm == true) {
                  setState(() {
                    photoUrl = "https://i.pravatar.cc/150?img=3";
                  });
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              name,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Position
            Text(
              position,
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                _buildStat("120", "Posts"),
                _divider(),
                _buildStat("5.2K", "Followers"),
                _divider(),
                _buildStat("300", "Following"),
              ],
            ),

            const SizedBox(height: 20),

            // Info Card
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text("sonu@example.com"),
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Gurugram, India"),
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text("Joined: Jan 2024"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Edit Profile (SnackBar + Navigation)
            OutlinedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit Profile clicked")),
                );

                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(
                      name: name,
                      position: position,
                      photoUrl: photoUrl,
                    ),
                  ),
                );

                if (!mounted) return;

                if (updated != null && updated is Map) {
                  await _saveProfile(
                    updated["name"],
                    updated["position"],
                    updated["photo"],
                  );
                }
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Profile Screen (kept intact)
class EditProfileScreen extends StatefulWidget {
  final String name;
  final String position;
  final String photoUrl;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.position,
    required this.photoUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController positionController;
  late String photoUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    positionController = TextEditingController(text: widget.position);
    photoUrl = widget.photoUrl;
  }

  void changePhoto() {
    setState(() {
      photoUrl =
          "https://i.pravatar.cc/150?img=${DateTime.now().millisecond % 70}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: changePhoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: positionController,
              decoration: const InputDecoration(labelText: "Position"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  Navigator.pop(context, {
                    "name": nameController.text,
                    "position": positionController.text,
                    "photo": photoUrl,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
