import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:path_provider/path_provider.dart';

class KompresiAudioPage extends StatefulWidget {
  @override
  State<KompresiAudioPage> createState() => _KompresiAudioPageState();
}

class _KompresiAudioPageState extends State<KompresiAudioPage> {
  File? selectedAudio;
  File? compressedAudio;

  void _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = file.path!;

      setState(() {
        selectedAudio = File(filePath);
        compressedAudio =
            null; // Reset gambar terkompresi saat gambar baru dipilih
      });
    }
  }

  void _compressAudio() async {
    if (selectedAudio != null) {
      EasyLoading.show(status: 'Mengompres...');

      Directory appDir = await getApplicationDocumentsDirectory();
      String dir = appDir.path;
      String targetPath =
          '$dir/compressed_${selectedAudio!.path.split('/').last}';
      final session = await FFmpegKit.execute(
          "-i '${selectedAudio!.path}' -b:a 80k '$targetPath'");
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        EasyLoading.dismiss();
        compressedAudio = File(targetPath);
        // SUCCESS
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Berhasil',
          desc: 'Audio berhasil dikompres.',
          btnOkOnPress: () {},
        ).show();
      } else if (ReturnCode.isCancel(returnCode)) {
        EasyLoading.dismiss();
        // CANCEL
      } else {
        // ERROR
        EasyLoading.showError('Terjadi kesalahan');
        EasyLoading.dismiss();
      }
      setState(() {});
    }
  }

  void _downloadAudio() async {
    if (compressedAudio != null) {
      try {
        final res =
            await FolderFileSaver.saveFileToFolderExt(compressedAudio!.path);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Berhasil',
          desc: 'Audio berhasil disimpan.',
          btnOkOnPress: () {
            setState(() {
              selectedAudio = null;
              compressedAudio = null;
            });
          },
        ).show();
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.black.withOpacity(0.5)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kompresi Audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kompresi Audio',
              style: TextStyle(fontSize: 24),
            ),
            if (compressedAudio != null)
              Column(
                children: [
                  Text(compressedAudio!.path.split('/').last),
                  ElevatedButton(
                    onPressed: _downloadAudio,
                    child: Text('Simpan'),
                  ),
                ],
              ),
            if (selectedAudio == null)
              ElevatedButton(
                onPressed: _selectAudio,
                child: Text('Pilih Audio'),
              ),
            if (selectedAudio != null && compressedAudio == null)
              Column(
                children: [
                  Text(selectedAudio!.path.split('/').last),
                  ElevatedButton(
                    onPressed: _compressAudio,
                    child: Text('Kompres'),
                  ), // Tampilkan animasi loading
                ],
              ),
          ],
        ),
      ),
    );
  }
}
