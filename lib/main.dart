import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_playback/home_screen.dart';

import 'Sound_Recorder/cubit/file_cubit.dart';
import 'Sound_Recorder/cubit/record_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecordCubit>(
          create: (context) => RecordCubit(),
        ),

        /// [FilesCubit] is provided before material app because it should start loading all files when app is opens
        /// asynschronous method [getFiles] is called in constructor of [Files Cubit].
        BlocProvider<FilesCubit>(
          create: (context) => FilesCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
