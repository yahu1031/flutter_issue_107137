// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabler_icons/tabler_icons.dart';

// 🌎 Project imports:
import '../../../core/services/app_services.dart';
import '../../../core/services/instances.dart';
import '../../../meta/components/adaptive/adaptive_loading.dart';
import '../../../meta/components/buttons/curved.button.dart';
import '../../../meta/components/buttons/curved.outline.button.dart';
import '../../../meta/components/filled.textfield.dart';
import '../../../meta/components/globals.dart';
import '../../../meta/components/sheets/otp.form.dart';
import '../../../meta/extensions/logger.ext.dart';
import '../../../meta/models/qr.dart';
import '../../constants/assets.dart';
import '../../constants/page_route_name.dart';
import '../../provider/notifiers/new_user.dart';
import '../../provider/notifiers/user_data.dart';

class GetAtSignScreen extends StatefulWidget {
  const GetAtSignScreen({Key? key}) : super(key: key);

  @override
  State<GetAtSignScreen> createState() => _GetAtSignScreenState();
}

class _GetAtSignScreenState extends State<GetAtSignScreen> {
  String? _atSign;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppLogger _logger = AppLogger('GetAtSignScreen');
  final AppService _appService = AppService.getInstance();
  bool _loading = false, _atSignPicked = false, _mailSent = false;
  late String _imgPath;
  late TextEditingController _emailController;
  int selectedIndex = -1;
  Future<void> _getAtSign() async {
    setState(() => _loading = true);
    _atSign = await _appService.getNewAtSign();
    setState(() => _loading = false);
  }

  @override
  void initState() {
    Future<void>.microtask(() async => _getAtSign());
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            TablerIcons.x,
            color: Colors.red,
          ),
          splashColor: Colors.transparent,
          splashRadius: 0.1,
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: _atSignPicked
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedContainer(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.all(5),
                      duration: const Duration(milliseconds: 120),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      child: Image.memory(
                        context.read<NewUser>().newUserData['img'],
                        height: 30,
                      ),
                    ),
                    const VSpacer(10),
                    Text(context.read<NewUser>().newUserData['atSign']),
                    const VSpacer(70),
                    !_mailSent
                        ? FilledTextField(
                            height: 40,
                            onChanged: (_) {},
                            controller: _emailController,
                            autofillHints: <String>[AutofillHints.email],
                            hint: 'Email',
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              OtpForm(
                                context: context,
                                wrongMail: () {
                                  setState(() {
                                    _mailSent = false;
                                  });
                                },
                                onSubmit: () async {
                                  String? _cram = await ServiceInstances
                                      .appServices
                                      .getCRAM(<String, dynamic>{
                                    'email': _emailController.text,
                                    'atsign': context
                                        .read<NewUser>()
                                        .newUserData['atSign']
                                        .toString()
                                        .replaceFirst('@', ''),
                                    'otp': context
                                        .read<NewUser>()
                                        .newUserData['otp'],
                                    'confirmation': true,
                                  });
                                  if (_cram != null) {
                                    context
                                        .read<UserData>()
                                        .atOnboardingPreference
                                        .cramSecret = _cram.split(':')[1];
                                    context.read<NewUser>().setQrData = QrModel(
                                        atSign: _cram.split(':')[0],
                                        cramSecret: _cram.split(':')[1]);
                                    await showToast(_scaffoldKey.currentContext,
                                        'OTP verified successfully.');
                                    await Navigator.pushNamed(
                                        context, PageRoutes.activatingAtSign);
                                  } else {
                                    await showToast(_scaffoldKey.currentContext,
                                        'Invalid OTP.',
                                        isError: true);
                                  }
                                },
                                onResend: () {},
                                resend: false,
                              ),
                            ],
                          ),
                    if (!_mailSent) const VSpacer(20),
                    if (!_mailSent)
                      CurvedButton(
                        text: 'Submit',
                        onPressed: () async {
                          try {
                            String _email = _emailController.text.trim();
                            _appService.validateEmail(_email);
                            bool mailSent = await _appService.registerWithMail(
                                _email,
                                context.read<NewUser>().newUserData['atSign']);
                            setState(() => _mailSent = mailSent);
                            await showToast(_scaffoldKey.currentContext!,
                                'Mail sent to $_email');
                          } on Exception catch (e) {
                            _logger.severe('Error while sending mail : $e');
                            await showToast(_scaffoldKey.currentContext!,
                                'Error while sending mail : $e',
                                isError: true);
                            setState(() => _mailSent = false);
                          }
                        },
                        color: Colors.lightBlue,
                        textStyle: const TextStyle(color: Colors.white),
                        splashColor: Colors.blue,
                      ),
                    if (!_mailSent) const VSpacer(20),
                    if (!_mailSent)
                      CurvedButton(
                        text: 'Change @sign',
                        onPressed: () {
                          setState(() {
                            _atSignPicked = false;
                          });
                        },
                        textStyle: const TextStyle(
                          color: Colors.lightBlue,
                        ),
                      )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                        text: const TextSpan(
                            text: 'Get free ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                            text: '@sign',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          )
                        ])),
                    const VSpacer(20),
                    _loading
                        ? const AdaptiveLoading(
                            size: 17,
                          )
                        : Text(_atSign ?? 'Loading...'),
                    const VSpacer(20),
                    _AvatarsList(onTap: (int index, String _path) {
                      setState(() {
                        selectedIndex = index;
                        _imgPath = _path;
                      });
                    }),
                    const VSpacer(20),
                    SizedBox(
                      width: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CurvedOutlineButton(
                            onPressed: _getAtSign,
                            text: 'Change @sign',
                            color: Colors.blue,
                          ),
                          CurvedButton(
                            onPressed: selectedIndex == -1
                                ? null
                                : () async {
                                    context
                                        .read<NewUser>()
                                        .newUserData['atSign'] = _atSign;
                                    context.read<NewUser>().newUserData['img'] =
                                        await _appService
                                            .readLocalfilesAsBytes(_imgPath);
                                    setState(() {
                                      _atSignPicked = true;
                                      _mailSent = false;
                                    });
                                  },
                            text: 'Pick',
                            splashColor: Colors.blue,
                            textStyle: TextStyle(
                                color: selectedIndex == -1
                                    ? Colors.grey
                                    : Colors.white),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AvatarsList extends StatefulWidget {
  const _AvatarsList({required this.onTap, Key? key}) : super(key: key);
  final Function(int index, String path) onTap;
  @override
  State<_AvatarsList> createState() => _AvatarsListState();
}

class _AvatarsListState extends State<_AvatarsList> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.zero,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: false,
        physics: const BouncingScrollPhysics(),
        itemCount: Assets.avatars.length,
        itemBuilder: (BuildContext context, int _index) {
          return FadeInRight(
            duration: Duration(milliseconds: _index * 50),
            delay: Duration.zero,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex == _index) {
                    selectedIndex = -1;
                  } else {
                    selectedIndex = _index;
                  }
                  widget.onTap.call(selectedIndex, Assets.avatars[_index]);
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedContainer(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: selectedIndex == _index
                            ? Border.all(color: Colors.lightBlue, width: 3)
                            : null,
                      ),
                      duration: const Duration(milliseconds: 120),
                      child: Image.asset(Assets.avatars[_index]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
