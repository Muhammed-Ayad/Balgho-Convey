import 'dart:io';
import 'package:dio/dio.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class AzanAudioCacheService {
  static final provider = Provider<AzanAudioCacheService>((ref) {
    return AzanAudioCacheService(Dio());
  });

  final Dio _dio;

  AzanAudioCacheService(this._dio);

  Future<String> _getSoundsDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final soundsDir = Directory('${docsDir.path}/azan_sounds');
    if (!await soundsDir.exists()) {
      await soundsDir.create(recursive: true);
    }
    return soundsDir.path;
  }

  Future<String?> getCachedFilePath(AzanVoice voice) async {
    if (voice == AzanVoice.silent || voice.sampleUrl.isEmpty) {
      return null;
    }
    try {
      final dir = await _getSoundsDirectory();
      final file = File('$dir/azan_${voice.name}.mp3');
      if (await file.exists() && await file.length() > 1000) {
        return file.path;
      }
    } catch (e) {
      "Error checking cached azan audio: $e".log();
    }
    return null;
  }

  Future<bool> isCached(AzanVoice voice) async {
    final path = await getCachedFilePath(voice);
    return path != null;
  }

  Future<String?> ensureCached(
    AzanVoice voice, {
    void Function(double progress)? onProgress,
  }) async {
    if (voice == AzanVoice.silent || voice.sampleUrl.isEmpty) {
      return null;
    }

    final existingPath = await getCachedFilePath(voice);
    if (existingPath != null) {
      "Azan voice ${voice.name} is already cached at $existingPath".log();
      return existingPath;
    }

    try {
      final dir = await _getSoundsDirectory();
      final targetPath = '$dir/azan_${voice.name}.mp3';
      final tempPath = '$targetPath.tmp';

      "Downloading azan voice ${voice.name} from ${voice.sampleUrl}...".log();

      await _dio.download(
        voice.sampleUrl,
        tempPath,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      final tempFile = File(tempPath);
      if (await tempFile.exists() && await tempFile.length() > 1000) {
        await tempFile.rename(targetPath);
        "Azan voice ${voice.name} downloaded and cached successfully at $targetPath"
            .log();
        return targetPath;
      } else {
        await tempFile.delete();
        throw Exception("Downloaded file is empty or corrupted");
      }
    } catch (e) {
      "Failed to download/cache azan voice: $e".log();
      rethrow;
    }
  }
}
