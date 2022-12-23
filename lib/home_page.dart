import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cam_loc_proj/location_service.dart';
import 'package:cam_loc_proj/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _pickImage(ImageSource.camera).then((value) {
                  if (value != null) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return ShowImageDialog(
                            image: value,
                          );
                        });
                  }
                });
              },
              icon: const Icon(Icons.camera),
              label: const Text('Open Camera'),
            ),
            ElevatedButton.icon(
              onPressed: () => getLocation(context),
              icon: const Icon(Icons.location_city),
              label: const Text('Get Location'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getLocation(BuildContext context) async {
    final pos = await Utils.dialogLoaderForDynamicFuture(
        context, LocationService.getLocation()) as Position?;
    if (pos != null) {
      // ignore: use_build_context_synchronously
      final placemark = await Utils.dialogLoaderForDynamicFuture(
          context,
          LocationService.getAddressFromCoordinates(
            pos.latitude,
            pos.longitude,
          )) as Placemark;
      showDialog(
        context: context,
        builder: (ctx) {
          return ShowLocationDialog(
            latLong: 'Latitude : ${pos.latitude}\nLongitude : ${pos.longitude}',
            place:
                "${placemark.street}, ${placemark.locality},\n${placemark.country}, ${placemark.postalCode}",
          );
        },
      );
    }
  }

  Future<String?> _pickImage(ImageSource imageSource) async {
    final XFile? pickImageFile = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 20,
    );
    final Uint8List imageBytes =
        await File(pickImageFile?.path ?? '').readAsBytes();
    return base64Encode(imageBytes);
  }
}

class ShowImageDialog extends StatelessWidget {
  const ShowImageDialog({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Image'),
      content: Image.memory(
        base64Decode(
          image,
        ),
        fit: BoxFit.cover,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class ShowLocationDialog extends StatelessWidget {
  const ShowLocationDialog({
    super.key,
    required this.latLong,
    required this.place,
  });
  final String latLong;
  final String place;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(latLong),
          const SizedBox(
            height: 10.0,
          ),
          Text(place),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
