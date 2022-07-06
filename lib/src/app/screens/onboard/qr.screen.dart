// 🐦 Flutter imports:
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
// 📦 Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:provider/provider.dart';
import 'package:tabler_icons/icon_data.dart';
import 'package:tabler_icons/tabler_icons.dart';

// 🌎 Project imports:
import '../../../app/constants/assets.dart';
import '../../../core/services/app_services.dart';
import '../../../core/services/instances.dart';
import '../../../meta/components/globals.dart';
import '../../../meta/extensions/logger.ext.dart';
import '../../../meta/models/qr.dart';
import '../../constants/page_route_name.dart';
import '../../provider/notifiers/new_user.dart';
import '../../provider/notifiers/user_data.dart';

// 📦 Package imports:
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AppLogger qrLog = AppLogger('QR');
  bool flash = false, _isDragging = false;
  QrReaderViewController? controller;
  final AppService _appService = AppService.getInstance();
  Future<void> onScan(String data, List<Offset> offsets) async {
    if (data.isNotEmpty) {
      await controller?.stopCamera();
      qrLog.info('QR Code: $data');

      context.read<UserData>().atOnboardingPreference.cramSecret =
          data.split(':')[1];
      context.read<NewUser>()
        ..newUserData['atSign'] = data.split(':')[0]
        ..newUserData['img'] =
            await _appService.readLocalfilesAsBytes(Assets.randomAvatar)
        ..setQrData =
            QrModel(atSign: data.split(':')[0], cramSecret: data.split(':')[1]);
      await controller?.stopCamera();
      await Navigator.pushNamed(context, PageRoutes.activatingAtSign);
    }
  }

  @override
  void dispose() {
    controller?.stopCamera();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   key: _scaffoldKey,
    //   body: Stack(
    //     children: <Widget>[
    //       Center(
    //         child: SizedBox(
    //           height: 300,
    //           width: 300,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(20),
    //             child: QrReaderView(
    //               key: qrKey,
    //               callback:
    //                   (QrReaderViewController qrReaderViewController) async {
    //                 controller = qrReaderViewController;
    //                 await controller?.startCamera(onScan);
    //               },
    //               height: 300,
    //               width: 300,
    //               torchEnabled: flash,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         bottom: 130,
    //         left: 0,
    //         right: 0,
    //         child: IconButton(
    //           icon: const Icon(
    //             TablerIcons.photo,
    //             color: Colors.black,
    //           ),
    //           onPressed: () async {
    //             try {
    //               // await controller!.stopCamera();
    //               Set<PlatformFile> _file =
    //                   await _appService.uploadFile(FileType.image);
    //               if (_file.isNotEmpty) {
    //                 bool _gotData = await _appService.getQRData(
    //                   _scaffoldKey.currentContext!,
    //                   _file.first.path,
    //                 );
    //                 if (_gotData) {
    //                   await Navigator.pushReplacementNamed(
    //                       context, PageRoutes.activatingAtSign);
    //                 }
    //               } else {
    //                 await controller!.startCamera(onScan);
    //                 await showToast(
    //                     _scaffoldKey.currentContext!, 'No image picked',
    //                     isError: true);
    //               }
    //             } on Exception catch (e) {
    //               await controller!.stopCamera();
    //               qrLog.severe(e);
    //               await showToast(
    //                   _scaffoldKey.currentContext!, 'Failed to pick image',
    //                   isError: true);
    //             }
    //           },
    //         ),
    //       ),
    //       Positioned(
    //         top: 40,
    //         right: 10,
    //         child: IconButton(
    //           onPressed: () async {
    //             bool _flash = (await controller!.setFlashlight())!;
    //             setState(
    //               () {
    //                 flash = _flash;
    //               },
    //             );
    //           },
    //           splashRadius: 0.01,
    //           icon: Icon(
    //             flash ? const TablerIconData(0xea38) : TablerIcons.bolt_off,
    //             color: flash
    //                 ? Colors.black
    //                 : Theme.of(context).primaryColor.withOpacity(0.3),
    //             size: 30,
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         top: 40,
    //         left: 10,
    //         child: IconButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           icon: const Icon(
    //             TablerIcons.x,
    //             color: Colors.black,
    //             size: 30,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: isMobile
            ? <Widget>[
                Center(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: QrReaderView(
                        key: qrKey,
                        callback: (QrReaderViewController
                            qrReaderViewController) async {
                          controller = qrReaderViewController;
                          await controller?.startCamera(onScan);
                        },
                        height: 300,
                        width: 300,
                        torchEnabled: flash,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 130,
                  left: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      TablerIcons.photo,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      try {
                        // await controller!.stopCamera();
                        Set<PlatformFile> _file =
                            await _appService.uploadFile(FileType.image);
                        if (_file.isNotEmpty) {
                          bool _gotData = await _appService.getQRData(
                            _scaffoldKey.currentContext!,
                            _file.first.path,
                          );
                          if (_gotData) {
                            await Navigator.pushReplacementNamed(
                                context, PageRoutes.activatingAtSign);
                          }
                        } else {
                          await controller!.startCamera(onScan);
                          await showToast(
                              _scaffoldKey.currentContext!, 'No image picked',
                              isError: true);
                        }
                      } on Exception catch (e) {
                        await controller!.stopCamera();
                        qrLog.severe(e);
                        await showToast(_scaffoldKey.currentContext!,
                            'Failed to pick image',
                            isError: true);
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: IconButton(
                    onPressed: () async {
                      bool _flash = (await controller!.setFlashlight())!;
                      setState(
                        () {
                          flash = _flash;
                        },
                      );
                    },
                    splashRadius: 0.01,
                    icon: Icon(
                      flash
                          ? const TablerIconData(0xea38)
                          : TablerIcons.bolt_off,
                      color: flash
                          ? Colors.black
                          : Theme.of(context).primaryColor.withOpacity(0.3),
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      TablerIcons.x,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ]
            : <Widget>[
                Center(
                  child: DropTarget(
                    onDragDone: (DropDoneDetails dropDetails) async {
                      bool _gotData = await ServiceInstances.appServices
                          .getQRData(context, dropDetails.files.first.path);
                      if (_gotData) {
                        await Navigator.pushReplacementNamed(
                            context, PageRoutes.activatingAtSign);
                      }
                    },
                    onDragExited: (_) => setState(() => _isDragging = false),
                    onDragEntered: (_) => setState(() => _isDragging = true),
                    child: GestureDetector(
                      onTap: _isDragging
                          ? null
                          : () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false);
                              bool _gotData = await ServiceInstances.appServices
                                  .getQRData(
                                      context, result?.files.single.path!);
                              if (_gotData) {
                                await Navigator.pushReplacementNamed(
                                    context, PageRoutes.activatingAtSign);
                              }
                            },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        // padding: const EdgeInsets.all(10),
                        radius: const Radius.circular(10),
                        dashPattern: const <double>[10, 10],
                        strokeCap: StrokeCap.round,
                        strokeWidth: 3,
                        color: _isDragging
                            ? Colors.blue.shade400.withOpacity(0.5)
                            : Colors.blue.shade400,
                        child: Opacity(
                          opacity: _isDragging ? 0.5 : 1,
                          child: Container(
                            width: 320,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Assets.dashboardQR,
                                  height: 100,
                                ),
                                const VSpacer(10),
                                Text(
                                  'Scan this QR to know\nwhere to download the QR codes\nfor your @sign.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const VSpacer(10),
                                Text(
                                  'OR',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const VSpacer(10),
                                Text(
                                  'Tap / Drag and drop\non this area to upload your QR code.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(
                      TablerIcons.x,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
