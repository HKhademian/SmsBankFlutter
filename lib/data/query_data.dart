class QueryData {
	final int categoryId;
	final String search;
	final bool fav;

	const QueryData({this.categoryId, this.search, this.fav});

	@override toString() {
		return 'CI:$categoryId F:$fav S:$search';
	}
}
