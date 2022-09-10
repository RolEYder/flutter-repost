// @dart=2.0
class OnboardingModel {
  String imageAssetPath;
  String title;
  String desc;

  OnboardingModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<OnboardingModel> getSlides() {
  List<OnboardingModel> slides = new List<OnboardingModel>();
  OnboardingModel sliderModel = new OnboardingModel();

  //1
  sliderModel.setDesc(
      "Discover new ways to schedule repost using a quickly and well-optimized app");
  sliderModel.setTitle("Search");
  sliderModel.setImageAssetPath("assets/illustration.png");
  slides.add(sliderModel);

  sliderModel = new OnboardingModel();

  //2
  sliderModel.setDesc("Put a remainder to notify you next repost");
  sliderModel.setTitle("Schedule");
  sliderModel.setImageAssetPath("assets/illustration2.png");
  slides.add(sliderModel);

  sliderModel = new OnboardingModel();

  //3
  sliderModel.setDesc(
      "Our app repost instagram posts or stories for you without neccesary without track you personal information");
  sliderModel.setTitle("Repost");
  sliderModel.setImageAssetPath("assets/illustration3.png");
  slides.add(sliderModel);

  sliderModel = new OnboardingModel();

  return slides;
}
