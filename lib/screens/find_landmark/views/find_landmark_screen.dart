import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp_app/screens/find_landmark/blocs/get_landmark/get_landmark_bloc.dart';
import 'package:tp_app/screens/find_landmark/views/results_screen.dart';
import 'package:tp_app/services/landmark_service.dart';

class FindLandmarkScreen extends StatelessWidget {
  const FindLandmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetLandmarkBloc(LandmarkService('http://10.0.2.2:5000')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Find Landmark"),
          actions: [
            IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => Navigator.pop(context)),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<GetLandmarkBloc, GetLandmarkState>(
          listener: (context, state) {
            if (state is LandmarkSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultsScreen(),
                ),
              );
            } else if (state is LandmarkError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _imageDisplay(state),
                  if (state is! ImageLoaded) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _pickImage(context),
                      child: const Text('Upload Image'),
                    ),
                  ],
                  if (state is ImageLoaded) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _pickImage(context),
                          child: const Text('Re-upload'),
                        ),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _imageDisplay(GetLandmarkState state) {
    if (state is ImageLoaded) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Image.file(state.image, fit: BoxFit.contain),
        ),
      );
    } else {
      return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image, size: 100, color: Colors.grey),
      );
    }
  }

  void _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<GetLandmarkBloc>().add(UploadImage(File(pickedFile.path)));
    }
  }
}
