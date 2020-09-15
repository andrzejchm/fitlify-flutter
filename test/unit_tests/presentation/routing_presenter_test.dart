import 'package:fitlify_flutter/presentation/routing/routing_presenter.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../test_doubles/mocks.dart';

void main() {
  RoutingPresentationModel presentationModel;
  RoutingPresenter presenter;

  group("RoutingPresenter", () {
    test("opens login screen if not logged in", () async {
      //given
      when(Mocks.isLoggedInUseCase.execute()).thenAnswer((_) => Future.value(false));
      //when
      await presenter.onViewInteraction(const Interaction.appOpened());
      //then
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteLoginPage>())));
    });

    test("opens dashboard for logged in users", () async {
      //given
      when(Mocks.isLoggedInUseCase.execute()).thenAnswer((_) => Future.value(true));
      //when
      await presenter.onViewInteraction(const Interaction.appOpened());
      //then
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteMain>())));
    });

    test("does not login user anonymously on start", () async {
      //given
      when(Mocks.isLoggedInUseCase.execute()).thenAnswer((_) => Future.value(false));
      //when
      await presenter.onViewInteraction(const Interaction.appOpened());
      //then
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteLoginPage>())));
      verifyNever(Mocks.authService.logInAnonymously());
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    presentationModel = RoutingPresentationModel();
    presenter = RoutingPresenter(
      presentationModel,
      Mocks.appNavigator,
      Mocks.isLoggedInUseCase,
      Mocks.initializeAppUseCase,
    );
  });
}
