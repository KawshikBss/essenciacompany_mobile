import 'package:essenciacompany_mobile/presentation/component/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PosLayout extends StatefulWidget {
  final Widget child;
  const PosLayout({super.key, required this.child});

  @override
  State<PosLayout> createState() => _PosLayoutState();
}

class _PosLayoutState extends State<PosLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar.showPosAppBar(context),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: widget.child,
        ))));
  }
}
