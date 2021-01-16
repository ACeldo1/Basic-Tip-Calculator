//
//  ViewController.swift
//  Prework
//
//  Created by Andy Celdo on 1/10/21.
//

import UIKit

class TipController: UIViewController {
    
    //Utilizing delegates
    var delegate: settingsControl?
    
    //Utilizing UserDefaults
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    override func viewDidLoad() {
        
        //couldn't get the delegation system to work
        /*if((self.delegate?.isUserDefaultKeyValid(key: "mode")) != nil) {
            if(self.delegate?.getUserDefaultKey(key: "mode") == "Y") {
                super.view.overrideUserInterfaceStyle = .dark
                super.overrideUserInterfaceStyle = .dark
            }
            else if(self.delegate?.getUserDefaultKey(key: "mode") == "N"){
                super.view.overrideUserInterfaceStyle = .light
                super.view.overrideUserInterfaceStyle = .light
            }
            else {
                print("viewDidLoad else statement in Tip Controller")
            }
        
        }*/
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Sets the title in the Navigation Bar
        self.title = "Tip Calculator"
        updateSegmentValues()
    }
    
    @IBAction func onTap(_ sender: Any) {
        updateSegmentValues()
    }
    
    //kept this here just in case, attempted to use delegates (use this exact same function from SettingsViewController), but I couldn't get it to work
    func isUserDefaultKeyValid(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func getKeyValue(key: String) -> Double {
    
        let returnVal = defaults.double(forKey: key)
        print("returnVal from if statement: ", returnVal)
        
        return returnVal
    }
    
    func checkKey(key: String) -> Bool {
        
        //func isUserDefaultKeyValid(key: String) -> Bool {
        
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
    
    func updateSegmentValues() {
        
        if(checkKey(key: "preset1")){
            tipControl.setTitle(String(Double(getKeyValue(key: "preset1")) * 100) + "%", forSegmentAt: 0)
            print("tipControl 1 success")
        }
        else {
            print("tipControl 1 failed")
        }
        if(checkKey(key: "preset2")){
            tipControl.setTitle(String(Double(getKeyValue(key: "preset2")) * 100) + "%", forSegmentAt: 1)
            print("tipControl 2 success")
        }
        else {
            print("tipControl 2 failed")
        }
        if(checkKey(key: "preset3")){
            tipControl.setTitle(String(Double(getKeyValue(key: "preset3")) * 100) + "%", forSegmentAt: 2)
            print("tipControl 3 success")
        }
        else {
            print("tipControl 3 failed")
        }
        
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        updateSegmentValues()
        
        var value1 = 0.15
        var value2 = 0.18
        var value3 = 0.20
        
        if(checkKey(key: "preset1")){
            value1 = getKeyValue(key: "preset1")
            print("preset1 success")
        }
        else {
            print("preset1 failed")
        }
        if(checkKey(key: "preset2")){
            value2 = getKeyValue(key: "preset2")
            print("preset2 success")
        }
        else {
            print("preset2 failed")
        }
        if(checkKey(key: "preset3")){
            value3 = getKeyValue(key: "preset3")
            print("preset3 success")
        }
        else {
            print("preset3 failed")
        }
        
        //Get initial bill amount and calculate tips
        let bill = Double(billAmountTextField.text!) ?? 0
        let tipPercentages = [value1, value2, value3]
        
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
    
        //Update the tip and total labels
        tipPercentageLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
}
