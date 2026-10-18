// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rentory';

  @override
  String get orders => 'Orders';

  @override
  String get scan => 'Scan';

  @override
  String get assets => 'Assets';

  @override
  String get settings => 'Settings';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get back => 'Back';

  @override
  String get change => 'Change';

  @override
  String get clear => 'Clear';

  @override
  String get notYet => 'Not yet';

  @override
  String get all => 'All';

  @override
  String get stateDraft => 'Draft';

  @override
  String get stateBooked => 'Booked';

  @override
  String get statePickedUp => 'Picked up';

  @override
  String get statePartialReturn => 'Partial return';

  @override
  String get stateReturned => 'Returned';

  @override
  String get stateCancelled => 'Cancelled';

  @override
  String get rentalNone => 'Not booked';

  @override
  String get rentalBooked => 'Booked';

  @override
  String get rentalOut => 'Out';

  @override
  String get rentalBack => 'Back';

  @override
  String get conditionGood => 'Good';

  @override
  String get conditionMinor => 'Minor';

  @override
  String get conditionDamaged => 'Damaged';

  @override
  String get conditionMissing => 'Missing';

  @override
  String get serialAvailable => 'Available';

  @override
  String get serialReserved => 'Reserved';

  @override
  String get serialOut => 'Out with a customer';

  @override
  String get serialMaintenance => 'In maintenance';

  @override
  String get serialLost => 'Lost';

  @override
  String get serialRetired => 'Retired';

  @override
  String get lineAsset => 'Asset';

  @override
  String get lineService => 'Service';

  @override
  String get lineSection => 'Section';

  @override
  String get noOrders => 'No orders yet.';

  @override
  String get noCustomer => 'No customer';

  @override
  String get newOrder => 'New order';

  @override
  String get order => 'Order';

  @override
  String dateRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String daysLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days late',
      one: '1 day late',
    );
    return '$_temp0';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get customer => 'Customer';

  @override
  String get chooseCustomer => 'Choose a customer';

  @override
  String get newCustomer => 'New customer';

  @override
  String get searchCustomers => 'Name or phone';

  @override
  String get noCustomers => 'No customers found.';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get endAfterStart => 'The end must be after the start.';

  @override
  String get createOrder => 'Create order';

  @override
  String get addLine => 'Add line';

  @override
  String get editLine => 'Edit line';

  @override
  String get removeLine => 'Remove';

  @override
  String removeLineQuestion(String name) {
    return 'Remove $name from the order?';
  }

  @override
  String get searchNameOrCode => 'Name or code';

  @override
  String get nothingFound => 'Nothing found.';

  @override
  String get perDay => '/ day';

  @override
  String get byUnitHint => 'Rented by unit. Pick the units after adding.';

  @override
  String get description => 'Description';

  @override
  String get sectionTitle => 'Section title';

  @override
  String get quantity => 'Quantity';

  @override
  String get pricePerDay => 'Price / day';

  @override
  String get discountPercent => 'Discount %';

  @override
  String get checkNumbers => 'Check the numbers.';

  @override
  String get quantityPositive => 'Quantity must be more than zero.';

  @override
  String get pickItemFirst => 'Pick an item first.';

  @override
  String get nameNeeded => 'Give it a name.';

  @override
  String get bookedLinesFixed =>
      'Booked lines are fixed. Put the order back to draft to change them.';

  @override
  String get linesTotal => 'Lines';

  @override
  String get discount => 'Discount';

  @override
  String get lateFee => 'Late fee';

  @override
  String get total => 'Total';

  @override
  String get paid => 'Paid';

  @override
  String get due => 'Due';

  @override
  String get depositHeld => 'Deposit held';

  @override
  String get deposit => 'Deposit';

  @override
  String get discountAndPayment => 'Discount and payment';

  @override
  String get orderDiscount => 'Order discount';

  @override
  String get percent => 'Percent';

  @override
  String get fixed => 'Fixed amount';

  @override
  String get percentMax => 'A percent discount is at most 100.';

  @override
  String get book => 'Book';

  @override
  String get pickup => 'Pickup';

  @override
  String get returnItems => 'Return';

  @override
  String get backToDraft => 'Back to draft';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get cancelOrderQuestion => 'Cancel this order?';

  @override
  String get unitsMissing => 'Units missing';

  @override
  String get pickUnits => 'Pick units';

  @override
  String get autofill => 'Autofill';

  @override
  String get autofillDone => 'Units picked.';

  @override
  String autofillShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units could not be found.',
      one: '1 unit could not be found.',
    );
    return '$_temp0';
  }

  @override
  String unitsChosen(int chosen, int wanted) {
    return '$chosen of $wanted chosen';
  }

  @override
  String get noFreeUnits => 'No free units for these dates.';

  @override
  String get overdue => 'Overdue';

  @override
  String get overdueHint =>
      'Still out past its return date. Autofill skips it.';

  @override
  String get notFree => 'Not free';

  @override
  String get checklist => 'Checklist';

  @override
  String get rentalContractSigned => 'Rental contract signed';

  @override
  String get requiredForPickup => 'Required for pickup';

  @override
  String get pickupReturnReceipt => 'Pickup / return receipt signed';

  @override
  String get loanContract => 'Loan contract signed';

  @override
  String get itemsCaptured => 'Items captured';

  @override
  String get documentsLeft => 'Documents left with us';

  @override
  String get signature => 'Signature';

  @override
  String get signerName => 'Signed by';

  @override
  String get signFirst => 'Sign in the box first.';

  @override
  String get saveSignature => 'Save signature';

  @override
  String signedBy(String name, String date) {
    return 'Signed by $name, $date';
  }

  @override
  String get conditionPhotos => 'Condition photos';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get forcePickup => 'Hand over without the contract';

  @override
  String get forcePickupHint =>
      'Admin only. Use when the contract will be signed later.';

  @override
  String get handOver => 'Hand over';

  @override
  String get checkIn => 'Check in';

  @override
  String stillOut(String qty) {
    return '$qty still out';
  }

  @override
  String get note => 'Note';

  @override
  String get nothingSelected => 'Nothing selected.';

  @override
  String get documentsReturned => 'Documents handed back to the customer';

  @override
  String documentsReturnedOn(String date) {
    return 'Documents returned $date';
  }

  @override
  String get scanHint => 'Scan or type a code, then Enter';

  @override
  String get scanWithCamera => 'Scan with camera';

  @override
  String notFound(String code) {
    return 'Nothing matches $code.';
  }

  @override
  String get openOrder => 'Open order';

  @override
  String get notOnAnyOrder => 'Not on any open order.';

  @override
  String get searchAssets => 'Name, code or barcode';

  @override
  String get noAssets => 'No assets.';

  @override
  String get byUnit => 'by unit';

  @override
  String get available => 'available';

  @override
  String get deviceOnly => 'This device only';

  @override
  String get sharedWithTeam => 'Shared with team';

  @override
  String get noServer => 'No server configured. Data stays on this device.';

  @override
  String signedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get language => 'Language';

  @override
  String get languageDevice => 'Device';

  @override
  String get loadDemo => 'Load demo data';

  @override
  String get loadDemoHint =>
      'Cameras, lights and a few sample orders. Only when empty.';

  @override
  String get dataAlready => 'There is data already.';

  @override
  String get demoLoaded => 'Demo data loaded.';

  @override
  String get signOut => 'Sign out';

  @override
  String get syncing => 'Syncing…';

  @override
  String get offline => 'Offline. Changes will sync later.';

  @override
  String syncProblem(String message) {
    return 'Sync problem: $message';
  }

  @override
  String get notSynced => 'Not synced yet';

  @override
  String synced(String date) {
    return 'Synced $date';
  }

  @override
  String get syncNow => 'Sync now';

  @override
  String get signInToTeam => 'Sign in to your team';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get accountCreated =>
      'Account created. Check your email to confirm it, then sign in.';

  @override
  String serverUnreachable(String error) {
    return 'Could not reach the server. $error';
  }
}
