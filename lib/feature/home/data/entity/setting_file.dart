import 'package:mp3_convert/widget/file_picker.dart';

enum ConvertStatus {
  uploading,
  uploaded,
  converting,
  converted,
  downloading,
  downloaded,
}

// abstract class Progress {
//   final int progress;
//
//   Progress(this.progress) {
//     assert(progress >= 0);
//     assert(progress <= 100);
//   }
// }

class ConfigConvertFile extends AppFile {
  ConfigConvertFile({
    required super.name,
    required super.path,
    this.destinationType,
  });

  final String? destinationType;

  ConfigConvertFile copyWith({
    String? name,
    String? path,
    String? destinationType,
  }) {
    return ConfigConvertFile(
      name: name ?? this.name,
      path: path ?? this.path,
      destinationType: destinationType ?? this.destinationType,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        destinationType,
      ];

  String getConvertFileName() {
    return name.substring(0, name.length - type.length) + destinationType!;
  }
}

class UnValidConfigConvertFile extends ConfigConvertFile {
  UnValidConfigConvertFile({
    required super.name,
    required super.path,
    required super.destinationType,
  });
}

abstract class ConvertStatusFile extends ConfigConvertFile {
  final ConvertStatus status;

  ConvertStatusFile({
    required super.name,
    required super.path,
    super.destinationType,
    required this.status,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        status,
      ];
}

class UploadFile extends ConvertStatusFile {
  final String uploadId;

  UploadFile({
    required super.status,
    required super.name,
    required super.path,
    required super.destinationType,
    required this.uploadId,
  });
}

class UploadingFile extends UploadFile {
  UploadingFile({
    required super.name,
    required super.path,
    required super.destinationType,
    required super.uploadId,
  }) : super(status: ConvertStatus.uploading);
}

class UploadedFile extends UploadFile {
  UploadedFile({
    required super.name,
    required super.path,
    required super.destinationType,
    required super.uploadId,
  }) : super(status: ConvertStatus.uploaded);
}

class ConvertingFile extends UploadFile {
  final double? convertProgress;

  ConvertingFile({
    required super.name,
    required super.path,
    required super.destinationType,
    required super.uploadId,
    required this.convertProgress,
  }) : super(status: ConvertStatus.converting);

  @override
  List<Object?> get props => [
        ...super.props,
        convertProgress,
      ];

  @override
  ConvertingFile copyWith({
    String? name,
    String? path,
    String? destinationType,
    String? uploadId,
    double? convertProgress,
  }) {
    return ConvertingFile(
      name: name ?? this.name,
      path: path ?? this.path,
      destinationType: destinationType ?? this.destinationType,
      uploadId: uploadId ?? this.uploadId,
      convertProgress: convertProgress ?? this.convertProgress,
    );
  }
}

class ConvertedFile extends ConvertStatusFile {
  final String? downloadId;

  ConvertedFile({
    required super.name,
    required super.path,
    required super.destinationType,
    required this.downloadId,
  }) : super(status: ConvertStatus.converted);

  @override
  List<Object?> get props => [
        ...super.props,
        downloadId,
      ];
}

class DownloadingFile extends ConvertStatusFile {
  final String? downloaderId;
  final String downloadPath;
  final double? downloadProgress;

  DownloadingFile({
    required super.name,
    required super.path,
    required super.destinationType,
    required this.downloaderId,
    required this.downloadPath,
    required this.downloadProgress,
  }) : super(status: ConvertStatus.downloading);

  @override
  ConfigConvertFile copyWith({
    String? name,
    String? path,
    String? destinationType,
    String? uploadId,
    String? downloaderId,
    double? downloadProgress,
    String? downloadPath,
  }) {
    return DownloadingFile(
      name: name ?? this.name,
      path: path ?? this.path,
      destinationType: destinationType ?? this.destinationType,
      downloaderId: downloaderId ?? this.downloaderId,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      downloadPath: downloadPath ?? this.downloadPath,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        downloaderId,
        downloadPath,
        downloadProgress,
      ];
}

class DownloadedFile extends ConvertStatusFile {
  DownloadedFile({
    required super.name,
    required super.path,
    required super.destinationType,
    required this.downloadPath,
  }) : super(status: ConvertStatus.downloaded);

  final String downloadPath;
}
