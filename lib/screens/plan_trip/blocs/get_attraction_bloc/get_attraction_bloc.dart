import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:attraction_repository/attraction_repository.dart';

part 'get_attraction_event.dart';
part 'get_attraction_state.dart';

class GetAttractionBloc extends Bloc<GetAttractionEvent, GetAttractionState> {
  final AttractionRepo _attractionRepo;

  GetAttractionBloc(this._attractionRepo) : super(GetAttractionInitial()) {
    on<GetAttraction>((event, emit) async {
      emit(GetAttractionLoading());
      try {
        List<Attraction> attractions = await _attractionRepo.getAttractions();
        emit(GetAttractionSuccess(attractions));
      } catch (e) {
        emit(GetAttractionFailure());
      }
    });
  }
}
