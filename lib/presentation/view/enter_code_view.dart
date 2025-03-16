import 'package:essenciacompany_mobile/presentation/component/form_widget.dart';
import 'package:essenciacompany_mobile/presentation/component/layout/default_layout.dart';
import 'package:essenciacompany_mobile/presentation/component/text_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterCodeView extends StatelessWidget {
  final String? icon;
  final String? title;

  final TextEditingController? codeController;
  final Function? onEnter;
  const EnterCodeView(
      {super.key, this.icon, this.title, this.codeController, this.onEnter});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
              image: AssetImage(icon ?? 'assets/images/logo.png'),
              height: 100,
              width: 100),
          const SizedBox(
            height: 15,
          ),
          Text(
            title ?? 'Enter Code',
            style:
                GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 54,
          ),
          FormWidget(
            children: [
              TextInput(
                  controller: codeController ?? TextEditingController(),
                  hintText: 'Enter Code'),
              const SizedBox(
                height: 26,
              ),
              GestureDetector(
                onTap: () {
                  if (onEnter == null) return;
                  onEnter!();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF36A30),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Enter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
