import 'package:flutter/material.dart';

class UserAvatars {
  static const List<IconData> defaultAvatars = [
    Icons.face,
    Icons.face_retouching_natural,
    Icons.face_retouching_natural_outlined,
    Icons.face_retouching_off,
    Icons.face_retouching_off_outlined,
    Icons.face_retouching_off_rounded,
    Icons.face_retouching_off_sharp,
    Icons.face_retouching_natural_rounded,
    Icons.face_retouching_natural_sharp,
    Icons.face_rounded,
    Icons.face_sharp,
    Icons.person,
    Icons.person_outline,
    Icons.person_rounded,
    Icons.person_sharp,
    Icons.account_circle,
    Icons.account_circle_outlined,
    Icons.account_circle_rounded,
    Icons.account_circle_sharp,
  ];

  static IconData getRandomAvatar() {
    return defaultAvatars[
        DateTime.now().millisecondsSinceEpoch % defaultAvatars.length];
  }

  static Color getAvatarColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.deepPurple,
    ];
    return colors[index % colors.length];
  }
}
