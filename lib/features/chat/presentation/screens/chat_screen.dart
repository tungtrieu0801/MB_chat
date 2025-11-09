import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/room/room_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/room/room_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/room/room_event.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // Future<String> _getCurrentUserId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('currentUserId') ?? '';
  // }

  Future<String> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('cached_user'); // key mà bạn lưu User
    if (userJson == null) return '';
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap['id'] ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getCurrentUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentUserId = snapshot.data!;
        return ChatScreenContent(currentUserId: currentUserId);
      },
    );
  }
}

class ChatScreenContent extends StatelessWidget {
  final String currentUserId;

  const ChatScreenContent({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomBloc()..add(GetRoomsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mengobrolx', style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: BlocBuilder<RoomBloc, RoomState>(
                builder: (context, state) {
                  if (state is RoomLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RoomLoaded) {
                    final rooms = state.rooms;
                    if (rooms.isEmpty) {
                      return const Center(child: Text('No chats available.'));
                    }
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        final unreadCount = room.unreadCounts[currentUserId] ?? 0;
                        final lastMessageTime = room.lastMessageAt != null
                            ? TimeOfDay.fromDateTime(room.lastMessageAt!).format(context)
                            : '';
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundImage: room.avatar != null && room.avatar!.isNotEmpty
                                ? NetworkImage(room.avatar!)
                                : null,
                            child: room.avatar == null || room.avatar!.isEmpty
                                ? const Icon(Icons.group, size: 28)
                                : null,
                          ),
                          title: Text(room.name),
                          subtitle: Text(room.lastMessage),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(lastMessageTime),
                              if (unreadCount > 0)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            // TODO: Navigate to chat detail
                          },
                        );
                      },
                    );
                  } else if (state is RoomError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const SizedBox.shrink();
                  }
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
          itemCount: 5,
          itemBuilder: (context, index) {
            if (index == 0) {
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
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CircleAvatar(radius: 28),
                  SizedBox(height: 8),
                  Text('Username'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
