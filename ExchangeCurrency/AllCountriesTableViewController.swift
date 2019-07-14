//
//  MyCountriesTableViewController.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/8/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import UIKit

class AllCountriesTableViewController: UITableViewController {
    
    

    
    @IBAction func SaveCountriesButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ReturnToMainView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.allowsMultipleSelection = true
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return entries.keys.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return String(keyEntries[section])
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries[keyEntries[section]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "AllCountriesTableCell", for: indexPath) as? AllCountriesTableViewCell
        cell?.CountryImage.image = UIImage(named: entries[keyEntries[indexPath.section]]![indexPath.row].flag)
        
        cell?.CountryNameAndSymbol.text = "\(entries[keyEntries[indexPath.section]]![indexPath.row].code) - \(entries[keyEntries[indexPath.section]]![indexPath.row].name)"
        
        if(entries[keyEntries[indexPath.section]]![indexPath.row].isSelected!){
         
            cell?.accessoryType = .checkmark
        }
        else{
            
            cell?.accessoryType = .none
            
        }
        
      
        return cell!
    }
    
    
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        if (!entries[keyEntries[indexPath.section]]![indexPath.row].isSelected!){
            if(choosedCountiesList.count < MAXIMUM_COUNTRIES){
            
            entries[keyEntries[indexPath.section]]![indexPath.row].isSelected = true
           if let cell = tableView.cellForRow(at: indexPath) as? AllCountriesTableViewCell {
            
              cell.accessoryType = .checkmark
              choosedCountiesList.append(entries[keyEntries[indexPath.section]]![indexPath.row])
            
            
                }
          
            }
            
            else{
                showErrorMessage(errorNO: 10)
                
            }
        }
        else{
            if(choosedCountiesList.count > MINIMUM_COUNTRIES){
            entries[keyEntries[indexPath.section]]![indexPath.row].isSelected = false
            if let cell = tableView.cellForRow(at: indexPath) as? AllCountriesTableViewCell {
                
               cell.accessoryType = .none
                choosedCountiesList.remove(at: searchForIndexInCoosedCountries(searchCode: entries[keyEntries[indexPath.section]]![indexPath.row].code)!)
                
                
            }
            }
            else{
                showErrorMessage(errorNO: 2)
            }
        }
    
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    private func showErrorMessage(errorNO : Int){
        var alert = UIAlertController(title: "Sorry!", message: "we are glad yoy are using our APP!", preferredStyle:.alert )
        switch errorNO{
        case 2:
            
            alert = UIAlertController(title: "Sorry!", message: MinimumAlert, preferredStyle:.alert )
            
            
        case 10:
            alert = UIAlertController(title: "Sorry", message: MaximumAlert, preferredStyle:.alert )
           
        default: break
            
        }
        alert.addAction(UIAlertAction(title: "OK",style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
