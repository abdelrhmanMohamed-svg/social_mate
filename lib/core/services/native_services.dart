import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_mate/core/utils/args_models/file_args_model.dart';

abstract class NativeServices {
  Future<File?> pickImage(ImageSource source);

  Future<FileArgsModel?> pickFile();
  Future<File?> pickVideo(ImageSource source);
  Future<void> downloadFile(String fileUrl,String fileName);
}

class NativeServicesImpl implements NativeServices {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<File?> pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    if (image == null) return null;
    return File(image.path);
  }

  @override
  Future<FileArgsModel?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'doc'],
      type: FileType.custom,
    );

    if (result == null) return null;
    return FileArgsModel(
      filePath: result.files.first.path!,
      fileName: result.files.first.name,
    );
  }

  @override
  Future<File?> pickVideo(ImageSource source) async {
    final video = await _picker.pickVideo(source: source);
    if (video == null) return null;
    return File(video.path);
  }

  @override
  Future<void> downloadFile(String fileUrl,String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      await Dio().download(
        fileUrl,
        filePath,
        
      );
      await OpenFilex.open(filePath);
    } catch (e) {
      rethrow;
    }
  }
}
