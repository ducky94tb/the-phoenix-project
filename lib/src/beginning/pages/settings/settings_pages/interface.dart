import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phoenix/i18n/localization_service.dart';
import 'package:phoenix/src/beginning/pages/settings/settings_pages/glass_effect.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:provider/provider.dart';
// import 'package:restart_app/restart_app.dart';

Future<void> clearCache() async {
  try {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  } catch (e) {
    // Handle error
    print('Error clearing cache: $e');
  }
}

Future<void> clearAppData() async {
  try {
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  } catch (e) {
    // Handle error
    print('Error clearing app data: $e');
  }
}

class Interface extends StatefulWidget {
  const Interface({super.key});

  @override
  State<Interface> createState() => _InterfaceState();
}

class _InterfaceState extends State<Interface> {
  @override
  void initState() {
    rootCrossfadeState = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rootCrossfadeState = Provider.of<Leprovider>(context);
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    return Consumer<Leprovider>(
      builder: (context, taste, _) {
        globaltaste = taste;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            shadowColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              'settings'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: deviceWidth! / 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Theme(
            data: themeOfApp,
            child: Stack(
              children: [
                // ignore: prefer_const_constructors
                BackArt(),
                Container(
                  padding: EdgeInsets.only(
                      top: kToolbarHeight + MediaQuery.of(context).padding.top),
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    physics: musicBox.get("fluidAnimation") ?? true
                        ? const BouncingScrollPhysics()
                        : const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(
                            "glass_effect".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "glass_effect_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                maintainState: false,
                                builder: (context) =>
                                    ChangeNotifierProvider<Leprovider>(
                                        create: (_) => Leprovider(),
                                        child: const GlassEffect()),
                              ),
                            );
                          },
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(
                            "default_artwork".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "default_artwork_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          leading: Card(
                            elevation: 3,
                            color: Colors.transparent,
                            child: ConstrainedBox(
                              constraints: musicBox.get("squareArt") ?? true
                                  ? kSqrConstraint
                                  : kRectConstraint,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(defaultNone!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.image_rounded,
                            color: Colors.white,
                          ),
                          onLongPress: () async {
                            ByteData bytes =
                                await rootBundle.load('assets/res/default.jpg');
                            setState(() {
                              defaultNone = bytes.buffer.asUint8List();
                            });
                            await File(
                                    "${applicationFileDirectory.path}/artworks/null.jpeg")
                                .writeAsBytes(defaultNone!,
                                    mode: FileMode.write);
                            Flushbar(
                              messageText: Text("fluid_flush_message".tr,
                                  style: const TextStyle(
                                      fontFamily: "Futura",
                                      color: Colors.white)),
                              icon: const Icon(
                                Icons.restore_rounded,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              shouldIconPulse: true,
                              dismissDirection:
                                  FlushbarDismissDirection.HORIZONTAL,
                              duration: const Duration(seconds: 3),
                              borderColor: Colors.white.withOpacity(0.04),
                              borderWidth: 1,
                              backgroundColor: glassOpacity!,
                              flushbarStyle: FlushbarStyle.FLOATING,
                              isDismissible: true,
                              barBlur: musicBox.get("glassBlur") ?? 18,
                              margin: const EdgeInsets.only(
                                  bottom: 20, left: 8, right: 8),
                              borderRadius: BorderRadius.circular(15),
                            ).show(context);
                            musicBox.put("dominantDefault", null);
                            refresh = true;
                          },
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile image = (await picker.pickImage(
                                source: ImageSource.gallery))!;
                            Uint8List bytes = await image.readAsBytes();
                            setState(() {
                              defaultNone = bytes;
                            });
                            await File(
                                    "${applicationFileDirectory.path}/artworks/null.jpeg")
                                .writeAsBytes(bytes, mode: FileMode.write);
                            musicBox.put("dominantDefault", null);
                            refresh = true;
                          },
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                            subtitle: Text(
                              'language_summary'.tr,
                              style: const TextStyle(
                                color: Colors.white38,
                              ),
                            ),
                            title: Text(
                              'language'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              value: musicBox.get("locale") ?? "en",
                              icon: const Icon(Icons.arrow_drop_down_rounded,
                                  color: Colors.white70),
                              elevation: 25,
                              enableFeedback: true,
                              borderRadius: BorderRadius.circular(kRounded / 2),
                              dropdownColor: kMaterialBlack.withOpacity(0.8),
                              underline: Container(
                                height: 2,
                                color: kCorrect,
                              ),
                              style: const TextStyle(color: Colors.white),
                              onChanged: (String? newValue) async {
                                if (newValue != null) {
                                  LocalizationService.changeLocale(newValue);
                                }
                                setState(() {});
                              },
                              items: LocalizationService.langs.entries
                                  .map((e) => DropdownMenuItem<String>(
                                      value: e.key, child: Text(e.value)))
                                  .toList(),
                            )),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          activeColor: kCorrect,
                          checkColor: kMaterialBlack,
                          subtitle: Text(
                            "fluid_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          title: Text(
                            "fluid".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: musicBox.get("fluidAnimation") ?? true,
                          onChanged: (newValue) {
                            setState(() {
                              musicBox.put("fluidAnimation", newValue);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          activeColor: kCorrect,
                          checkColor: kMaterialBlack,
                          subtitle: Text(
                            "dynamic_background_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          title: Text(
                            "dynamic_background".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: musicBox.get("dynamicArtDB") ?? true,
                          onChanged: (newValue) {
                            setState(() {
                              musicBox.put("dynamicArtDB", newValue);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          activeColor: kCorrect,
                          checkColor: kMaterialBlack,
                          subtitle: Text(
                            "square_art_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          title: Text(
                            "square_art".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: musicBox.get("squareArt") ?? true,
                          onChanged: (newValue) {
                            setState(() {
                              musicBox.put("squareArt", newValue);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          activeColor: kCorrect,
                          checkColor: kMaterialBlack,
                          subtitle: Text(
                            "left_steering_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          title: Text(
                            "left_steering".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: musicBox.get("androidAutoLefty") ?? true,
                          onChanged: (newValue) {
                            setState(() {
                              musicBox.put("androidAutoLefty", newValue);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          activeColor: kCorrect,
                          checkColor: kMaterialBlack,
                          subtitle: Text(
                            "audiophile_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          title: Text(
                            "audiophile".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: musicBox.get("audiophileData") ?? true,
                          onChanged: (newValue) {
                            setState(() {
                              musicBox.put("audiophileData", newValue);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          activeColor: kCorrect,
                          checkColor: kMaterialBlack,
                          subtitle: Text(
                            "classix_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          title: Text(
                            "classix".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          value: musicBox.get("classix") ?? true,
                          onChanged: (newValue) {
                            setState(() {
                              musicBox.put("classix", newValue);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                            subtitle: Text(
                              "mini_player_summary".tr,
                              style: const TextStyle(
                                color: Colors.white38,
                              ),
                            ),
                            title: Text(
                              "mini_player".tr,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              value: musicBox.get("miniPlayerPosition") ??
                                  "bottom".tr,
                              icon: const Icon(Icons.arrow_drop_down_rounded,
                                  color: Colors.white70),
                              elevation: 25,
                              enableFeedback: true,
                              borderRadius: BorderRadius.circular(kRounded / 2),
                              dropdownColor: kMaterialBlack.withOpacity(0.8),
                              underline: Container(
                                height: 2,
                                color: kCorrect,
                              ),
                              style: const TextStyle(color: Colors.white),
                              onChanged: (String? newValue) async {
                                await musicBox.put(
                                    "miniPlayerPosition", newValue);
                                setState(() {});
                              },
                              items: <String>[
                                'top'.tr,
                                'bottom'.tr,
                                'hidden'.tr,
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(
                            "reset".tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "reset_summary".tr,
                            style: const TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                          onTap: () {
                            showConfirmationDialog(context, () async {
                              musicBox.put('countryCode', null);
                              musicBox.put('locale', null);
                              await clearCache();
                              await clearAppData();
                              // Restart.restartApp();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<bool?> showConfirmationDialog(BuildContext context, Function onConfirm) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('confirm'.tr),
        content: Text('confirm_message'.tr),
        actions: <Widget>[
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
          ),
          TextButton(
            child: Text('ok'.tr),
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}
