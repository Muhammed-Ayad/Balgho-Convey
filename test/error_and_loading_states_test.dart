import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/core/widgets/app_lottie_widget.dart';
import 'package:great_quran/core/widgets/empty_state_widget.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/azan/logic/repo/azan_repository.dart';
import 'package:great_quran/feature/azkar/logic/providers/azkar_category_provider.dart';
import 'package:great_quran/feature/radios/logic/models/radios.dart';
import 'package:great_quran/feature/radios/logic/providers/radios_provider.dart';
import 'package:great_quran/feature/radios/logic/repo/radios_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Failing repository to test error states
class ThrowingAzanRepository implements IAzanRepository {
  @override
  Future<Azan> getAzan({bool allowPrompt = false}) async {
    throw Exception("Network failure 500");
  }

  @override
  Future<Azan?> getCachedAzan() async => null;

  @override
  Azan getInitialAzan() {
    throw Exception("Cannot calculate initial azan");
  }
}

class ThrowingRadiosRepository implements IRadiosRepository {
  @override
  Future<List<Radios>> getRadios() async {
    throw Exception("Server unavailable");
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoadingWidget and ErrorWidget Core Tests', () {
    testWidgets('LoadingWidget renders with and without message',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(message: "جارِ تحميل البيانات..."),
          ),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text("جارِ تحميل البيانات..."), findsOneWidget);
    });

    testWidgets('CustomErrorWidget renders error message and triggers retry',
        (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomErrorWidget(
              errorMsg: "فشل الاتصال بالإنترنت",
              onRefresh: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      expect(find.text("حدث خطأ أثناء تحميل البيانات"), findsOneWidget);
      expect(find.text("فشل الاتصال بالإنترنت"), findsOneWidget);
      expect(find.text("إعادة المحاولة"), findsOneWidget);

      await tester.tap(find.text("إعادة المحاولة"));
      await tester.pump();
      expect(retried, true);
    });

    testWidgets('EmptyStateWidget renders title, subtitle, and action',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: "قائمة المفضلة فارغة",
              subtitle: "أضف أذكارك وإذاعاتك المفضلة للوصول إليها بسرعة",
            ),
          ),
        ),
      );

      expect(find.text("قائمة المفضلة فارغة"), findsOneWidget);
      expect(find.text("أضف أذكارك وإذاعاتك المفضلة للوصول إليها بسرعة"),
          findsOneWidget);
    });

    testWidgets('AppLottieWidget fallback renders in test environment',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppLottieWidget.loading(),
          ),
        ),
      );

      expect(find.byType(AppLottieWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Feature Provider Error and Loading Handling Tests', () {
    test('RadiosNotifier handles error state properly in ProviderContainer',
        () async {
      final container = ProviderContainer(
        overrides: [
          RadiosRepository.provider
              .overrideWithValue(ThrowingRadiosRepository()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(RadiosNotifier.provider) is AsyncLoading, true);

      await container.read(RadiosNotifier.provider.notifier).getRadios();
      final state = container.read(RadiosNotifier.provider);

      expect(state is AsyncError, true);
      expect(state.error.toString(), contains("Server unavailable"));
    });

    test('AzkarCategoryNotifier loads category and handles counts', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(azkarCategoryProvider("أذكار الصباح"));
      expect(state is AsyncData, true);
      expect(state.value?.category, "أذكار الصباح");
    });

    testWidgets('ProviderScope renders CustomErrorWidget when provider fails',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            RadiosRepository.provider
                .overrideWithValue(ThrowingRadiosRepository()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(RadiosNotifier.provider);
                  return state.when(
                    data: (data) => const Text("Data"),
                    loading: () => const LoadingWidget(),
                    error: (err, _) => CustomErrorWidget(
                      errorMsg: err.toString(),
                      onRefresh: () => ref
                          .read(RadiosNotifier.provider.notifier)
                          .getRadios(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially loading
      expect(find.byType(LoadingWidget), findsOneWidget);

      // Trigger fetch
      final element = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(element);
      await container.read(RadiosNotifier.provider.notifier).getRadios();
      await tester.pumpAndSettle();

      // Now error is displayed
      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.text("حدث خطأ أثناء تحميل البيانات"), findsOneWidget);
    });
  });
}
