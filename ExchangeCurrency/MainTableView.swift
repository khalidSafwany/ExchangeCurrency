//
//  ViewController.swift
//  ExchangeCurrency
//
//  Created by Khalid hassan on 7/6/19.
//  Copyright © 2019 Khalid hassan. All rights reserved.
//

import UIKit
import Alamofire

class mainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    private var keyBoard = false
    
    private struct MyCell {
        static var cellSnapShot: UIView? = nil
    }
    
    private struct Path {
        static var initialIndexPath: IndexPath? = nil
    }
    
    // main controller class of main view
    
    @IBOutlet weak var ChangeValueCountryButton: UIButton!{
        didSet{
            if (choosedCurrency != nil){
                ChangeValueCountryButton.setBackgroundImage(UIImage(named: choosedCurrency.valueCountry!.flag), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var ValueInputTextField: UITextField!{
        didSet{
            ValueInputTextField.delegate = self
        }
    }
    
    
    
    @IBOutlet weak var MainTableView: UITableView!{
        didSet{
            MainTableView.delegate = self
            MainTableView.dataSource = self
        }
    }
    
    
    
    @IBAction func viewCurrencyChoose(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChooseCurrencyTableViewController") as! ChooseCurrencyTableViewController
        vc.callback = {
            if (choosedCurrency != nil){
                self.ChangeValueCountryButton.setBackgroundImage(UIImage(named: choosedCurrency.valueCountry!.flag), for: .normal)
            }
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func EditButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AllCountriesTableViewController") as! AllCountriesTableViewController
        vc.callback = {
            self.MainTableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(!Connectivity.isConnectedToInternet){
            print("No Connection")
            checkConnectionToRun()
            
            
        }
//        self.MainTableView.reloadData()
//        if (choosedCurrency != nil){
//            ChangeValueCountryButton.setBackgroundImage(UIImage(named: choosedCurrency.valueCountry!.flag), for: .normal)
//        }
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        isActive = defaults.bool(forKey: "isActive")
        
        if isActive{
            
            ListString = UserDefaults.standard.array(forKey:"UserCurrenciesNames" ) as! [String]
            MainCurrencyName = UserDefaults.standard.string(forKey: "UserMainCurrency")!
        }
        
        if(Connectivity.isConnectedToInternet){
            startApp()
        }
        else{
            checkConnectionToRun()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        
        
        let longPress :UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LongPressGestureRecognizer(gestureRecognizer:)))
        self.MainTableView.addGestureRecognizer(longPress)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem (barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([doneButton], animated: false)
        ValueInputTextField.inputAccessoryView = toolBar
        
        
        
    }
    
    @objc func keyboardWillAppear() {
        keyBoard = true
    }
    
    @objc func doneClicked(){
        self.ValueInputTextField.endEditing(true)
        CurrencyAmount = (ValueInputTextField.text! as NSString).floatValue
        self.MainTableView.reloadData()
        keyBoard = false
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        ValueInputTextField.placeholder = String(CurrencyAmount)
    }
    
    @objc func LongPressGestureRecognizer(gestureRecognizer: UIGestureRecognizer){
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: self.MainTableView)
        var indexPath = self.MainTableView.indexPathForRow(at: locationInView)
        
        switch state{
        case.began:
            if (indexPath != nil){
                Path.initialIndexPath = indexPath
                let cell = self.MainTableView.cellForRow(at: indexPath!) as! MainTableViewCell
                MyCell.cellSnapShot = snapshopOfCell(inputView: cell)
                var center = cell.center
                MyCell.cellSnapShot?.center = center
                MyCell.cellSnapShot?.alpha = 0.0
                self.MainTableView.addSubview(MyCell.cellSnapShot!)
                
                UIView.animate(withDuration: 0.25, animations: {
                    center.y = locationInView.y
                    MyCell.cellSnapShot?.center = center
                    MyCell.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    MyCell.cellSnapShot?.alpha = 0.98
                    cell.alpha = 0.0
                    
                },completion: { (finished) -> Void in
                    if(finished){
                        cell.isHidden = true
                    }
                    
                })
                
            }
            
        case.changed:
            var center = MyCell.cellSnapShot?.center
            center?.y = locationInView.y
            MyCell.cellSnapShot?.center = center!
            if((indexPath != nil) && (indexPath != Path.initialIndexPath)){
                choosedCountiesList.swapAt(indexPath!.row, Path.initialIndexPath!.row)
                ListString.swapAt(indexPath!.row, Path.initialIndexPath!.row)
                self.MainTableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
                
            }
            
            
        default:
            let cell = self.MainTableView.cellForRow(at: Path.initialIndexPath!) as! MainTableViewCell
            cell.isHidden = false
            cell.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
                MyCell.cellSnapShot?.center = cell.center
                MyCell.cellSnapShot?.transform = .identity
                MyCell.cellSnapShot?.alpha = 0.0
                cell.alpha = 1.0
            },completion: {(finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    MyCell.cellSnapShot?.removeFromSuperview()
                    MyCell.cellSnapShot = nil
                }
            })
        }
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    
    func callAlamo(url : String){       // function to call th API of currencies rate
        
        AF.request(url).responseJSON(completionHandler:{
            response in
            switch (response.result){
            case .success(let _):
                if let data = response.data {
                    self.parseData(JSONData: data)
                }
            case .failure(let error):
                print(error)
                
            }
            
            
            
            
        })
        
    }
    
    
    
    func parseData(JSONData : Data){   // parsing the JSON date to the values of currencies struct
        do{
            valuesList = [try JSONDecoder().decode(ValuesOfCurrenciesInUSD.self, from: JSONData)]
        }catch {
            
            print(error)
        }
        
        mirgeValuesToCountries()
        calculateEntries(){ () -> () in
            
            contrustMyview()
            
            
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
    
    func contrustMyview(){  // upload data to tableView  and button after fetching and run default setting if first timeto                       //run the app
        if(!isActive){
            defaultSetting()
            
        }
        else{
            if let cNames = defaults.array(forKey:"UserCurrenciesNames" ) as? [String] , let UserMainCurrency =   defaults.string(forKey: "UserMainCurrency"){
                ListString = cNames
                MainCurrencyName = UserMainCurrency
                UserSetting()
            }else{
                print("Couldn't fetch UserCurrenciesNames or UserMainCurrency")
            }
        }
        self.updateData()
        if (choosedCurrency != nil){
            ChangeValueCountryButton.setBackgroundImage(UIImage(named: choosedCurrency.valueCountry!.flag), for: .normal)
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choosedCountiesList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(keyBoard){
            keyBoard = false
            self.ValueInputTextField.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mainCell = MainTableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as? MainTableViewCell
        
        mainCell?.countryImage.image = UIImage(named: choosedCountiesList[indexPath.row].flag)
        let (rate, reverseRate) = calculateRateBetweenCurrencies(CurrencyOneToUSD: (choosedCurrency.valueCountry?.valueOfUSD!)! , CurrencyTwotoUSD: choosedCountiesList[indexPath.row].valueOfUSD!)
        mainCell?.oneCurrencyValueLabel.text = String("1.0 \(choosedCountiesList[indexPath.row].code) = \(rate) \((choosedCurrency.valueCountry?.code)!)")
        
        
        mainCell?.totalValueLabel.text = String(CurrencyAmount * reverseRate)
        
        return mainCell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Exchange Rates"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            choosedCountiesList.remove(at: indexPath.row)
            ListString.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView{
            headerView.contentView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
            headerView.textLabel?.textColor = .white
        }
    }
    
    private func  updateData(){
        
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform expensive task
            
            DispatchQueue.main.async {
                
                self.MainTableView.reloadData()
            }
        }
        
    }
    
    private func showNoConnectionMessage(){
        let alert = UIAlertController(title: "Error!", message: "Check Your Connection", preferredStyle:.alert )
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler :{ action in
            self.checkConnectionToRun()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func startApp(){
        if (Connectivity.isConnectedToInternet){
            if(!fetched){
                readCountriesFileData()
                callAlamo(url:url)
                
                
            }
        }
    }
    
    private func checkConnectionToRun(){
        sleep(UInt32(1.2))
        if(!Connectivity.isConnectedToInternet){
            showNoConnectionMessage()
        }
            
        else{
            startApp()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ValueInputTextField.resignFirstResponder()
        keyBoard = false
    }
    
}

