import 'package:flutter/material.dart';
import 'package:smsbank/data/db.dart';
import 'package:smsbank/data/message_data.dart';
import 'package:smsbank/data/query_data.dart';

class QueryScreen extends StatefulWidget {
	QueryScreen({Key key, this.query}) : super(key: key);

	final QueryData query;

	@override createState() => _State();
}

class _State extends State<QueryScreen> {
	final List<MessageData> items = [];
	bool more = true;

	@override
	void initState() {
		super.initState();
		items.clear();
		more = false;
		_query(context);
	}

	@override build(context) {
		if (items.isEmpty)
			return Center(child: Text('چیزی پیدا نشد :('));

		return ListView.builder(
			itemCount: items.length + (more ? 1 : 0),
			itemBuilder: (context, index) {
				final theme = Theme.of(context);

				if (index >= items.length)
					return Padding(
						padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
						child: RaisedButton(
							color: theme.primaryColor,
							textColor: theme.cardColor,
							onPressed: () => _query(context),
							child: Text("موارد بیشتر ..."),
						),
					);
				return _MessageCard(message: items[index % items.length]);
			},
		);
	}

	_query(context) {
		DB.queryMessage(widget.query, offset: items.length).then((res) {
			if (res != null && res.isNotEmpty)
				setState(() {
					more = true;
					items.addAll(res);
				});
			else {
				setState(() {
					more = false;
				});

				Scaffold.of(context).showSnackBar(SnackBar(
					content: Text('به اتمام رسید'),
				));
			}
		}, onError: (err) {});
	}
}

class _MessageCard extends StatelessWidget {
	_MessageCard({ Key key, this.message }) : super(key: key);

	final MessageData message;

	@override build(context) {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
			child: Card(child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					Padding(
						padding: EdgeInsets.all(8.0),
						child: Text(
							message.content,
							// textAlign: TextAlign.right,
							textDirection: TextDirection.rtl,
							style: Theme
								.of(context)
								.textTheme
								.body1,
						),
					),
					Divider(height: 0.0),
					Row(
						mainAxisSize: MainAxisSize.max,
						children: [
							IconButton(
								icon: Icon(Icons.share),
								color: Colors.pink,
								onPressed: () {},
							),
							Divider(),
							IconButton(
								icon: Icon(Icons.content_copy),
								color: Colors.grey,
								onPressed: () {},
							),
//							Divider(),
//							IconButton(
//								icon: Icon(Icons.bookmark),
//								color: Colors.pink,
//								onPressed: () {},
//							),
						],
					),
				],
			)),
		);
	}
}
