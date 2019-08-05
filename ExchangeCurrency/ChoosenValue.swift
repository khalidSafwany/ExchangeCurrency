//
//  ChosenCurrency.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/18/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import Foundation

class ChoosedValue : Codable {
    
    var valueCountry: Country?{
        didSet{
            self.valueOfUSD = valueCountry!.valueOfUSD!
        }
    }
    var valueOfUSD : Float
    
    
    init(myCountry: Country) {
        valueCountry = myCountry
        valueOfUSD = myCountry.valueOfUSD!
        
        
    }
    
    
    
    
    
    
}
