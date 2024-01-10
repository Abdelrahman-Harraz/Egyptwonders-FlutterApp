import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_cached_img.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ProfileHeader extends StatefulWidget {
  String? imageUrl;
  bool canEdit = true;
  ProfileHeader({super.key, this.imageUrl, this.canEdit = true});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? file = null;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // User Profile Image
          CircleAvatar(
            radius: 10.h,
            backgroundImage: getImage(widget.imageUrl, file),
            backgroundColor: OwnTheme.darkTextColor,
            child: getChild(file, widget.imageUrl),
          ),
          // Edit Icon (if canEdit is true)
          widget.canEdit
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () async => await editPhoto(context),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: OwnTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.edit, color: OwnTheme.backgroundColor),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  // Function to handle editing user photo
  editPhoto(BuildContext context) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      AuthBloc.get(context).add(UpdateUserPhotoEvent(File(image.path)));
      setState(() {
        file = File(image.path);
      });
    } else {
      // Handle case when user cancels image selection
    }
  }

  // Function to determine the image source based on file and imageUrl
  getImage(String? imageUrl, File? file) {
    if (file != null) {
      return FileImage(file);
    }
    if (imageUrl != null) {
      if (imageUrl.isNotEmpty) {
        return CachedNetworkImageProvider(imageUrl);
      }
    }
    return null; // Return null if no image source is available
  }

  // Function to determine the child widget based on file and imageUrl
  getChild(File? file, String? imageUrl) {
    if (file != null) {
      return null; // Return null when using a local file
    }
    if (imageUrl != null) {
      if (imageUrl.isNotEmpty) {
        return null; // Return null when using a network image
      }
    }
    // Return default icon when no image is available
    return Icon(
      Icons.person,
      size: 10.h,
      color: OwnTheme.backgroundColor,
    );
  }
}
