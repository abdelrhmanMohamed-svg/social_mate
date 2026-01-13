import 'package:flutter/material.dart';

class FileIcon extends StatelessWidget {
  final String fileName;

  const FileIcon({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    final ext = fileName.split('.').last.toLowerCase();

    IconData icon;
    Color color;

    switch (ext) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'jpg':
      case 'png':
        icon = Icons.image;
        color = Colors.blue;
        break;
      case 'mp4':
        icon = Icons.videocam;
        color = Colors.deepPurple;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color),
    );
  }
}
