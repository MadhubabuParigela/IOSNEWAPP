//
//  Constants.swift
//  Dhukan
//
//  Created by Suganya on 7/18/18.
//  Copyright © 2018 Suganya. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0 , width: 50, height: 50), type: .ballRotateChase, color: #colorLiteral(red: 0.09963711458, green: 0.4649581245, blue: 0.8165961247, alpha: 1), padding: 5)

class Constants {
    
//    static let kMainViewController = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
//    static let kNavigationController = (UIApplication.shared.delegate?.window??.rootViewController as? MainViewController)?.rootViewController as? NavigationController
    
    // Development Urls
//    static let BaseUrl = "http://35.154.239.192:4500/"
//    static let BaseImageUrl = "http://35.154.239.192:4500/Misc/Images/productImages/"
//    static let VendorBaseImgUrl = "http://35.154.239.192:4500/Misc/Images/vendorProductImages/"
//    static let BannnerBaseImgUrl = "http://35.154.239.192:4500/Misc/Images/bannerImages/"
    
    // Production Urls
    static let BaseUrl = "http://15.206.193.122:4500/"
    static let BaseImageUrl = "http://15.206.193.122:4500/Misc/Images/productImages/"
    static let VendorBaseImgUrl = "http://15.206.193.122:4500/Misc/Images/vendorProductImages/"
    static let BannnerBaseImgUrl = "http://15.206.193.122:4500/Misc/Images/"

    static let DEVICE_ID               = UIDevice.current.identifierForVendor!.uuidString
    
    static let FONTNAME: NSString      = "Arial"
    
    static let FONTNAME_BOLD: NSString = "Arial-BoldMT"
    
    static let OFFLINE_MESSAGE = "The Internet connection appears to be offline"
    
    static let FEATURE_MESSAGE = "Login to use this feature"
    
    static let SCREEN_WIDTH            = UIScreen.main.bounds.size.width
    
    static let SCREEN_HEIGHT           = UIScreen.main.bounds.size.height
    
    static let appDelegate             = UIApplication.shared.delegate as? AppDelegate
    
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

}

//Vendor Login

let vendorGetAllStockUnitUrl = "endUsers/getAllStockUnitByAccountId/"
let vendorAddStockUnitUrl = "endusers/stockUnit_add"
let vendorUpdateStockUnitUrl = "endusers/stockUnit_update"
let vendorGetStorageLocationUrl = "endUsers/getAllStorageLocationByAccountId/"
let vendorUpdateStoragekUnitUrl = "endusers/storageLocation_update"
let vendorAddStoragekUnitUrl = "endusers/storageLocation_add"
let vendorGetUrl = "endUsers/getAllStorageLocationByAccountId/"
//61780acf0679a76022739c25


//CUSTOMER
let priceUnitUrl = "endUSers/getAllPriceUnits/IND"
let barCodeDetailsUrl = "endUsers/getbarcodeproductdetails/"
let satesUrl = "endUSers/getAllStates/IND"
let OTPUrl = "endusers/otpverificationwithmobilenumber/"
let sendOTPUrl = "endusers/mobileverification/"
let EmailValidationUrl = "endusers/account_add"
let LoginUrl = "endusers/login"
let FogotPwdSendOTPUrl = "endusers/forgotpasswordotp/"
let ForgotPwdOTPVerificationUrl = "endusers/forgotpasswordotpverification/"
let ResetPwdURL = "endusers/reset"
let GetAllAccountsUrl = "endusers/getallaccounts_byuserid/"
let GetAllAccountsForUserUrl = "endusers/getallaccounts_foruser/"
//Intro New
let GetAllAccountsForUserUrlNew="consumer/getallaccounts_byuserid/"
let resendEmailNew="consume/resendEmail/"

