import 'package:flutter/material.dart';
import 'package:quickchat/modules/auth/utils/auth_service.dart';
import 'package:quickchat/modules/chat/chat_page.dart';
import 'package:quickchat/modules/home_page/widget/my_drawer.dart';

import '../chat/services/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        String? currentUserEmail = authService.getCurrentUser()?.email;

        var filteredUsers = snapshot.data!.where((userData) => userData['email'] != currentUserEmail).toList();

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            var userData = filteredUsers[index];
            String displayName = userData['name'] ?? 'default name';
            String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: userData['imageUrl'] == null
                    ? CircleAvatar(
                        backgroundColor: Colors.grey.shade600,
                        child: Text(initial),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey.shade600,
                        backgroundImage: NetworkImage(userData['imageUrl']),
                      ),
                title: Text(displayName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverName: userData['name'],
                        receiverId: userData['uid'],
                        receiverImage: userData['imageUrl'] ?? "",
                      ),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                tileColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quick Chat'),
        ),
        drawer: const MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _buildUserList(),
        ));
  }
}
