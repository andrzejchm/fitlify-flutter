part of 'routing_presenter.dart';

abstract class RoutingViewModel {}

@injectable
class RoutingPresentationModel = RoutingPresentationModelBase with _$RoutingPresentationModel;

abstract class RoutingPresentationModelBase with Store implements RoutingViewModel {}
