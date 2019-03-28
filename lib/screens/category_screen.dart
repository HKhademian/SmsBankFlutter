import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smsbank/data/category_data.dart';
import 'package:smsbank/data/query_data.dart';
import 'package:smsbank/data/repository.dart';
import 'package:smsbank/pages/query_page.dart';

class CategoryScreen extends StatefulWidget {
	CategoryScreen({Key key}) : super(key: key);

	final _categories = Repository.categories;
	final _topCategories = Repository.categories.where((it) => it.parentId == 0).toList();

	@override createState() => _State();
}

class _State extends State<CategoryScreen> {
	final _biggerFont = const TextStyle(fontSize: 18.0);

	int _catId = -1;

	get _currentCatId => _catId;

	set _currentCatId(id) {
		setState(() {
			_catId = id;
		});
	}

	@override build(context) {
		return StaggeredGridView.countBuilder(
			padding: const EdgeInsets.all(16.0),
			itemCount: widget._topCategories.length,
			itemBuilder: (context, position) => _createListItem(context, position),
			crossAxisCount: 6,
			staggeredTileBuilder: (position) => _createStaggeredTile(position),
		);
	}

	StaggeredTile _createStaggeredTile(position) {
		final cat = widget._topCategories[position];
		final cols = 3;
		final rows = cat.id == _currentCatId ? 6 : 3;
		return StaggeredTile.count(cols, rows);
	}

	Widget _createListItem(context, position) {
		final cat = widget._topCategories[position];

		final onTap = () {
			if (_currentCatId != cat.id) {
				if (widget._categories.any((c) => c.parentId == cat.id))
					_currentCatId = cat.id;
				else
					_queryCategory(context, cat.id); // open query for category
			} else {
				_currentCatId = -1;
			}
		};

		final title = FlatButton(
			onPressed: onTap,
			child: Text(cat.title, style: _biggerFont),
		);

		if (_currentCatId != cat.id)
			return Card(
				child: title,
			);

		final subCats = widget._categories
			.where((c) => c.parentId == cat.id && (Repository.messageCount[c.id] ?? 0) > 0)
			.toList();

		return Card(
			child: Column(
				children: [
					title,
					Expanded(
						child: ListView.separated(
							itemBuilder: (context, index) => _createSubItems(context, subCats[index], position),
							separatorBuilder: (context, index) => Divider(height: 1.0),
							itemCount: subCats.length,
						),
					),
				],
			),
		);
	}

	Widget _createSubItems(BuildContext context, CategoryData cat, int position) {
		return ListTile(
			title: Text(cat.title, maxLines: 1, textAlign: TextAlign.center),
			onTap: () => _queryCategory(context, cat.id),
		);
	}

	Future _queryCategory(BuildContext context, int categoryId) {
		return Navigator.of(context).push(MaterialPageRoute(builder: (context) {
			return QueryPage(query: QueryData(categoryId: categoryId));
		}));
		// return Navigator.of(context).pushNamed('/query', arguments: QueryData(categoryId: categoryId));
	}
}
