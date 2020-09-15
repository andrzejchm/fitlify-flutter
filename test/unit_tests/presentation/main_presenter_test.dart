import 'package:fitlify_flutter/presentation/main/main_presenter.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  MainPresentationModel model;
  MainPresenter presenter;

  void _initMvp() {
    model = MainPresentationModel(Mocks.currentUserStore);
    presenter = MainPresenter(model, Mocks.appNavigator, Mocks.currentUserStore);
  }

  group("MainPresenter", () {
    test("opens login page on avatar click", () async {
      _initMvp();
      when(Mocks.currentUserStore.user).thenAnswer((_) => Stubs.anonymousUser);
      await presenter.onViewInteraction(const Interaction.profileClicked());

      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteLoginPage>())));
    });

    test("opens profile page on avatar click", () async {
      _initMvp();
      when(Mocks.currentUserStore.user).thenAnswer((_) => Stubs.user);
      await presenter.onViewInteraction(const Interaction.profileClicked());

      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteProfilePage>())));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
