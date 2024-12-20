import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/screens/login.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before the test starts
  await Firebase.initializeApp();

  group('End-to-End Test', () {
    testWidgets('Navigate to Login Page, enter credentials, press Connect to the Server button, and click Login button', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPage());


      // Wait for the page to navigate to LoginPage
      await tester.pumpAndSettle();

      // Verify we are on the LoginPage
      expect(find.byType(LoginPage), findsOneWidget);

      // Find the "Email" and "Password" TextFields
      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);

      // Enter email and password into the fields
      await tester.enterText(emailField, 'mostafa@gmail.com');
      await tester.enterText(passwordField, '123456789');

      // Verify if the email and password are entered correctly
      expect(find.text('mostafa@gmail.com'), findsOneWidget);
      expect(find.text('123456789'), findsOneWidget);

      final loginButton = find.text('Login');

      // Verify that the "Login" button exists
      expect(loginButton, findsOneWidget);

      // Tap the "Login" button
      await tester.tap(loginButton);


      final phoneField = find.byType(TextFormField);
      expect(phoneField, findsOneWidget);

      // Enter the phone number into the TextFormField
      await tester.enterText(phoneField, '01124949897');

      final saveButton = find.byKey(const Key("add_friend_phone"));
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 2));
      final myEventsButton = find.text('Create Your Own Event/List');

      expect(myEventsButton, findsOneWidget);
      await tester.tap(myEventsButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

    });
  });
}