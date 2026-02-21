import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/theme/theme_cubit.dart';
import 'package:social_mate/generated/l10n.dart';

class ThmeSelectionPage extends StatefulWidget {
  const ThmeSelectionPage({super.key});

  @override
  State<ThmeSelectionPage> createState() => _ThmeSelectionPageState();
}

class _ThmeSelectionPageState extends State<ThmeSelectionPage> {
  ThemeMode? _selectedTheme;
  @override
  void initState() {
    final ThemeMode currentTheme = context.read<ThemeCubit>().state;
    _selectedTheme = currentTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).themePageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RadioGroup<ThemeMode>(
          groupValue: _selectedTheme,
          onChanged: (value) {
            setState(() {
              _selectedTheme = value;
            });
            context.read<ThemeCubit>().toggleTheme(_selectedTheme);
          },
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(S.of(context).lightLabel),
                leading: Radio<ThemeMode>(value: ThemeMode.light),
              ),

              ListTile(
                title: Text(S.of(context).darkLabel),
                leading: Radio<ThemeMode>(value: ThemeMode.dark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
