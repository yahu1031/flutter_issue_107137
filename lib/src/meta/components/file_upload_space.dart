// 🐦 Flutter imports:

// 📦 Package imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../core/services/app_services.dart';
import 'adaptive/adaptive_loading.dart';
import 'globals.dart';

class FileUploadSpace extends StatefulWidget {
  const FileUploadSpace({
    required this.onTap,
    this.uploadMessage,
    this.onDismmisTap,
    this.dismissable = false,
    this.child,
    this.messageStyle,
    this.assetPath,
    this.fileType = FileType.any,
    this.boxColor,
    this.multipleFiles = false,
    this.extensions,
    Key? key,
    this.isUploading = false,
    this.size = const Size(300, 150),
  }) : super(key: key);
  final Function(Set<PlatformFile>) onTap;
  final VoidCallback? onDismmisTap;
  final String? uploadMessage;
  final String? assetPath;
  final FileType? fileType;
  final Color? boxColor;
  final Widget? child;
  final Size? size;
  final TextStyle? messageStyle;
  final bool multipleFiles;
  final List<String>? extensions;
  final bool isUploading;
  final bool dismissable;

  @override
  State<FileUploadSpace> createState() => _FileUploadSpaceState();
}

class _FileUploadSpaceState extends State<FileUploadSpace> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () async => widget.onTap.call(await AppService.getInstance()
              .uploadFile(
                  widget.fileType, widget.multipleFiles, widget.extensions)),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const <double>[10, 10],
            strokeCap: StrokeCap.round,
            strokeWidth: 3,
            color: widget.boxColor ?? Theme.of(context).primaryColor,
            child: Container(
              width: widget.size?.width ?? 300,
              height: widget.size?.height ?? 150,
              decoration: BoxDecoration(
                color: widget.boxColor ??
                    Theme.of(context).primaryColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.child ??
                          Image.asset(
                            widget.assetPath!,
                            height: 40,
                          ),
                      const VSpacer(10),
                      widget.isUploading
                          ? const AdaptiveLoading(
                              size: 28,
                            )
                          : Text(
                              widget.uploadMessage ?? 'Upload your files',
                              textAlign: TextAlign.center,
                              style: widget.messageStyle ??
                                  TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.dismissable)
          Positioned(
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.red,
              ),
              iconSize: 20,
              onPressed: widget.onDismmisTap,
            ),
            right: 0,
            top: 0,
          ),
      ],
    );
  }
}