let GetAllCountriesUrl = "endusers/getallcountries"
let GetAllCountriesNetworkUrl = "consumer/getallcountries"
let CheckAccountsForUserUrl = "endusers/check_account_access/"
let VendorCheckAccountForUserUrl = "vendorUsers/check_account_access/"
let GetAllAccountsConsumerUrl = "endUsers/consumerdetails_byid/"
let GetPrivacypolicyUpdateUrl = "endusers/privacypolicy_update"
let GetTermaandconditionsUpdateUrl = "endusers/termaandconditions_update"
let MyAccountUrl = "endusers/user_byid/"
let ChangePwdUrl = "endusers/changepassword"
let CurrentInventoryUrl = "endusers/getallcurrentinventory_by_accountid/"
let AddCurrentInventoryUrl = "endusers/currentinventory_add"
let categoriesUrl = "endusers/getallcategories"
let SubCategoriesUrl = "endusers/getsubcategory_bycategoryid/"
let AddToCartUrl = "endusers/shoppingcart_add"
let ShoppingCartRetrieveUrl = "endusers/getallshoppingcartmanagement_by_accountid/"
let SavedCartRetrieveUrl = "endusers/getallsavedlistmanagement/"
let SaveForLaterUrl = "endusers/savedlist_add"
let MoveToCartUrl = "endusers/shoppingcart_add_from_savelist"
let AddVendorUrl = "endusers/vendor_add"
let VendorListUrl = "endusers/getallvendormastermanagement_by_accountid/"
let VendorMasterListUrl = "endusers/getallvendorsforvendormaster_by_accountid/"
let UpdateVendorUrl = "endusers/vendor_update"
let EditVendorListUrl = "endusers/getvendor_byid/"
let AddOpenOrdersUrl = "endusers/openorders_add"
let OpenOrdersUrl = "endusers/getallopenorders_byaccountid/"
let OrdersHistoryUrl = "endusers/getallorderhistorymanagement_byaccountid/"
let EditOrdersHistoryUrl = "endusers/getEditproductmodifiedhistorydetails/"
let UpdateOrdersHistoryUrl = "endusers/getUpdateproductmodifiedhistorydetails/"
let ApprovalsHistoryUrl = "endusers/approvalusershistorylist/"
let ApprovalsListUrl = "endusers/getallapprovalrequestsbyaccountid/"
let localSortUrl = "endusers/get_by_accountid/sorting/"
let FilterSortUrl = "endusers/getGlobalSearchFilter/"
let UpdateInventoryUrl = "endusers/currentinventory/updateStatusDetails"
let GlobalSearchFilterUrl = "endusers/getGlobalSearch/"
let GetCurrentInventopryUrl = "endusers/getcurrentinventory_byid/"
let UpdateCurrentInventoryUrl = "endusers/currentInventory_update"
let ModifiedProductHistoryUrl = "endusers/getproductmodifiedhistory_byproductid/"
let GlobalSearchListUrl = "endusers/getSearchedValues/"
let LocalSearchUrl = "endusers/getLocalSearch/"
let AddShoppingCartProductUrl = "endusers/shoppingcart_add_product"
let AddSaveForLaterShoppingCartProductUrl = "endusers/saveforlater_add_product_from_cart"
let ShoppingCartUpdateUrl = "endusers/shoppingcart_update"
let UpdateOpenOrdersUrl = "endusers/openorders_update_status"
let primaryAccountApprovalUrl = "endUsers/approval_resend_request"
let EditUpdateOpenOrdersUrl = "endusers/openorders_update"
let CheckSwitchAccPwdUrl = "endusers/validatePassword"
let Approve_RejectUrl = "endusers/approvalrequest_update"
let LocalSearchFilterUrl = "endusers/getLocalSearchFilter/"
let EditPermissionListUrl = "endusers/approvaluserslist_onlyapproved/"
let UpdatePermissionsListUrl = "endusers/approvalrequest_permissions_update"
let getTotalValuationUrl = "filters/getTotalValuation"
let getHistoricalWastageUrl = "filters/getHistoricalWastage"
let getHistoricalConsumptionUrl = "filters/getHistoricalConsumption"
let getDemandForcastUrl = "filters/getDemandForcast"
let periodTotalValuationUrl = "filters/getTotalValuation/periodVsPeriod"
let periodHistoricalWastageUrl = "filters/getHistoricalWastage/periodVsPeriod"
let periodHistoricalConsumptionUrl = "filters/getHistoricalConsumption/periodVsPeriod"
let periodDemandForecastUrl = "filters/getDemandForcast/periodVsPeriod"
let ConsumerConnectListUrl = "endUsers/getAllConsumerConnectList/"
//let ConsumerConnectListUrl = "endUsers/getAllConsumerConnectListByLimit/"
let VendorConnectListUrl = "vendorUsers/getallVendorproductsForConsumer/"
let VendorProductLocalSearchListUrl = "vendorUsers/getProductManagementLocalSearch/"
let addVendorProductUrl = "vendorUsers/vendorproducts_multipleadd"
let getAllStorageLocationByParentUrl = "endUsers/getAllStorageLocationByparentLocationAndLevel/"
let getAllStorageLocationByHierachyLevelUrl = "endUsers/getAllStorageLocationByHierachyLevel/"
let PostVendorConnectListUrl = "vendorUsers/getallVendorproductsForConsumerWithFilters/"
let GiveAwayListUrl = "endUsers/getAllGiveAwayList/"
let AcceptBidUrl = "endUsers/acceptBid"
let cancelBidUrl = "endUsers/deleteBid/"
let ConsumerConnectDetailUrl = "endUsers/consumerConnectBidDetailsById/"
let GiveAwayDetailUrl = "endUsers/biddingDetailsByProduct/"
let BorrowLentUrl = "endusers/borrowLent_add"
let RemoveBorrowLentUrl = "endusers/borrowLent_remove"
let ShareUrl = "endusers/sharedStatus_update"
let GetUsersListUrl = "endusers/getAllUsersByAccount/"
let UpdateGiveAwayStatusUrl = "endUsers/updateGiveawayStatus"
let SetGiveAwayRangeUrl = "endusers/vicinityFoAccount"
let VendorBorrowInactiveUrl = "endusers/acceptance_update"
let GiveAwayDetailUpdateStatusUrl = "endUsers/upateBidStatus"
let AllNotificationsUrl = "endusers/getAllNotifications/"
let productDetail = "endusers/getProductById/"
let DeleteNotificationUrl = "endUsers/notificationDelete/"
let ConsumerDetailsRejectUrl = "endUsers/rejectRequestedBid/"

