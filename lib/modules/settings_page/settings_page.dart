import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickchat/themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0, // Removing the shadow for a cleaner look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView( // Using ListView for better scalability with more settings
          children: [
            ListTile(
              title: const Text('Dark Mode'),
              trailing: CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme();
                },
                activeColor: Theme.of(context).colorScheme.secondary, // Match theme color
              ),
              onTap: () {
                // Allows toggling dark mode by tapping anywhere on the ListTile
                themeProvider.toggleTheme();
              },
            ),
            Divider(), // Add dividers for clear separation if more items are added later
            // Additional settings options can be added here
          ],
        ),
      ),
    );
  }
}
