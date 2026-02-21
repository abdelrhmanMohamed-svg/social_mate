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
        color = Color(0xffFF0000); // Red - use semantic color for error states
        break;
      case 'jpg':
      case 'png':
        icon = Icons.image;
        color = Theme.of(context).colorScheme.primary;
        break;
      case 'mp4':
        icon = Icons.videocam;
        color = Color(0xff9C27B0); // Purple - TODO: Add as app color if needed for dark mode
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Theme.of(context).colorScheme.outlineVariant;
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
