import 'dart:io';

import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('create');

  final args = parser.parse(arguments);

  if (args.command != null && args.command!.name == 'create') {
    final projectName = args.command!.rest.first;
    if (projectName.isNotEmpty) {
      // Call your function to create the project here
      createProject(projectName);

      print('Creating project: $projectName');
    } else {
      print('Usage: construct create <projectName>');
    }
  } else {
    print('Usage: construct create <projectName>');
  }
}

void createProject(String projectName) {
  final projectDirectory = Directory(projectName);

  if (projectDirectory.existsSync()) {
    print('Error: Directory "$projectName" already exists');
    return;
  }

  projectDirectory.createSync();

  final pubspecContent = '''
name: $projectName
description: A new Construct project
version: 1.0.0
dependencies:
  construct: ^1.0.0
''';

  File('$projectName/pubspec.yaml').writeAsStringSync(pubspecContent);

  print('Project "$projectName" created successfully');
}
