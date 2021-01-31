//
//  ViewController.swift
//  Prework
//
//  Created by Andy Celdo on 1/10/21.
//

import UIKit

class TipController: UIViewController {

    //MARK: - Class Variables
    
    //Utilizing delegates, didn't work
//    var delegate: settingsControl?
    
    //Utilizing UserDefaults
    let defaults = UserDefaults.standard
    
    var value1 = 0.15
    var value2 = 0.18
    var value3 = 0.20
    
    //MARK: - UIElements
    
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currencySign: UILabel!
    @IBOutlet weak var tipRate: UILabel!
    @IBOutlet weak var currencySignTip: UILabel!
  
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!
    
    //view references
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var splitBillView: UIView!
    
    //split bill label references
    @IBOutlet weak var splitBillLabel1: UILabel!
    @IBOutlet weak var splitBillLabel2: UILabel!
    @IBOutlet weak var splitBillLabel3: UILabel!
    @IBOutlet weak var splitBillLabel4: UILabel!
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        //Sets the title in the Navigation Bar
        self.title = "Tipulator"
        
        //will check the UserDate value that stores the time at which the ap was closed and compare it to the current time/when the app was reopened
        
        let time1 = defaults.value(forKey: "lastDate") //last time app was open
        let time2 = Date() //current time
        
        let timeDiff = Calendar.current.dateComponents([.hour, .minute], from: time1 as! Date, to: time2)
        
        if let hours = timeDiff.hour { //unwrap hours portion first
            if(hours == 0) { //passing condition
                if let minutes = timeDiff.minute {
                    if(minutes >= 10) {
                        defaults.removeObject(forKey: "bill")
                        print("After deleting UD bill: ", getKeyValueDouble(key: "bill"))
                    }
                    else {
                        print("timmeInterval is less than 10 minutes")
                    }
                }
                else {
                    print("Unwrapping timeDiff.minute failed")
                }
            }
            else {
                defaults.removeObject(forKey: "bill")
                print("After deleting UD bill: ", getKeyValueDouble(key: "bill"))
            }
        }
        else{
            print("Unwrapping timeDiff.hour failed")
        }
        
        //Utilizing currency locale info
        //Initial locale currency info. Will try to have an option that allows the user to change the currency
        let locale = Locale.current
        let symbol = locale.currencySymbol!
        let code = locale.currencyCode!
        
        //Setting the corresponding labels to the approprite locale information
        currencySign.text = symbol
        currencySignTip.text = symbol
        
        //for loading in the last entered total
        billAmountTextField.text = String(format: "%.2f", getKeyValueDouble(key: "bill"))
        
        //will check UserDefaults for the dark mode feature
        if(UserDefaults.standard.bool(forKey: "modeSwitch") == true) {
            UIApplication.shared.windows.forEach {
                window in window.overrideUserInterfaceStyle = .dark
            }
            print("tipcontroller ud modeswitch true")
        }
        else {
            UIApplication.shared.windows.forEach {
                window in window.overrideUserInterfaceStyle = .light
            }
            print("tipcontroller ud modeswitch false")
        }
        
