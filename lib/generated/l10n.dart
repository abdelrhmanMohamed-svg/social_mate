// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Camera`
  String get cameraAction {
    return Intl.message('Camera', name: 'cameraAction', desc: '', args: []);
  }

  /// `Videos`
  String get videosAction {
    return Intl.message('Videos', name: 'videosAction', desc: '', args: []);
  }

  /// `Gallery`
  String get galleryAction {
    return Intl.message('Gallery', name: 'galleryAction', desc: '', args: []);
  }

  /// `Follow Requests`
  String get followRequestsTitle {
    return Intl.message(
      'Follow Requests',
      name: 'followRequestsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No Follwo Requests`
  String get noRequests {
    return Intl.message(
      'No Follwo Requests',
      name: 'noRequests',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chatsTitle {
    return Intl.message('Chats', name: 'chatsTitle', desc: '', args: []);
  }

  /// `Create a Post`
  String get postTitle {
    return Intl.message('Create a Post', name: 'postTitle', desc: '', args: []);
  }

  /// `Post`
  String get postButton {
    return Intl.message('Post', name: 'postButton', desc: '', args: []);
  }

  /// `What is on your mind`
  String get postPlaceholder {
    return Intl.message(
      'What is on your mind',
      name: 'postPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get followersTitle {
    return Intl.message(
      'Followers',
      name: 'followersTitle',
      desc: '',
      args: [],
    );
  }

  /// `No followers found`
  String get noFollowersFound {
    return Intl.message(
      'No followers found',
      name: 'noFollowersFound',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Following`
  String get followingTitle {
    return Intl.message(
      'Following',
      name: 'followingTitle',
      desc: '',
      args: [],
    );
  }

  /// `REQUESTED`
  String get followRequested {
    return Intl.message(
      'REQUESTED',
      name: 'followRequested',
      desc: '',
      args: [],
    );
  }

  /// `FOLLOWING`
  String get followFollowing {
    return Intl.message(
      'FOLLOWING',
      name: 'followFollowing',
      desc: '',
      args: [],
    );
  }

  /// `FOLLOW`
  String get follow {
    return Intl.message('FOLLOW', name: 'follow', desc: '', args: []);
  }

  /// `UNFOLLOW`
  String get unfollow {
    return Intl.message('UNFOLLOW', name: 'unfollow', desc: '', args: []);
  }

  /// `Request`
  String get request {
    return Intl.message('Request', name: 'request', desc: '', args: []);
  }

  /// `Search`
  String get searchPlacholder {
    return Intl.message('Search', name: 'searchPlacholder', desc: '', args: []);
  }

  /// `Saved Posts`
  String get savedPosts {
    return Intl.message('Saved Posts', name: 'savedPosts', desc: '', args: []);
  }

  /// `username`
  String get usernameLabel {
    return Intl.message('username', name: 'usernameLabel', desc: '', args: []);
  }

  /// `Change Cover`
  String get changeCover {
    return Intl.message(
      'Change Cover',
      name: 'changeCover',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameLabel {
    return Intl.message('Name', name: 'nameLabel', desc: '', args: []);
  }

  /// `Bio`
  String get bioLabel {
    return Intl.message('Bio', name: 'bioLabel', desc: '', args: []);
  }

  /// `About Me`
  String get aboutMeLabel {
    return Intl.message('About Me', name: 'aboutMeLabel', desc: '', args: []);
  }

  /// `Work Experience`
  String get workExperienceLabel {
    return Intl.message(
      'Work Experience',
      name: 'workExperienceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add A Photo`
  String get addAPhoto {
    return Intl.message('Add A Photo', name: 'addAPhoto', desc: '', args: []);
  }

  /// `Take A Photo`
  String get takeAPhoto {
    return Intl.message('Take A Photo', name: 'takeAPhoto', desc: '', args: []);
  }

  /// `Add A Video`
  String get addAVideo {
    return Intl.message('Add A Video', name: 'addAVideo', desc: '', args: []);
  }

  /// `Attach A File`
  String get attachAFile {
    return Intl.message(
      'Attach A File',
      name: 'attachAFile',
      desc: '',
      args: [],
    );
  }

  /// `No Posts Found`
  String get noPostsFound {
    return Intl.message(
      'No Posts Found',
      name: 'noPostsFound',
      desc: '',
      args: [],
    );
  }

  /// `{count} followers`
  String followersCount(Object count) {
    return Intl.message(
      '$count followers',
      name: 'followersCount',
      desc: '',
      args: [count],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Request Sent Successfully`
  String get requestSentSuccessfully {
    return Intl.message(
      'Request Sent Successfully',
      name: 'requestSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Followed Successfully`
  String get followedSuccessfully {
    return Intl.message(
      'Followed Successfully',
      name: 'followedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Unfollowed Successfully`
  String get unfollowedSuccessfully {
    return Intl.message(
      'Unfollowed Successfully',
      name: 'unfollowedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error:`
  String get errorPrefix {
    return Intl.message('Error:', name: 'errorPrefix', desc: '', args: []);
  }

  /// `File Selected: {name}`
  String fileSelected(Object name) {
    return Intl.message(
      'File Selected: $name',
      name: 'fileSelected',
      desc: '',
      args: [name],
    );
  }

  /// `There is no Bio yet..`
  String get noBioYet {
    return Intl.message(
      'There is no Bio yet..',
      name: 'noBioYet',
      desc: '',
      args: [],
    );
  }

  /// `FOLLOW`
  String get followLabel {
    return Intl.message('FOLLOW', name: 'followLabel', desc: '', args: []);
  }

  /// `EDIT PROFILE`
  String get editProfileLabel {
    return Intl.message(
      'EDIT PROFILE',
      name: 'editProfileLabel',
      desc: '',
      args: [],
    );
  }

  /// `unknown`
  String get unknownLower {
    return Intl.message('unknown', name: 'unknownLower', desc: '', args: []);
  }

  /// `Add`
  String get addLabel {
    return Intl.message('Add', name: 'addLabel', desc: '', args: []);
  }

  /// `Accepted`
  String get acceptedLabel {
    return Intl.message('Accepted', name: 'acceptedLabel', desc: '', args: []);
  }

  /// `Rejected`
  String get rejectedLabel {
    return Intl.message('Rejected', name: 'rejectedLabel', desc: '', args: []);
  }

  /// `Reject`
  String get rejectButton {
    return Intl.message('Reject', name: 'rejectButton', desc: '', args: []);
  }

  /// `Accept`
  String get acceptButton {
    return Intl.message('Accept', name: 'acceptButton', desc: '', args: []);
  }

  /// `Discover people`
  String get discoverPeople {
    return Intl.message(
      'Discover people',
      name: 'discoverPeople',
      desc: '',
      args: [],
    );
  }

  /// `No users found`
  String get noUsersFound {
    return Intl.message(
      'No users found',
      name: 'noUsersFound',
      desc: '',
      args: [],
    );
  }

  /// `No likes yet.`
  String get noLikesYet {
    return Intl.message(
      'No likes yet.',
      name: 'noLikesYet',
      desc: '',
      args: [],
    );
  }

  /// `error page`
  String get errorPageTitle {
    return Intl.message(
      'error page',
      name: 'errorPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteLabel {
    return Intl.message('Delete', name: 'deleteLabel', desc: '', args: []);
  }

  /// `Delete Story`
  String get deleteStory {
    return Intl.message(
      'Delete Story',
      name: 'deleteStory',
      desc: '',
      args: [],
    );
  }

  /// `Delete Post`
  String get deletePost {
    return Intl.message('Delete Post', name: 'deletePost', desc: '', args: []);
  }

  /// `Posts`
  String get postsLabel {
    return Intl.message('Posts', name: 'postsLabel', desc: '', args: []);
  }

  /// `Followers`
  String get followersLabel {
    return Intl.message(
      'Followers',
      name: 'followersLabel',
      desc: '',
      args: [],
    );
  }

  /// `Following`
  String get followingLabel {
    return Intl.message(
      'Following',
      name: 'followingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsLabel {
    return Intl.message('Settings', name: 'settingsLabel', desc: '', args: []);
  }

  /// `Language`
  String get languageLabel {
    return Intl.message('Language', name: 'languageLabel', desc: '', args: []);
  }

  /// `Logging Out..`
  String get loggingOut {
    return Intl.message(
      'Logging Out..',
      name: 'loggingOut',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Google`
  String get googleLabel {
    return Intl.message('Google', name: 'googleLabel', desc: '', args: []);
  }

  /// `Theme`
  String get ThemeLabel {
    return Intl.message('Theme', name: 'ThemeLabel', desc: '', args: []);
  }

  /// `Light`
  String get lightLabel {
    return Intl.message('Light', name: 'lightLabel', desc: '', args: []);
  }

  /// `Dark`
  String get darkLabel {
    return Intl.message('Dark', name: 'darkLabel', desc: '', args: []);
  }

  /// `Select Theme`
  String get themePageTitle {
    return Intl.message(
      'Select Theme',
      name: 'themePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Connect with Friends`
  String get onboardingTitle1 {
    return Intl.message(
      'Connect with Friends',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Find Friends & Get Inspiration`
  String get onboardingSubtitle1 {
    return Intl.message(
      'Find Friends & Get Inspiration',
      name: 'onboardingSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Stay connected with people you care about. Discover new friends and get inspired by their stories.`
  String get onboardingDescription1 {
    return Intl.message(
      'Stay connected with people you care about. Discover new friends and get inspired by their stories.',
      name: 'onboardingDescription1',
      desc: '',
      args: [],
    );
  }

  /// `Share Your Moments`
  String get onboardingTitle2 {
    return Intl.message(
      'Share Your Moments',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Share Your Life with Friends`
  String get onboardingSubtitle2 {
    return Intl.message(
      'Share Your Life with Friends',
      name: 'onboardingSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Create posts, share photos and videos, and engage with your community.`
  String get onboardingDescription2 {
    return Intl.message(
      'Create posts, share photos and videos, and engage with your community.',
      name: 'onboardingDescription2',
      desc: '',
      args: [],
    );
  }

  /// `Meet Awesome People`
  String get onboardingTitle3 {
    return Intl.message(
      'Meet Awesome People',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Meet Awesome People & Enjoy Yourself`
  String get onboardingSubtitle3 {
    return Intl.message(
      'Meet Awesome People & Enjoy Yourself',
      name: 'onboardingSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Discover like-minded individuals and build meaningful connections.`
  String get onboardingDescription3 {
    return Intl.message(
      'Discover like-minded individuals and build meaningful connections.',
      name: 'onboardingDescription3',
      desc: '',
      args: [],
    );
  }

  /// `Hangout with Friends`
  String get onboardingTitle4 {
    return Intl.message(
      'Hangout with Friends',
      name: 'onboardingTitle4',
      desc: '',
      args: [],
    );
  }

  /// `Hangout with Friends`
  String get onboardingSubtitle4 {
    return Intl.message(
      'Hangout with Friends',
      name: 'onboardingSubtitle4',
      desc: '',
      args: [],
    );
  }

  /// `Chat, collaborate, and have fun together with your friends.`
  String get onboardingDescription4 {
    return Intl.message(
      'Chat, collaborate, and have fun together with your friends.',
      name: 'onboardingDescription4',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
