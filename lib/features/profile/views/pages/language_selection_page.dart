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
  late String _selectedLanguage;

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
        child: Column(
          children: [
            RadioListTile<String>(
              title: Text(S.of(context).english),
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  context.read<LocalizationCubit>().changeLocale('en', 'US');
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(S.of(context).arabic),
              value: 'ar',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  context.read<LocalizationCubit>().changeLocale('ar');
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
