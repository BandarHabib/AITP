part of 'get_attraction_bloc.dart';

sealed class GetAttractionState extends Equatable {
  const GetAttractionState();

  @override
  List<Object> get props => [];
}

final class GetAttractionInitial extends GetAttractionState {}

final class GetAttractionFailure extends GetAttractionState {}

final class GetAttractionLoading extends GetAttractionState {}

final class GetAttractionSuccess extends GetAttractionState {
  final List<Attraction> attractions;

  const GetAttractionSuccess(this.attractions);

  @override
  List<Object> get props => [attractions];
}
