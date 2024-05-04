part of 'get_landmark_bloc.dart';

abstract class GetLandmarkState extends Equatable {
  const GetLandmarkState();
  @override
  List<Object?> get props => [];
}

/// State for when no image has been uploaded yet.
class ImageInitial extends GetLandmarkState {}

/// State for when an image is successfully loaded and ready for processing.
class ImageLoaded extends GetLandmarkState {
  final File image;
  const ImageLoaded(this.image);

  @override
  List<Object?> get props => [image];
}

/// State for when the system is processing the image to detect landmarks.
class LandmarkProcessing extends GetLandmarkState {}

/// State for when landmarks have been successfully detected.
class LandmarkSuccess extends GetLandmarkState {
  final List<Landmark> results;
  const LandmarkSuccess(this.results);

  @override
  List<Object?> get props => [results];
}

/// State for when an error has occurred during image uploading or processing.
class LandmarkError extends GetLandmarkState {
  final String message;
  const LandmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
