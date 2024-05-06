import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tp_app/screens/find_landmark/blocs/get_landmark/get_landmark_bloc.dart';
import 'package:tp_app/screens/find_landmark/views/results_screen.dart';
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

  BoxDecoration _buildGradientDecoration() {
    ThemeData theme = Theme.of(context);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(2, 2),
        colors: [
          theme.colorScheme.primary.withOpacity(0.7),
          theme.colorScheme.secondary.withOpacity(0.2)
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context,
      {bool isReupload = false}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<GetLandmarkBloc>().add(UploadImage(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1, -1),
            end: const Alignment(2, 2),
            colors: [
              theme.colorScheme.primary.withOpacity(0.7),
              theme.colorScheme.secondary.withOpacity(0.2)
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text("Find Landmark"),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.maybePop(context).then((returned) {
                    if (returned) {
                      context.read<GetLandmarkBloc>().add(ResetStateEvent());
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: BlocConsumer<GetLandmarkBloc, GetLandmarkState>(
                listener: (context, state) {
                  if (state is LandmarkSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ResultsScreen(landmarks: state.results)),
                    ).then((_) {
                      context.read<GetLandmarkBloc>().add(ResetStateEvent());
                    });
                  } else if (state is LandmarkError) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sorry'),
                          content: Text(state.message),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LandmarkProcessing || state is LandmarkSuccess) {
                    return Center(
                      child: Lottie.asset('assets/animation/2.json',
                          width: 600, height: 600),
                    );
                  }

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
                            if (state is ImageLoaded ||
                                state is ImageInitial ||
                                state is LandmarkError)
                              ElevatedButton(
                                onPressed: () => _pickImage(context,
                                    isReupload: state is ImageLoaded),
                                child: Text(state is ImageLoaded
                                    ? 'Reupload'
                                    : 'Upload'),
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
            ),
          ],
        ),
      ),
    );
  }
}
