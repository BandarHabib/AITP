part of 'get_landmark_bloc.dart';

abstract class GetLandmarkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadImage extends GetLandmarkEvent {
  final File image;
  UploadImage(this.image);

  @override
  List<Object?> get props => [image];
}

class FindLandmark extends GetLandmarkEvent {
  FindLandmark(File image);
}

class ResetStateEvent extends GetLandmarkEvent {}
