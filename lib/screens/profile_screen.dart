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

    setState(() {
      name = newName;
      position = newPos;
      photoUrl = newPhoto;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile photo
            CircleAvatar(radius: 50, backgroundImage: NetworkImage(photoUrl)),

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

            OutlinedButton(
              onPressed: () async {
                // Open Edit Screen
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

                if (updated != null && updated is Map) {
                  _saveProfile(
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
    // For now choosing random avatar
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
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: positionController,
              decoration: const InputDecoration(
                labelText: "Position",
                border: OutlineInputBorder(),
              ),
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
