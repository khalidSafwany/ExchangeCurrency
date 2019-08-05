//
//  ChooseCurrencyTableViewCell.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/20/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import UIKit

class ChooseCurrencyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var CountryImage: UIImageView!
    
    @IBOutlet weak var currencyCode: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if((self.currencyCode.text?.elementsEqual(choosedCurrency.valueCountry!.code))!)
        {self.accessoryType = .checkmark}
        else
        {self.accessoryType = .none}

        // Configure the view for the selected state
        
        return
    }

}
