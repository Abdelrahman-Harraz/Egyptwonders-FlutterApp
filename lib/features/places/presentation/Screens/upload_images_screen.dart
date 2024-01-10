import 'dart:io';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/failure_ui_handling.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/helpers/navigation.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_dialog.dart';
import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class UploadPlaceImagesScreen extends StatefulWidget {
  static String routeName = "/UploadPlaceImagesScreen";

  // Parameters for the screen
  PlaceModel placeModel;
  PlaceDetailsModel placeDetails;

  // Constructor
  UploadPlaceImagesScreen(
      {super.key, required this.placeModel, required this.placeDetails});

  // Override to create the state for the StatefulWidget
  @override
  State<UploadPlaceImagesScreen> createState() =>
      _UploadPlaceImagesScreenState();
}

class _UploadPlaceImagesScreenState extends State<UploadPlaceImagesScreen> {
  // Lists to store images
  List<File> placeImages = [];
  List<File> galleryImages = [];
  List<File> coverImageUrl = [];

  // Build method to create the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OwnTheme.backgroundColor,
      appBar: CustomAppBar(txt: "Upload Images"),
      body: BlocListener<PlacesBloc, PlacesState>(
        listenWhen: (previous, current) =>
            previous.addPlacesStatus != current.addPlacesStatus,
        listener: (context, state) {
          // Handle different states of the add process
          if (state.addPlacesStatus == RequestStatus.success) {
            HomeBloc.get(context).add(SetHomeTabEvent(HomeTab.home));
            PlacesBloc.get(context).add(GetVenuesEvent([]));
            PlacesBloc.get(context).add(GetEventsAndActivitiesPlacesEvent([]));
            Navigation.emptyNavigator(HomeScreen.routeName, context, null);
            PlacesBloc.get(context).add(RestAddingStatusEvent());
          } else if (state.addPlacesStatus == RequestStatus.loading) {
            LoadingDialog.displayLoadingDialog(context);
          } else if (state.addPlacesStatus == RequestStatus.failure) {
            Navigator.pop(context);
            FailureUiHandling.showToast(
              context: context,
              errorMsg: state.errorObject.message.toString(),
            );
            PlacesBloc.get(context).add(RestAddingStatusEvent());
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
                context: context, title: "Gallery Images", list: galleryImages),
            SizedBox(
              height: 5.h,
            ),
            // Button to create/upload images
            CustomButton(
                label: "Create",
                onPressed: () async {
                  // Check if all required images are selected
                  if (placeImages.isNotEmpty &&
                      coverImageUrl.isNotEmpty &&
                      galleryImages.isNotEmpty) {
                    // Add the add event to the PlacesBloc
                    PlacesBloc.get(context).add(AddPlaceEvent(
                      placeModel: widget.placeModel,
                      placeDetailsModel: widget.placeDetails,
                      placeImages: placeImages,
                      coverImageUrl: coverImageUrl,
                      galleryImages: galleryImages,
                    ));
                  } else {
                    FailureUiHandling.showToast(
                        context: context,
                        errorMsg: "Please Upload images for all fields");
                  }
                })
          ],
        )),
      ),
    );
  }

  // Widget to display each image box
  Widget ImageBoxWidget({File? picked, void Function()? onTap}) {
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
                    fit: BoxFit.cover, image: FileImage(picked!))),
          ),
          Positioned(
              top: 3,
              right: 3,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: OwnTheme.callToActionColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.delete_outline, color: OwnTheme.white),
                ),
              )),
        ]),
      ),
    );
  }

  // Function to pick multiple images
  Future<void> pickImages(List<File>? targetList) async {
    List<XFile>? pickedList = await ImagePicker().pickMultiImage();
    List<File> newList = [];
    if (pickedList.isNotEmpty) {
      pickedList.forEach((element) {
        setState(() {
          targetList!.add(File(element.path));
        });
      });
    }
  }

  // Widget for displaying an empty label
  emptyLable() {
    return Center(
      child: Text(
        "Upload Images Please",
        style: OwnTheme.bodyTextStyle().copyWith(color: Colors.red),
      ),
    );
  }

  // Function to remove a photo from the list
  removePhoto(List<File>? list, int index) {
    setState(() {
      list!.removeAt(index);
    });
  }

  // Widget for displaying the image list selection
  _imageListSelection(
      {required BuildContext context,
      required String title,
      List<File>? list}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(paddingAll),
          child: Row(
            children: [
              Text(
                title,
                style:
                    OwnTheme.captionTextStyle().copyWith(color: OwnTheme.black),
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
}
