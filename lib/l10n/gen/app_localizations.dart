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
/// import 'gen/app_localizations.dart';
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
  /// In ar, this message translates to:
  /// **'سجلك'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navPipeline.
  ///
  /// In ar, this message translates to:
  /// **'الفرص'**
  String get navPipeline;

  /// No description provided for @navCustomers.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get navCustomers;

  /// No description provided for @invoices.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get invoices;

  /// No description provided for @createNew.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء جديد'**
  String get createNew;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك إلى مساحة شركتك'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signIn;

  /// No description provided for @signInFaceId.
  ///
  /// In ar, this message translates to:
  /// **'الدخول ببصمة الوجه'**
  String get signInFaceId;

  /// No description provided for @fatooraCompliant.
  ///
  /// In ar, this message translates to:
  /// **'متوافق مع الفوترة الإلكترونية «فاتورة»'**
  String get fatooraCompliant;

  /// No description provided for @noAccountPrompt.
  ///
  /// In ar, this message translates to:
  /// **'ليس لدى شركتك حساب؟ '**
  String get noAccountPrompt;

  /// No description provided for @signUpFree.
  ///
  /// In ar, this message translates to:
  /// **'سجّل مجاناً'**
  String get signUpFree;

  /// No description provided for @accountTitle.
  ///
  /// In ar, this message translates to:
  /// **'حساب مدير المساحة'**
  String get accountTitle;

  /// No description provided for @accountSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ستكون المسؤول عن إضافة فريقك لاحقاً'**
  String get accountSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز التحقق'**
  String get sendOtp;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الأول والأخير'**
  String get fullNameHint;

  /// No description provided for @workEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني للعمل'**
  String get workEmail;

  /// No description provided for @mobileNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال'**
  String get mobileNumber;

  /// No description provided for @strengthWeak.
  ///
  /// In ar, this message translates to:
  /// **'ضعيفة'**
  String get strengthWeak;

  /// No description provided for @strengthMedium.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get strengthMedium;

  /// No description provided for @strengthStrong.
  ///
  /// In ar, this message translates to:
  /// **'قوية'**
  String get strengthStrong;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'٨ أحرف على الأقل'**
  String get passwordHint;

  /// No description provided for @agreeTo.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على '**
  String get agreeTo;

  /// No description provided for @termsOfUse.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get termsOfUse;

  /// No description provided for @andJoiner.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get andJoiner;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @companyLogo.
  ///
  /// In ar, this message translates to:
  /// **'شعار شركتك'**
  String get companyLogo;

  /// No description provided for @logoSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يظهر في صفحة دخول فريقك وعلى الفواتير'**
  String get logoSubtitle;

  /// No description provided for @createWorkspace.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء المساحة'**
  String get createWorkspace;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @loginPreview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة صفحة الدخول'**
  String get loginPreview;

  /// No description provided for @uploadedTapToChange.
  ///
  /// In ar, this message translates to:
  /// **'تم الرفع — اضغط للتغيير'**
  String get uploadedTapToChange;

  /// No description provided for @uploadLogo.
  ///
  /// In ar, this message translates to:
  /// **'ارفع الشعار'**
  String get uploadLogo;

  /// No description provided for @logoRequirements.
  ///
  /// In ar, this message translates to:
  /// **'صورة بخلفية فاتحة، حتى ٢ ميجابايت'**
  String get logoRequirements;

  /// No description provided for @sectorTrade.
  ///
  /// In ar, this message translates to:
  /// **'تجارة وتوزيع'**
  String get sectorTrade;

  /// No description provided for @sectorIndustry.
  ///
  /// In ar, this message translates to:
  /// **'صناعة'**
  String get sectorIndustry;

  /// No description provided for @sectorServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات'**
  String get sectorServices;

  /// No description provided for @sectorContracting.
  ///
  /// In ar, this message translates to:
  /// **'مقاولات'**
  String get sectorContracting;

  /// No description provided for @sectorOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get sectorOther;

  /// No description provided for @companyTitle.
  ///
  /// In ar, this message translates to:
  /// **'عرّفنا بشركتك'**
  String get companyTitle;

  /// No description provided for @companySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'واختر رابط المساحة الخاص بها'**
  String get companySubtitle;

  /// No description provided for @continueLabel.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueLabel;

  /// No description provided for @companyName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الشركة'**
  String get companyName;

  /// No description provided for @companyNameHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم كما في السجل التجاري'**
  String get companyNameHint;

  /// No description provided for @companySector.
  ///
  /// In ar, this message translates to:
  /// **'نشاط الشركة'**
  String get companySector;

  /// No description provided for @workspaceLink.
  ///
  /// In ar, this message translates to:
  /// **'رابط مساحة الشركة'**
  String get workspaceLink;

  /// No description provided for @linkAvailable.
  ///
  /// In ar, this message translates to:
  /// **'الرابط متاح'**
  String get linkAvailable;

  /// No description provided for @linkTaken.
  ///
  /// In ar, this message translates to:
  /// **'هذا الرابط مستخدم، جرّب اسماً آخر'**
  String get linkTaken;

  /// No description provided for @linkRules.
  ///
  /// In ar, this message translates to:
  /// **'أحرف إنجليزية صغيرة وأرقام فقط'**
  String get linkRules;

  /// No description provided for @teamWillSignInVia.
  ///
  /// In ar, this message translates to:
  /// **'سيدخل فريقك من خلال'**
  String get teamWillSignInVia;

  /// No description provided for @enterWorkspace.
  ///
  /// In ar, this message translates to:
  /// **'الدخول إلى المساحة'**
  String get enterWorkspace;

  /// No description provided for @inviteTeam.
  ///
  /// In ar, this message translates to:
  /// **'دعوة أعضاء الفريق'**
  String get inviteTeam;

  /// No description provided for @workspaceReady.
  ///
  /// In ar, this message translates to:
  /// **'مساحة شركتك جاهزة'**
  String get workspaceReady;

  /// No description provided for @shareLinkWithTeam.
  ///
  /// In ar, this message translates to:
  /// **'شارك الرابط مع فريقك ليبدؤوا العمل'**
  String get shareLinkWithTeam;

  /// No description provided for @linkCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ الرابط'**
  String get linkCopied;

  /// No description provided for @copy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get copy;

  /// No description provided for @startInThreeSteps.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بثلاث خطوات'**
  String get startInThreeSteps;

  /// No description provided for @addFirstCustomer.
  ///
  /// In ar, this message translates to:
  /// **'أضف أول عميل'**
  String get addFirstCustomer;

  /// No description provided for @addProducts.
  ///
  /// In ar, this message translates to:
  /// **'أضف منتجاتك وخدماتك'**
  String get addProducts;

  /// No description provided for @issueFirstInvoice.
  ///
  /// In ar, this message translates to:
  /// **'أصدر أول فاتورة'**
  String get issueFirstInvoice;

  /// No description provided for @verifyAndContinue.
  ///
  /// In ar, this message translates to:
  /// **'تحقق ومتابعة'**
  String get verifyAndContinue;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز التحقق'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمزاً من ٦ أرقام إلى الجوال'**
  String get otpSubtitle;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @verificationCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get verificationCode;

  /// No description provided for @resendCode.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get resendCode;

  /// No description provided for @resendIn.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال بعد '**
  String get resendIn;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @cityRiyadh.
  ///
  /// In ar, this message translates to:
  /// **'الرياض'**
  String get cityRiyadh;

  /// No description provided for @cityJeddah.
  ///
  /// In ar, this message translates to:
  /// **'جدة'**
  String get cityJeddah;

  /// No description provided for @cityDammam.
  ///
  /// In ar, this message translates to:
  /// **'الدمام'**
  String get cityDammam;

  /// No description provided for @cityMakkah.
  ///
  /// In ar, this message translates to:
  /// **'مكة المكرمة'**
  String get cityMakkah;

  /// No description provided for @cityMadinah.
  ///
  /// In ar, this message translates to:
  /// **'المدينة المنورة'**
  String get cityMadinah;

  /// No description provided for @taxTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الضريبية'**
  String get taxTitle;

  /// No description provided for @taxSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تظهر على فواتيرك وتلزم للربط مع «فاتورة»'**
  String get taxSubtitle;

  /// No description provided for @later.
  ///
  /// In ar, this message translates to:
  /// **'لاحقاً'**
  String get later;

  /// No description provided for @commercialRegNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم السجل التجاري'**
  String get commercialRegNo;

  /// No description provided for @digits10.
  ///
  /// In ar, this message translates to:
  /// **'١٠ أرقام'**
  String get digits10;

  /// No description provided for @vatNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الضريبي'**
  String get vatNumber;

  /// No description provided for @vatNumberHint.
  ///
  /// In ar, this message translates to:
  /// **'١٥ رقماً يبدأ وينتهي بـ ٣'**
  String get vatNumberHint;

  /// No description provided for @nationalAddress.
  ///
  /// In ar, this message translates to:
  /// **'العنوان الوطني'**
  String get nationalAddress;

  /// No description provided for @postalCode.
  ///
  /// In ar, this message translates to:
  /// **'الرمز البريدي'**
  String get postalCode;

  /// No description provided for @digits5.
  ///
  /// In ar, this message translates to:
  /// **'٥ أرقام'**
  String get digits5;

  /// No description provided for @addressHint.
  ///
  /// In ar, this message translates to:
  /// **'الحي، الشارع، رقم المبنى'**
  String get addressHint;

  /// No description provided for @city.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get city;

  /// No description provided for @fatooraLinkSemantic.
  ///
  /// In ar, this message translates to:
  /// **'الربط مع منصة فاتورة'**
  String get fatooraLinkSemantic;

  /// No description provided for @fatooraLink.
  ///
  /// In ar, this message translates to:
  /// **'الربط مع منصة «فاتورة»'**
  String get fatooraLink;

  /// No description provided for @fatooraLinkDesc.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الفواتير لهيئة الزكاة تلقائياً'**
  String get fatooraLinkDesc;

  /// No description provided for @welcomeTagline.
  ///
  /// In ar, this message translates to:
  /// **'عملاؤك ومبيعاتك وفواتيرك\nفي مكان واحد'**
  String get welcomeTagline;

  /// No description provided for @featureFree.
  ///
  /// In ar, this message translates to:
  /// **'مجاني بالكامل، بلا بطاقة دفع'**
  String get featureFree;

  /// No description provided for @featureFatoora.
  ///
  /// In ar, this message translates to:
  /// **'فواتير متوافقة مع منصة «فاتورة»'**
  String get featureFatoora;

  /// No description provided for @featureOwnLink.
  ///
  /// In ar, this message translates to:
  /// **'رابط خاص لشركتك بشعارها'**
  String get featureOwnLink;

  /// No description provided for @createCompanyAccountFree.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حساب شركتك مجاناً'**
  String get createCompanyAccountFree;

  /// No description provided for @haveAccountSignIn.
  ///
  /// In ar, this message translates to:
  /// **'لدي حساب — تسجيل الدخول'**
  String get haveAccountSignIn;

  /// No description provided for @tabActivity.
  ///
  /// In ar, this message translates to:
  /// **'النشاط'**
  String get tabActivity;

  /// No description provided for @tabData.
  ///
  /// In ar, this message translates to:
  /// **'البيانات'**
  String get tabData;

  /// No description provided for @createInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء فاتورة'**
  String get createInvoice;

  /// No description provided for @quote.
  ///
  /// In ar, this message translates to:
  /// **'عرض سعر'**
  String get quote;

  /// No description provided for @customerProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف العميل'**
  String get customerProfile;

  /// No description provided for @options.
  ///
  /// In ar, this message translates to:
  /// **'خيارات'**
  String get options;

  /// No description provided for @call.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get call;

  /// No description provided for @message.
  ///
  /// In ar, this message translates to:
  /// **'رسالة'**
  String get message;

  /// No description provided for @mail.
  ///
  /// In ar, this message translates to:
  /// **'بريد'**
  String get mail;

  /// No description provided for @location.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get location;

  /// No description provided for @totalSales.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المبيعات'**
  String get totalSales;

  /// No description provided for @amountDue.
  ///
  /// In ar, this message translates to:
  /// **'المستحق'**
  String get amountDue;

  /// No description provided for @openDeals.
  ///
  /// In ar, this message translates to:
  /// **'فرص مفتوحة'**
  String get openDeals;

  /// No description provided for @goodMorning.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير'**
  String get goodMorning;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن عميل، فاتورة، فرصة…'**
  String get searchHint;

  /// No description provided for @salesThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'مبيعات هذا الشهر'**
  String get salesThisMonth;

  /// No description provided for @sar.
  ///
  /// In ar, this message translates to:
  /// **'ر.س'**
  String get sar;

  /// No description provided for @sarSpaced.
  ///
  /// In ar, this message translates to:
  /// **' ر.س'**
  String get sarSpaced;

  /// No description provided for @dueInvoices.
  ///
  /// In ar, this message translates to:
  /// **'فواتير مستحقة'**
  String get dueInvoices;

  /// No description provided for @invoice.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة'**
  String get invoice;

  /// No description provided for @customer.
  ///
  /// In ar, this message translates to:
  /// **'عميل'**
  String get customer;

  /// No description provided for @deal.
  ///
  /// In ar, this message translates to:
  /// **'فرصة'**
  String get deal;

  /// No description provided for @todaysTasks.
  ///
  /// In ar, this message translates to:
  /// **'مهام اليوم'**
  String get todaysTasks;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @statusPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة'**
  String get statusPaid;

  /// No description provided for @statusDue.
  ///
  /// In ar, this message translates to:
  /// **'مستحقة'**
  String get statusDue;

  /// No description provided for @statusLate.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة'**
  String get statusLate;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @payBankTransfer.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي'**
  String get payBankTransfer;

  /// No description provided for @refTransferNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحوالة'**
  String get refTransferNo;

  /// No description provided for @payCard.
  ///
  /// In ar, this message translates to:
  /// **'مدى / بطاقة'**
  String get payCard;

  /// No description provided for @refTransactionNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم العملية'**
  String get refTransactionNo;

  /// No description provided for @payCash.
  ///
  /// In ar, this message translates to:
  /// **'نقداً'**
  String get payCash;

  /// No description provided for @refVoucherNo.
  ///
  /// In ar, this message translates to:
  /// **'رقم السند'**
  String get refVoucherNo;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @thisMonth.
  ///
  /// In ar, this message translates to:
  /// **'هذا الشهر'**
  String get thisMonth;

  /// No description provided for @totalInvoices.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الفواتير'**
  String get totalInvoices;

  /// No description provided for @recordPayment.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة'**
  String get recordPayment;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @download.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get download;

  /// No description provided for @reportedToFatoora.
  ///
  /// In ar, this message translates to:
  /// **'مُبلّغة إلى «فاتورة»'**
  String get reportedToFatoora;

  /// No description provided for @taxInvoiceTo.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة ضريبية إلى'**
  String get taxInvoiceTo;

  /// No description provided for @invoiceQrSemantic.
  ///
  /// In ar, this message translates to:
  /// **'رمز الاستجابة السريعة للفاتورة'**
  String get invoiceQrSemantic;

  /// No description provided for @issueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإصدار'**
  String get issueDate;

  /// No description provided for @dueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاستحقاق'**
  String get dueDate;

  /// No description provided for @subtotalBeforeVat.
  ///
  /// In ar, this message translates to:
  /// **'المجموع قبل الضريبة'**
  String get subtotalBeforeVat;

  /// No description provided for @vat15.
  ///
  /// In ar, this message translates to:
  /// **'ضريبة القيمة المضافة ١٥٪'**
  String get vat15;

  /// No description provided for @totalDue.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي المستحق'**
  String get totalDue;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get total;

  /// No description provided for @issueInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إصدار الفاتورة'**
  String get issueInvoice;

  /// No description provided for @draft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get draft;

  /// No description provided for @invoiceAutoSendNote.
  ///
  /// In ar, this message translates to:
  /// **'تُرسل الفاتورة إلى منصة «فاتورة» تلقائياً عند الإصدار'**
  String get invoiceAutoSendNote;

  /// No description provided for @newInvoice.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة جديدة'**
  String get newInvoice;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @paymentTerms.
  ///
  /// In ar, this message translates to:
  /// **'شروط الدفع'**
  String get paymentTerms;

  /// No description provided for @productsAndServices.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات والخدمات'**
  String get productsAndServices;

  /// No description provided for @customerLabel.
  ///
  /// In ar, this message translates to:
  /// **'العميل'**
  String get customerLabel;

  /// No description provided for @change.
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get change;

  /// No description provided for @increaseQty.
  ///
  /// In ar, this message translates to:
  /// **'زيادة الكمية'**
  String get increaseQty;

  /// No description provided for @decreaseQty.
  ///
  /// In ar, this message translates to:
  /// **'إنقاص الكمية'**
  String get decreaseQty;

  /// No description provided for @addProduct.
  ///
  /// In ar, this message translates to:
  /// **'إضافة منتج'**
  String get addProduct;

  /// No description provided for @sendReceipt.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الإيصال للعميل'**
  String get sendReceipt;

  /// No description provided for @backToInvoices.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الفواتير'**
  String get backToInvoices;

  /// No description provided for @paymentRecorded.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدفعة'**
  String get paymentRecorded;

  /// No description provided for @invoiceLabel.
  ///
  /// In ar, this message translates to:
  /// **'الفاتورة'**
  String get invoiceLabel;

  /// No description provided for @paymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get paymentMethod;

  /// No description provided for @invoiceStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الفاتورة'**
  String get invoiceStatus;

  /// No description provided for @paidInFull.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة بالكامل'**
  String get paidInFull;

  /// No description provided for @dealAutoWon.
  ///
  /// In ar, this message translates to:
  /// **'أُغلقت الفرصة المرتبطة كـ«مكسوبة» تلقائياً'**
  String get dealAutoWon;

  /// No description provided for @paymentDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الدفع'**
  String get paymentDate;

  /// No description provided for @optional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optional;

  /// No description provided for @attachReceipt.
  ///
  /// In ar, this message translates to:
  /// **'إرفاق صورة الإيصال'**
  String get attachReceipt;

  /// No description provided for @confirmPaymentReceived.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد استلام الدفعة'**
  String get confirmPaymentReceived;

  /// No description provided for @amountReceived.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المستلم'**
  String get amountReceived;

  /// No description provided for @amountHelp.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المتبقي على الفاتورة كاملاً · يمكنك تسجيل دفعة جزئية'**
  String get amountHelp;

  /// No description provided for @convertToInvoice.
  ///
  /// In ar, this message translates to:
  /// **'تحويل إلى فاتورة'**
  String get convertToInvoice;

  /// No description provided for @stageNew.
  ///
  /// In ar, this message translates to:
  /// **'جديدة'**
  String get stageNew;

  /// No description provided for @stageQualified.
  ///
  /// In ar, this message translates to:
  /// **'مؤهلة'**
  String get stageQualified;

  /// No description provided for @stageNegotiation.
  ///
  /// In ar, this message translates to:
  /// **'تفاوض'**
  String get stageNegotiation;

  /// No description provided for @stageWon.
  ///
  /// In ar, this message translates to:
  /// **'مكسوبة'**
  String get stageWon;

  /// No description provided for @saveDeal.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الفرصة'**
  String get saveDeal;

  /// No description provided for @saveAndCreateQuote.
  ///
  /// In ar, this message translates to:
  /// **'حفظ وإنشاء عرض سعر'**
  String get saveAndCreateQuote;

  /// No description provided for @newDeal.
  ///
  /// In ar, this message translates to:
  /// **'فرصة جديدة'**
  String get newDeal;

  /// No description provided for @dealTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الفرصة'**
  String get dealTitle;

  /// No description provided for @dealTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: توريد خط تعبئة'**
  String get dealTitleHint;

  /// No description provided for @newCustomerAction.
  ///
  /// In ar, this message translates to:
  /// **'+ عميل جديد'**
  String get newCustomerAction;

  /// No description provided for @expectedValue.
  ///
  /// In ar, this message translates to:
  /// **'القيمة المتوقعة'**
  String get expectedValue;

  /// No description provided for @expectedClose.
  ///
  /// In ar, this message translates to:
  /// **'الإغلاق المتوقع'**
  String get expectedClose;

  /// No description provided for @expectedCloseHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: ٣٠ نوفمبر'**
  String get expectedCloseHint;

  /// No description provided for @stage.
  ///
  /// In ar, this message translates to:
  /// **'المرحلة'**
  String get stage;

  /// No description provided for @owner.
  ///
  /// In ar, this message translates to:
  /// **'المسؤول'**
  String get owner;

  /// No description provided for @me.
  ///
  /// In ar, this message translates to:
  /// **'أنا'**
  String get me;

  /// No description provided for @notes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب، المنافسون، الخطوة التالية…'**
  String get notesHint;

  /// No description provided for @filter.
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get filter;

  /// No description provided for @stageTotal.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المرحلة'**
  String get stageTotal;

  /// No description provided for @customerApprovedConfirm.
  ///
  /// In ar, this message translates to:
  /// **'العميل وافق — تأكيد العرض'**
  String get customerApprovedConfirm;

  /// No description provided for @quoteSent.
  ///
  /// In ar, this message translates to:
  /// **'مُرسل'**
  String get quoteSent;

  /// No description provided for @quoteConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'مؤكد'**
  String get quoteConfirmed;

  /// No description provided for @whatsapp.
  ///
  /// In ar, this message translates to:
  /// **'واتساب'**
  String get whatsapp;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @stepOf.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة {step} من {total}'**
  String stepOf(String step, String total);

  /// No description provided for @probabilityPct.
  ///
  /// In ar, this message translates to:
  /// **'احتمال {value}٪'**
  String probabilityPct(String value);

  /// No description provided for @amountSar.
  ///
  /// In ar, this message translates to:
  /// **'{amount} ر.س'**
  String amountSar(String amount);

  /// No description provided for @unitPriceLine.
  ///
  /// In ar, this message translates to:
  /// **'{price} ر.س للوحدة · {line} ر.س'**
  String unitPriceLine(String price, String line);

  /// No description provided for @invoiceRowSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم {number} · {date}'**
  String invoiceRowSubtitle(String number, String date);

  /// No description provided for @invoiceNo.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم {number}'**
  String invoiceNo(String number);

  /// No description provided for @quoteNo.
  ///
  /// In ar, this message translates to:
  /// **'عرض سعر رقم {number}'**
  String quoteNo(String number);

  /// No description provided for @pipelineSummary.
  ///
  /// In ar, this message translates to:
  /// **'{count} فرصة · {amount} ر.س متوقعة'**
  String pipelineSummary(String count, String amount);

  /// No description provided for @overdueCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} متأخرة'**
  String overdueCount(String count);

  /// No description provided for @amountExpected.
  ///
  /// In ar, this message translates to:
  /// **'{amount} ر.س متوقعة'**
  String amountExpected(String amount);

  /// No description provided for @vatNumberLine.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الضريبي: {number}'**
  String vatNumberLine(String number);

  /// No description provided for @legendPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة {amount}'**
  String legendPaid(String amount);

  /// No description provided for @legendDue.
  ///
  /// In ar, this message translates to:
  /// **'مستحقة {amount}'**
  String legendDue(String amount);

  /// No description provided for @legendLate.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة {amount}'**
  String legendLate(String amount);

  /// No description provided for @invoiceNumberValue.
  ///
  /// In ar, this message translates to:
  /// **'رقم {number}'**
  String invoiceNumberValue(String number);

  /// No description provided for @customerAndInvoice.
  ///
  /// In ar, this message translates to:
  /// **'{customer} · فاتورة رقم {number}'**
  String customerAndInvoice(String customer, String number);

  /// No description provided for @authEmailHint.
  ///
  /// In ar, this message translates to:
  /// **'name@company.com'**
  String get authEmailHint;

  /// No description provided for @authPhoneCountryCode.
  ///
  /// In ar, this message translates to:
  /// **'٩٦٦+'**
  String get authPhoneCountryCode;

  /// No description provided for @authPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'٥٠ ٠٠٠ ٠٠٠٠'**
  String get authPhoneHint;

  /// No description provided for @authDemoBrandName.
  ///
  /// In ar, this message translates to:
  /// **'[اسم شركتك]'**
  String get authDemoBrandName;

  /// No description provided for @authDemoBrandInitial.
  ///
  /// In ar, this message translates to:
  /// **'ن'**
  String get authDemoBrandInitial;

  /// No description provided for @authDemoWorkspaceHandle.
  ///
  /// In ar, this message translates to:
  /// **'alnokhba'**
  String get authDemoWorkspaceHandle;

  /// No description provided for @opportunityLine.
  ///
  /// In ar, this message translates to:
  /// **'الفرصة: {title}'**
  String opportunityLine(String title);

  /// No description provided for @lineQtyPrice.
  ///
  /// In ar, this message translates to:
  /// **'{qty} × {price}'**
  String lineQtyPrice(String qty, String price);

  /// No description provided for @glyphPlus.
  ///
  /// In ar, this message translates to:
  /// **'+'**
  String get glyphPlus;

  /// No description provided for @glyphMinus.
  ///
  /// In ar, this message translates to:
  /// **'−'**
  String get glyphMinus;

  /// No description provided for @monthName.
  ///
  /// In ar, this message translates to:
  /// **'{month, select, jan{يناير} feb{فبراير} mar{مارس} apr{أبريل} may{مايو} jun{يونيو} jul{يوليو} aug{أغسطس} sep{سبتمبر} oct{أكتوبر} nov{نوفمبر} dec{ديسمبر} other{}}'**
  String monthName(String month);

  /// No description provided for @dateDayMonth.
  ///
  /// In ar, this message translates to:
  /// **'{day} {month}'**
  String dateDayMonth(String day, String month);

  /// No description provided for @dateDayMonthYear.
  ///
  /// In ar, this message translates to:
  /// **'{day} {month} {year}'**
  String dateDayMonthYear(String day, String month, String year);

  /// No description provided for @newLeadValueHint.
  ///
  /// In ar, this message translates to:
  /// **'٠'**
  String get newLeadValueHint;

  /// No description provided for @salesGrowthBadge.
  ///
  /// In ar, this message translates to:
  /// **'↑ {value}٪'**
  String salesGrowthBadge(String value);

  /// No description provided for @amountThousands.
  ///
  /// In ar, this message translates to:
  /// **'{count} ألف'**
  String amountThousands(String count);

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @errorNetwork.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الاتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في الخادم. حاول مرة أخرى لاحقاً'**
  String get errorServer;

  /// No description provided for @errorNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم نعثر على المطلوب'**
  String get errorNotFound;

  /// No description provided for @errorUnauthorized.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الجلسة. سجّل دخولك من جديد'**
  String get errorUnauthorized;

  /// No description provided for @errorValidation.
  ///
  /// In ar, this message translates to:
  /// **'راجع البيانات المُدخلة وحاول مرة أخرى'**
  String get errorValidation;

  /// No description provided for @errorUnknown.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع. حاول مرة أخرى'**
  String get errorUnknown;

  /// No description provided for @clockTime.
  ///
  /// In ar, this message translates to:
  /// **'{hour}:{minute} {period}'**
  String clockTime(String hour, String minute, String period);

  /// No description provided for @timePeriodAm.
  ///
  /// In ar, this message translates to:
  /// **'ص'**
  String get timePeriodAm;

  /// No description provided for @timePeriodPm.
  ///
  /// In ar, this message translates to:
  /// **'م'**
  String get timePeriodPm;

  /// No description provided for @relativeJustNow.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get relativeJustNow;

  /// No description provided for @relativeToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get relativeToday;

  /// No description provided for @relativeTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غداً'**
  String get relativeTomorrow;

  /// No description provided for @relativeMinutesAgo.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{منذ دقيقة} =2{منذ دقيقتين} few{منذ {formatted} دقائق} other{منذ {formatted} دقيقة}}'**
  String relativeMinutesAgo(int count, String formatted);

  /// No description provided for @relativeHoursAgo.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{منذ ساعة} =2{منذ ساعتين} few{منذ {formatted} ساعات} other{منذ {formatted} ساعة}}'**
  String relativeHoursAgo(int count, String formatted);

  /// No description provided for @relativeDaysAgo.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{أمس} =2{منذ يومين} few{منذ {formatted} أيام} other{منذ {formatted} يوماً}}'**
  String relativeDaysAgo(int count, String formatted);

  /// No description provided for @overdueSinceDays.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{مستحقة اليوم} =1{مستحقة منذ يوم} =2{مستحقة منذ يومين} few{مستحقة منذ {formatted} أيام} other{مستحقة منذ {formatted} يوماً}}'**
  String overdueSinceDays(int count, String formatted);

  /// No description provided for @activityDetailLine.
  ///
  /// In ar, this message translates to:
  /// **'{first} · {second}'**
  String activityDetailLine(String first, String second);

  /// No description provided for @weekdayName.
  ///
  /// In ar, this message translates to:
  /// **'{day, select, mon{الاثنين} tue{الثلاثاء} wed{الأربعاء} thu{الخميس} fri{الجمعة} sat{السبت} sun{الأحد} other{}}'**
  String weekdayName(String day);

  /// No description provided for @dealNextActionWhen.
  ///
  /// In ar, this message translates to:
  /// **'{title} — {when}'**
  String dealNextActionWhen(String title, String when);

  /// No description provided for @dealNextActionTodayAt.
  ///
  /// In ar, this message translates to:
  /// **'{title} اليوم {time}'**
  String dealNextActionTodayAt(String title, String time);

  /// No description provided for @dealQuoteExpiresInDays.
  ///
  /// In ar, this message translates to:
  /// **'انتهاء العرض بعد {days} أيام'**
  String dealQuoteExpiresInDays(String days);

  /// No description provided for @dealQuoteExpiresToday.
  ///
  /// In ar, this message translates to:
  /// **'انتهاء العرض اليوم'**
  String get dealQuoteExpiresToday;

  /// No description provided for @dealQuoteExpiresTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'انتهاء العرض غداً'**
  String get dealQuoteExpiresTomorrow;

  /// No description provided for @dealExpectedCloseOn.
  ///
  /// In ar, this message translates to:
  /// **'الإغلاق المتوقع {date}'**
  String dealExpectedCloseOn(String date);

  /// No description provided for @dealNoNextAction.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خطوة تالية'**
  String get dealNoNextAction;

  /// No description provided for @dueInDaysCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{تستحق اليوم} =1{مستحقة خلال يوم} =2{مستحقة خلال يومين} few{مستحقة خلال {formatted} أيام} other{مستحقة خلال {formatted} يوماً}}'**
  String dueInDaysCount(int count, String formatted);

  /// No description provided for @paymentTermsWithinDays.
  ///
  /// In ar, this message translates to:
  /// **'خلال {days} يوماً'**
  String paymentTermsWithinDays(String days);

  /// No description provided for @receiptAttached.
  ///
  /// In ar, this message translates to:
  /// **'تم إرفاق صورة الإيصال'**
  String get receiptAttached;

  /// No description provided for @paidPartially.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة جزئياً'**
  String get paidPartially;

  /// No description provided for @quoteViewedBanner.
  ///
  /// In ar, this message translates to:
  /// **'فتح العميل العرض {viewed} · صالح حتى {validUntil}'**
  String quoteViewedBanner(String viewed, String validUntil);

  /// No description provided for @quoteViewedToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم {time}'**
  String quoteViewedToday(String time);

  /// No description provided for @quoteViewedOn.
  ///
  /// In ar, this message translates to:
  /// **'{date} {time}'**
  String quoteViewedOn(String date, String time);

  /// No description provided for @loginBiometricNeedsPassword.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول بالبريد وكلمة المرور أولاً'**
  String get loginBiometricNeedsPassword;

  /// No description provided for @invoicesSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث برقم الفاتورة أو العميل'**
  String get invoicesSearchHint;

  /// No description provided for @closeSearch.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق البحث'**
  String get closeSearch;

  /// No description provided for @selectPeriod.
  ///
  /// In ar, this message translates to:
  /// **'اختيار الفترة'**
  String get selectPeriod;

  /// No description provided for @periodLastMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر الماضي'**
  String get periodLastMonth;

  /// No description provided for @periodThisYear.
  ///
  /// In ar, this message translates to:
  /// **'هذه السنة'**
  String get periodThisYear;

  /// No description provided for @periodAllTime.
  ///
  /// In ar, this message translates to:
  /// **'كل الفترات'**
  String get periodAllTime;

  /// No description provided for @productCatalogTitle.
  ///
  /// In ar, this message translates to:
  /// **'من قائمة المنتجات'**
  String get productCatalogTitle;

  /// No description provided for @customItemTitle.
  ///
  /// In ar, this message translates to:
  /// **'بند مخصص'**
  String get customItemTitle;

  /// No description provided for @itemNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم البند'**
  String get itemNameLabel;

  /// No description provided for @itemNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: خدمة استشارية'**
  String get itemNameHint;

  /// No description provided for @unitPriceLabel.
  ///
  /// In ar, this message translates to:
  /// **'سعر الوحدة'**
  String get unitPriceLabel;

  /// No description provided for @addToInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى الفاتورة'**
  String get addToInvoice;

  /// No description provided for @removeLine.
  ///
  /// In ar, this message translates to:
  /// **'حذف البند'**
  String get removeLine;

  /// No description provided for @noProducts.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات في القائمة'**
  String get noProducts;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get settingsTitle;

  /// No description provided for @settingsOpenAccount.
  ///
  /// In ar, this message translates to:
  /// **'فتح الحساب والإعدادات'**
  String get settingsOpenAccount;

  /// No description provided for @settingsWorkspace.
  ///
  /// In ar, this message translates to:
  /// **'مساحة العمل'**
  String get settingsWorkspace;

  /// No description provided for @settingsWorkspaceUrl.
  ///
  /// In ar, this message translates to:
  /// **'رابط المساحة'**
  String get settingsWorkspaceUrl;

  /// No description provided for @settingsLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguage;

  /// No description provided for @settingsSignOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج؟'**
  String get settingsSignOutTitle;

  /// No description provided for @settingsSignOutBody.
  ///
  /// In ar, this message translates to:
  /// **'ستحتاج إلى تسجيل الدخول من جديد للوصول إلى مساحة عملك.'**
  String get settingsSignOutBody;

  /// No description provided for @settingsSignOutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get settingsSignOutConfirm;

  /// No description provided for @settingsCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get settingsCancel;

  /// No description provided for @customersCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} عميل'**
  String customersCount(String count);

  /// No description provided for @customersSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث باسم العميل أو المدينة'**
  String get customersSearchHint;

  /// No description provided for @customersEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد عملاء بعد'**
  String get customersEmpty;

  /// No description provided for @customersNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج مطابقة'**
  String get customersNoResults;

  /// No description provided for @customerOpenDealsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} فرص مفتوحة'**
  String customerOpenDealsCount(String count);

  /// No description provided for @customerDuePill.
  ///
  /// In ar, this message translates to:
  /// **'مستحق {amount}'**
  String customerDuePill(String amount);

  /// No description provided for @customerAddress.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get customerAddress;

  /// No description provided for @customerSector.
  ///
  /// In ar, this message translates to:
  /// **'القطاع'**
  String get customerSector;

  /// No description provided for @customerSince.
  ///
  /// In ar, this message translates to:
  /// **'عميل منذ'**
  String get customerSince;

  /// No description provided for @customerNoDeals.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فرص لهذا العميل'**
  String get customerNoDeals;

  /// No description provided for @customerNoInvoices.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فواتير لهذا العميل'**
  String get customerNoInvoices;

  /// No description provided for @customerInvoiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم {number}'**
  String customerInvoiceTitle(String number);

  /// No description provided for @notifMarkAllRead.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل كمقروء'**
  String get notifMarkAllRead;

  /// No description provided for @notifEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get notifEmptyTitle;

  /// No description provided for @notifEmptyHint.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا تنبيهات عروض الأسعار والفواتير والمهام.'**
  String get notifEmptyHint;

  /// No description provided for @notifGroupYesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get notifGroupYesterday;

  /// No description provided for @notifGroupEarlier.
  ///
  /// In ar, this message translates to:
  /// **'أقدم'**
  String get notifGroupEarlier;

  /// No description provided for @notifUnreadMark.
  ///
  /// In ar, this message translates to:
  /// **'غير مقروء'**
  String get notifUnreadMark;

  /// No description provided for @notifBellUnread.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{الإشعارات، إشعار واحد غير مقروء} =2{الإشعارات، إشعاران غير مقروءين} few{الإشعارات، {formatted} إشعارات غير مقروءة} other{الإشعارات، {formatted} إشعاراً غير مقروء}}'**
  String notifBellUnread(String formatted, int count);

  /// No description provided for @notifQuoteViewedTitle.
  ///
  /// In ar, this message translates to:
  /// **'{customer} اطّلع على عرض السعر'**
  String notifQuoteViewedTitle(String customer);

  /// No description provided for @notifQuoteApprovedTitle.
  ///
  /// In ar, this message translates to:
  /// **'{customer} وافق على عرض السعر'**
  String notifQuoteApprovedTitle(String customer);

  /// No description provided for @notifQuoteBody.
  ///
  /// In ar, this message translates to:
  /// **'عرض السعر رقم {number} · {amount}'**
  String notifQuoteBody(String number, String amount);

  /// No description provided for @notifInvoiceOverdueTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفاتورة رقم {number} متأخرة'**
  String notifInvoiceOverdueTitle(String number);

  /// No description provided for @notifPaymentReceivedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم استلام دفعة من {customer}'**
  String notifPaymentReceivedTitle(String customer);

  /// No description provided for @notifPaymentReceivedBody.
  ///
  /// In ar, this message translates to:
  /// **'{amount} للفاتورة رقم {number}'**
  String notifPaymentReceivedBody(String amount, String number);

  /// No description provided for @notifTaskReminderTitle.
  ///
  /// In ar, this message translates to:
  /// **'تذكير بمهمة'**
  String get notifTaskReminderTitle;

  /// No description provided for @notifDealWonTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إغلاق صفقة مع {customer}'**
  String notifDealWonTitle(String customer);

  /// No description provided for @notifJoinedBody.
  ///
  /// In ar, this message translates to:
  /// **'{first} · {second}'**
  String notifJoinedBody(String first, String second);

  /// No description provided for @customerPickerTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر العميل'**
  String get customerPickerTitle;

  /// No description provided for @newCustomerTitle.
  ///
  /// In ar, this message translates to:
  /// **'عميل جديد'**
  String get newCustomerTitle;

  /// No description provided for @newCustomerNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل'**
  String get newCustomerNameLabel;

  /// No description provided for @newCustomerNameHint.
  ///
  /// In ar, this message translates to:
  /// **'اسم الشركة أو العميل'**
  String get newCustomerNameHint;

  /// No description provided for @newCustomerSectorNone.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get newCustomerSectorNone;

  /// No description provided for @newCustomerSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ العميل'**
  String get newCustomerSave;

  /// No description provided for @dealPickerTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر الفرصة'**
  String get dealPickerTitle;

  /// No description provided for @dealPickerEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فرص مفتوحة لهذا العميل'**
  String get dealPickerEmpty;

  /// No description provided for @dealPickerNew.
  ///
  /// In ar, this message translates to:
  /// **'+ فرصة جديدة'**
  String get dealPickerNew;

  /// No description provided for @searchRecentTitle.
  ///
  /// In ar, this message translates to:
  /// **'البحث الأخير'**
  String get searchRecentTitle;

  /// No description provided for @searchClearRecent.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get searchClearRecent;

  /// No description provided for @searchIdleTitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في كل شيء'**
  String get searchIdleTitle;

  /// No description provided for @searchIdleHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن العملاء والفرص والفواتير وعروض الأسعار من مكان واحد.'**
  String get searchIdleHint;

  /// No description provided for @searchGroupQuotes.
  ///
  /// In ar, this message translates to:
  /// **'عروض الأسعار'**
  String get searchGroupQuotes;

  /// No description provided for @searchSectionHeading.
  ///
  /// In ar, this message translates to:
  /// **'{title} ({count})'**
  String searchSectionHeading(String title, String count);

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج لـ «{query}»'**
  String searchNoResultsTitle(String query);

  /// No description provided for @searchNoResultsHint.
  ///
  /// In ar, this message translates to:
  /// **'جرّب اسم العميل أو رقم الفاتورة أو عنوان الفرصة.'**
  String get searchNoResultsHint;

  /// No description provided for @biometricReason.
  ///
  /// In ar, this message translates to:
  /// **'أكّد هويتك لتسجيل الدخول إلى سجلّك'**
  String get biometricReason;

  /// No description provided for @loginBiometricUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بصمة أو وجه مسجّل على هذا الجهاز. فعّلها من إعدادات الجهاز أو سجّل الدخول بكلمة المرور'**
  String get loginBiometricUnavailable;

  /// No description provided for @loginBiometricLockedOut.
  ///
  /// In ar, this message translates to:
  /// **'تم قفل التحقق الحيوي مؤقتاً بعد محاولات كثيرة. حاول لاحقاً أو سجّل الدخول بكلمة المرور'**
  String get loginBiometricLockedOut;
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
