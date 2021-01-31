//
//  TableViewController.swift
//  Prework
//
//  Created by Andy Celdo on 1/22/21.
//

import UIKit

class TableViewController: UITableViewController {

    //MARK: - Class Variables
    
    let defaults = UserDefaults.standard
    
//    dynamic UIElements
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var yesOrNo: UILabel!
    @IBOutlet weak var presetOne: UITextField!
    @IBOutlet weak var presetTwo: UITextField!
    @IBOutlet weak var presetThree: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    
//    static UIElements
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var presetLabel1: UILabel!
    @IBOutlet weak var presetLabel2: UILabel!
    @IBOutlet weak var presetLabel3: UILabel!
    @IBOutlet weak var resetPresetsLabel: UILabel!
    
    
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        if(UIViewController().isUserDefaultKeyValid(key: "preset1")) {
            presetOne.text = String(defaults.double(forKey: "preset1") * 100)
        }
        if(UIViewController().isUserDefaultKeyValid(key: "preset2")) {
            presetTwo.text = String(defaults.double(forKey: "preset2") * 100)
        }
        if(UIViewController().isUserDefaultKeyValid(key: "preset3")) {
            presetThree.text = String(defaults.double(forKey: "preset3") * 100)
        }
        
        modeSwitchColor()

        switchLogic()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("table viewWillAppear")
        
        modeSwitch.isOn = defaults.bool(forKey: "modeSwitch")
        yesOrNo.text = getKeyValueStr(key: "mode")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("table viewDidAppear")
    }
    
    //used to store the last known input value as a user default
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("table viewWillDisappear")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("table viewDidDisappear")
    }
    
    // MARK: - IBActions
    
    @IBAction func changedState(_ sender: UISwitch) {

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
    
    @IBAction func resetTest(_ sender: Any) {
        
        let alert = UIAlertController(title: "Reset Settings to Default Configurations?", message: "Click \"OK\" to confirm", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { action in
            //resetting to light mode
            UIApplication.shared.windows.forEach {
                window in window.overrideUserInterfaceStyle = .light
            }
            
            //resetting switch and its correspondings UD values
            self.modeSwitch.setOn(false, animated: true)
            self.yesOrNo.text = "N"
            self.defaults.set("N", forKey: "mode")
            self.defaults.set(false, forKey: "modeSwitch")
            
            //clearing the text fields of inputs
            self.presetOne.text = ""
            self.presetTwo.text = ""
            self.presetThree.text = ""
                
            //resetting the tip presets
            self.defaults.set(nil, forKey: "preset1")
            self.defaults.set(nil, forKey: "preset2")
            self.defaults.set(nil, forKey: "preset3")
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil))
        print("Passing through...")
        super.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func setPreset1(_ sender: Any) {
    
        if let pre1 = Double(presetOne.text!) {
            defaults.set(String(pre1 / 100.0), forKey: "preset1")
        }
        else {
            print("preset1 is nil")
            defaults.set(String(15.0/100.0), forKey: "preset1")
        }
        
    }
    
    @IBAction func setPreset2(_ sender: Any) {
    
        if let pre2 = Double(presetTwo.text!) {
            defaults.set(String(pre2 / 100.0), forKey: "preset2")
        }
        else {
            print("preset2 is nil")
            defaults.set(String(18.0/100.0), forKey: "preset2")
        }
    
    }
    
    @IBAction func setPreset3(_ sender: Any) {
  
        if let pre3 = Double(presetThree.text!) {
            defaults.set(String(pre3 / 100.0), forKey: "preset3")
        }
        else {
            print("preset3 is nil")
            defaults.set(String(20.0/100.0), forKey: "preset3")
        }
    
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
//        return self.tableView.numberOfSections
            //(tableView.numberOfSections)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Options"
    }
 
    //MARK: Regular Functions
    
    //colors for the switch
    func modeSwitchColor () {
         modeSwitch.tintColor = UIColor.darkGray
    }
    
    //logic for dark mode switch
    func switchLogic() {
        modeSwitch.addTarget(self, action: #selector(self.changedState), for: UIControl.Event.valueChanged)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
