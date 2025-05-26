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
    Icons.face_retouching_off_two_tone,
    Icons.face_retouching_natural_rounded,
    Icons.face_retouching_natural_sharp,
    Icons.face_retouching_natural_two_tone,
    Icons.face_rounded,
    Icons.face_sharp,
    Icons.face_two_tone,
    Icons.face_man,
    Icons.face_man_outlined,
    Icons.face_man_rounded,
    Icons.face_man_sharp,
    Icons.face_man_two_tone,
    Icons.face_woman,
    Icons.face_woman_outlined,
    Icons.face_woman_rounded,
    Icons.face_woman_sharp,
    Icons.face_woman_two_tone,
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
