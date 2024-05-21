import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servy_app/static_test/fr.dart';
import 'package:servy_app/utils/auth_service.dart';
import 'package:servy_app/utils/servy_backend.dart';

import '../components/forms/custom_password_field.dart';
import '../components/forms/custom_text_field.dart';

class PageConnexion extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mdpController = TextEditingController();
  final TextEditingController mdpConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  PageConnexion({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: screenSize.width,
        height: screenSize.height,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Text(
                ConnexionText.titre,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              CustomTextField(
                  name: "email",
                  labelText: ConnexionText.labelDescEmail,
                  labelTitle: ConnexionText.labelTitleEmail,
                  controller: emailController,
                  icon: Icons.email_rounded),
              const SizedBox(
                height: 20,
              ),
              CustomPasswordField(
                  labelTitle: ConnexionText.labelTitleMdp,
                  labelText: ConnexionText.labelDescMdp,
                  name: "password",
                  controller: mdpController,
                  icon: Icons.password),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.isValid) {
                    final message = await AuthService().login(
                      email: emailController.text,
                      password: mdpController.text,
                    );

                    if (message!.contains('Success')) {
                      final profilRempli = await ServyBackend().userExist();
                      Navigator.of(context).popAndPushNamed(
                          profilRempli == ServyBackend.success
                              ? "/main"
                              : "/remplirProfil");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Remplisssez tous les champs"),
                      ),
                    );
                  }
                },
                child: SizedBox(
                    width: screenSize.width - 60,
                    child: const Text(
                      ConnexionText.actionButton,
                      textAlign: TextAlign.center,
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(ConnexionText.haveAccount),
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).popAndPushNamed("/inscription"),
                      child: const Text(
                        ConnexionText.actionTextButton,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
