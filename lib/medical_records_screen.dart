import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';
import 'app_shell.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final List<MedicalRecordItem> _defaultRecords = const [
    MedicalRecordItem(
      title: 'Blood Test Report',
      date: '15 Mar 2026',
      type: 'PDF',
      filePath: null,
    ),
    MedicalRecordItem(
      title: 'Diabetes Specialist Notes',
      date: '02 Mar 2026',
      type: 'DOC',
      filePath: null,
    ),
    MedicalRecordItem(
      title: 'Glucose Lab Summary',
      date: '21 Feb 2026',
      type: 'PDF',
      filePath: null,
    ),
  ];

  List<MedicalRecordItem> _uploadedRecords = [];

  @override
  void initState() {
    super.initState();
    _loadUploadedRecords();
  }

  Future<void> _loadUploadedRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getStringList('medical_records') ?? [];

    setState(() {
      _uploadedRecords = savedData
          .map((item) => MedicalRecordItem.fromJson(jsonDecode(item)))
          .toList();
    });
  }

  Future<void> _saveUploadedRecords() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = _uploadedRecords
        .map((record) => jsonEncode(record.toJson()))
        .toList();

    await prefs.setStringList('medical_records', savedData);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _getFileName(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  String _getFileExtension(String path) {
    final fileName = _getFileName(path);

    if (!fileName.contains('.')) {
      return 'FILE';
    }

    return fileName.split('.').last.toUpperCase();
  }

  IconData _getFileIcon(String type) {
    final upperType = type.toUpperCase();

    if (upperType == 'PDF') {
      return Icons.picture_as_pdf;
    }

    if (upperType == 'DOC' || upperType == 'DOCX') {
      return Icons.description;
    }

    if (upperType == 'PNG' ||
        upperType == 'JPG' ||
        upperType == 'JPEG' ||
        upperType == 'WEBP') {
      return Icons.image;
    }

    return Icons.insert_drive_file;
  }

  Future<void> _addFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg', 'webp'],
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final pickedPath = result.files.single.path!;
    final pickedFile = File(pickedPath);

    final appDirectory = await getApplicationDocumentsDirectory();
    final medicalRecordsDirectory = Directory(
      '${appDirectory.path}${Platform.pathSeparator}medical_records',
    );

    if (!await medicalRecordsDirectory.exists()) {
      await medicalRecordsDirectory.create(recursive: true);
    }

    final fileName = _getFileName(pickedPath);
    final savedPath =
        '${medicalRecordsDirectory.path}${Platform.pathSeparator}$fileName';

    await pickedFile.copy(savedPath);

    final newRecord = MedicalRecordItem(
      title: fileName,
      date: _formatDate(DateTime.now()),
      type: _getFileExtension(fileName),
      filePath: savedPath,
    );

    setState(() {
      _uploadedRecords.insert(0, newRecord);
    });

    await _saveUploadedRecords();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('File added successfully')));
  }

  Future<void> _openRecord(MedicalRecordItem record) async {
    if (record.filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This is a sample record. Add your own file to open it.',
          ),
        ),
      );
      return;
    }

    final file = File(record.filePath!);

    if (!await file.exists()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('File not found')));
      return;
    }

    await OpenFilex.open(record.filePath!);
  }

  Future<void> _deleteRecord(MedicalRecordItem record) async {
    if (record.filePath != null) {
      final file = File(record.filePath!);

      if (await file.exists()) {
        await file.delete();
      }
    }

    setState(() {
      _uploadedRecords.remove(record);
    });

    await _saveUploadedRecords();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('File deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final allRecords = [..._uploadedRecords, ..._defaultRecords];

    return AppShell(
      title: 'Medical Records',
      currentIndex: 0,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          GestureDetector(
            onTap: _addFile,
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppTheme.darkGreen.withOpacity(0.35),
                  width: 1.4,
                ),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add, color: AppTheme.darkGreen, size: 30),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add new file',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Upload PDF, DOC, or image document',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.upload_file, color: AppTheme.darkGreen, size: 28),
                ],
              ),
            ),
          ),

          ...allRecords.map((record) {
            final bool isUploaded = record.filePath != null;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () {
                  _openRecord(record);
                },
                onLongPress: isUploaded
                    ? () {
                        _deleteRecord(record);
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(
                          _getFileIcon(record.type),
                          color: AppTheme.darkGreen,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Date: ${record.date}'),
                            Text('Type: ${record.type}'),
                            if (isUploaded)
                              const Text(
                                'Tap to open • Long press to delete',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isUploaded)
                        const Icon(Icons.chevron_right, color: Colors.black45),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class MedicalRecordItem {
  final String title;
  final String date;
  final String type;
  final String? filePath;

  const MedicalRecordItem({
    required this.title,
    required this.date,
    required this.type,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {'title': title, 'date': date, 'type': type, 'filePath': filePath};
  }

  factory MedicalRecordItem.fromJson(Map<String, dynamic> json) {
    return MedicalRecordItem(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      type: json['type'] ?? 'FILE',
      filePath: json['filePath'],
    );
  }
}
