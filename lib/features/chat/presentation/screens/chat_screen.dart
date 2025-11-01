import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mengobrol', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoriesSection(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual chat list length from BLoC
              itemBuilder: (context, index) {
                // Replace with ChatListItem widget
                return const ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    // backgroundImage: NetworkImage(chat.avatarUrl), // Replace with actual data
                  ),
                  title: Text('User Name'), // Replace with actual data
                  subtitle: Text('Last message...'), // Replace with actual data
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('02:11'), // Replace with actual data
                      SizedBox(height: 4),
                      // if (chat.unreadCount > 0) ... // Add logic for unread badge
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('+ New Chat'),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Set current index based on router
        onTap: (index) {},
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8, // Replace with actual story list length + 1 for 'Add story'
          itemBuilder: (context, index) {
            if (index == 0) {
              // 'Add story' button
              return const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFF2F2F2),
                      child: Icon(Icons.add, size: 28, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text('Add story'),
                  ],
                ),
              );
            }
            // Story items
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    // backgroundImage: NetworkImage(story.avatarUrl), // Replace with actual data
                  ),
                  SizedBox(height: 8),
                  Text('Username'), // Replace with actual data
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
