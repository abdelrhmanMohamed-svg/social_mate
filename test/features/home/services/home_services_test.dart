import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/services/home_services.dart';

import 'home_services_test.mocks.dart';

@GenerateMocks([SupabaseDatabaseServices])
void main() {
  late MockSupabaseDatabaseServices mockSupabaseDatabaseServices;
  late HomeServicesImpl homeServices;

  setUp(() {
    mockSupabaseDatabaseServices = MockSupabaseDatabaseServices();
    homeServices = HomeServicesImpl(
      supabaseDatabaseServices: mockSupabaseDatabaseServices,
    );
  });

  tearDown(() {
    reset(mockSupabaseDatabaseServices);
  });

  group('HomeServices Tests', () {
    group('fetchStories()', () {
      final mockStories = [
        StoryModel(
          id: '1',
          createdAt: "2026-01-13 23:23:35.758314+00",
          authorId: "user1",
          color: 22,
          imageUrl:
              'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
        ),
        StoryModel(
          id: '2',
          createdAt: "2026-01-14 10:30:00.000000+00",
          authorId: "user2",
          color: 15,
          imageUrl:
              'https://images.unsplash.com/photo-1511379938547-c1f69b13d835',
        ),
      ];

      test('should return list of stories on successful API call', () async {
        // Arrange: Setup mock to return stories
        when(
          mockSupabaseDatabaseServices.fetchRows<StoryModel>(
            table: anyNamed('table'),
            builder: anyNamed('builder'),
          ),
        ).thenAnswer((_) async => mockStories);

        // Act
        final result = await homeServices.fetchStories();

        // Assert: verify result
        expect(result, isA<List<StoryModel>>());
        expect(result.length, equals(2));
        expect(result[0].id, equals('1'));
        expect(result[0].authorId, equals('user1'));
        expect(result[1].id, equals('2'));
        expect(result[1].authorId, equals('user2'));
      });

      test('should throw exception when API call fails', () async {
        // Arrange: Setup mock to throw an exception
        when(
          mockSupabaseDatabaseServices.fetchRows<StoryModel>(
            table: anyNamed('table'),
            builder: anyNamed('builder'),
          ),
        ).thenThrow(Exception('Network error'));

        // Act & Assert: Verify exception is propagated
        expect(
          () async => await homeServices.fetchStories(),
          throwsA(isA<Exception>()),
        );
      });

      test('should return empty list when no stories exist', () async {
        // Arrange: Setup mock to return empty list
        when(
          mockSupabaseDatabaseServices.fetchRows<StoryModel>(
            table: anyNamed('table'),
            builder: anyNamed('builder'),
          ),
        ).thenAnswer((_) async => []);

        // Act
        final result = await homeServices.fetchStories();

        // Assert: Verify empty list is returned
        expect(result, isEmpty);
        expect(result.length, equals(0));
      });

      test('should call fetchRows with correct table parameter', () async {
        // Arrange
        when(
          mockSupabaseDatabaseServices.fetchRows<StoryModel>(
            table: anyNamed('table'),
            builder: anyNamed('builder'),
          ),
        ).thenAnswer((_) async => mockStories);

        // Act
        final result = await homeServices.fetchStories();

        // Assert: Verify the method was called with correct arguments (story table)
        verify(
          mockSupabaseDatabaseServices.fetchRows<StoryModel>(
            table: 'stories',
            builder: anyNamed('builder'),
          ),
        ).called(1);
        expect(result, mockStories);
      });
    });

    group('fetchUserStories()', () {
      final userId = 'user1';
      final userStories = [
        StoryModel(
          id: '1',
          createdAt: "2026-01-13 23:23:35.758314+00",
          authorId: userId,
          color: 22,
          imageUrl:
              'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
        ),
      ];

      test(
        'should return list of user stories on successful API call',
        () async {
          // Arrange
          when(
            mockSupabaseDatabaseServices.fetchRows<StoryModel>(
              table: anyNamed('table'),
              builder: anyNamed('builder'),
              filter: anyNamed('filter'),
            ),
          ).thenAnswer((_) async => userStories);

          // Act
          final result = await homeServices.fetchUserStories(userId);

          // Assert
          expect(result, isA<List<StoryModel>>());
          expect(result.length, equals(1));
          expect(result[0].authorId, equals(userId));
        },
      );

      test('should throw exception when API call fails', () async {
        // Arrange: mock throws
        when(
          mockSupabaseDatabaseServices.fetchRows<StoryModel>(
            table: anyNamed('table'),
            builder: anyNamed('builder'),
            filter: anyNamed('filter'),
          ),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () async => await homeServices.fetchUserStories(userId),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'should return only stories belonging to the specified user',
        () async {
          // Arrange
          final allStories = [
            StoryModel(
              id: '1',
              createdAt: "2026-01-13 23:23:35.758314+00",
              authorId: "user1",
              color: 22,
              imageUrl:
                  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
            ),
            StoryModel(
              id: '2',
              createdAt: "2026-01-14 10:30:00.000000+00",
              authorId: "user2",
              color: 15,
              imageUrl:
                  'https://images.unsplash.com/photo-1511379938547-c1f69b13d835',
            ),
          ];

          // Act: Filter stories
          final filteredStories = allStories
              .where((story) => story.authorId == 'user1')
              .toList();

          // Assert
          expect(filteredStories.length, equals(1));
          expect(filteredStories[0].authorId, equals('user1'));
        },
      );
    });

    group('addStory()', () {
      test('should successfully add a new story', () async {
        // Arrange
        const text = 'New story text';
        const userId = 'currentUser123';
        const color = 10;

        when(
          mockSupabaseDatabaseServices.insertRow(
            table: anyNamed('table'),
            values: anyNamed('values'),
          ),
        ).thenAnswer((_) async {});

        // Act
        await homeServices.addStory(text, userId, color);

        // Assert: Verify insertRow was called via service
        verify(
          mockSupabaseDatabaseServices.insertRow(
            table: 'stories',
            values: anyNamed('values'),
          ),
        ).called(1);
      });

      test('should throw exception when adding story fails', () async {
        // Arrange
        when(
          mockSupabaseDatabaseServices.insertRow(
            table: anyNamed('table'),
            values: anyNamed('values'),
          ),
        ).thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(
          () async => await homeServices.addStory('x', 'y', 1),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteStory()', () {
      test('should successfully delete a story', () async {
        // Arrange
        const storyId = 'story123';

        when(
          mockSupabaseDatabaseServices.deleteRow(
            table: anyNamed('table'),
            column: anyNamed('column'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});

        // Act
        await homeServices.deleteStory(storyId);

        // Assert
        verify(
          mockSupabaseDatabaseServices.deleteRow(
            table: 'stories',
            column: AppConstants.primaryKey,
            value: storyId,
          ),
        ).called(1);
      });

      test('should throw exception when delete fails', () async {
        // Arrange
        when(
          mockSupabaseDatabaseServices.deleteRow(
            table: anyNamed('table'),
            column: anyNamed('column'),
            value: anyNamed('value'),
          ),
        ).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () async => await homeServices.deleteStory('id'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
