import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;
import 'package:smsbank/data/category_data.dart';
import 'package:smsbank/data/message_data.dart';
import 'package:smsbank/data/query_data.dart';

class DB {
	DB._();

	static sqflite.Database _database;

	static close() async {
		await _database?.close();
		_database = null;
	}

	static Future<sqflite.Database> get _db async {
		if (_database == null || !_database.isOpen) {
			await init();
		}
		return _database;
	}

	static init() async {
		await close();

		final databasesPath = await sqflite.getDatabasesPath();
		final dbPath = path.join(databasesPath, 'database.db');
		final dbFile = File(dbPath);

		if (!await dbFile.exists()) {
			final data = await rootBundle.load('assets/database.db');
			final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
			await dbFile.create(recursive: true);
			await dbFile.writeAsBytes(bytes);
//			final archive = ZipDecoder().decodeBytes(bytes);
//			for (final file in archive) {
//				final content = await compute((ArchiveFile f) => f.content, file);
//				await dbFile.create(recursive: true);
//				await dbFile.writeAsBytes(content);
//				break;
//			}
		}

		_database = await sqflite.openDatabase(
			dbPath,
			version: 1,
			// onOpen: (db) async {},
			// onCreate: (db, version) async {},
		);
	}

	static Future<List<CategoryData>> listCategory() async {
		final db = await _db;
		final res = await db.query(CategoryData.TABLE);
		return res.isEmpty ? [] : res.map((data) => CategoryData.fromMap(data)).toList();
	}

	static Future<CategoryData> insertCategory(CategoryData item) async {
		final db = await _db;
		final id = await db.insert(CategoryData.TABLE, item.toMap());
		return CategoryData.copy(item, id: id);
	}

	static Future<CategoryData> getCategoryById(int id) async {
		final db = await _db;
		final res = await db.query(CategoryData.TABLE,
			columns: [CategoryData.COL_ID, CategoryData.COL_PARENT_ID, CategoryData.COL_TITLE],
			where: '${CategoryData.COL_ID} = ?',
			whereArgs: [id]);
		return res.isEmpty ? null : CategoryData.fromMap(res.first);
	}


	static Future<List<MessageData>> listMessage() async {
		final db = await _db;
		final res = await db.query(MessageData.TABLE);
		return res.isEmpty ? [] : res.map((data) => MessageData.fromMap(data)).toList();
	}

	static Future<MessageData> insertMessage(MessageData item) async {
		final db = await _db;
		final id = await db.insert(MessageData.TABLE, item.toMap());
		return MessageData.copy(item, id: id);
	}

	static Future<MessageData> getMessageById(int id) async {
		final db = await _db;
		final res = await db.query(MessageData.TABLE,
			columns: [MessageData.COL_ID, MessageData.COL_CAT_ID, MessageData.COL_CONTENT],
			where: '${MessageData.COL_ID} = ?',
			whereArgs: [id]);
		return res.isEmpty ? null : MessageData.fromMap(res.first);
	}

	static Future<int> getMessageCountByCatId(int catId) async {
		final db = await _db;
		final res = await db.rawQuery("SELECT COUNT(*) FROM ${MessageData.TABLE} WHERE ${MessageData.COL_CAT_ID} = ?", [ catId]);
		return sqflite.Sqflite.firstIntValue(res);
	}

	static Future<List<MessageData>> queryMessage(QueryData query, {limit: 10, offset: 0}) async {
		final db = await _db;
		_genWhere(QueryData query) {
			if (query == null)
				return [];
			if (query.categoryId != null)
				return '${MessageData.COL_CAT_ID} = ?';
			if (query.search != null)
				return '${MessageData.COL_CONTENT} LIKE ?';
			return [];
		}

		_genWhereArgs(QueryData query) {
			if (query == null)
				return [];
			if (query.categoryId != null)
				return [query.categoryId];
			if (query.search != null)
				return [query.search];
			return [];
		}

		final where = _genWhere(query);
		final whereArgs = _genWhereArgs(query);
		final res = await db.query(MessageData.TABLE, where: where, whereArgs: whereArgs, limit: limit, offset: offset);
		return res.isEmpty ? [] : res.map((data) => MessageData.fromMap(data)).toList();
	}


}
