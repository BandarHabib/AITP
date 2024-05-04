part of 'get_attraction_bloc.dart';

sealed class GetAttractionEvent extends Equatable {
  const GetAttractionEvent();

  @override
  List<Object> get props => [];
}

class GetAttraction extends GetAttractionEvent {}
