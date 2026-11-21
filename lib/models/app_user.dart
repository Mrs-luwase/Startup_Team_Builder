//Describe the user
class AppUser {
  final String uid;
  final String name;
  final String role; // 'builder' or 'mentor'

  const AppUser({required this.uid, required this.name, required this.role});

  bool get isMentor => role == 'mentor';

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? 'builder',
    );
  }
}