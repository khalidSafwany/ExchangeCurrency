//
//  File.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/6/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import Foundation

let url = "http://www.apilayer.net/api/live?access_key=13557f9e94479f74ae1b455adf1b62f4" // API of currencies rate
var countries = [Country]()                                                         // Array of counties with code falg etc..
var valuesList = [ValuesOfCurrenciesInUSD]()                                  //temp array contains the calues and codes only


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
    
    
   
    
}

func mirgeValuesToCountries(){              // merging the values to main array of countries
    
    for (currency,value) in valuesList[0].quotes{
        
        let index = currency.index(currency.endIndex,offsetBy: -3)
        let combareString = String(currency.suffix(from : index))
        for counter in 0 ..< countries.count {
            if(countries[counter].code.elementsEqual(combareString)){
               countries[counter].valueOfUSD = value
                
            }
        }
        
    }
    
}

