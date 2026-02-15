import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseServices {
  // Singleton pattern to ensure a single instance
  SupabaseDatabaseServices._();
  static final instance = SupabaseDatabaseServices._();

  /// Internal Supabase client reference
  SupabaseClient get _db => Supabase.instance.client;

  // ------------------
  // Write operations
  // ------------------

  /// Inserts a new row into the given [table] with the provided [values].
  ///
  /// - [table]: the name of the table to insert into.
  /// - [values]: a map of column names to values.
  ///
  /// Throws a [PostgrestException] if the insert fails.
  Future<void> insertRow({
    required String table,
    required Map<String, dynamic> values,
  }) async {
    try {
      // Perform the insert operation
      await _db.from(table).insert(values);
    } on PostgrestException catch (e) {
      // Log and rethrow database errors
      debugPrint('Insert error on $table: ${e.message}');
      rethrow;
    }
  }

  // Insert a new row into [table] with the provided [values], returning the inserted row.
  // في SupabaseDatabaseServices class
  Future<Map<String, dynamic>> insertRowWithReturn({
    required String table,
    required Map<String, dynamic> values,
  }) async {
    try {
      final response = await _db.from(table).insert(values).select().single();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //count rows in [table] where [column] equals [value].
  // في SupabaseDatabaseServices class
  Future<int> countRows({
    required String table,
    required PostgrestFilterBuilder Function(PostgrestFilterBuilder query)
    filter,
  }) async {
    try {
      PostgrestFilterBuilder query = _db.from(table).select('*');

      query = filter(query);

      final countQuery = query.count(CountOption.exact);

      final response = await countQuery;

      return response.count;
    } catch (e) {
      rethrow;
    }
  }

  /// Updates rows in [table] where [column] equals [value], setting them to [values].
  ///
  /// - [table]: the table to update.
  /// - [values]: a map of updated column names to new values.
  /// - [column]: the column to filter on.
  /// - [value]: the value to match in the filter column.
  ///
  /// Throws a [PostgrestException] if the update fails.
  Future<void> updateRow({
    required String table,
    required Map<String, dynamic> values,
    required String column,
    required dynamic value,
    PostgrestFilterBuilder Function(PostgrestFilterBuilder query)? filter,
  }) async {
    try {
      // Perform the update operation with a filter
      if (filter != null) {
        await filter(_db.from(table).update(values)).single();
      } else {
        await _db.from(table).update(values).eq(column, value);
      }
    } on PostgrestException catch (e) {
      debugPrint('Update error on $table where $column==$value: ${e.message}');
      rethrow;
    }
  }

  // Update rows in [table] where [column] equals [value], setting them to [values], returning the updated row.
  Future<void> updateRows({
    required String table,
    required Map<String, dynamic> values,
    required PostgrestFilterBuilder Function(PostgrestFilterBuilder query)
    filter,
  }) async {
    try {
      var query = _db.from(table).update(values);
      query = filter(query);

      await query;
    } catch (e) {
      rethrow;
    }
  }

  /// Inserts or updates (upserts) rows in [table].
  ///
  /// - [table]: the table to operate on.
  /// - [values]: the row data to insert or update.
  /// - [onConflict]: optional column(s) to detect conflicts.
  /// - [ignoreDuplicates]: whether to ignore duplicates when upserting.
  ///
  /// Throws a [PostgrestException] if the upsert fails.
  Future<void> upsertRow({
    required String table,
    required Map<String, dynamic> values,
    String? onConflict,
    bool ignoreDuplicates = true,
  }) async {
    try {
      // Perform upsert with conflict resolution
      await _db
          .from(table)
          .upsert(
            values,
            onConflict: onConflict,
            ignoreDuplicates: ignoreDuplicates,
          );
    } on PostgrestException catch (e) {
      debugPrint('Upsert error on $table: ${e.message}');
      rethrow;
    }
  }

  //update row if exists, otherwise insert new row
  Future<void> updateRowIfExists({
    required String table,
    required String column,
    required dynamic value,
    required Map<String, dynamic> values,
  }) async {
    try {
      // 1. Check if the row exists with the given filter
      final exists = await fetchRows(
        table: table,
        builder: (data, id) => data,
        filter: (query) => query.eq(column, value),
      );

        // 2. If it exists, perform the update; otherwise, do nothing
      if (exists.isEmpty) {
        return;
      }
      // Perform the update operation with a filter

      var query = _db.from(table).update(values).eq(column, value);
      await query;  
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes rows from [table] where [column] equals [value].
  ///
  /// - [table]: the table from which to delete.
  /// - [column]: the column to filter on.
  /// - [value]: the value to match for deletion.
  ///
  /// Throws a [PostgrestException] if the delete fails.
  Future<void> deleteRow({
    required String table,
    required String column,
    required dynamic value,
  }) async {
    try {
      // Perform delete with a filter condition
      await _db.from(table).delete().eq(column, value);
    } on PostgrestException catch (e) {
      debugPrint('Delete error on $table where $column==$value: ${e.message}');
      rethrow;
    }
  }

  // ------------------
  // Realtime subscriptions
  // ------------------

  /// Subscribes to realtime changes on all rows in [table].
  ///
  /// - [table]: the table to listen on.
  /// - [primaryKey]: list of columns to uniquely identify rows.
  /// - [builder]: function to map each row into a model instance.
  /// - [filter]: optional function to apply additional realtime filters.
  /// - [sort]: optional comparator to sort the results.
  ///
  /// Returns a [Stream] emitting lists of mapped model instances.
  Stream<List<T>> tableStream<T>({
    required String table,
    required List<String> primaryKey,
    required T Function(Map<String, dynamic> data, String id) builder,
    SupabaseStreamFilterBuilder Function(SupabaseStreamFilterBuilder query)?
    filter,
    int Function(T a, T b)? sort,
  }) {
    // Create the base realtime stream
    var streamQuery = _db.from(table).stream(primaryKey: primaryKey);
    if (filter != null) {
      // Apply any additional realtime filters
      streamQuery = filter(streamQuery);
    }
    // Map each update into model instances
    return streamQuery.map((rows) {
      final list = rows.map((row) {
        final id = row[primaryKey.first]?.toString() ?? '';
        return builder(row, id);
      }).toList();
      if (sort != null) list.sort(sort);
      return list;
    });
  }

  /// Subscribes to realtime changes for a single row identified by [id].
  ///
  /// - [table]: the table to listen on.
  /// - [primaryKey]: the column identifying the row.
  /// - [id]: the specific primary key value.
  /// - [builder]: function to map the row into a model instance.
  ///
  /// Returns a [Stream] emitting updated model instances.
  Stream<T> recordStream<T>({
    required String table,
    required String primaryKey,
    required String id,
    required T Function(Map<String, dynamic> data, String id) builder,
  }) {
    var streamQuery = _db
        .from(table)
        .stream(primaryKey: [primaryKey])
        .eq(primaryKey, id);
    return streamQuery.map((rows) {
      final row = rows.first;
      return builder(row, row[primaryKey]?.toString() ?? '');
    });
  }

  // ------------------
  // One-time fetch
  // ------------------

  /// Fetches a single row from [table] where [primaryKey] == [id].
  ///
  /// - [table]: the table to query.
  /// - [primaryKey]: the column to filter on.
  /// - [id]: the value to match for a single row.
  /// - [builder]: function to map the result into a model.
  ///
  /// Returns the mapped model instance or throws a [PostgrestException].
  Future<T> fetchRow<T>({
    required String table,
    required String primaryKey,
    required String id,
    required T Function(Map<String, dynamic> data, String id) builder,
  }) async {
    try {
      // Retrieve a single row with filtering
      final data = await _db.from(table).select().eq(primaryKey, id).single();
      return builder(data, data[primaryKey]?.toString() ?? '');
    } on PostgrestException catch (e) {
      debugPrint(
        'Fetch row error on $table where $primaryKey==$id: ${e.message}',
      );
      rethrow;
    }
  }

  /// Fetches multiple rows from [table], applying optional filters and sorting.
  ///
  /// - [table]: the table to query.
  /// - [builder]: function to map each row into a model.
  /// - [primaryKey]: optional column to extract IDs for each row.
  /// - [filter]: optional function to apply query filters.
  /// - [sort]: optional comparator to sort the result list.
  ///
  /// Returns a [List] of mapped model instances or throws a [PostgrestException].
  Future<List<T>> fetchRows<T>({
    required String table,
    required T Function(Map<String, dynamic> data, String id) builder,
    String? primaryKey,
    PostgrestFilterBuilder Function(PostgrestFilterBuilder query)? filter,
    int Function(T a, T b)? sort,
  }) async {
    try {
      // Build the base select query
      var query = _db.from(table).select() as PostgrestFilterBuilder;
      if (filter != null) {
        // Apply any additional filters
        query = filter(query);
      }
      // Execute and cast to list
      final rows = (await query) as List<dynamic>;
      final list = rows.map((e) {
        final row = e as Map<String, dynamic>;
        final id = primaryKey != null ? row[primaryKey]?.toString() ?? '' : '';
        return builder(row, id);
      }).toList();
      if (sort != null) list.sort(sort);
      return list;
    } on PostgrestException catch (e) {
      debugPrint('Fetch rows error on $table: ${e.message}');
      rethrow;
    }
  }

  Future<List<T>> fetchRowsWithTransform<T>({
    required String table,
    required T Function(Map<String, dynamic> data, String id) builder,
    String? primaryKey,

    // WHERE
    PostgrestFilterBuilder Function(PostgrestFilterBuilder query)? filter,

    // ORDER / RANGE / LIMIT
    PostgrestTransformBuilder Function(PostgrestFilterBuilder query)? transform,

    // Client-side sort (optional)
    int Function(T a, T b)? sort,
  }) async {
    try {
      // base query
      var query = _db.from(table).select() as PostgrestFilterBuilder;

      // 1️⃣ apply filters
      if (filter != null) {
        query = filter(query);
      }

      // 2️⃣ apply transforms
      final finalQuery = transform != null ? transform(query) : query;

      // execute
      final rows = await finalQuery as List<dynamic>;

      final list = rows.map((e) {
        final row = e as Map<String, dynamic>;
        final id = primaryKey != null ? row[primaryKey]?.toString() ?? '' : '';
        return builder(row, id);
      }).toList();

      if (sort != null) list.sort(sort);
      return list;
    } on PostgrestException catch (e) {
      debugPrint('Fetch rows error on $table: ${e.message}');
      rethrow;
    }
  }
}