let GetVendorAccountsUrl = "endusers/getallaccounts_forvendors/"
let GetVendorAccountUsersUrl = "vendorUsers/getallvendoraccounts_foruser/"
let UploadVendorKYCDEtailsUrl = "vendorUsers/kycUpload"
let GetVendorPendingListUrl = "vendorUsers/getallpendingorders/"
let AddVendorProductUrl = "vendorUsers/vendorproducts_add"

let GetVendorProductsListUrl = "vendorUsers/getallproducts_by_accountid/"
let GetVendorProductsSortListUrl = "vendorUsers/getallproducts_by_accountid_sorting/"
let VendorShoppingCartAddProductsUrl = "vendorUsers/shoppingcart_add_vendorproducts"
let OrderProductDetailsUrl = "vendorUsers/getProductsDetailsByhistoryId/"
let VendorActiveOrdersUrl = "vendorUsers/getAllActiveOrders/"
let VendorCompletedOrdersUrl = "vendorUsers/getallCompletedorders/"
let VendorCancelledOrdersUrl = "vendorUsers/getallCancelledorders/"
let VendorUpdateProductStatusUrl = "vendorUsers/update_order_status"
let VendorProductsUpdateUrl = "vendorUsers/vendorproducts_update"
let UpdateOrderDetailsAPI = "vendorUsers/update_delivery_status"
let VendorProductLocalSearchAPI = "vendorUsers/getProductManagementLocalSearch"
let VendorOrderLocalSearchAPI = "vendorUsers/getOrderManagementLocalSearch"
let VendorProfileDetailsUrl = "endUsers/vendorUser_byaccountid"
let VendoeGlobalSearchUrl = "vendorUsers/getAllGlobalSearch"
let VendorMyAccountUrl = "endUsers/vendorUser_byaccountid/"
let OrdersSortUrl = "vendorUsers/getAllPendingOrdersBySorting/"

