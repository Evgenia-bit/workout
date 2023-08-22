import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/screens/loading_screen.dart';
import 'package:workout/screens/mock/exercise_list_screen.dart';
import 'package:workout/screens/web_view.dart';
import 'package:workout/utils/json_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AppModel extends ChangeNotifier {
  final  _deviceInfo = DeviceInfoPlugin();
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  String _url = '';
  String get url => _url;

  AppModel() {
    _load();
  }

  Future<void> _load() async {
    Map<String, dynamic> json =
        await JsonManager.readJson('assets/google-services.json');
     _url = json['url'];
    if (url.isEmpty) {
      //TODO: обращение к Firebase за ссылкой
    }
    _isLoading = false;
    notifyListeners();
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
        em.brand.contains('google')||
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

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => AppModel(),
        child: Builder(
          builder: (context) {
            final model = context.watch<AppModel>();
            if (model.isLoading) {
              return const LoadingScreen();
            }
            if (model.url.isNotEmpty) {
              return MainView(r: model.url);
            }
            return const ExerciseListScreen();
          },
        ),
      ),
    );
  }
}
