import 'dart:io';

import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('create');

  final args = parser.parse(arguments);

  if (args.command != null && args.command!.name == 'create') {
    final projectName = args.command!.rest.first;
    if (projectName.isNotEmpty) {
      createProject(projectName);
    } else {
      print('Usage: construct create <projectName>');
    }
  } else {
    print('Usage: construct create <projectName>');
  }
}

void createProject(String projectName) {
  final projectDirectory = Directory(projectName);
  final templateDirectory = Directory('template'); // Adjust the path here

  if (projectDirectory.existsSync()) {
    print('Error: Directory "$projectName" already exists');
    return;
  }

  // Create the project directory
  projectDirectory.createSync();

  // Copy entire contents of the template directory to the project directory
  copyDirectory(templateDirectory, projectDirectory);

  print('Project "$projectName" created successfully');
}

void copyDirectory(Directory source, Directory destination) {
  for (var entity in source.listSync(recursive: true)) {
    final relativePath = entity.uri.path.replaceFirst(source.uri.path, '');
    final destinationPath = '${destination.path}/$relativePath';

    if (entity is File) {
      entity.copySync(destinationPath);
    } else if (entity is Directory) {
      Directory(destinationPath).createSync();
    }
  }
}
