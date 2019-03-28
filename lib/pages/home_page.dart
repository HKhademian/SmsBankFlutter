import 'package:flutter/material.dart';
import 'package:smsbank/screens/screens.dart';

class HomePage extends StatefulWidget {
	HomePage({Key key}) : super(key: key);

	@override createState() => _State();
}

class _State extends State<HomePage> {
	final _pageController = PageController(initialPage: 1);
	int _page = 1;

	@override build(context) {
		return WillPopScope(
			onWillPop: () => _exitApp(context),
			child: Scaffold(
				appBar: AppBar(
					title: Text('بانک پیامک'),
					centerTitle: true,
				),

				body: PageView.builder(
					controller: _pageController,
					onPageChanged: _onPageChanged,
					itemCount: 3,
					itemBuilder: (context, index) {
						switch (index) {
							case 0:
								return TestScreen();
							case 1:
								return CategoryScreen();
							case 2:
								return TestScreen();
						}
						return TestScreen();
					},
				),

				bottomNavigationBar: BottomNavigationBar(
					currentIndex: _page,
					onTap: _onNavigationTapped,
					items: [
						BottomNavigationBarItem(
							icon: Icon(Icons.info),
							title: Text('درباره ما'),
						),
						BottomNavigationBarItem(
							icon: Icon(Icons.home),
							title: Text('دسته بندی ها'),
						),
						BottomNavigationBarItem(
							icon: Icon(Icons.settings),
							title: Text('تنظیمات'),
						),
					],
				),
			),
		);
	}

	_onNavigationTapped(int index) {
		_pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
	}

	_onPageChanged(int page) {
		setState(() {
			_page = page;
		});
	}

	Future<bool> _exitApp(context) async {
		return await showDialog(
			context: context,
			builder: (context) =>
			new AlertDialog(
				title: new Text('جدی می خوای بری؟'),
				content: new Text('کاش میموندی ...'),
				actions: [
					new FlatButton(
						onPressed: () => Navigator.of(context).pop(false),
						child: new Text('باش، می مونم'),
					),
					new FlatButton(
						onPressed: () => Navigator.of(context).pop(true),
						child: new Text('واقعا باید برم'),
					),
				],
			),
		) ?? false;
	}
}
