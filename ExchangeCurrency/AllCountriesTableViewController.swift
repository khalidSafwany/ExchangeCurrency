//
//  MyCountriesTableViewController.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/8/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import UIKit

class AllCountriesTableViewController: UITableViewController {
    var callback : (()->())?
    

    
    @IBAction func SaveCountriesButton(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "ReturnToMainView", sender: self)
        self.callback?()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
    
    }
    
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return entries.keys.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 0){
             return "My Countries"
        }
       
            
        return String(keyEntries[section - 1])
            
        

        }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0){
            return choosedCountiesList.count
        }
        print("\(section) : \(entries[keyEntries[section - 1 ]]!.count)")
        
        return entries[keyEntries[section - 1 ]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "AllCountriesTableCell", for: indexPath) as? AllCountriesTableViewCell
        if(indexPath.section == 0){
            
            cell?.CountryImage.image = UIImage(named: choosedCountiesList[indexPath.row].flag)
            
            cell?.CountryNameAndSymbol.text = "\(choosedCountiesList[indexPath.row].code) - \(choosedCountiesList[indexPath.row].name)"
            
            if(choosedCountiesList[indexPath.row].isSelected!){
                   cell?.accessoryType = .checkmark
            }
            else{
                   cell?.accessoryType = .none
            }
            
        }
        else{
        cell?.CountryImage.image = UIImage(named: entries[keyEntries[indexPath.section - 1]]![indexPath.row].flag)
        
        cell?.CountryNameAndSymbol.text = "\(entries[keyEntries[indexPath.section - 1]]![indexPath.row].code) - \(entries[keyEntries[indexPath.section - 1]]![indexPath.row].name)"
            
        
        if(entries[keyEntries[indexPath.section - 1 ]]![indexPath.row].isSelected!){
         
            cell?.accessoryType = .checkmark
        }
        else{
            
            cell?.accessoryType = .none
            
        }
        }
      
        return cell!
    }
    
    
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        if(indexPath.section == 0){
            if(choosedCountiesList.count > MINIMUM_COUNTRIES){
            let (rowIndex,sectionIndex) = searchForIndexpathInEntries(searchCode: choosedCountiesList[indexPath.row].code)
            entries[sectionIndex]![rowIndex].isSelected = false
             var (index, char) = searchForIndexpathInEntries(searchCode: choosedCountiesList[indexPath.row].code)
            let indexPathInEntry = IndexPath(row: index, section: Int(char.asciiValue! - 65 + 1))
            choosedCountiesList.remove(at: indexPath.row )
            ListString.remove(at: indexPath.row)
            tableView.reloadData()
            //tableView.reloadRows(at: [indexPathInEntry], with: .left)
            self.updateSection(direction: "L")
            }
            else{
                showErrorMessage(errorNO: 2)
            }
            
            
        }
        else{
        if (!entries[keyEntries[indexPath.section - 1]]![indexPath.row].isSelected!){
            if(choosedCountiesList.count < MAXIMUM_COUNTRIES){
            
            entries[keyEntries[indexPath.section - 1]]![indexPath.row].isSelected = true
           if let cell = tableView.cellForRow(at: indexPath) as? AllCountriesTableViewCell {
            
              cell.accessoryType = .checkmark
              choosedCountiesList.append(entries[keyEntries[indexPath.section - 1]]![indexPath.row])
            ListString.append(entries[keyEntries[indexPath.section - 1]]![indexPath.row].code)
            
            self.updateSection(direction: "R")
                }
          
            }
            
            else{
                showErrorMessage(errorNO: 10)
                
            }
        }
        else{
            if(choosedCountiesList.count > MINIMUM_COUNTRIES){
            entries[keyEntries[indexPath.section - 1]]![indexPath.row].isSelected = false
            if let cell = tableView.cellForRow(at: indexPath) as? AllCountriesTableViewCell {
                
               cell.accessoryType = .none
                choosedCountiesList.remove(at: searchForIndexInCoosedCountries(searchCode: entries[keyEntries[indexPath.section - 1]]![indexPath.row].code)!)
                ListString.remove(at: searchForIndexInStringsList(SearchCode: entries[keyEntries[indexPath.section - 1]]![indexPath.row].code))
                updateSection(direction: "L")
            }
            }
            else{
                showErrorMessage(errorNO: 2)
            }
        }
    
    }
        
        func tableView(_ tableView : UITableView, willDisplayHeaderView: UIView, forSection: Int){
            if let headerView = view as? UITableViewHeaderFooterView{
                headerView.contentView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
                headerView.textLabel?.textColor = .white
            }
        }
       
        //reloadSections(IndexSet(integersIn:Range(0...0)), with: UITableView.RowAnimation.top)
        //reloadSections(IndexSet(0,0), with: UITableView.RowAnimation.right)
        

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
    
    
    
    private func updateSection(direction : Character){
        
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform expensive task
            
            DispatchQueue.main.async {
                switch direction{
                case "L":
                    
                    self.tableView.reloadSections([0], with: UITableView.RowAnimation.left)
                    
                default:
                    
                    self.tableView.reloadSections([0], with: UITableView.RowAnimation.right)
                }
                
            }
        }
        
    }
    
    
    private func updateData(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
