//
//  DataViewController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 21/11/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var toTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    var dataObject: Measurement? = nil
    var selectedFromUnit: String? = nil
    var selectedToUnit: String? = nil
    var fromValues: [Dictionary<String, String>] = []
    var toValues: [Dictionary<String, String>] = []
    var unitSelections: [Dictionary<String,String>]? = nil
    let defaults: UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DataViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getValuesBy(abbreviation: String, SIValues: [Dictionary<String, String>], imperialValues: [Dictionary<String, String>]) -> [Dictionary<String, String>] {
        let foundFromSIValues = SIValues.filter({(unit: Dictionary<String,String>) -> Bool in
            return unit["abbreviation"] == abbreviation
        })
        if foundFromSIValues.count > 0 {
            return SIValues
        } else {
            return imperialValues
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fromButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.toButton.titleLabel?.textAlignment = NSTextAlignment.center
        if let measurement = self.dataObject {
            self.dataLabel!.text = measurement.header
            var fromUnit: Dictionary<String,String> = [:]
            var toUnit: Dictionary<String,String> = [:]
            if let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!) {
                fromUnit = defaultUnits["fromUnit"] as! Dictionary<String, String>
                toUnit = defaultUnits["toUnit"] as! Dictionary<String, String>
            } else {
                fromUnit = measurement.SIValues[0]
                toUnit = measurement.imperialValues[0]
                self.defaults.set(["fromUnit": fromUnit, "toUnit": toUnit], forKey: self.dataLabel!.text!)
            }
            self.fromButton.setTitle(fromUnit["name"], for: .normal)
            self.selectedFromUnit = fromUnit["abbreviation"]
            self.toButton.setTitle(toUnit["name"], for: .normal)
            self.selectedToUnit = toUnit["abbreviation"]
            self.toValues = self.getValuesBy(abbreviation: selectedToUnit!, SIValues: measurement.SIValues, imperialValues: measurement.imperialValues)
            self.fromValues = self.getValuesBy(abbreviation: selectedFromUnit!, SIValues: measurement.SIValues, imperialValues: measurement.imperialValues)
        } else {
            self.dataLabel!.text = ""
            self.fromButton.setTitle("", for: .normal)
            self.toButton.setTitle("", for: .normal)
        }
        determineLayout(orientation: UIApplication.shared.statusBarOrientation)
    }
    
    func determineLayout(orientation: UIInterfaceOrientation) {
        if UIInterfaceOrientationIsPortrait(orientation) {
            self.fromTextFieldTopConstraint.constant = 113
            self.toTextFieldTopConstraint.constant = 113
        } else {
            self.fromTextFieldTopConstraint.constant = 63
            self.toTextFieldTopConstraint.constant = 63
        }
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        determineLayout(orientation: toInterfaceOrientation)
    }

    func fromUnitSelected(fromUnit: Dictionary<String,String>) {
        let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!)
        let toUnit = defaultUnits?["toUnit"] as! Dictionary<String, String>
        self.defaults.set(["fromUnit": fromUnit, "toUnit": toUnit], forKey: self.dataLabel!.text!)
        self.fromButton.setTitle(fromUnit["name"]!, for: .normal)
        self.selectedFromUnit = fromUnit["abbreviation"]
        self.triggerFromValueChange()
    }

    public func toUnitSelected(toUnit: Dictionary<String,String>) {
        let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!)
        let fromUnit = defaultUnits?["fromUnit"] as! Dictionary<String, String>
        self.defaults.set(["fromUnit": fromUnit, "toUnit": toUnit], forKey: self.dataLabel!.text!)
        self.toButton.setTitle(toUnit["name"]!, for: .normal)
        self.selectedToUnit = toUnit["abbreviation"]
        self.triggerFromValueChange()
    }

    func launchPopOver(_ sender: UIButton, _ isFromUnit: Bool) {
        if let selections = self.unitSelections {
            let VC = storyboard?.instantiateViewController(withIdentifier: "popoverController") as! PopOverViewController
            VC.unitSelections = selections
            VC.parentController = self
            VC.isFromUnit = isFromUnit
            VC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(selections.count * 50))
            let navController = UINavigationController(rootViewController: VC)
            navController.modalPresentationStyle = UIModalPresentationStyle.popover
            let popOver = navController.popoverPresentationController
            popOver?.delegate = self
            popOver?.sourceView = sender
            popOver?.sourceRect = CGRect(x: 0, y: 0, width: sender.frame.size.width, height: sender.frame.size.height)
            popOver?.permittedArrowDirections = UIPopoverArrowDirection.up
            self.dismissKeyboard()
            self.present(navController, animated: true, completion: nil)
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    @IBAction func fromButtonClick(_ sender: UIButton) {
        if self.fromValues.count > 1 {
            unitSelections = self.fromValues
            self.launchPopOver(sender, true)
        }
    }

    @IBAction func toButtonClick(_ sender: UIButton) {
        if self.toValues.count > 1 {
            unitSelections = self.toValues
            self.launchPopOver(sender, false)
        }
    }

    internal func triggerFromValueChange() {
        if let measurement = self.dataObject {
            if let fromText = self.fromTextField.text {
                if let fromValue = Double(fromText) {
                    let toValue = measurement.convert(fromUnit: self.selectedFromUnit!, toUnit: self.selectedToUnit!, fromValue: fromValue)
                    self.toTextField.text = String(round(100 * toValue) / 100)
                    
                } else {
                    self.toTextField.text = ""
                }
            } else {
                self.toTextField.text = ""
            }
        }
    }

    internal func triggerToValueChange() {
        if let measurement = self.dataObject {
            if let toText = self.toTextField.text {
                if let toValue = Double(toText) {
                    let fromValue = measurement.convert(fromUnit: self.selectedToUnit!, toUnit: self.selectedFromUnit!, fromValue: toValue)
                    self.fromTextField.text = String(round(100 * fromValue) / 100)
                    
                } else {
                    self.fromTextField.text = ""
                }
            } else {
                self.fromTextField.text = ""
            }
        }
    }

    @IBAction func onFromChanged(_ sender: Any) {
        self.triggerFromValueChange()
    }

    @IBAction func onToChanged(_ sender: Any) {
        self.triggerToValueChange()
    }

    @IBAction func onSwitchButtonClicked(_ sender: Any) {
        let formerFromValues = self.fromValues
        let formerSelectedFromUnit = self.selectedFromUnit
        let formerToValues = self.toValues
        let formerSelectedToUnit = self.selectedToUnit
        let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!)
        let formerFromUnit = defaultUnits?["fromUnit"] as! Dictionary<String, String>
        let formerToUnit = defaultUnits?["toUnit"] as! Dictionary<String, String>
        
        self.fromValues = formerToValues
        self.toValues = formerFromValues
        self.selectedFromUnit = formerSelectedToUnit
        self.selectedToUnit = formerSelectedFromUnit
        self.defaults.set(["fromUnit": formerToUnit, "toUnit": formerFromUnit], forKey: self.dataLabel!.text!)
        self.fromButton.setTitle(formerToUnit["name"], for: .normal)
        self.toButton.setTitle(formerFromUnit["name"], for: .normal)
        self.triggerFromValueChange()
    }

    @IBAction func onSiTouchDown(_ sender: Any) {
        self.fromTextField.becomeFirstResponder()
        self.fromTextField.selectedTextRange = self.fromTextField.textRange(from: self.fromTextField.beginningOfDocument, to: self.fromTextField.endOfDocument)
    }

    @IBAction func onImperialTouchDown(_ sender: Any) {
        self.toTextField.becomeFirstResponder()
        self.toTextField.selectedTextRange = self.toTextField.textRange(from: self.toTextField.beginningOfDocument, to: self.toTextField.endOfDocument)
    }
}
