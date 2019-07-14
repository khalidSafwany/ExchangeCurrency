//
//  ViewController.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/6/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import UIKit
import Alamofire

class mainViewController: UIViewController {        // main controller class of main view
    
    
    @IBAction func EditButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowAllCountries", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(!fetched){
        readCountriesFileData()
            callAlamo(url:url)
            
              }
    }
    
    
    func callAlamo(url : String){       // function to call th API of currencies rate
        
        AF.request(url).responseJSON(completionHandler:{
            response in
            self.parseData(JSONData: response.data!)
            
        }  )
        
    }
    
    
    
    func parseData(JSONData : Data){        // parsing the JSON date to the values of currencies struct
        do{
            valuesList = [try JSONDecoder().decode(ValuesOfCurrenciesInUSD.self, from: JSONData)]
    }catch {
    
    print(error)
        }
        
        mirgeValuesToCountries()
        calculateEntries(){ () -> () in
            
            defaultSetting()
        
        }
        
        fetched = true
       
        
    }
    
    func readCountriesFileData(){           // read file of counties code and etc....
        
        if let path = Bundle.main.path(forResource: "currnciesList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                countries = try JSONDecoder().decode([Country].self, from: data)
                
            } catch {
                
                print(error)
            }
        }
    }
    
}
