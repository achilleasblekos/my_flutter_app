import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grada_app/providers/user_provider.dart';
import 'package:grada_app/screens/tabs.dart';

import '../models/user.dart';

class UserScreen extends ConsumerStatefulWidget {
  final AppUser user;

  const UserScreen({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  late Future<void> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUser();
  }

  Future<void> _loadUser() async {
    await ref.read(userProvider.notifier).loadUsers();
  }

  void _deleteUser() async {
    // Perform the deletion logic here
    final users = ref.watch(userProvider);
    final currentUser = users.firstWhere((user) => user.id == widget.user.id);
    await ref.read(userProvider.notifier).deleteUser(currentUser);
    // Navigate back or handle the deletion completion as required
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const TabsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<void>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = ref.watch(userProvider);
            final user = users.isNotEmpty ? users[0] : null;

            if (user != null) {
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${user.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Rest of the user profile widgets
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Surname: ${user.surname}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email: ${user.email}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paasword: ${user.password}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _deleteUser,
                        child: const Text('Delete User'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const TabsScreen()));
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Text('No user data found');
            }
          }
        },
      ),
    );
  }
}