let getVendorTotalValuationUrl = "filters/getVendorTotalValuation"
let getVendorHistoricalWastageUrl = "filters/getVendorHistoricalWastage"
let getVendorHistoricalConsumptionUrl = "filters/getVendorHistoricalConsumption"
let getVendorDemandForcastUrl = "filters/getVendorDemandForcast"
let periodVendorTotalValuationUrl = "filters/getVendorTotalValuation/periodVsPeriod"
let periodVendorHistoricalWastageUrl = "filters/getHistoricalWastage/periodVsPeriod"
let periodVendorHistoricalConsumptionUrl = "filters/getVendorHistoricalConsumption/periodVsPeriod"
let periodVendorDemandForecastUrl = "filters/getVendorDemandForcast/periodVsPeriod"

let shoppingCartDeleteUrl = "endusers/shoppingcart_delete"
let savedCartDeleteUrl = "endusers/savedlist_delete"

let VendorMarketShareFromToUrl = "filters/getVendorMarketShare"
let VendorMarketSharePeriodComparisionUrl = "filters/getVendorMarketShare/periodVsPeriod"
let searchConsumerConnect="endUsers/getAllConsumerConnectListNew/"
let closedConsumerConnect="endUsers/getCompletedConsumerConnectList/"
let activeConsumerConnect="endUsers/getActiveConsumerConnectList/"

let BannnersUrl = "endusers/getallbannersByRadius/"
//    "endusers/getallbannersForHomeScreen"

let MyAccImgUrl = "http://15.206.193.122:4500/Misc/Images/consumerPhotos/"
let VendorMyAccImgUrl = "http://15.206.193.122:4500/Misc/Images/vendorPhotos/"

//Intro screens
let termsandConditions="consumer/get_terms_and_privacypolicy"
let mobileExistance="consumer/mobileExistanceverification/"
let mobileVerification="consumer/mobileverification"
let mobileOTPVerification="consumer/otpverificationwithmobilenumber"
let consumerUserDetailsAdd="consumer/userdetails_add"
let consumerVerifyEmail="consumer/verifyEmail/"
let consumerUserpersonalDetails="consumer/userpersonaldetails_add"
let consumerAccountDetails_add="consumer/accountdetails_add"
let consumerAccount_check="consumer/account_check/"
let consumerLogin="consumer/login"

//MARK:  New Currnet Inventory screens

let getCurrentInventoryUrl = "consumer/getallcurrentinventory_by_accountid/"
let getSortingCurrentInventoryUrl = "consumer/get_by_accountid/sorting/"
let consumerAccountAccess="consumer/check_account_access/"
let updateInventoryNewUrl="consumer/currentinventory_update"
let vendorMasterNewUrl="consumer/getallvendormastermanagement_by_accountid/"
let stockUnitNewUrl="consumer/getAllStockUnitByAccountId/"
let StorageLocationNewUrl="consumer/getAllStorageLocationByAccountId/"
let editCurrentInventoryNew="consumer/getcurrentinventory_byid/"

var selectedBillPriceScan=String()
var stockUnitDefault=String()
var storageLocationDefault=String()
var vendorNameDefault=String()
var localSearchInventory=String()
var localSearchShoppingCart=String()
var localSearchOpenOrders=String()
var localSearchOrderHistory=String()
var barcodeCurrentList=[String]()
var barcodeShoppingList=[String]()
var phoneNumber=String()
var userEmailID=String()
var userExists=String()
var userDetailsExists=Bool()
var accountExists=Bool()
var signUpTypeGlobal=String()
var signUpFirstName=String()
var signUpLastName=String()
var signUpDOB=String()
var signUpmobileStatus=String()
var signUpUserDetailArray=[MobileResultVo]()
var signUpUserAccountDetailArray=[AccountInfoResultVo]()


let kContactFormat = "^\\+(?:[0-9] ?){6,14}[0-9]$"

let kAppFont = "Poppins-Regular"
let kAppFontBold = "Poppins-Bold"
let kAppFontMedium = "Poppins-Medium"

//Text Colours

