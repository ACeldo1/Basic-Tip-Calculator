//
//  SettingsViewController.swift
//  Prework
//
//  Created by Andy Celdo on 1/10/21.
//

import UIKit
import SwiftUI

//can expand on this, as the this Settings View Controller will handle most of the configurations/preferences of the application
protocol settingsControl {
    func isUserDefaultKeyValid(key: String) -> Bool
    func getUserDefaultKey(key: String) -> String
}


class SettingsViewController: UIViewController, settingsControl {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var presetLabel1: UILabel!
    @IBOutlet weak var presetLabel2: UILabel!
    @IBOutlet weak var presetLabel3: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var yesOrNo: UILabel!
    
    @IBOutlet weak var inputField1: UITextField!
    @IBOutlet weak var inputField2: UITextField!
    @IBOutlet weak var inputField3: UITextField!
    
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
        
        if(isUserDefaultKeyValid(key: "preset1")) {
            inputField1.text = String(defaults.double(forKey: "preset1") * 100)
        }
        if(isUserDefaultKeyValid(key: "preset2")) {
            inputField2.text = String(defaults.double(forKey: "preset2") * 100)
        }
        if(isUserDefaultKeyValid(key: "preset3")) {
            inputField3.text = String(defaults.double(forKey: "preset3") * 100)
        }
        
        modeSwitchColor()
        
        switchLogic()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        modeSwitch.isOn = defaults.bool(forKey: "modeSwitch")
    }
    
    //colors for the switch
    func modeSwitchColor () {
        modeSwitch.tintColor = UIColor.gray
        modeSwitch.thumbTintColor = UIColor.blue
        modeSwitch.onTintColor = UIColor.white
    }
    
    //logic for dark mode switch
    func switchLogic() {
        
        modeSwitch.addTarget(self, action: #selector(self.changedState), for: UIControl.Event.valueChanged)
        
    }
    
    //can use thes for future alerts (not alertsheets) with only choices
    func yes() -> Bool {
        return true
    }
    
    func no() -> Bool {
        return false
    }
    func displayTipView() {
        
        let tipVC = TipController()
        tipVC.delegate = self
        self.present(tipVC, animated: true)
        
    }

    //sets the mode for the app and shows the output in the app as "Y" or "N"
    @IBAction func changedState(_ sender : UISwitch) {
        
        if(sender.isOn) {
            yesOrNo.text = "Y"
            UIApplication.shared.windows.forEach {
                window in window.overrideUserInterfaceStyle = .dark
            }
            
            defaults.set(yesOrNo.text, forKey: "mode")
            defaults.set(true, forKey: "modeSwitch")
        }
        else if(!sender.isOn) {
            yesOrNo.text = "N"
            UIApplication.shared.windows.forEach {
                window in window.overrideUserInterfaceStyle = .light
            }
            
            defaults.set(yesOrNo.text, forKey: "mode")
            defaults.set(false, forKey: "modeSwitch")
        }
        
    }
    
    //logic for the preset values
    @IBAction func setPreset1(_ sender: UITextField) {
        
        if let pre1 = Double(inputField1.text!) {
            defaults.set(String(pre1 / 100), forKey: "preset1")
        }
        else {
            print("setPreset1() else statement")
        }
    
    }
    
    @IBAction func setPreset2(_ sender: UITextField) {
    
        if let pre2 = Double(inputField2.text!) {
            defaults.set(String(pre2 / 100), forKey: "preset2")
        }
        else {
            print("setPreset2() else statement")
        }
    
    }
    
    @IBAction func setPreset3(_ sender: UITextField) {
    
        if let pre3 = Double(inputField3.text!) {
            defaults.set(String(pre3 / 100), forKey: "preset3")
        }
        else {
            print("setPreset3() else statement")
        }
        
    }
    
    //logic for resetting the tip presets to the orignal values
    //as more features get added, their resetting logic would be included here as well
    @IBAction func resetTest(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Reset Settings to Default Configurations?", message: "Click \"OK\" to confirm", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { action in
            //resetting to light mode
            UIApplication.shared.windows.forEach {
                window in window.overrideUserInterfaceStyle = .light
            }
                
            //clearing the text fields of inputs
            self.inputField1.text = ""
            self.inputField2.text = ""
            self.inputField3.text = ""
                
            //resetting the tip presets
            self.defaults.set(nil, forKey: "preset1")
            self.defaults.set(nil, forKey: "preset2")
            self.defaults.set(nil, forKey: "preset3")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        )
        print("Passing through...")
        super.present(alert, animated: true, completion: nil)
        
    }
    
    //will return boolean value of whether the key is nil/null or not
    func isUserDefaultKeyValid(key: String) -> Bool {
        print("isUserDef: ", UserDefaults.standard.object(forKey: key) != nil)
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //will return the value of the key
    func getUserDefaultKey(key: String) -> String {
        print("getUserDef: ", UserDefaults.standard.string(forKey: key) ?? "<no_value>")
        return UserDefaults.standard.string(forKey: key) ?? "<no_value>"
    }
    // Force UserDefaults to save.
//    defaults.synchronize()
    
    //link below explains that defaults.synchronize() should no longer be utilized
/*h ttps://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults
  */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
