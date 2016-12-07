//
//  DataViewController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 21/11/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var imperialTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var siTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imperialButton: UIButton!
    @IBOutlet weak var siButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var siTextField: UITextField!
    @IBOutlet weak var imperialTextField: UITextField!
    var dataObject: Measurement? = nil
    var selectedSiUnit: String? = nil
    var selectedImperialUnit: String? = nil
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.siButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.imperialButton.titleLabel?.textAlignment = NSTextAlignment.center
        if let measurement = self.dataObject {
            self.dataLabel!.text = measurement.header
            var siUnit: Dictionary<String,String> = [:]
            var imperialUnit: Dictionary<String,String> = [:]
            if let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!) {
                siUnit = defaultUnits["siUnit"] as! Dictionary<String, String>
                imperialUnit = defaultUnits["imperialUnit"] as! Dictionary<String, String>
            } else {
                siUnit = measurement.SIValues[0]
                imperialUnit = measurement.imperialValues[0]
                self.defaults.set(["siUnit": siUnit, "imperialUnit": imperialUnit], forKey: self.dataLabel!.text!)
            }
            self.siButton.setTitle(siUnit["name"], for: .normal)
            self.selectedSiUnit = siUnit["abbreviation"]
            self.imperialButton.setTitle(imperialUnit["name"], for: .normal)
            self.selectedImperialUnit = imperialUnit["abbreviation"]
        } else {
            self.dataLabel!.text = ""
            self.siButton.setTitle("", for: .normal)
            self.imperialButton.setTitle("", for: .normal)
        }
        determineLayout(orientation: UIApplication.shared.statusBarOrientation)
    }
    
    func determineLayout(orientation: UIInterfaceOrientation) {
        if UIInterfaceOrientationIsPortrait(orientation) {
            self.siTextFieldTopConstraint.constant = 113
            self.imperialTextFieldTopConstraint.constant = 113
        } else {
            self.siTextFieldTopConstraint.constant = 63
            self.imperialTextFieldTopConstraint.constant = 63
        }
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        determineLayout(orientation: toInterfaceOrientation)
    }

    public func unitSelected(isSIUnit: Bool, name: String) {
        if let measurement = self.dataObject {
            if (isSIUnit) {
                let siUnit = measurement.SIValues.filter({(unit: Dictionary<String,String>) -> Bool in
                    return unit["name"] == name
                })[0]
                let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!)
                let imperialUnit = defaultUnits?["imperialUnit"] as! Dictionary<String, String>
                self.defaults.set(["siUnit": siUnit, "imperialUnit": imperialUnit], forKey: self.dataLabel!.text!)
                self.siButton.setTitle(name, for: .normal)
                self.selectedSiUnit = siUnit["abbreviation"]
                self.triggerSIValueChange()
            } else {
                let imperialUnit = measurement.imperialValues.filter({(unit: Dictionary<String,String>) -> Bool in
                    return unit["name"] == name
                })[0]
                let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!)
                let siUnit = defaultUnits?["siUnit"] as! Dictionary<String, String>
                self.defaults.set(["siUnit": siUnit, "imperialUnit": imperialUnit], forKey: self.dataLabel!.text!)
                self.imperialButton.setTitle(name, for: .normal)
                self.selectedImperialUnit = imperialUnit["abbreviation"]
                self.triggerSIValueChange()
            }
        }
        
    }
    
    func launchPopOver(_ sender: UIButton, _ isSIUnit: Bool) {
        if let selections = self.unitSelections {
            let VC = storyboard?.instantiateViewController(withIdentifier: "popoverController") as! PopOverViewController
            VC.unitSelections = selections
            VC.parentController = self
            VC.isSIUnit = isSIUnit
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
    
    @IBAction func siButtonClick(_ sender: UIButton) {
        if let measurement = self.dataObject {
            if measurement.SIValues.count > 1 {
                unitSelections = measurement.SIValues
                self.launchPopOver(sender, true)
            }
        }
    }

    @IBAction func imperialButtonClick(_ sender: UIButton) {
        if let measurement = self.dataObject {
            if measurement.imperialValues.count > 1 {
                unitSelections = measurement.imperialValues
                self.launchPopOver(sender, false)
            }
        }
    }
    
    internal func triggerSIValueChange() {
        if let measurement = self.dataObject {
            if let siText = self.siTextField.text {
                if let siValue = Double(siText) {
                    let imperialValue = measurement.convert(fromUnit: self.selectedSiUnit!, toUnit: self.selectedImperialUnit!, fromValue: siValue)
                    self.imperialTextField.text = String(round(100 * imperialValue) / 100)
                    
                } else {
                    self.imperialTextField.text = ""
                }
            } else {
                self.imperialTextField.text = ""
            }
        }
    }
    
    internal func triggerImperialValueChange() {
        if let measurement = self.dataObject {
            if let imperialText = self.imperialTextField.text {
                if let imperialValue = Double(imperialText) {
                    let siValue = measurement.convert(fromUnit: self.selectedImperialUnit!, toUnit: self.selectedSiUnit!, fromValue: imperialValue)
                    self.siTextField.text = String(round(100 * siValue) / 100)
                    
                } else {
                    self.siTextField.text = ""
                }
            } else {
                self.siTextField.text = ""
            }
        }
    }
    
    @IBAction func onSiChanged(_ sender: Any) {
        self.triggerSIValueChange()
    }

    @IBAction func onImperialChanged(_ sender: Any) {
        self.triggerImperialValueChange()
    }

    @IBAction func onSiTouchDown(_ sender: Any) {
        self.siTextField.becomeFirstResponder()
        self.siTextField.selectedTextRange = self.siTextField.textRange(from: self.siTextField.beginningOfDocument, to: self.siTextField.endOfDocument)
    }

    @IBAction func onImperialTouchDown(_ sender: Any) {
        self.imperialTextField.becomeFirstResponder()
        self.imperialTextField.selectedTextRange = self.imperialTextField.textRange(from: self.imperialTextField.beginningOfDocument, to: self.imperialTextField.endOfDocument)
    }
}
