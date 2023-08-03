library ui;

import 'package:flutter/material.dart';
import 'package:ui/generated/l10n.dart';

export 'generated/l10n.dart';
export 'generated/intl/messages_all.dart';

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) => Text(
        S.of(context).helloA,
      );
}
