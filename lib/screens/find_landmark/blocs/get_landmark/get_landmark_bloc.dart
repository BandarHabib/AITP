import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_app/services/landmark_service.dart';
import 'package:landmark_repository/landmark_repository.dart';
part 'get_landmark_event.dart';
part 'get_landmark_state.dart';

class GetLandmarkBloc extends Bloc<GetLandmarkEvent, GetLandmarkState> {
  final LandmarkService landmarkService;
  late File imageFile;

  GetLandmarkBloc(this.landmarkService) : super(ImageInitial()) {
    on<UploadImage>((event, emit) {
      imageFile = event.image;
      emit(ImageLoaded(imageFile));
    });

    on<FindLandmark>((event, emit) async {
      if (state is! ImageLoaded) {
        emit(const LandmarkError('Image not loaded'));
        return;
      }

      emit(LandmarkProcessing());
      try {
        List<Landmark> results =
            await landmarkService.recognizeLandmark(imageFile);
        if (results.isEmpty) {
          emit(const LandmarkError('No landmarks detected'));
        } else {
          emit(LandmarkSuccess(results));
        }
      } catch (e) {
        emit(LandmarkError('Failed to detect landmarks: ${e.toString()}'));
      }
    });
  }
}
