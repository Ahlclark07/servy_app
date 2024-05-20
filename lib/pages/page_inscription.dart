import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/static_test/fr.dart';
import 'package:servy_app/utils/auth_service.dart';

import '../components/forms/custom_password_field.dart';
import '../components/forms/custom_text_field.dart';

class PageInscription extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mdpController = TextEditingController();
  final TextEditingController mdpConfirmController = TextEditingController();
  final language = "fr";
  PageInscription({super.key});

  @override
  Widget build(BuildContext context) {
    // final textes = language =="fr" ? FrLanguageData.contenuPageInscription : null;
    const textes = FrLanguageData.contenuPageInscription;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: screenSize.width,
          height: screenSize.height,
          child: FormBuilder(
            child: Column(
              children: [
                Text(
                  textes["titre"]!,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                CustomTextField(
                    name: "email",
                    labelText: InscriptionText.labelDescEmail,
                    labelTitle: InscriptionText.labelTitleEmail,
                    controller: emailController,
                    icon: Icons.email_rounded),
                const SizedBox(
                  height: 20,
                ),
                CustomPasswordField(
                    labelTitle: InscriptionText.labelTitleMdp,
                    labelText: InscriptionText.labelDescMdp,
                    name: "password",
                    controller: mdpController,
                    icon: Icons.password),
                const SizedBox(
                  height: 20,
                ),
                CustomPasswordField(
                    labelTitle: InscriptionText.labelTitleMdp2,
                    labelText: InscriptionText.labelDescMdp2,
                    name: "password_confirm",
                    controller: mdpConfirmController,
                    icon: Icons.password),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    emailController.value.composing.isValid;
                    final message = await AuthService().registration(
                      email: emailController.text,
                      password: mdpController.text,
                    );
                    if (message!.contains('Success')) {
                      Navigator.of(context)
                          .pushReplacementNamed("/remplirProfil");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  },
                  child: SizedBox(
                      width: screenSize.width - 60,
                      child: const Text(
                        InscriptionText.actionButton,
                        textAlign: TextAlign.center,
                      )),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: screenSize.width - 60,
                  child: FormBuilderCheckbox(
                      checkColor: Palette.background,
                      activeColor: Palette.blue,
                      initialValue: true,
                      name: "conditions",
                      title: const Text(InscriptionText.conditions)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(InscriptionText.haveAccount),
                    TextButton(
                        onPressed: () =>
                            Navigator.of(context).popAndPushNamed("/connexion"),
                        child: const Text(
                          InscriptionText.actionTextButton,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