let BluePrimaryTextColour = "105fef"
let BlackPrimaryTExtColour = "3f4767"
var selectedMenu = String()

public enum Model : String {

//Simulator
case simulator     = "simulator/sandbox",

//iPod
iPod1              = "iPod 1",
iPod2              = "iPod 2",
iPod3              = "iPod 3",
iPod4              = "iPod 4",
iPod5              = "iPod 5",

//iPad
iPad2              = "iPad 2",
iPad3              = "iPad 3",
iPad4              = "iPad 4",
iPadAir            = "iPad Air ",
iPadAir2           = "iPad Air 2",
iPadAir3           = "iPad Air 3",
iPad5              = "iPad 5", //iPad 2017
iPad6              = "iPad 6", //iPad 2018
iPad7              = "iPad 7", //iPad 2019

//iPad Mini
iPadMini           = "iPad Mini",
iPadMini2          = "iPad Mini 2",
iPadMini3          = "iPad Mini 3",
iPadMini4          = "iPad Mini 4",
iPadMini5          = "iPad Mini 5",

//iPad Pro
iPadPro9_7         = "iPad Pro 9.7\"",
iPadPro10_5        = "iPad Pro 10.5\"",
iPadPro11          = "iPad Pro 11\"",
iPadPro12_9        = "iPad Pro 12.9\"",
iPadPro2_12_9      = "iPad Pro 2 12.9\"",
iPadPro3_12_9      = "iPad Pro 3 12.9\"",

//iPhone
iPhone4            = "iPhone 4",
iPhone4S           = "iPhone 4S",
iPhone5            = "iPhone 5",
iPhone5S           = "iPhone 5S",
iPhone5C           = "iPhone 5C",
iPhone6            = "iPhone 6",
iPhone6Plus        = "iPhone 6 Plus",
iPhone6S           = "iPhone 6S",
iPhone6SPlus       = "iPhone 6S Plus",
iPhoneSE           = "iPhone SE",
iPhone7            = "iPhone 7",
iPhone7Plus        = "iPhone 7 Plus",
iPhone8            = "iPhone 8",
iPhone8Plus        = "iPhone 8 Plus",
iPhoneX            = "iPhone X",
iPhoneXS           = "iPhone XS",
iPhoneXSMax        = "iPhone XS Max",
iPhoneXR           = "iPhone XR",
iPhone11           = "iPhone 11",
iPhone11Pro        = "iPhone 11 Pro",
iPhone11ProMax     = "iPhone 11 Pro Max",
iPhoneSE2          = "iPhone SE 2nd gen",

//Apple TV
AppleTV            = "Apple TV",
AppleTV_4K         = "Apple TV 4K",
unrecognized       = "?unrecognized?"
    
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {

var type: Model {
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            ptr in String.init(validatingUTF8: ptr)
        }
    }

