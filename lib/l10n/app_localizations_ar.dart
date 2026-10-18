// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Rentory';

  @override
  String get orders => 'الطلبات';

  @override
  String get scan => 'مسح';

  @override
  String get assets => 'المعدات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get ok => 'حسناً';

  @override
  String get yes => 'نعم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get add => 'إضافة';

  @override
  String get back => 'رجوع';

  @override
  String get change => 'تغيير';

  @override
  String get clear => 'مسح';

  @override
  String get notYet => 'ليس بعد';

  @override
  String get all => 'الكل';

  @override
  String get stateDraft => 'مسودة';

  @override
  String get stateBooked => 'محجوز';

  @override
  String get statePickedUp => 'تم الاستلام';

  @override
  String get statePartialReturn => 'إرجاع جزئي';

  @override
  String get stateReturned => 'مُرجع';

  @override
  String get stateCancelled => 'ملغى';

  @override
  String get rentalNone => 'غير محجوز';

  @override
  String get rentalBooked => 'محجوز';

  @override
  String get rentalOut => 'خارج';

  @override
  String get rentalBack => 'عاد';

  @override
  String get conditionGood => 'جيد';

  @override
  String get conditionMinor => 'بسيط';

  @override
  String get conditionDamaged => 'تالف';

  @override
  String get conditionMissing => 'مفقود';

  @override
  String get serialAvailable => 'متاح';

  @override
  String get serialReserved => 'محجوز';

  @override
  String get serialOut => 'مع زبون';

  @override
  String get serialMaintenance => 'في الصيانة';

  @override
  String get serialLost => 'مفقود';

  @override
  String get serialRetired => 'خارج الخدمة';

  @override
  String get lineAsset => 'معدّة';

  @override
  String get lineService => 'خدمة';

  @override
  String get lineSection => 'قسم';

  @override
  String get noOrders => 'لا توجد طلبات بعد.';

  @override
  String get noCustomer => 'بلا زبون';

  @override
  String get newOrder => 'طلب جديد';

  @override
  String get order => 'طلب';

  @override
  String dateRange(String start, String end) {
    return '$start ← $end';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معدّة',
      many: '$count معدّة',
      few: '$count معدات',
      two: 'معدّتان',
      one: 'معدّة واحدة',
      zero: 'لا معدات',
    );
    return '$_temp0';
  }

  @override
  String daysLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متأخر $count يوماً',
      few: 'متأخر $count أيام',
      two: 'متأخر يومين',
      one: 'متأخر يوماً واحداً',
    );
    return '$_temp0';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوماً',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get customer => 'الزبون';

  @override
  String get chooseCustomer => 'اختر زبوناً';

  @override
  String get newCustomer => 'زبون جديد';

  @override
  String get searchCustomers => 'الاسم أو الهاتف';

  @override
  String get noCustomers => 'لا يوجد زبائن.';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get start => 'البداية';

  @override
  String get end => 'النهاية';

  @override
  String get endAfterStart => 'يجب أن تكون النهاية بعد البداية.';

  @override
  String get createOrder => 'إنشاء الطلب';

  @override
  String get addLine => 'إضافة بند';

  @override
  String get editLine => 'تعديل البند';

  @override
  String get removeLine => 'حذف';

  @override
  String removeLineQuestion(String name) {
    return 'حذف $name من الطلب؟';
  }

  @override
  String get searchNameOrCode => 'الاسم أو الرمز';

  @override
  String get nothingFound => 'لا نتائج.';

  @override
  String get perDay => '/ يوم';

  @override
  String get byUnitHint => 'تؤجَّر بالقطعة. اختر الوحدات بعد الإضافة.';

  @override
  String get description => 'الوصف';

  @override
  String get sectionTitle => 'عنوان القسم';

  @override
  String get quantity => 'الكمية';

  @override
  String get pricePerDay => 'السعر / يوم';

  @override
  String get discountPercent => 'الخصم %';

  @override
  String get checkNumbers => 'تحقق من الأرقام.';

  @override
  String get quantityPositive => 'يجب أن تكون الكمية أكبر من صفر.';

  @override
  String get pickItemFirst => 'اختر عنصراً أولاً.';

  @override
  String get nameNeeded => 'أدخل اسماً.';

  @override
  String get bookedLinesFixed =>
      'البنود المحجوزة ثابتة. أعد الطلب إلى مسودة لتعديلها.';

  @override
  String get linesTotal => 'البنود';

  @override
  String get discount => 'الخصم';

  @override
  String get lateFee => 'غرامة التأخير';

  @override
  String get total => 'الإجمالي';

  @override
  String get paid => 'المدفوع';

  @override
  String get due => 'المتبقي';

  @override
  String get depositHeld => 'التأمين المحتجز';

  @override
  String get deposit => 'التأمين';

  @override
  String get discountAndPayment => 'الخصم والدفع';

  @override
  String get orderDiscount => 'خصم الطلب';

  @override
  String get percent => 'نسبة';

  @override
  String get fixed => 'مبلغ ثابت';

  @override
  String get percentMax => 'الخصم بالنسبة لا يتجاوز 100.';

  @override
  String get book => 'حجز';

  @override
  String get pickup => 'التسليم';

  @override
  String get returnItems => 'الإرجاع';

  @override
  String get backToDraft => 'إعادة إلى مسودة';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get cancelOrderQuestion => 'إلغاء هذا الطلب؟';

  @override
  String get unitsMissing => 'وحدات ناقصة';

  @override
  String get pickUnits => 'اختيار الوحدات';

  @override
  String get autofill => 'تعبئة تلقائية';

  @override
  String get autofillDone => 'تم اختيار الوحدات.';

  @override
  String autofillShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تعذر إيجاد $count وحدة.',
      few: 'تعذر إيجاد $count وحدات.',
      two: 'تعذر إيجاد وحدتين.',
      one: 'تعذر إيجاد وحدة واحدة.',
    );
    return '$_temp0';
  }

  @override
  String unitsChosen(int chosen, int wanted) {
    return 'تم اختيار $chosen من $wanted';
  }

  @override
  String get noFreeUnits => 'لا توجد وحدات متاحة لهذه التواريخ.';

  @override
  String get overdue => 'متأخر';

  @override
  String get overdueHint =>
      'لا تزال خارجاً بعد موعد إرجاعها. التعبئة التلقائية تتجاوزها.';

  @override
  String get notFree => 'غير متاحة';

  @override
  String get checklist => 'قائمة التحقق';

  @override
  String get rentalContractSigned => 'عقد الإيجار موقّع';

  @override
  String get requiredForPickup => 'مطلوب للتسليم';

  @override
  String get pickupReturnReceipt => 'إيصال التسليم / الإرجاع موقّع';

  @override
  String get loanContract => 'عقد الأمانة موقّع';

  @override
  String get itemsCaptured => 'تم تصوير المعدات';

  @override
  String get documentsLeft => 'الوثائق المتروكة لدينا';

  @override
  String get signature => 'التوقيع';

  @override
  String get signerName => 'اسم الموقّع';

  @override
  String get signFirst => 'وقّع في المربع أولاً.';

  @override
  String get saveSignature => 'حفظ التوقيع';

  @override
  String signedBy(String name, String date) {
    return 'وقّعه $name، $date';
  }

  @override
  String get conditionPhotos => 'صور الحالة';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get forcePickup => 'التسليم بدون العقد';

  @override
  String get forcePickupHint => 'للمدير فقط. عند توقيع العقد لاحقاً.';

  @override
  String get handOver => 'تسليم';

  @override
  String get checkIn => 'استلام';

  @override
  String stillOut(String qty) {
    return '$qty لا تزال خارجاً';
  }

  @override
  String get note => 'ملاحظة';

  @override
  String get nothingSelected => 'لم يتم اختيار شيء.';

  @override
  String get documentsReturned => 'أعيدت الوثائق إلى الزبون';

  @override
  String documentsReturnedOn(String date) {
    return 'أعيدت الوثائق $date';
  }

  @override
  String get scanHint => 'امسح أو اكتب الرمز ثم Enter';

  @override
  String get scanWithCamera => 'المسح بالكاميرا';

  @override
  String notFound(String code) {
    return 'لا شيء يطابق $code.';
  }

  @override
  String get openOrder => 'فتح الطلب';

  @override
  String get notOnAnyOrder => 'ليست على أي طلب مفتوح.';

  @override
  String get searchAssets => 'الاسم أو الرمز أو الباركود';

  @override
  String get noAssets => 'لا توجد معدات.';

  @override
  String get byUnit => 'بالقطعة';

  @override
  String get available => 'متاح';

  @override
  String get sharedWithTeam => 'مشترك مع الفريق';

  @override
  String signedInAs(String email) {
    return 'مسجّل الدخول باسم $email';
  }

  @override
  String get language => 'اللغة';

  @override
  String get languageDevice => 'لغة الجهاز';

  @override
  String get loadDemo => 'تحميل بيانات تجريبية';

  @override
  String get loadDemoHint =>
      'كاميرات وإضاءة وبعض الطلبات التجريبية. فقط عندما تكون فارغة.';

  @override
  String get dataAlready => 'توجد بيانات بالفعل.';

  @override
  String get demoLoaded => 'تم تحميل البيانات التجريبية.';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get syncing => 'جارٍ المزامنة…';

  @override
  String get offline => 'غير متصل. ستتم مزامنة التغييرات لاحقاً.';

  @override
  String syncProblem(String message) {
    return 'مشكلة في المزامنة: $message';
  }

  @override
  String get notSynced => 'لم تتم المزامنة بعد';

  @override
  String synced(String date) {
    return 'تمت المزامنة $date';
  }

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get signInToTeam => 'سجّل الدخول إلى فريقك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get accountCreated =>
      'تم إنشاء الحساب. افتح بريدك لتأكيده ثم سجّل الدخول.';

  @override
  String serverUnreachable(String error) {
    return 'تعذر الوصول إلى الخادم. $error';
  }

  @override
  String get notConfigured =>
      'تم بناء هذه النسخة من Rentory بدون عنوان الخادم، لذا لا يمكن تشغيلها. اطلب نسخة جديدة.';

  @override
  String get startupFailed =>
      'تعذّر تشغيل Rentory. أغلقه وافتحه مجددًا. إذا تكرر ذلك، أرسل هذه الرسالة:';

  @override
  String get copyError => 'نسخ الخطأ';

  @override
  String get errorCopied => 'تم نسخ الخطأ';

  @override
  String get noConnection => 'لا يوجد اتصال';

  @override
  String get noConnectionHint =>
      'يحتاج Rentory إلى الإنترنت ليعمل. سيتابع فور عودة الاتصال.';

  @override
  String get serverProblem => 'تعذر تحميل بيانات فريقك';

  @override
  String get connecting => 'جارٍ الاتصال…';

  @override
  String get tryAgain => 'حاول مجدداً';

  @override
  String get statOut => 'خارج الآن';

  @override
  String get statDrafts => 'مسودات';

  @override
  String ordersSummary(int out, int overdue) {
    return '$out خارج الآن · $overdue متأخر';
  }

  @override
  String get searchOrders => 'الزبون أو الهاتف أو رقم الطلب';

  @override
  String get noOrdersHint => 'اضغط طلب جديد لبدء تأجير.';

  @override
  String get items => 'المعدات';

  @override
  String get payment => 'الدفع';

  @override
  String get edit => 'تعديل';

  @override
  String get noLinesYet => 'لا شيء في هذا الطلب بعد.';

  @override
  String get newAsset => 'معدّة جديدة';

  @override
  String assetsSummary(int count, int out) {
    return '$count معدّة · $out خارج';
  }

  @override
  String get noAssetsHint => 'أضف أول معدّة من معدّة جديدة.';

  @override
  String availableOf(String available, String total) {
    return '$available من $total متاح';
  }

  @override
  String get asset => 'معدّة';

  @override
  String get availableNow => 'متاح';

  @override
  String get totalStock => 'الإجمالي';

  @override
  String get pricing => 'التسعير';

  @override
  String get declaredValue => 'القيمة';

  @override
  String get barcode => 'الباركود';

  @override
  String get notes => 'ملاحظات';

  @override
  String unitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وحدة',
      few: '$count وحدات',
      two: 'وحدتان',
      one: 'وحدة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get addUnits => 'إضافة وحدات';

  @override
  String get unitsOnePerLine => 'اسم وحدة في كل سطر، مثل FX6-0003';

  @override
  String get viewAsset => 'عرض المعدّة';

  @override
  String get scanSubtitle => 'اعثر على وحدة والطلب الذي تتبعه';

  @override
  String get account => 'الحساب';

  @override
  String get data => 'البيانات';

  @override
  String get dates => 'التواريخ';

  @override
  String get goingOut => 'ما سيخرج';

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get details => 'التفاصيل';

  @override
  String get nameRequired => 'الاسم *';

  @override
  String get codeOrBarcode => 'الرمز أو الباركود';

  @override
  String get codeHint => 'ما يقرؤه الماسح. اتركه فارغاً إن لم يوجد.';

  @override
  String get category => 'الفئة';

  @override
  String get none => 'بدون';

  @override
  String get location => 'الموقع';

  @override
  String get stock => 'المخزون';

  @override
  String get trackByUnit => 'بالوحدة';

  @override
  String get trackByQuantity => 'بالكمية';

  @override
  String get trackByUnitHint =>
      'لكل قطعة رقم تسلسلي وباركود خاص، مثل الكاميرات.';

  @override
  String get trackByQuantityHint =>
      'قطع متطابقة تُعدّ معاً، مثل الحوامل أو الكابلات.';

  @override
  String get createAsset => 'إنشاء المعدّة';

  @override
  String get unitName => 'رقم الوحدة';

  @override
  String get unitNameHint => 'اكتب أو امسح ثم Enter';

  @override
  String get numberUnits => 'رقّمها تلقائياً';

  @override
  String get prefix => 'البادئة';

  @override
  String get howMany => 'كم وحدة';

  @override
  String get acquisition => 'الاقتناء';

  @override
  String get acquisitionDate => 'تاريخ الاقتناء';

  @override
  String get allowLinesOutside => 'السماح للبنود خارج تواريخ الطلب';

  @override
  String get allowLinesOutsideHint =>
      'عند الإيقاف: يجب أن تقع تواريخ كل بند داخل تواريخ الطلب.';

  @override
  String get availableForRent => 'متاحة للتأجير';

  @override
  String get availableForRentHint =>
      'عند الإيقاف: تبقى كأصل فقط ولا تُعرض في الطلبات.';

  @override
  String get backInService => 'إعادة إلى الخدمة';

  @override
  String get barcodeSameAsCode => 'نفس الرمز';

  @override
  String get conditionReceived => 'الحالة عند الاستلام';

  @override
  String get conditionReturned => 'الحالة عند الإرجاع';

  @override
  String get costPerDay => 'التكلفة / يوم';

  @override
  String get costPerUnit => 'التكلفة / وحدة';

  @override
  String get declaredValuePerUnit => 'القيمة المصرّح بها / وحدة';

  @override
  String get depositPaid => 'التأمين المدفوع';

  @override
  String get dueBack => 'موعد الإرجاع';

  @override
  String get editAsset => 'تعديل المعدّة';

  @override
  String get evaluationLink => 'رابط التقييم';

  @override
  String examinedOn(String date) {
    return 'تم الفحص $date';
  }

  @override
  String get followsOrderDates => 'يتبع تواريخ الطلب';

  @override
  String get giveBack => 'إرجاع للمالك';

  @override
  String giveBackTo(String who) {
    return 'إرجاع إلى $who';
  }

  @override
  String get givenBackOn => 'أُرجعت في';

  @override
  String get heldFrom => 'بحوزتنا من';

  @override
  String get internalNotes => 'ملاحظات داخلية';

  @override
  String get internalReference => 'المرجع الداخلي';

  @override
  String get itemsExamined => 'تم فحص المعدات';

  @override
  String get itemsExaminedHint => 'قام أحدهم بفحص ما عاد وتأكيد حالته.';

  @override
  String get linkMustBeHttp => 'يجب أن يبدأ الرابط بـ http:// أو https://.';

  @override
  String get loan => 'الإعارة';

  @override
  String loanDueIn(String span, String who) {
    return 'يجب إرجاعها إلى $who خلال $span.';
  }

  @override
  String get loanNoDueDate => 'مستأجرة بدون تاريخ إرجاع. أضف تاريخاً.';

  @override
  String get loanNotes => 'ملاحظات الإعارة';

  @override
  String loanOverdueBy(String span, String who) {
    return 'متأخرة على $who بمقدار $span. اتصل بهم.';
  }

  @override
  String get noNotes => 'لا ملاحظات.';

  @override
  String get notForRent => 'غير متاحة للتأجير';

  @override
  String get notesHint => 'أي شيء يجب أن يعرفه الفريق';

  @override
  String get ownDates => 'تواريخ خاصة';

  @override
  String get owned => 'مملوكة';

  @override
  String get ownedHint => 'ملكنا: مشتراة ومحفوظة.';

  @override
  String get ownership => 'الملكية';

  @override
  String get photosLink => 'رابط الصور';

  @override
  String get quantityOnHand => 'الكمية المتوفرة';

  @override
  String get rentedFrom => 'مستأجرة من';

  @override
  String get rentedIn => 'مستأجرة';

  @override
  String get rentedInHint =>
      'معارة من مورّد. يجب أن تنتهي الحجوزات قبل موعد إرجاعها.';

  @override
  String retireQuestion(String name) {
    return 'إخراج $name من الخدمة؟ ستخرج وحداتها المتاحة أيضاً.';
  }

  @override
  String get setMaintenance => 'إرسال للصيانة';

  @override
  String get setRetired => 'إخراج من الخدمة';

  @override
  String get signs => 'يوقّع';

  @override
  String get source => 'المصدر';

  @override
  String get supplierPhone => 'هاتف المورّد';

  @override
  String get theSupplier => 'المورّد';

  @override
  String get theirReference => 'مرجعهم';

  @override
  String get unit => 'الوحدة';

  @override
  String get capturePhone => 'هاتف';

  @override
  String get captureMacro => 'ماكرو';

  @override
  String get rentalContract => 'عقد الإيجار';

  @override
  String get pickupReturnReceiptDoc => 'إيصال التسليم / الإرجاع';

  @override
  String get loanContractDoc => 'عقد الأمانة';

  @override
  String get loanUpcoming => 'لم تُستلم بعد';

  @override
  String get loanInHouse => 'لدينا';

  @override
  String get loanDueSoon => 'موعد إرجاعها قريب';

  @override
  String get loanOverdue => 'متأخرة على المورّد';

  @override
  String get loanReturned => 'أُرجعت';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get fromGallery => 'اختيار من المعرض';

  @override
  String get photos => 'الصور';

  @override
  String get noPhotosYet => 'لا صور بعد. اضغط لإضافة صورة.';

  @override
  String get cover => 'الغلاف';

  @override
  String get setAsCover => 'تعيين كغلاف';

  @override
  String get delete => 'حذف';

  @override
  String get deletePhotoQuestion => 'حذف هذه الصورة؟';
}
