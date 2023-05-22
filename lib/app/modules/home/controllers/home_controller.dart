import 'package:get/get.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as aws;
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  XFile? photo;
  XFile? image;
  bool isCompareButtonClicked = false;

  final rekognition = aws.Rekognition(
    region: 'us-east-1',
    credentials: aws.AwsClientCredentials(
      accessKey: "GLOBAL_KEY",
      secretKey: "SECRET_KEY",
    ),
  );
  double similarity = 0.0;
  bool? isSamePerson;

  Future<void> compareFaces() async {
    if (isCompareButtonClicked) return;
    isCompareButtonClicked = true;
    update(["compare"]);
    if (photo != null && image != null) {
      try {
        // final image1 = await _loadImage(
        //     'assets/1.jpg'); // Replace with your first image path
        // final image2 = await _loadImage(
        //     'assets/2.jpeg'); // Replace with your second image path

        aws.CompareFacesResponse response;

        //  response  =
        await rekognition
            .compareFaces(
          similarityThreshold:
              70, // Adjust the similarity threshold as per your requirement
          sourceImage: aws.Image(bytes: await image!.readAsBytes()),
          targetImage: aws.Image(bytes: await photo!.readAsBytes()),
        )
            .then((value) {
          response = value;

          similarity = (response.faceMatches?.isNotEmpty ?? false)
              ? (response.faceMatches?.first.similarity ?? 0.0)
              : 0.0;
          if (similarity >= 70) {
            isSamePerson = true;
          } else {
            isSamePerson = false;
          }
        });
      } catch (e) {
        print("e ${e.runtimeType}");
        print("e ${e}");
        Get.snackbar(
          "Error",
          (e is aws.InvalidParameterException)
              ? "Please, Enter a person"
              : e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please Enter Images first",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isCompareButtonClicked = false;
    update(["similarity", "compare"]);
  }

  // Future<Uint8List> _loadImage(String imagePath) async {
  //   final byteData = await rootBundle.load(imagePath);
  //   return byteData.buffer
  //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  // }

  Future<void> fetchImage() async {
    final ImagePicker picker = ImagePicker();

    image = await picker.pickImage(source: ImageSource.gallery);
    update(["image"]);
  }

  // To be compared
  Future<void> fetchPhotoToBeCompared() async {
    final ImagePicker picker = ImagePicker();

    photo = await picker.pickImage(source: ImageSource.camera);
    update(["photo"]);
  }

  Future<void> clear() async {
    photo = null;
    image = null;
    similarity = 0.0;
    isSamePerson = false;
    isCompareButtonClicked = false;
    update(["photo", "image", "similarity", "compare"]);
  }
}
