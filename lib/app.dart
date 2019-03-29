import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smsbank/data/repository.dart';
import 'package:smsbank/pages/pages.dart';

class App extends StatelessWidget {
	final locale = Locale('fa', 'IR');

	@override build(context) {
		return MaterialApp(
			title: 'بانک پیامک',

			theme: ThemeData(
				primarySwatch: Colors.indigo,
			),

			localizationsDelegates: [
				GlobalMaterialLocalizations.delegate,
				GlobalWidgetsLocalizations.delegate,
			],
			supportedLocales: [locale],
			locale: locale,

			home: FutureBuilder<bool>(
				future: Repository.init(),
				initialData: false,
				builder: (context, snapshot) {
					if (snapshot.hasData && snapshot.data) {
						return HomePage();
					}
					return SplashPage();
				},
			),

			onUnknownRoute: (setting) {
				return MaterialPageRoute(builder: (context) => Text('صفحه ای یافت نشد'));
			},
		);
	}
}
