// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/failure_ui_handling.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/helpers/navigation.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_dialog.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class UpdatePlaceImagesScreen extends StatefulWidget {
  static String routeName = "/UpdatePlaceImagesScreen";

  // Parameters for the screen
  final PlaceModel placeModel;
  final PlaceDetailsModel placeDetails;

  // Constructor
  const UpdatePlaceImagesScreen({
    Key? key,
    required this.placeModel,
    required this.placeDetails,
  }) : super(key: key);

  // Override to create the state for the StatefulWidget
  @override
  State<UpdatePlaceImagesScreen> createState() =>
      _UpdatePlaceImagesScreenState();
}

class _UpdatePlaceImagesScreenState extends State<UpdatePlaceImagesScreen> {
  // Lists to store images
  List<dynamic> placeImages = [];
  List<dynamic> galleryImages = [];
  List<dynamic> coverImageUrl = [];
  List<String> deletedImages = [];

  // Initialize state
  @override
  void initState() {
    super.initState();
    // Initialize image lists with existing images from the widget's parameters
    setState(() {
      coverImageUrl.add(widget.placeModel.coverImageUrl);
      galleryImages.addAll(widget.placeDetails.gallerylist!);
      placeImages.addAll(widget.placeDetails.imageslist!);
    });
  }

  // Build method to create the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OwnTheme.backgroundColor,
      appBar: CustomAppBar(txt: "Update Images"),
      body: BlocListener<PlacesBloc, PlacesState>(
        listenWhen: (previous, current) =>
            previous.updatePlacesStatus != current.updatePlacesStatus,
        listener: (context, state) {
          // Handle different states of the update process
          if (state.updatePlacesStatus == RequestStatus.success) {
            HomeBloc.get(context).add(SetHomeTabEvent(HomeTab.home));
            PlacesBloc.get(context).add(GetVenuesEvent([]));
            PlacesBloc.get(context).add(GetEventsAndActivitiesPlacesEvent([]));
            Navigation.emptyNavigator(HomeScreen.routeName, context, null);
            PlacesBloc.get(context).add(ResetUpdatingStatusEvent());
          } else if (state.updatePlacesStatus == RequestStatus.loading) {
            LoadingDialog.displayLoadingDialog(context);
          } else if (state.updatePlacesStatus == RequestStatus.failure) {
            Navigator.pop(context);
            FailureUiHandling.showToast(
              context: context,
              errorMsg: state.errorObject.message.toString(),
            );
            PlacesBloc.get(context).add(ResetUpdatingStatusEvent());
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image selection widgets
              _imageListSelection(
                  context: context, title: "Cover Image", list: coverImageUrl),
              _imageListSelection(
                  context: context, title: "Place Images", list: placeImages),
              _imageListSelection(
                  context: context,
                  title: "Gallery Images",
                  list: galleryImages),
              // Button to update images
              CustomButton(
                  label: "Update Images",
                  onPressed: () async {
                    // Check if all required images are selected
                    if (placeImages.isNotEmpty &&
                        coverImageUrl.isNotEmpty &&
                        galleryImages.isNotEmpty) {
                      // Add the update event to the PlacesBloc
                      PlacesBloc.get(context).add(UpdatePlaceImagesEvent(
                          placeModel: widget.placeModel,
                          detailsModel: widget.placeDetails,
                          placeImages: placeImages,
                          coverImageUrl: coverImageUrl,
                          galleryImages: galleryImages,
                          deletedImages: deletedImages));
                    } else {
                      FailureUiHandling.showToast(
                          context: context,
                          errorMsg: "Please Upload images for all fields");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display each image box
  Widget ImageBoxWidget({dynamic picked, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 20.h,
        width: 20.h,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
                image: DecorationImage(
                    fit: BoxFit.cover, image: _getImage(picked))),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: OwnTheme.callToActionColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.delete, color: OwnTheme.backgroundColor),
                ),
              )),
        ]),
      ),
    );
  }

  // Function to pick images using ImagePicker
  Future<void> pickImages(List<dynamic>? targetList) async {
    List<XFile>? pickedList = await ImagePicker().pickMultiImage();
    if (pickedList.isNotEmpty) {
      pickedList.forEach((element) {
        setState(() {
          targetList!.add(File(element.path));
        });
      });
    }
  }

  // Widget to display a label if image list is empty
  Widget emptyLable() {
    return Center(
      child: Text(
        "Upload Images Please",
        style: OwnTheme.bodyTextStyle().copyWith(color: Colors.red),
      ),
    );
  }

  // Function to remove a photo from the list
  void removePhoto(List<dynamic>? list, int index) {
    var temp = list![index];
    if (temp is File) {
    } else {
      deletedImages.add(temp);
    }
    setState(() {
      list.removeAt(index);
    });
  }

  // Widget to display a list of images with title
  Widget _imageListSelection(
      {required BuildContext context,
      required String title,
      List<dynamic>? list}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(paddingAll),
          child: Row(
            children: [
              Text(
                title,
                style: OwnTheme.subTitleStyle().copyWith(
                    color: OwnTheme.black, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                  onPressed: () async {
                    await pickImages(list);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: OwnTheme.callToActionColor,
                  )),
            ],
          ),
        ),
        // Display the images using ListView.builder
        list != null
            ? list.isNotEmpty
                ? SizedBox(
                    height: 20.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ImageBoxWidget(
                          picked: list[index],
                          onTap: () => removePhoto(list, index),
                        );
                      },
                    ),
                  )
                : emptyLable()
            : emptyLable(),
      ],
    );
  }

  // Function to get the image based on its type (File or Network image)
  ImageProvider<Object> _getImage(dynamic picked) {
    if (picked is File) {
      return FileImage(picked);
    } else {
      return CachedNetworkImageProvider(picked);
    }
  }
}
