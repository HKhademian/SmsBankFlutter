class MessageData {
	static const TABLE = 'SmsMessage';
	static const COL_ID = '_id';
	static const COL_CAT_ID = 'categoryId';
	static const COL_CONTENT = 'text';
	static const COL_FAV = 'favorite';
	static const COL_USER = 'user';

	final int id;
	final int categoryId;
	final String content;

	const MessageData({ this.id, this.categoryId, this.content});

	MessageData.copy(MessageData from, {id, categoryId, content}) : this(
		id: id ?? from.id,
		categoryId: categoryId ?? from.categoryId,
		content: content ?? from.content,
	);

	MessageData.fromMap(Map<String, dynamic> map) : this(
		id: map[COL_ID],
		categoryId: map[COL_CAT_ID],
		content: map[COL_CONTENT],
	);

	Map<String, dynamic> toMap() {
		final map = <String, dynamic>{
			COL_CAT_ID: categoryId,
			COL_CONTENT: content,
		};
		if (id != null) {
			map[COL_ID] = id;
		}
		return map;
	}
}
