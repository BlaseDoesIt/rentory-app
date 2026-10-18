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
  String get sharedWithTeam => 'Shared with team';

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

  @override
  String get notConfigured =>
      'This copy of Rentory was built without the server address, so it can\'t run. Ask for a new build.';

  @override
  String get noConnection => 'No connection';

  @override
  String get noConnectionHint =>
      'Rentory needs the internet to work. It will continue as soon as the connection is back.';

  @override
  String get serverProblem => 'Can\'t load your team\'s data';

  @override
  String get connecting => 'Connecting…';

  @override
  String get tryAgain => 'Try again';

  @override
  String get statOut => 'Out now';

  @override
  String get statDrafts => 'Drafts';

  @override
  String ordersSummary(int out, int overdue) {
    return '$out out now · $overdue overdue';
  }

  @override
  String get searchOrders => 'Customer, phone or order number';

  @override
  String get noOrdersHint => 'Tap New order to start a rental.';

  @override
  String get items => 'Items';

  @override
  String get payment => 'Payment';

  @override
  String get edit => 'Edit';

  @override
  String get noLinesYet => 'Nothing on this order yet.';

  @override
  String get newAsset => 'New asset';

  @override
  String assetsSummary(int count, int out) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assets',
      one: '1 asset',
    );
    return '$_temp0 · $out out';
  }

  @override
  String get noAssetsHint => 'Add your first asset with New asset.';

  @override
  String availableOf(String available, String total) {
    return '$available of $total available';
  }

  @override
  String get asset => 'Asset';

  @override
  String get availableNow => 'Available';

  @override
  String get totalStock => 'Total';

  @override
  String get pricing => 'Pricing';

  @override
  String get declaredValue => 'Value';

  @override
  String get barcode => 'Barcode';

  @override
  String get notes => 'Notes';

  @override
  String unitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units',
      one: '1 unit',
    );
    return '$_temp0';
  }

  @override
  String get addUnits => 'Add units';

  @override
  String get unitsOnePerLine => 'One unit name per line, e.g. FX6-0003';

  @override
  String get viewAsset => 'View asset';

  @override
  String get scanSubtitle => 'Find a unit and the order it\'s on';

  @override
  String get account => 'Account';

  @override
  String get data => 'Data';

  @override
  String get dates => 'Dates';

  @override
  String get goingOut => 'Going out';

  @override
  String get newCategory => 'New category';

  @override
  String get details => 'Details';

  @override
  String get nameRequired => 'Name *';

  @override
  String get codeOrBarcode => 'Code or barcode';

  @override
  String get codeHint => 'What a scanner reads. Leave empty if it has none.';

  @override
  String get category => 'Category';

  @override
  String get none => 'None';

  @override
  String get location => 'Location';

  @override
  String get stock => 'Stock';

  @override
  String get trackByUnit => 'By unit';

  @override
  String get trackByQuantity => 'By quantity';

  @override
  String get trackByUnitHint =>
      'Each piece has its own serial and barcode, like cameras.';

  @override
  String get trackByQuantityHint =>
      'Identical pieces counted together, like stands or cables.';

  @override
  String get createAsset => 'Create asset';

  @override
  String get unitName => 'Unit serial';

  @override
  String get unitNameHint => 'Type or scan, then Enter';

  @override
  String get numberUnits => 'Number them for me';

  @override
  String get prefix => 'Prefix';

  @override
  String get howMany => 'How many';

  @override
  String get acquisition => 'Acquisition';

  @override
  String get acquisitionDate => 'Acquisition date';

  @override
  String get allowLinesOutside => 'Allow lines outside the order dates';

  @override
  String get allowLinesOutsideHint =>
      'Off: each line\'s own dates must sit inside the order\'s.';

  @override
  String get availableForRent => 'Available for rent';

  @override
  String get availableForRentHint =>
      'Off: kept as an asset only, never offered on orders.';

  @override
  String get backInService => 'Back in service';

  @override
  String get barcodeSameAsCode => 'Same as the code';

  @override
  String get conditionReceived => 'Condition received';

  @override
  String get conditionReturned => 'Condition returned';

  @override
  String get costPerDay => 'Cost / day';

  @override
  String get costPerUnit => 'Cost / unit';

  @override
  String get declaredValuePerUnit => 'Declared value / unit';

  @override
  String get depositPaid => 'Deposit paid';

  @override
  String get dueBack => 'Due back';

  @override
  String get editAsset => 'Edit asset';

  @override
  String get evaluationLink => 'Evaluation link';

  @override
  String examinedOn(String date) {
    return 'Examined $date';
  }

  @override
  String get followsOrderDates => 'Follows the order\'s dates';

  @override
  String get giveBack => 'Give back';

  @override
  String giveBackTo(String who) {
    return 'Give back to $who';
  }

  @override
  String get givenBackOn => 'Given back';

  @override
  String get heldFrom => 'Held from';

  @override
  String get internalNotes => 'Internal notes';

  @override
  String get internalReference => 'Internal reference';

  @override
  String get itemsExamined => 'Items examined';

  @override
  String get itemsExaminedHint =>
      'Somebody went over what came back and confirmed its condition.';

  @override
  String get linkMustBeHttp => 'The link must start with http:// or https://.';

  @override
  String get loan => 'Loan';

  @override
  String loanDueIn(String span, String who) {
    return 'Due back to $who in $span.';
  }

  @override
  String get loanNoDueDate => 'Rented in with no return date set. Add one.';

  @override
  String get loanNotes => 'Loan notes';

  @override
  String loanOverdueBy(String span, String who) {
    return 'Overdue to $who by $span. Call them.';
  }

  @override
  String get noNotes => 'No notes.';

  @override
  String get notForRent => 'Not for rent';

  @override
  String get notesHint => 'Anything the team should know';

  @override
  String get ownDates => 'Own dates';

  @override
  String get owned => 'Owned';

  @override
  String get ownedHint => 'Ours: bought and kept.';

  @override
  String get ownership => 'Ownership';

  @override
  String get photosLink => 'Photos link';

  @override
  String get quantityOnHand => 'Quantity on hand';

  @override
  String get rentedFrom => 'Rented from';

  @override
  String get rentedIn => 'Rented in';

  @override
  String get rentedInHint =>
      'On loan from a supplier. Bookings must end before it is due back.';

  @override
  String retireQuestion(String name) {
    return 'Retire $name? Its free units retire too.';
  }

  @override
  String get setMaintenance => 'Send to maintenance';

  @override
  String get setRetired => 'Retire';

  @override
  String get signs => 'Signs';

  @override
  String get source => 'Source';

  @override
  String get supplierPhone => 'Supplier phone';

  @override
  String get theSupplier => 'the supplier';

  @override
  String get theirReference => 'Their reference';

  @override
  String get unit => 'Unit';

  @override
  String get capturePhone => 'Phone';

  @override
  String get captureMacro => 'Macro';

  @override
  String get rentalContract => 'Rental contract';

  @override
  String get pickupReturnReceiptDoc => 'Pickup / return receipt';

  @override
  String get loanContractDoc => 'Loan contract';

  @override
  String get loanUpcoming => 'Not yet collected';

  @override
  String get loanInHouse => 'In house';

  @override
  String get loanDueSoon => 'Due back soon';

  @override
  String get loanOverdue => 'Overdue to supplier';

  @override
  String get loanReturned => 'Given back';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get fromGallery => 'Choose from gallery';

  @override
  String get photos => 'Photos';

  @override
  String get noPhotosYet => 'No photos yet. Tap to add one.';

  @override
  String get cover => 'Cover';

  @override
  String get setAsCover => 'Set as cover';

  @override
  String get delete => 'Delete';

  @override
  String get deletePhotoQuestion => 'Delete this photo?';
}
