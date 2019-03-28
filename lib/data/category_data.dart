class CategoryData {
	static const TABLE = 'SmsCategory';
	static const COL_ID = '_id';
	static const COL_PARENT_ID = 'parentId';
	static const COL_TITLE = 'title';
	static const COL_IMAGE = 'image';

	final int id;
	final int parentId;
	final String title;

	const CategoryData({ this.id, this.parentId, this.title});

	CategoryData.copy(CategoryData from, {id, parentId, title}) : this(
		id: id ?? from.id,
		parentId: parentId ?? from.parentId,
		title: title ?? from.title,
	);

	CategoryData.fromMap(Map<String, dynamic> map) : this(
		id: map[COL_ID],
		parentId: map[COL_PARENT_ID],
		title: map[COL_TITLE],
	);

	Map<String, dynamic> toMap() {
		final map = <String, dynamic>{
			COL_PARENT_ID: parentId,
			COL_TITLE: title,
		};
		if (id != null) {
			map[COL_ID] = id;
		}
		return map;
	}
}
