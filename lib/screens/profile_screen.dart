import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tap to change photo")),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Remove photo?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Remove"),
                      ),
                    ],
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "Sonu Agarwal",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Developer",
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit Profile clicked")),
                );
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
