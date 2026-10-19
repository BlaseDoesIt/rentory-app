import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rentory'**
  String get appName;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYet;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @stateDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get stateDraft;

  /// No description provided for @stateBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get stateBooked;

  /// No description provided for @statePickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get statePickedUp;

  /// No description provided for @statePartialReturn.
  ///
  /// In en, this message translates to:
  /// **'Partial return'**
  String get statePartialReturn;

  /// No description provided for @stateReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get stateReturned;

  /// No description provided for @stateCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get stateCancelled;

  /// No description provided for @rentalNone.
  ///
  /// In en, this message translates to:
  /// **'Not booked'**
  String get rentalNone;

  /// No description provided for @rentalBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get rentalBooked;

  /// No description provided for @rentalOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get rentalOut;

  /// No description provided for @rentalBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get rentalBack;

  /// No description provided for @conditionGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get conditionGood;

  /// No description provided for @conditionMinor.
  ///
  /// In en, this message translates to:
  /// **'Minor'**
  String get conditionMinor;

  /// No description provided for @conditionDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get conditionDamaged;

  /// No description provided for @conditionMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get conditionMissing;

  /// No description provided for @serialAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get serialAvailable;

  /// No description provided for @serialReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get serialReserved;

  /// No description provided for @serialOut.
  ///
  /// In en, this message translates to:
  /// **'Out with a customer'**
  String get serialOut;

  /// No description provided for @serialMaintenance.
  ///
  /// In en, this message translates to:
  /// **'In maintenance'**
  String get serialMaintenance;

  /// No description provided for @serialLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get serialLost;

  /// No description provided for @serialRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get serialRetired;

  /// No description provided for @lineAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get lineAsset;

  /// No description provided for @lineService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get lineService;

  /// No description provided for @lineSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get lineSection;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet.'**
  String get noOrders;

  /// No description provided for @noCustomer.
  ///
  /// In en, this message translates to:
  /// **'No customer'**
  String get noCustomer;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get newOrder;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'{start} → {end}'**
  String dateRange(String start, String end);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @daysLate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day late} other{{count} days late}}'**
  String daysLate(int count);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String daysCount(int count);

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @chooseCustomer.
  ///
  /// In en, this message translates to:
  /// **'Choose a customer'**
  String get chooseCustomer;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get newCustomer;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Name or phone'**
  String get searchCustomers;

  /// No description provided for @noCustomers.
  ///
  /// In en, this message translates to:
  /// **'No customers found.'**
  String get noCustomers;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @endAfterStart.
  ///
  /// In en, this message translates to:
  /// **'The end must be after the start.'**
  String get endAfterStart;

  /// No description provided for @createOrder.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get createOrder;

  /// No description provided for @addLine.
  ///
  /// In en, this message translates to:
  /// **'Add line'**
  String get addLine;

  /// No description provided for @editLine.
  ///
  /// In en, this message translates to:
  /// **'Edit line'**
  String get editLine;

  /// No description provided for @removeLine.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeLine;

  /// No description provided for @removeLineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the order?'**
  String removeLineQuestion(String name);

  /// No description provided for @searchNameOrCode.
  ///
  /// In en, this message translates to:
  /// **'Name or code'**
  String get searchNameOrCode;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found.'**
  String get nothingFound;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'/ day'**
  String get perDay;

  /// No description provided for @byUnitHint.
  ///
  /// In en, this message translates to:
  /// **'Rented by unit. Pick the units after adding.'**
  String get byUnitHint;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @sectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Section title'**
  String get sectionTitle;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @pricePerDay.
  ///
  /// In en, this message translates to:
  /// **'Price / day'**
  String get pricePerDay;

  /// No description provided for @discountPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discountPercent;

  /// No description provided for @checkNumbers.
  ///
  /// In en, this message translates to:
  /// **'Check the numbers.'**
  String get checkNumbers;

  /// No description provided for @quantityPositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be more than zero.'**
  String get quantityPositive;

  /// No description provided for @pickItemFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick an item first.'**
  String get pickItemFirst;

  /// No description provided for @nameNeeded.
  ///
  /// In en, this message translates to:
  /// **'Give it a name.'**
  String get nameNeeded;

  /// No description provided for @bookedLinesFixed.
  ///
  /// In en, this message translates to:
  /// **'Already out: only the name, price and discount can change.'**
  String get bookedLinesFixed;

  /// No description provided for @linesTotal.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get linesTotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @lateFee.
  ///
  /// In en, this message translates to:
  /// **'Late fee'**
  String get lateFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @depositHeld.
  ///
  /// In en, this message translates to:
  /// **'Deposit held'**
  String get depositHeld;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @discountAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Discount and payment'**
  String get discountAndPayment;

  /// No description provided for @orderDiscount.
  ///
  /// In en, this message translates to:
  /// **'Order discount'**
  String get orderDiscount;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get percent;

  /// No description provided for @fixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed amount'**
  String get fixed;

  /// No description provided for @percentMax.
  ///
  /// In en, this message translates to:
  /// **'A percent discount is at most 100.'**
  String get percentMax;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @returnItems.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnItems;

  /// No description provided for @backToDraft.
  ///
  /// In en, this message translates to:
  /// **'Back to draft'**
  String get backToDraft;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @cancelOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get cancelOrderQuestion;

  /// No description provided for @unitsMissing.
  ///
  /// In en, this message translates to:
  /// **'Units missing'**
  String get unitsMissing;

  /// No description provided for @pickUnits.
  ///
  /// In en, this message translates to:
  /// **'Pick units'**
  String get pickUnits;

  /// No description provided for @autofill.
  ///
  /// In en, this message translates to:
  /// **'Autofill'**
  String get autofill;

  /// No description provided for @autofillDone.
  ///
  /// In en, this message translates to:
  /// **'Units picked.'**
  String get autofillDone;

  /// No description provided for @autofillShort.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unit could not be found.} other{{count} units could not be found.}}'**
  String autofillShort(int count);

  /// No description provided for @unitsChosen.
  ///
  /// In en, this message translates to:
  /// **'{chosen} of {wanted} chosen'**
  String unitsChosen(int chosen, int wanted);

  /// No description provided for @noFreeUnits.
  ///
  /// In en, this message translates to:
  /// **'No free units for these dates.'**
  String get noFreeUnits;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @overdueHint.
  ///
  /// In en, this message translates to:
  /// **'Still out past its return date. Autofill skips it.'**
  String get overdueHint;

  /// No description provided for @notFree.
  ///
  /// In en, this message translates to:
  /// **'Not free'**
  String get notFree;

  /// No description provided for @checklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get checklist;

  /// No description provided for @rentalContractSigned.
  ///
  /// In en, this message translates to:
  /// **'Rental contract signed'**
  String get rentalContractSigned;

  /// No description provided for @requiredForPickup.
  ///
  /// In en, this message translates to:
  /// **'Required for pickup'**
  String get requiredForPickup;

  /// No description provided for @pickupReturnReceipt.
  ///
  /// In en, this message translates to:
  /// **'Pickup / return receipt signed'**
  String get pickupReturnReceipt;

  /// No description provided for @loanContract.
  ///
  /// In en, this message translates to:
  /// **'Loan contract signed'**
  String get loanContract;

  /// No description provided for @itemsCaptured.
  ///
  /// In en, this message translates to:
  /// **'Items captured'**
  String get itemsCaptured;

  /// No description provided for @documentsLeft.
  ///
  /// In en, this message translates to:
  /// **'Documents left with us'**
  String get documentsLeft;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @signerName.
  ///
  /// In en, this message translates to:
  /// **'Signed by'**
  String get signerName;

  /// No description provided for @signFirst.
  ///
  /// In en, this message translates to:
  /// **'Sign in the box first.'**
  String get signFirst;

  /// No description provided for @saveSignature.
  ///
  /// In en, this message translates to:
  /// **'Save signature'**
  String get saveSignature;

  /// No description provided for @signedBy.
  ///
  /// In en, this message translates to:
  /// **'Signed by {name}, {date}'**
  String signedBy(String name, String date);

  /// No description provided for @conditionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Condition photos'**
  String get conditionPhotos;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @forcePickup.
  ///
  /// In en, this message translates to:
  /// **'Hand over without the contract'**
  String get forcePickup;

  /// No description provided for @forcePickupHint.
  ///
  /// In en, this message translates to:
  /// **'Admin only. Use when the contract will be signed later.'**
  String get forcePickupHint;

  /// No description provided for @handOver.
  ///
  /// In en, this message translates to:
  /// **'Hand over'**
  String get handOver;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get checkIn;

  /// No description provided for @stillOut.
  ///
  /// In en, this message translates to:
  /// **'{qty} still out'**
  String stillOut(String qty);

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @nothingSelected.
  ///
  /// In en, this message translates to:
  /// **'Nothing selected.'**
  String get nothingSelected;

  /// No description provided for @documentsReturned.
  ///
  /// In en, this message translates to:
  /// **'Documents handed back to the customer'**
  String get documentsReturned;

  /// No description provided for @documentsReturnedOn.
  ///
  /// In en, this message translates to:
  /// **'Documents returned {date}'**
  String documentsReturnedOn(String date);

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan or type a code, then Enter'**
  String get scanHint;

  /// No description provided for @scanWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get scanWithCamera;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches {code}.'**
  String notFound(String code);

  /// No description provided for @openOrder.
  ///
  /// In en, this message translates to:
  /// **'Open order'**
  String get openOrder;

  /// No description provided for @notOnAnyOrder.
  ///
  /// In en, this message translates to:
  /// **'Not on any open order.'**
  String get notOnAnyOrder;

  /// No description provided for @searchAssets.
  ///
  /// In en, this message translates to:
  /// **'Name, code or barcode'**
  String get searchAssets;

  /// No description provided for @noAssets.
  ///
  /// In en, this message translates to:
  /// **'No assets.'**
  String get noAssets;

  /// No description provided for @byUnit.
  ///
  /// In en, this message translates to:
  /// **'by unit'**
  String get byUnit;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get available;

  /// No description provided for @sharedWithTeam.
  ///
  /// In en, this message translates to:
  /// **'Shared with team'**
  String get sharedWithTeam;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get languageDevice;

  /// No description provided for @loadDemo.
  ///
  /// In en, this message translates to:
  /// **'Load demo data'**
  String get loadDemo;

  /// No description provided for @loadDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Cameras, lights and a few sample orders. Only when empty.'**
  String get loadDemoHint;

  /// No description provided for @dataAlready.
  ///
  /// In en, this message translates to:
  /// **'There is data already.'**
  String get dataAlready;

  /// No description provided for @demoLoaded.
  ///
  /// In en, this message translates to:
  /// **'Demo data loaded.'**
  String get demoLoaded;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncing;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline. Changes will sync later.'**
  String get offline;

  /// No description provided for @syncProblem.
  ///
  /// In en, this message translates to:
  /// **'Sync problem: {message}'**
  String syncProblem(String message);

  /// No description provided for @notSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get notSynced;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced {date}'**
  String synced(String date);

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @signInToTeam.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your team'**
  String get signInToTeam;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created. Check your email to confirm it, then sign in.'**
  String get accountCreated;

  /// No description provided for @serverUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. {error}'**
  String serverUnreachable(String error);

  /// No description provided for @notConfigured.
  ///
  /// In en, this message translates to:
  /// **'This copy of Rentory was built without the server address, so it can\'t run. Ask for a new build.'**
  String get notConfigured;

  /// No description provided for @startupFailed.
  ///
  /// In en, this message translates to:
  /// **'Rentory couldn\'t start. Close it and open it again. If this keeps happening, send this message:'**
  String get startupFailed;

  /// No description provided for @copyError.
  ///
  /// In en, this message translates to:
  /// **'Copy error'**
  String get copyError;

  /// No description provided for @errorCopied.
  ///
  /// In en, this message translates to:
  /// **'Error copied'**
  String get errorCopied;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get noConnection;

  /// No description provided for @noConnectionHint.
  ///
  /// In en, this message translates to:
  /// **'Rentory needs the internet to work. It will continue as soon as the connection is back.'**
  String get noConnectionHint;

  /// No description provided for @serverProblem.
  ///
  /// In en, this message translates to:
  /// **'Can\'t load your team\'s data'**
  String get serverProblem;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @statOut.
  ///
  /// In en, this message translates to:
  /// **'Out now'**
  String get statOut;

  /// No description provided for @statDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get statDrafts;

  /// No description provided for @ordersSummary.
  ///
  /// In en, this message translates to:
  /// **'{out} out now · {overdue} overdue'**
  String ordersSummary(int out, int overdue);

  /// No description provided for @searchOrders.
  ///
  /// In en, this message translates to:
  /// **'Name, number, item, note or date'**
  String get searchOrders;

  /// No description provided for @noOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'Tap New order to start a rental.'**
  String get noOrdersHint;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @noLinesYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this order yet.'**
  String get noLinesYet;

  /// No description provided for @newAsset.
  ///
  /// In en, this message translates to:
  /// **'New asset'**
  String get newAsset;

  /// No description provided for @assetsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 asset} other{{count} assets}} · {out} out'**
  String assetsSummary(int count, int out);

  /// No description provided for @noAssetsHint.
  ///
  /// In en, this message translates to:
  /// **'Add your first asset with New asset.'**
  String get noAssetsHint;

  /// No description provided for @availableOf.
  ///
  /// In en, this message translates to:
  /// **'{available} of {total} available'**
  String availableOf(String available, String total);

  /// No description provided for @asset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get asset;

  /// No description provided for @availableNow.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableNow;

  /// No description provided for @totalStock.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalStock;

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @declaredValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get declaredValue;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @unitsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unit} other{{count} units}}'**
  String unitsCount(int count);

  /// No description provided for @addUnits.
  ///
  /// In en, this message translates to:
  /// **'Add units'**
  String get addUnits;

  /// No description provided for @unitsOnePerLine.
  ///
  /// In en, this message translates to:
  /// **'One unit name per line, e.g. FX6-0003'**
  String get unitsOnePerLine;

  /// No description provided for @viewAsset.
  ///
  /// In en, this message translates to:
  /// **'View asset'**
  String get viewAsset;

  /// No description provided for @scanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find a unit and the order it\'s on'**
  String get scanSubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @goingOut.
  ///
  /// In en, this message translates to:
  /// **'Going out'**
  String get goingOut;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get nameRequired;

  /// No description provided for @codeOrBarcode.
  ///
  /// In en, this message translates to:
  /// **'Code or barcode'**
  String get codeOrBarcode;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'What a scanner reads. Leave empty if it has none.'**
  String get codeHint;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @trackByUnit.
  ///
  /// In en, this message translates to:
  /// **'By unit'**
  String get trackByUnit;

  /// No description provided for @trackByQuantity.
  ///
  /// In en, this message translates to:
  /// **'By quantity'**
  String get trackByQuantity;

  /// No description provided for @trackByUnitHint.
  ///
  /// In en, this message translates to:
  /// **'Each piece has its own serial and barcode, like cameras.'**
  String get trackByUnitHint;

  /// No description provided for @trackByQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Identical pieces counted together, like stands or cables.'**
  String get trackByQuantityHint;

  /// No description provided for @createAsset.
  ///
  /// In en, this message translates to:
  /// **'Create asset'**
  String get createAsset;

  /// No description provided for @unitName.
  ///
  /// In en, this message translates to:
  /// **'Unit serial'**
  String get unitName;

  /// No description provided for @unitNameHint.
  ///
  /// In en, this message translates to:
  /// **'Type or scan, then Enter'**
  String get unitNameHint;

  /// No description provided for @numberUnits.
  ///
  /// In en, this message translates to:
  /// **'Number them for me'**
  String get numberUnits;

  /// No description provided for @prefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get prefix;

  /// No description provided for @howMany.
  ///
  /// In en, this message translates to:
  /// **'How many'**
  String get howMany;

  /// No description provided for @acquisition.
  ///
  /// In en, this message translates to:
  /// **'Acquisition'**
  String get acquisition;

  /// No description provided for @acquisitionDate.
  ///
  /// In en, this message translates to:
  /// **'Acquisition date'**
  String get acquisitionDate;

  /// No description provided for @allowLinesOutside.
  ///
  /// In en, this message translates to:
  /// **'Allow lines outside the order dates'**
  String get allowLinesOutside;

  /// No description provided for @allowLinesOutsideHint.
  ///
  /// In en, this message translates to:
  /// **'Off: each line\'s own dates must sit inside the order\'s.'**
  String get allowLinesOutsideHint;

  /// No description provided for @availableForRent.
  ///
  /// In en, this message translates to:
  /// **'Available for rent'**
  String get availableForRent;

  /// No description provided for @availableForRentHint.
  ///
  /// In en, this message translates to:
  /// **'Off: kept as an asset only, never offered on orders.'**
  String get availableForRentHint;

  /// No description provided for @backInService.
  ///
  /// In en, this message translates to:
  /// **'Back in service'**
  String get backInService;

  /// No description provided for @barcodeSameAsCode.
  ///
  /// In en, this message translates to:
  /// **'Same as the code'**
  String get barcodeSameAsCode;

  /// No description provided for @conditionReceived.
  ///
  /// In en, this message translates to:
  /// **'Condition received'**
  String get conditionReceived;

  /// No description provided for @conditionReturned.
  ///
  /// In en, this message translates to:
  /// **'Condition returned'**
  String get conditionReturned;

  /// No description provided for @costPerDay.
  ///
  /// In en, this message translates to:
  /// **'Cost / day'**
  String get costPerDay;

  /// No description provided for @costPerUnit.
  ///
  /// In en, this message translates to:
  /// **'Cost / unit'**
  String get costPerUnit;

  /// No description provided for @declaredValuePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Declared value / unit'**
  String get declaredValuePerUnit;

  /// No description provided for @depositPaid.
  ///
  /// In en, this message translates to:
  /// **'Deposit paid'**
  String get depositPaid;

  /// No description provided for @dueBack.
  ///
  /// In en, this message translates to:
  /// **'Due back'**
  String get dueBack;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit asset'**
  String get editAsset;

  /// No description provided for @evaluationLink.
  ///
  /// In en, this message translates to:
  /// **'Evaluation link'**
  String get evaluationLink;

  /// No description provided for @examinedOn.
  ///
  /// In en, this message translates to:
  /// **'Examined {date}'**
  String examinedOn(String date);

  /// No description provided for @followsOrderDates.
  ///
  /// In en, this message translates to:
  /// **'Follows the order\'s dates'**
  String get followsOrderDates;

  /// No description provided for @giveBack.
  ///
  /// In en, this message translates to:
  /// **'Give back'**
  String get giveBack;

  /// No description provided for @giveBackTo.
  ///
  /// In en, this message translates to:
  /// **'Give back to {who}'**
  String giveBackTo(String who);

  /// No description provided for @givenBackOn.
  ///
  /// In en, this message translates to:
  /// **'Given back'**
  String get givenBackOn;

  /// No description provided for @heldFrom.
  ///
  /// In en, this message translates to:
  /// **'Held from'**
  String get heldFrom;

  /// No description provided for @internalNotes.
  ///
  /// In en, this message translates to:
  /// **'Internal notes'**
  String get internalNotes;

  /// No description provided for @internalReference.
  ///
  /// In en, this message translates to:
  /// **'Internal reference'**
  String get internalReference;

  /// No description provided for @itemsExamined.
  ///
  /// In en, this message translates to:
  /// **'Items examined'**
  String get itemsExamined;

  /// No description provided for @itemsExaminedHint.
  ///
  /// In en, this message translates to:
  /// **'Somebody went over what came back and confirmed its condition.'**
  String get itemsExaminedHint;

  /// No description provided for @linkMustBeHttp.
  ///
  /// In en, this message translates to:
  /// **'The link must start with http:// or https://.'**
  String get linkMustBeHttp;

  /// No description provided for @loan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loan;

  /// No description provided for @loanDueIn.
  ///
  /// In en, this message translates to:
  /// **'Due back to {who} in {span}.'**
  String loanDueIn(String span, String who);

  /// No description provided for @loanNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'Rented in with no return date set. Add one.'**
  String get loanNoDueDate;

  /// No description provided for @loanNotes.
  ///
  /// In en, this message translates to:
  /// **'Loan notes'**
  String get loanNotes;

  /// No description provided for @loanOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'Overdue to {who} by {span}. Call them.'**
  String loanOverdueBy(String span, String who);

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes.'**
  String get noNotes;

  /// No description provided for @notForRent.
  ///
  /// In en, this message translates to:
  /// **'Not for rent'**
  String get notForRent;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything the team should know'**
  String get notesHint;

  /// No description provided for @ownDates.
  ///
  /// In en, this message translates to:
  /// **'Own dates'**
  String get ownDates;

  /// No description provided for @owned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// No description provided for @ownedHint.
  ///
  /// In en, this message translates to:
  /// **'Ours: bought and kept.'**
  String get ownedHint;

  /// No description provided for @ownership.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get ownership;

  /// No description provided for @photosLink.
  ///
  /// In en, this message translates to:
  /// **'Photos link'**
  String get photosLink;

  /// No description provided for @quantityOnHand.
  ///
  /// In en, this message translates to:
  /// **'Quantity on hand'**
  String get quantityOnHand;

  /// No description provided for @rentedFrom.
  ///
  /// In en, this message translates to:
  /// **'Rented from'**
  String get rentedFrom;

  /// No description provided for @rentedIn.
  ///
  /// In en, this message translates to:
  /// **'Rented in'**
  String get rentedIn;

  /// No description provided for @rentedInHint.
  ///
  /// In en, this message translates to:
  /// **'On loan from a supplier. Bookings must end before it is due back.'**
  String get rentedInHint;

  /// No description provided for @retireQuestion.
  ///
  /// In en, this message translates to:
  /// **'Retire {name}? Its free units retire too.'**
  String retireQuestion(String name);

  /// No description provided for @setMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Send to maintenance'**
  String get setMaintenance;

  /// No description provided for @setRetired.
  ///
  /// In en, this message translates to:
  /// **'Retire'**
  String get setRetired;

  /// No description provided for @signs.
  ///
  /// In en, this message translates to:
  /// **'Signs'**
  String get signs;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @supplierPhone.
  ///
  /// In en, this message translates to:
  /// **'Supplier phone'**
  String get supplierPhone;

  /// No description provided for @theSupplier.
  ///
  /// In en, this message translates to:
  /// **'the supplier'**
  String get theSupplier;

  /// No description provided for @theirReference.
  ///
  /// In en, this message translates to:
  /// **'Their reference'**
  String get theirReference;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @capturePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get capturePhone;

  /// No description provided for @captureMacro.
  ///
  /// In en, this message translates to:
  /// **'Macro'**
  String get captureMacro;

  /// No description provided for @rentalContract.
  ///
  /// In en, this message translates to:
  /// **'Rental contract'**
  String get rentalContract;

  /// No description provided for @pickupReturnReceiptDoc.
  ///
  /// In en, this message translates to:
  /// **'Pickup / return receipt'**
  String get pickupReturnReceiptDoc;

  /// No description provided for @loanContractDoc.
  ///
  /// In en, this message translates to:
  /// **'Loan contract'**
  String get loanContractDoc;

  /// No description provided for @loanUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Not yet collected'**
  String get loanUpcoming;

  /// No description provided for @loanInHouse.
  ///
  /// In en, this message translates to:
  /// **'In house'**
  String get loanInHouse;

  /// No description provided for @loanDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due back soon'**
  String get loanDueSoon;

  /// No description provided for @loanOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue to supplier'**
  String get loanOverdue;

  /// No description provided for @loanReturned.
  ///
  /// In en, this message translates to:
  /// **'Given back'**
  String get loanReturned;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get fromGallery;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @noPhotosYet.
  ///
  /// In en, this message translates to:
  /// **'No photos yet. Tap to add one.'**
  String get noPhotosYet;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @setAsCover.
  ///
  /// In en, this message translates to:
  /// **'Set as cover'**
  String get setAsCover;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletePhotoQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo?'**
  String get deletePhotoQuestion;

  /// No description provided for @unitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitsLabel;

  /// No description provided for @chooseUnits.
  ///
  /// In en, this message translates to:
  /// **'Choose units'**
  String get chooseUnits;

  /// No description provided for @orderPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get orderPhotos;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @orderPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Saved to this phone\'s gallery. Only this phone has them.'**
  String get orderPhotosHint;

  /// No description provided for @removeOrderPhotoQuestion.
  ///
  /// In en, this message translates to:
  /// **'Take this photo off the order? It stays in the gallery.'**
  String get removeOrderPhotoQuestion;

  /// No description provided for @photoNotFound.
  ///
  /// In en, this message translates to:
  /// **'This photo is no longer on the phone.'**
  String get photoNotFound;

  /// No description provided for @scanAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String scanAdded(String name);

  /// No description provided for @scanAlready.
  ///
  /// In en, this message translates to:
  /// **'{name} is already on this order'**
  String scanAlready(String name);

  /// No description provided for @unbook.
  ///
  /// In en, this message translates to:
  /// **'Unbook'**
  String get unbook;

  /// No description provided for @deleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Delete order'**
  String get deleteOrder;

  /// No description provided for @deleteOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this order? If items ever went out on it, it is archived instead.'**
  String get deleteOrderQuestion;

  /// No description provided for @orderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Order deleted'**
  String get orderDeleted;

  /// No description provided for @orderArchived.
  ///
  /// In en, this message translates to:
  /// **'Items went out on this order, so it was archived.'**
  String get orderArchived;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restored;

  /// No description provided for @deleteAsset.
  ///
  /// In en, this message translates to:
  /// **'Delete asset'**
  String get deleteAsset;

  /// No description provided for @deleteAssetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this asset? If it is on any order, it is archived instead.'**
  String get deleteAssetQuestion;

  /// No description provided for @assetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Asset deleted'**
  String get assetDeleted;

  /// No description provided for @assetArchived.
  ///
  /// In en, this message translates to:
  /// **'This asset is on orders, so it was archived.'**
  String get assetArchived;

  /// No description provided for @newLocation.
  ///
  /// In en, this message translates to:
  /// **'New location'**
  String get newLocation;

  /// No description provided for @trackingChangeHint.
  ///
  /// In en, this message translates to:
  /// **'Switching keeps its history. Units come back if you switch back.'**
  String get trackingChangeHint;

  /// No description provided for @moveLine.
  ///
  /// In en, this message translates to:
  /// **'Drag to move'**
  String get moveLine;

  /// No description provided for @chooseLinesOut.
  ///
  /// In en, this message translates to:
  /// **'Tick what goes out now.'**
  String get chooseLinesOut;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @backendSupabase.
  ///
  /// In en, this message translates to:
  /// **'Rentory server'**
  String get backendSupabase;

  /// No description provided for @backendOdoo.
  ///
  /// In en, this message translates to:
  /// **'Odoo'**
  String get backendOdoo;

  /// No description provided for @connectToOdoo.
  ///
  /// In en, this message translates to:
  /// **'Connect to Odoo'**
  String get connectToOdoo;

  /// No description provided for @odooSignInHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your own Odoo API key. In Odoo: your profile, Account Security, New API Key.'**
  String get odooSignInHint;

  /// No description provided for @odooUrl.
  ///
  /// In en, this message translates to:
  /// **'Odoo address'**
  String get odooUrl;

  /// No description provided for @odooDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get odooDatabase;

  /// No description provided for @odooApiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get odooApiKey;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @useSupabaseInstead.
  ///
  /// In en, this message translates to:
  /// **'Use the Rentory server instead'**
  String get useSupabaseInstead;

  /// No description provided for @useOdooInstead.
  ///
  /// In en, this message translates to:
  /// **'Connect to Odoo instead'**
  String get useOdooInstead;

  /// No description provided for @odooReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Odoo data is read only in the app for now. Make changes in Odoo.'**
  String get odooReadOnly;

  /// No description provided for @odooNoRentory.
  ///
  /// In en, this message translates to:
  /// **'Connected, but this database has no Rentory, or your Odoo user has no Rentory access.'**
  String get odooNoRentory;

  /// No description provided for @odooBadKey.
  ///
  /// In en, this message translates to:
  /// **'Odoo did not accept this API key or database.'**
  String get odooBadKey;

  /// No description provided for @odooFillAll.
  ///
  /// In en, this message translates to:
  /// **'Fill in the address, database and API key.'**
  String get odooFillAll;

  /// No description provided for @connectedToOdoo.
  ///
  /// In en, this message translates to:
  /// **'Odoo: {database}'**
  String connectedToOdoo(String database);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
