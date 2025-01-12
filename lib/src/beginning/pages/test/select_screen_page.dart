import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/begin.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:provider/provider.dart';

import '../../utilities/provider/provider.dart';

class CountrySelectorScreen extends StatefulWidget {
  const CountrySelectorScreen({super.key});

  @override
  CountrySelectorScreenState createState() => CountrySelectorScreenState();
}

class CountrySelectorScreenState extends State<CountrySelectorScreen> {
  final List<Pair<String, String>> countries = [
    Pair("VN", "Việt Nam"),
    Pair("US", "United States"),
    Pair("GB", "United Kingdom"),
    // Add more countries as needed
  ];

  Color nowColor = const Color(0xFF13272f);
  Color nowContrast = const Color(0xFFdbdbdc);
  List<Pair<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = countries; // Initialize with the full list
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = countries;
      } else {
        filteredCountries = countries
            .where((country) =>
                country.second.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const BackArt(),
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search country...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterCountries,
                  ),
                  ...filteredCountries.map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          musicBox.put('countryCode', e.first);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                maintainState: false,
                                builder: (context) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider<Leprovider>(
                                            create: (_) => Leprovider()),
                                        ChangeNotifierProvider<MrMan>(
                                          create: (_) => MrMan(),
                                        ),
                                        ChangeNotifierProvider<Seek>(
                                            create: (_) => Seek()),
                                      ],
                                      child: const Begin(),
                                    )),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CountryFlag.fromCountryCode(
                                e.first,
                                shape: const RoundedRectangle(6),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(e.second,
                                        style: TextStyle(
                                            fontSize: 24, color: nowContrast)),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: nowContrast,
                              ),
                            ],
                          ),
                        ),
                      )))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);

  @override
  String toString() => 'Pair($first, $second)';
}
