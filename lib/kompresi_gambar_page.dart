import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:path_provider/path_provider.dart';

class KompresiGambarPage extends StatefulWidget {
  @override
  _KompresiGambarPageState createState() => _KompresiGambarPageState();
}

class _KompresiGambarPageState extends State<KompresiGambarPage> {
  File? selectedImage;
  File? compressedImage;

  void _selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp', 'webp', 'gif'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = file.path!;

      setState(() {
        selectedImage = File(filePath);
        compressedImage =
            null; // Reset gambar terkompresi saat gambar baru dipilih
      });
    }
  }

  void _compressImage() async {
    if (selectedImage != null) {
      EasyLoading.show(status: 'Mengompres...');

      Directory appDir = await getApplicationDocumentsDirectory();
      String dir = appDir.path;
      String targetPath = '$dir/compressed_image.jpg';

      DateTime startTime = DateTime.now(); // Waktu awal kompresi

      compressedImage = await FlutterImageCompress.compressAndGetFile(
        selectedImage!.path,
        targetPath,
        quality: 50,
      );

      DateTime endTime = DateTime.now(); // Waktu akhir kompresi
      Duration duration = endTime.difference(startTime); // Durasi kompresi

      if (compressedImage != null) {
        EasyLoading.dismiss();
        // Kompressi berhasil
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Berhasil',
          desc:
              'Gambar berhasil dikompres.\nWaktu kompresi: ${duration.inMilliseconds} ms',
          btnOkOnPress: () {},
        ).show();
      } else {
        // Kompressi gagal

        EasyLoading.dismiss();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Gagal',
          desc: 'Gagal melakukan kompresi gambar.',
          btnOkOnPress: () {},
        ).show();
      }

      setState(() {});
    }
  }

  void _downloadImage() async {
    if (compressedImage != null) {
      try {
        final res =
            await FolderFileSaver.saveFileToFolderExt(compressedImage!.path);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Berhasil',
          desc: 'Gambar berhasil disimpan.',
          btnOkOnPress: () {
            setState(() {
              selectedImage = null;
              compressedImage = null;
            });
          },
        ).show();
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kompresi Gambar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kompresi Gambar',
              style: TextStyle(fontSize: 24),
            ),
            if (compressedImage != null)
              Column(
                children: [
                  Image.file(
                    compressedImage!,
                    width: 600,
                    height: 600,
                  ),
                  ElevatedButton(
                    onPressed: _downloadImage,
                    child: Text('Simpan'),
                  ),
                ],
              ),
            if (selectedImage == null)
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Pilih Gambar'),
              ),
            if (selectedImage != null && compressedImage == null)
              Column(
                children: [
                  Image.file(
                    selectedImage!,
                    width: 600,
                    height: 600,
                  ),
                  ElevatedButton(
                    onPressed: _compressImage,
                    child: Text('Kompres'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
