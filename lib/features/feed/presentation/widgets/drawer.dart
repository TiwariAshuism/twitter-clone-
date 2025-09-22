import 'package:flutter/material.dart';

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=3",
                  ), // sample image
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Ashu Tiwari",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("@ashutw"),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          // Menu Items
          _drawerItem(icon: Icons.home, label: "Home", onTap: () {}),
          _drawerItem(icon: Icons.search, label: "Explore", onTap: () {}),
          _drawerItem(
            icon: Icons.notifications,
            label: "Notifications",
            onTap: () {},
          ),
          _drawerItem(
            icon: Icons.mail_outline,
            label: "Messages",
            onTap: () {},
          ),
          _drawerItem(
            icon: Icons.bookmark_border,
            label: "Bookmarks",
            onTap: () {},
          ),
          _drawerItem(icon: Icons.list_alt, label: "Lists", onTap: () {}),
          _drawerItem(
            icon: Icons.person_outline,
            label: "Profile",
            onTap: () {},
          ),
          const Spacer(),
          _drawerItem(
            icon: Icons.settings,
            label: "Settings and privacy",
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}

Widget _drawerItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(label, style: const TextStyle(fontSize: 16)),
    onTap: onTap,
  );
}
