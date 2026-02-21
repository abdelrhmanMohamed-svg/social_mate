import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/localization/localization_cubit.dart';
import 'package:social_mate/generated/l10n.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final currentLocale = context.read<LocalizationCubit>().state;
    _selectedLanguage = currentLocale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).selectLanguage)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RadioGroup<String>(
          groupValue: _selectedLanguage,
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value;
            });
            context.read<LocalizationCubit>().changeLocale(_selectedLanguage!);
          },
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(S.of(context).english),
                leading: Radio<String>(value: 'en'),
              ),

              ListTile(
                title: Text(S.of(context).arabic),
                leading: Radio<String>(value: 'ar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
