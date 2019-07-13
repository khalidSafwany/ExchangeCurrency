//
//  File.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/6/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import Foundation

let url = "http://www.apilayer.net/api/live?access_key=13557f9e94479f74ae1b455adf1b62f4" // API of currencies rate
var countries = [Country]()                                                    // Array of counties with code falg etc..
var valuesList = [ValuesOfCurrenciesInUSD]()                                  //temp array contains the calues and codes only
var keyEntries = [Character]()                                              //no of sections
var entries : Dictionary = [Character:[Country]]()
var fetched = false
var choosedCountiesList = [Country]()

struct ValuesOfCurrenciesInUSD : Decodable {
    var quotes : [String : Float]
}


struct Country : Decodable{
    
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


func calculateEntries(){                    // to calculate no of sections in the all countries table
    var tempChar : Character = "$"
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

    
}


func searchForIndexInCoosedCountries(searchCode : String) -> Int?{
    return choosedCountiesList.firstIndex(where : {(item) -> Bool in
        item.code.elementsEqual(searchCode)
    })
}


// to Set the default Coutries ---------- NOT FINISHED YET
func defaultSetting(){
    
    var myDefaultCountrty = searchForCountryByCode(searchCode: "USD")
    choosedCountiesList.append(myDefaultCountrty)
    myDefaultCountrty = searchForCountryByCode(searchCode: "EUR")
    choosedCountiesList.append(myDefaultCountrty)
    
}

func searchForCountryByCode(searchCode : String) -> Country{
    let notFound = Country(givenCode: "notFound")
    for item in countries{
        if item.code.elementsEqual(searchCode){
            return item
        }
    }
    
    return notFound
}