        //Make the keypad always visible and all text selected or easy input
        self.billAmountTextField.becomeFirstResponder()
        self.billAmountTextField.selectAll(nil)
        
    }
    
    //used to retrieve the last known input value as a user default
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tip viewWillAppear(animated)")
        
        billAmountTextField.text = String(getKeyValueDouble(key: "bill"))
        if(UserDefaults.standard.bool(forKey: "modeSwitch") == true) {
            billAmountTextField.keyboardAppearance = .dark
        }
        else {
            billAmountTextField.keyboardAppearance = .light
        }
        
        updateSegmentValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("tip viewDidAppear")
    }
    
    //used to store the last known input value as a user default
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("tip viewWillDisappear")
        
        defaults.set(billAmountTextField.text, forKey: "bill")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("tip viewDidDisappear")
    }
    
    //MARK: - IBActions
    
    @IBAction func onTap(_ sender: Any) {
        
        //maybe add a ripple effect here
        
    }
    
    //same as calculateTip function, but handles the UISlider logic
    @IBAction func calcTipSlider(_ sender: UISlider) {
        
        //Get initial bill amount and calculate tips
        let bill = Double(billAmountTextField.text!) ?? 0
        let tipPercentages = Double(sender.value)
        
        let tip = bill * (tipPercentages)
        let total = bill + tip
        
        //Update the tip and total labels
        tipPercentageLabel.text = String(format: "%.2f", tip)
        totalLabel.text = String(format: "%.2f", total)
        tipRate.text = String(format: "%.1f", tipPercentages * 100)
        
        //update the split bill values
        splitBillLabel1.text = String(format: "%.2f", tip / 2)
        splitBillLabel2.text = String(format: "%.2f", tip / 3)
        splitBillLabel3.text = String(format: "%.2f", tip / 4)
        splitBillLabel4.text = String(format: "%.2f", tip / 5)
        
        //animation for the results of user input
        UIView.transition(with: outputView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.outputView.isHidden = false
        })
    
        //animation for the tip values split amongst up to a party of five
        UIView.transition(with: splitBillView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.splitBillView.isHidden = false
        })
        
        //save the last input
        if let lastInput = Double(billAmountTextField.text!) {
            defaults.set(String(lastInput), forKey: "bill")
        }
        
    }
    
    //function responsible for calculating tip value of the tip and the tip + bill (segement control)
    @IBAction func calculateTip(_ sender: Any) {
        
        if(checkKey(key: "preset1")){
            value1 = getKeyValueDouble(key: "preset1")
        }
        else {
            value1 = 0.15
            print("preset1 dne")
        }
        if(checkKey(key: "preset2")){
            value2 = getKeyValueDouble(key: "preset2")
        }
        else {
            value2 = 0.18
            print("preset2 dne")
        }
        if(checkKey(key: "preset3")){
            value3 = self.getKeyValueDouble(key: "preset3")
        }
        else {
            value3 = 0.20
            print("preset3 dne")
        }
        
        //Get initial bill amount and calculate tips
        let bill = Double(billAmountTextField.text!) ?? 0
        let tipPercentages = [value1, value2, value3]
        
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
    
        //update UISlider as well
        tipSlider.value = Float(tipPercentages[tipControl.selectedSegmentIndex])

        //Update the tip and total labels
        tipPercentageLabel.text = String(format: "%.2f", tip)
        totalLabel.text = String(format: "%.2f", total)
        tipRate.text = String(format: "%.1f", tipPercentages[tipControl.selectedSegmentIndex] * 100)
        
        //update the split bill values
        splitBillLabel1.text = String(format: "%.2f", total / 2)
        splitBillLabel2.text = String(format: "%.2f", total / 3)
        splitBillLabel3.text = String(format: "%.2f", total / 4)
        splitBillLabel4.text = String(format: "%.2f", total / 5)
        
        //animation for the results of user input
        UIView.transition(with: outputView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.outputView.isHidden = false
        })
    
        //animation for the tip values split amongst up to a party of five
        UIView.transition(with: splitBillView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.splitBillView.isHidden = false
        })
        
        //save the last input
        if let lastInput = Double(billAmountTextField.text!) {
            defaults.set(String(lastInput), forKey: "bill")
        }
        
    }
    
    //MARK: - Regular Functions
    
    //responsible for updating the preset values in the UISegementControl input in the settings
    func updateSegmentValues() {
        
        if(checkKey(key: "preset1")){
            tipControl.setTitle(String(Double(getKeyValueDouble(key: "preset1")) * 100) + "%", forSegmentAt: 0)
        }
        else {
            print("tipControl 1 default value")
            tipControl.setTitle(String(15) + "%", forSegmentAt: 0)
        }
        if(checkKey(key: "preset2")){
            tipControl.setTitle(String(Double(getKeyValueDouble(key: "preset2")) * 100) + "%", forSegmentAt: 1)
        }
        else {
            print("tipControl 2 default value")
            tipControl.setTitle(String(18) + "%", forSegmentAt: 1)
        }
        if(checkKey(key: "preset3")){
            tipControl.setTitle(String(Double(getKeyValueDouble(key: "preset3")) * 100) + "%", forSegmentAt: 2)
        }
        else {
            print("tipControl 3 default value")
            tipControl.setTitle(String(20) + "%", forSegmentAt: 2)
        }
        
    }
    
}

//MARK: - Extensions

//extension that will contain functions that may be needed by all the view controllers in the application (currently only 2)
extension UIViewController {
    
    //checks for valid UserDefault key and returns boolean on whether it exists or not
    func isUserDefaultKeyValid(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //returns key value as a double (for presets values and the last time the app was running
    func getKeyValueDouble(key: String) -> Double {
    
        let returnVal = UserDefaults.standard.double(forKey: key)
        return returnVal
    }
    
    //returns key value as a boolean (used for the dark mode))
    //same as above, only difference is return type
    func getKeyValueBool(key: String) -> Bool {
    
        let returnVal = UserDefaults.standard.bool(forKey: key)
        return returnVal
    }
    
    func getKeyValueStr(key: String) -> String {
    
        let returnVal = UserDefaults.standard.string(forKey: key)!
        return returnVal
    }
    
    //uses isUserDefaultKeyValid method to verify whether the UserDefault key exists
    func checkKey(key: String) -> Bool {
    
        let value = isUserDefaultKeyValid(key: key)
        print("value: ", value)
        if(value == true) {
            print("returning true")
            return true
        }
        else {
            print("returning false")
            return false
        }
        
    }
}
