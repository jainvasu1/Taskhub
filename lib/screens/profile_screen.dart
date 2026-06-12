import 'package:flutter/material.dart';

class ProfileData {
  String name;
  String position;
  String photoUrl;

  ProfileData({
    required this.name,
    required this.position,
    required this.photoUrl,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileData data = ProfileData(
    name: "Sonu Agarwal",
    position: "Developer",
    photoUrl: "https://i.pravatar.cc/150?img=3",
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              onLongPress: () {},
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(data.photoUrl),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              data.name,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              data.position,
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "24",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Posts", style: textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: Colors.grey),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "520",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Followers", style: textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: Colors.grey),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "180",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Following", style: textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

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
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(data: data),
                  ),
                );

                if (updated != null && updated is ProfileData) {
                  setState(() => data = updated);
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
  final ProfileData data;
  const EditProfileScreen({super.key, required this.data});

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
    nameController = TextEditingController(text: widget.data.name);
    positionController = TextEditingController(text: widget.data.position);
    photoUrl = widget.data.photoUrl;
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
              onTap: () {
                setState(() {
                  photoUrl = "https://i.pravatar.cc/150?img=5";
                });
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),

            const SizedBox(height: 20),

            // --- Edit Name ---
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // --- Edit Position ---
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
                onPressed: () {
                  Navigator.pop(
                    context,
                    ProfileData(
                      name: nameController.text,
                      position: positionController.text,
                      photoUrl: photoUrl,
                    ),
                  );
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
