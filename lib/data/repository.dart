import 'package:smsbank/data/db.dart';
import 'package:smsbank/data/category_data.dart';

class Repository {
	Repository._();

	static final List<CategoryData> categories = [];
	static final Map<int, int> messageCount = {};


	static Future<bool> init() async {
		await DB.init();
		categories.clear();
		messageCount.clear();

		final cats = await DB.listCategory();
		categories.addAll(cats);
		for (final cat in categories) {
			messageCount[cat.id ] = await DB.getMessageCountByCatId(cat.id);
		}
		return true;
	}
}
