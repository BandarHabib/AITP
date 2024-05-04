import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp_app/screens/find_landmark/blocs/get_landmark/get_landmark_bloc.dart';
import 'package:tp_app/screens/find_landmark/views/results_screen.dart';
import 'package:tp_app/screens/plan_trip/views/preferences_screen.dart';
import 'package:tp_app/services/landmark_service.dart';

class FindLandmarkScreen extends StatelessWidget {
  final LandmarkService _landmarkService =
      LandmarkService('http://10.0.2.2:5000');

  FindLandmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetLandmarkBloc(LandmarkService(_landmarkService.baseUrl)),
      child: _FindLandmarkView(),
    );
  }
}

class _FindLandmarkView extends StatefulWidget {
  @override
  __FindLandmarkViewState createState() => __FindLandmarkViewState();
}

class __FindLandmarkViewState extends State<_FindLandmarkView> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context,
      {bool isReupload = false}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<GetLandmarkBloc>().add(UploadImage(File(pickedFile.path)));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.isCurrent) {
        final bloc = context.read<GetLandmarkBloc>();
        if (bloc.state is ImageLoaded) {
          bloc.add(ResetStateEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Landmark"),
      ),
      body: BlocConsumer<GetLandmarkBloc, GetLandmarkState>(
        listener: (context, state) {
          if (state is LandmarkSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ResultsScreen(landmarks: state.results)),
            );
          }
        },
        builder: (context, state) {
          Widget imageWidget = Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.white,
            ),
            child: state is ImageLoaded
                ? Image.file(state.image, fit: BoxFit.cover)
                : Icon(Icons.image, size: 100, color: Colors.grey[300]),
          );

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                imageWidget,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (state is ImageLoaded || state is ImageInitial)
                      ElevatedButton(
                        onPressed: () => _pickImage(context,
                            isReupload: state is ImageLoaded),
                        child:
                            Text(state is ImageLoaded ? 'Reupload' : 'Upload'),
                      ),
                    if (state is ImageLoaded)
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<GetLandmarkBloc>()
                              .add(FindLandmark(state.image));
                        },
                        child: const Text('Submit'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
