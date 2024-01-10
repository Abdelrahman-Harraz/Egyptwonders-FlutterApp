//  ------------------------------- Enumerations -----------------------------

// Enum to specify different types of user input
enum InputType { signin, signup, forgetPassword, updateProfile }

// Enum to specify basic form types
enum BasicFormType { signup, signin, phoneForm, codeForm, passwordForm }

// Enum to specify the type of place screens
enum PlaceScreenType { venues, eventsAndActivities, favorite, search }

// Enum to specify categories for places
enum PlaceCategory { historicalSites, museums, shopping, dining }

// List of place types
List<String> placesTypeslist = [
  "Historical Sites",
  "Museums",
  "Shopping",
  "Dining"
];

// Enum to specify home tabs
enum HomeTab { home, explore, favorits, profile }

// Enum to specify shared preferences keys
enum SharedPrefKey {
  email,
  apiToken,
  phone,
  password,
  age,
  state,
  fname,
  lname,
}

// Enum to specify app status
enum AppStatus { loggedIn, loggedOut, loading, profileNotFilled }

// Enum to specify request status
enum RequestStatus { initial, loading, success, failure }

// Enum to specify size types
enum SizeType { big, small }

//  ------------------------------- Main Variables ----------------------------

// Titles for different sections
String eventsAndActivitiesTitle = "Events and activities";
String venuesTitle = "Venues";
String favoritTitle = "Favorites";

//  ------------------------------- Page Padding ------------------------------

// Constants for borderRadius, paddingAll, side, side1, and homePadding
const double borderRadius = 15;
const double paddingAll = 10;
const double side = 20;
const double side1 = 40;
const double homePadding = 10;

//  ------------------------------- Element Spacing & Sizing ------------------

// Constants for space0, space0_5, space1, space2, space3, height1, height2, height3, height4, height5, height6, round, and round2
const double space0 = 5;
const double space0_5 = 10;
const double space1 = 15;
const double space2 = 20;
const double space3 = 30;

const double height1 = 50;
const double height2 = 65;
const double height3 = 75;
const double height4 = 115;
const double height5 = 130;
const double height6 = 160;

const double round = 15;
const double round2 = 25;

//  ------------------------------- Text -------------------------------------

// Constant string for Aboutegypt_wonders providing a detailed description of the app
const Aboutegypt_wonders =
    '''Discover egypt_wonders: Your Passport to Unparalleled Adventures!
...
(backslash indicates the continuation of the string for brevity)
... 
At the core of egypt_wonders is a commitment to reliable and accurate content,
backed by in-depth research on Egypt's civilizations, historical sites, museums, and cultural offerings.
This ensures that your exploration is not only engrossing but also trustworthy.''';
