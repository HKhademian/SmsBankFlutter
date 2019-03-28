import 'package:flutter/material.dart';
import 'package:smsbank/screens/query_screen.dart';
import 'package:smsbank/data/repository.dart';
import 'package:smsbank/data/query_data.dart';

class QueryPage extends StatelessWidget {
	QueryPage({Key key, this.query}) : super(key: key);

	final QueryData query;

	@override build(context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(_title),
			),

			body: QueryScreen(query: query),
		);
	}

	get _title {
		if (query == null) {
			return 'پیام ها';
		} else if (query.categoryId > 0) {
			return 'دسته "${Repository.categories
				.firstWhere((cat) => cat.id == query.categoryId)
				?.title ?? 'نامشخص'}"';
		} else if (query.fav) {
			return 'علاقه مندی ها';
		} else if (query.search.isNotEmpty) {
			return 'جستجوی "${query.search}"';
		} else {
			return 'پیام ها';
		}
	}
}
