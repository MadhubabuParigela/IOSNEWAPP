//
//  CountryUtility.swift
//  Lekhha
//
//  Created by USM on 28/02/22.
//

import Foundation
//
//  CountryUtility.swift
//
import Foundation

struct CountryUtility {

    static private func loadCountryListISO() -> Dictionary<String, String>? {

        let pListFileURL = Bundle.main.url(forResource: "iso3166_2_to_iso3166_3", withExtension: "plist", subdirectory: "")
        if let pListPath = pListFileURL?.path,
            let pListData = FileManager.default.contents(atPath: pListPath) {
            do {
                let pListObject = try PropertyListSerialization.propertyList(from: pListData, options:PropertyListSerialization.ReadOptions(), format:nil)

                guard let pListDict = pListObject as? Dictionary<String, String> else {
                    return nil
                }

                return pListDict
            } catch {
                print("Error reading regions plist file: \(error)")
                return nil
            }
        }
        return nil
    }
    /// Convertion ISO 3166-1-Alpha2 to Alpha3
    /// Country code of 2 letters to 3 letters code
    /// E.g: PT to PRT
    static func getCountryCodeAlpha3(countryCodeAlpha2: String) -> String? {

        guard let countryList = CountryUtility.loadCountryListISO() else {
            return nil
        }

        if let countryCodeAlpha3 = countryList[countryCodeAlpha2]{
            return countryCodeAlpha3
        }
        return nil
    }
    static func getLocalCountryCode() -> String?{

        guard let countryCode = NSLocale.current.regionCode else { return nil }
        return countryCode
    }
    /// This function will get full country name based on the phone Locale
    /// E.g. Portugal
    static func getLocalCountry() -> String?{

        let countryLocale = NSLocale.current
        guard let countryCode = countryLocale.regionCode else { return nil }
        let country = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
        return country
    }
}
