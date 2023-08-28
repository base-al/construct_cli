import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) async {
  final parser = ArgParser();
  parser.addCommand('create');

  final args = parser.parse(arguments);

  if (args.command != null && args.command!.name == 'create') {
    final projectName =
        args.command!.rest.isNotEmpty ? args.command!.rest.first : '';
    projectName.isNotEmpty ? await createProject(projectName) : printUsage();
  } else {
    printUsage();
  }
}

void printUsage() {
  print('Usage: construct create <projectName>');
}

Future<void> createProject(String projectName) async {
  final currentDirectory = Directory.current;
  final projectDirectoryPath = path.join(currentDirectory.path, projectName);
  final projectDirectory = Directory(projectDirectoryPath);

  final templatePackageUri = Uri.parse('package:construct_cli/template');
  final resolvedUri = await Isolate.resolvePackageUri(templatePackageUri);

  if (resolvedUri == null) {
    print('Error: Could not resolve package URI');
    return;
  }

  final templateDirectoryPath =
      path.join(currentDirectory.path, 'lib', 'template');

  if (await projectDirectory.exists()) {
    stdout.write(
        'Error: Directory "$projectName" already exists, do you want to override (y/n): ');
    final input = stdin.readLineSync();

    if (input?.toLowerCase() != 'y') {
      print('Aborted.');
      return;
    }

    await projectDirectory.delete(recursive: true);
  }

  await projectDirectory.create();
  await copyDirectory(Directory(templateDirectoryPath), projectDirectory);

  print('Project "$projectName" created successfully');
}

Future<void> copyDirectory(Directory source, Directory destination) async {
  final entities = await source.list(recursive: true).toList();
  for (var entity in entities) {
    final relative = path.relative(entity.path, from: source.path);
    if (entity is File) {
      await entity.copy(path.join(destination.path, relative));
    } else if (entity is Directory) {
      await Directory(path.join(destination.path, relative)).create();
    }
  }
}
