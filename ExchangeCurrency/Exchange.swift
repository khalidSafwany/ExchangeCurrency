//
//  File.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/6/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import Foundation
let MinimumAlert = "Sorry, You have reached the minmum number of countries (2). You can't remove more"
let MaximumAlert = "Sorry, You have reached the maximum number of countries (10). You can't add more"

let defaults = UserDefaults.standard
let MAXIMUM_COUNTRIES = 10
let MINIMUM_COUNTRIES = 2
let url = "http://www.apilayer.net/api/live?access_key=13557f9e94479f74ae1b455adf1b62f4" // API of currencies rate
var countries = [Country]()                                                    // Array of counties with code falg etc..
var valuesList = [ValuesOfCurrenciesInUSD]()                                  //temp array contains the calues and codes only
var keyEntries = [Character]()                                              //no of sections
var entries : Dictionary = [Character:[Country]]()
var fetched = false
var choosedCountiesList = [Country]()
var choosedCurrency : ChoosedValue!
var CurrencyAmount : Float = 0.0
var isActive = Bool()
var ListString = [String]()
var MainCurrencyName = String()

struct ValuesOfCurrenciesInUSD : Decodable {
    var quotes : [String : Float]
}


struct Country : Decodable, Encodable{
    
    var symbol : String
    var name : String
    var symbol_native : String
    var code : String
    var name_plural : String
    var flag : String
    var valueOfUSD : Float?
    var isSelected : Bool? = false
    
}

extension Country{
    init(givenCode:String){
        code = givenCode
        symbol = ""
        name = ""
        symbol_native = ""
        name_plural = ""
        flag  = ""
        valueOfUSD = 0.0
        isSelected = false
    }
}

func mirgeValuesToCountries(){              // merging the values to main array of countries
    
    for (currency,value) in valuesList[0].quotes{
        
        let index = currency.index(currency.endIndex,offsetBy: -3)
        let combareString = String(currency.suffix(from : index))
        for counter in 0 ..< countries.count {
            if(countries[counter].code.elementsEqual(combareString)){
               countries[counter].valueOfUSD = value
               countries[counter].isSelected = false
                
            }
        }
    }
}


func calculateEntries(handleComplete : (() -> ()) ){                    // to calculate no of sections in the all countries table
    var tempChar : Character = "~"
    var selectedCountriesInEntry = [Country]()
    for item in countries{
        
        if (Array(item.code)[0] != tempChar){
            
            
            if (!selectedCountriesInEntry.isEmpty){
                
                entries[tempChar] = selectedCountriesInEntry
                selectedCountriesInEntry.removeAll()
            }
            tempChar = Array(item.code)[0]
            keyEntries.append(tempChar)
           
            selectedCountriesInEntry.append(item)
           
        }
        else
        {
        
        selectedCountriesInEntry.append(item)
            
        }
    }
    keyEntries.append(tempChar)
    entries[tempChar] = selectedCountriesInEntry

    handleComplete()
}


func searchForIndexInCoosedCountries(searchCode : String) -> Int?{
    return choosedCountiesList.firstIndex(where : {(item) -> Bool in
        item.code.elementsEqual(searchCode)
    })
}


// to Set the default Coutries ---------- NOT FINISHED YET
func defaultSetting(){
    if (choosedCountiesList.count == 0 && ListString.count == 0){
    var myDefaultCountrty = searchForCountryByCode(searchCode: "USD")
    choosedCountiesList.append(myDefaultCountrty)
        ListString.append("USD")
    myDefaultCountrty = searchForCountryByCode(searchCode: "EUR")
    choosedCountiesList.append(myDefaultCountrty)
    choosedCurrency = ChoosedValue(myCountry: searchForCountryByCode(searchCode: "USD"))
        ListString.append("EUR")
        MainCurrencyName = "USD"
    isActive = true
    defaults.set(isActive, forKey: "isActive")
    }
    else
    {
        return
    }
}

func UserSetting(){
    
    for name in ListString{
        choosedCountiesList.append(searchForCountryByCode(searchCode: name))
    }
    let tempCountry = searchForCountryByCode(searchCode: MainCurrencyName)
    
    choosedCurrency = ChoosedValue(myCountry: tempCountry)
}


func searchForCountryByCode(searchCode : String) -> Country{
    let notFound = Country(givenCode: "notFound")
    let firstChar = Array(searchCode)[0]
    
        for i in 0 ..< (entries[firstChar]!.count){
            if(entries[firstChar]![i].code.elementsEqual(searchCode)){
                entries[firstChar]![i].isSelected = true
                return entries[firstChar]![i]
            
        }      
    }
    return notFound
}

func searchForIndexpathInEntries(searchCode : String) -> (Int,Character)!{
    
    let firstChar = Array(searchCode)[0]
    
    for i in 0 ..< (entries[firstChar]!.count){
        if(entries[firstChar]![i].code.elementsEqual(searchCode)){
            return (i,firstChar)
        }
    }
    
    return nil
}

func searchForIndexInStringsList(SearchCode : String ) -> Int{
    return ListString.firstIndex(where : {(item) -> Bool in
        item.elementsEqual(SearchCode)
    })!
}

func calculateRateBetweenCurrencies(CurrencyOneToUSD: Float, CurrencyTwotoUSD : Float) -> (Float, Float){
    let rate = CurrencyOneToUSD / CurrencyTwotoUSD
    let reverseRate = CurrencyTwotoUSD / CurrencyOneToUSD
    
    return (rate, reverseRate)
}