    let modelMap : [String: Model] = [

        //Simulator
        "i386"      : .simulator,
        "x86_64"    : .simulator,

        //iPod
        "iPod1,1"   : .iPod1,
        "iPod2,1"   : .iPod2,
        "iPod3,1"   : .iPod3,
        "iPod4,1"   : .iPod4,
        "iPod5,1"   : .iPod5,

        //iPad
        "iPad2,1"   : .iPad2,
        "iPad2,2"   : .iPad2,
        "iPad2,3"   : .iPad2,
        "iPad2,4"   : .iPad2,
        "iPad3,1"   : .iPad3,
        "iPad3,2"   : .iPad3,
        "iPad3,3"   : .iPad3,
        "iPad3,4"   : .iPad4,
        "iPad3,5"   : .iPad4,
        "iPad3,6"   : .iPad4,
        "iPad6,11"  : .iPad5, //iPad 2017
        "iPad6,12"  : .iPad5,
        "iPad7,5"   : .iPad6, //iPad 2018
        "iPad7,6"   : .iPad6,
        "iPad7,11"  : .iPad7, //iPad 2019
        "iPad7,12"  : .iPad7,

        //iPad Mini
        "iPad2,5"   : .iPadMini,
        "iPad2,6"   : .iPadMini,
        "iPad2,7"   : .iPadMini,
        "iPad4,4"   : .iPadMini2,
        "iPad4,5"   : .iPadMini2,
        "iPad4,6"   : .iPadMini2,
        "iPad4,7"   : .iPadMini3,
        "iPad4,8"   : .iPadMini3,
        "iPad4,9"   : .iPadMini3,
        "iPad5,1"   : .iPadMini4,
        "iPad5,2"   : .iPadMini4,
        "iPad11,1"  : .iPadMini5,
        "iPad11,2"  : .iPadMini5,

        //iPad Pro
        "iPad6,3"   : .iPadPro9_7,
        "iPad6,4"   : .iPadPro9_7,
        "iPad7,3"   : .iPadPro10_5,
        "iPad7,4"   : .iPadPro10_5,
        "iPad6,7"   : .iPadPro12_9,
        "iPad6,8"   : .iPadPro12_9,
        "iPad7,1"   : .iPadPro2_12_9,
        "iPad7,2"   : .iPadPro2_12_9,
        "iPad8,1"   : .iPadPro11,
        "iPad8,2"   : .iPadPro11,
        "iPad8,3"   : .iPadPro11,
        "iPad8,4"   : .iPadPro11,
        "iPad8,5"   : .iPadPro3_12_9,
        "iPad8,6"   : .iPadPro3_12_9,
        "iPad8,7"   : .iPadPro3_12_9,
        "iPad8,8"   : .iPadPro3_12_9,

        //iPad Air
        "iPad4,1"   : .iPadAir,
        "iPad4,2"   : .iPadAir,
        "iPad4,3"   : .iPadAir,
        "iPad5,3"   : .iPadAir2,
        "iPad5,4"   : .iPadAir2,
        "iPad11,3"  : .iPadAir3,
        "iPad11,4"  : .iPadAir3,
        

        //iPhone
        "iPhone3,1" : .iPhone4,
        "iPhone3,2" : .iPhone4,
        "iPhone3,3" : .iPhone4,
        "iPhone4,1" : .iPhone4S,
        "iPhone5,1" : .iPhone5,
        "iPhone5,2" : .iPhone5,
        "iPhone5,3" : .iPhone5C,
        "iPhone5,4" : .iPhone5C,
        "iPhone6,1" : .iPhone5S,
        "iPhone6,2" : .iPhone5S,
        "iPhone7,1" : .iPhone6Plus,
        "iPhone7,2" : .iPhone6,
        "iPhone8,1" : .iPhone6S,
        "iPhone8,2" : .iPhone6SPlus,
        "iPhone8,4" : .iPhoneSE,
        "iPhone9,1" : .iPhone7,
        "iPhone9,3" : .iPhone7,
        "iPhone9,2" : .iPhone7Plus,
        "iPhone9,4" : .iPhone7Plus,
        "iPhone10,1" : .iPhone8,
        "iPhone10,4" : .iPhone8,
        "iPhone10,2" : .iPhone8Plus,
        "iPhone10,5" : .iPhone8Plus,
        "iPhone10,3" : .iPhoneX,
        "iPhone10,6" : .iPhoneX,
        "iPhone11,2" : .iPhoneXS,
        "iPhone11,4" : .iPhoneXSMax,
        "iPhone11,6" : .iPhoneXSMax,
        "iPhone11,8" : .iPhoneXR,
        "iPhone12,1" : .iPhone11,
        "iPhone12,3" : .iPhone11Pro,
        "iPhone12,5" : .iPhone11ProMax,
        "iPhone12,8" : .iPhoneSE2,

        //Apple TV
        "AppleTV5,3" : .AppleTV,
        "AppleTV6,2" : .AppleTV_4K
    ]

    if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
        if model == .simulator {
            if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                    return simModel
                }
            }
        }
        
        return model
    }
    return Model.unrecognized
  }
}

func decimalPlaces(stt:String) -> Int {
let decimals = stt.split(separator: ".")
    var decimal1=String.SubSequence()
    if decimals.count>1
    {
       decimal1=decimals[1]
    }
return decimal1 == "0" ? 0 : decimal1.count
}
