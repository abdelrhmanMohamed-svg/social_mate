import 'package:flutter/material.dart';
import 'package:social_mate/generated/l10n.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).errorPageTitle)),
      body: Center(child: Text(S.of(context).somethingWentWrong)),
    );
  }
}
