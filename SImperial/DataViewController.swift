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
        if let measurement = dataObject {
            self.dataLabel!.text = measurement.header
            let siUnit = measurement.SIValues[0]
            let siText = siUnit["name"]
            self.siButton.setTitle(siText, for: .normal)
            selectedSiUnit = siUnit["abbreviation"]

            let imperialUnit = measurement.imperialValues[0]
            let imperialText = imperialUnit["name"]
            imperialButton.setTitle(imperialText, for: .normal)
            selectedImperialUnit = imperialUnit["abbreviation"]
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
                self.siButton.setTitle(name, for: .normal)
                self.selectedSiUnit = siUnit["abbreviation"]
                triggerSIValueChange()
            } else {
                let imperialUnit = measurement.imperialValues.filter({(unit: Dictionary<String,String>) -> Bool in
                    return unit["name"] == name
                })[0]
                self.imperialButton.setTitle(name, for: .normal)
                self.selectedImperialUnit = imperialUnit["abbreviation"]
                triggerImperialValueChange()
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
        if let measurement = dataObject {
            if measurement.SIValues.count > 1 {
                unitSelections = measurement.SIValues
                launchPopOver(sender, true)
            }
        }
    }

    @IBAction func imperialButtonClick(_ sender: UIButton) {
        if let measurement = dataObject {
            if measurement.imperialValues.count > 1 {
                unitSelections = measurement.imperialValues
                launchPopOver(sender, false)
            }
        }
    }
    
    internal func triggerSIValueChange() {
        if let measurement = dataObject {
            if let siText = siTextField.text {
                if let siValue = Double(siText) {
                    let imperialValue = measurement.convert(fromUnit: self.selectedSiUnit!, toUnit: self.selectedImperialUnit!, fromValue: siValue)
                    imperialTextField.text = String(round(100 * imperialValue) / 100)
                    
                } else {
                    imperialTextField.text = ""
                }
            } else {
                imperialTextField.text = ""
            }
        }
    }
    
    internal func triggerImperialValueChange() {
        if let measurement = dataObject {
            if let imperialText = imperialTextField.text {
                if let imperialValue = Double(imperialText) {
                    let siValue = measurement.convert(fromUnit: self.selectedImperialUnit!, toUnit: self.selectedSiUnit!, fromValue: imperialValue)
                    siTextField.text = String(round(100 * siValue) / 100)
                    
                } else {
                    siTextField.text = ""
                }
            } else {
                siTextField.text = ""
            }
        }
    }
    
    @IBAction func onSiChanged(_ sender: Any) {
        triggerSIValueChange()
    }

    @IBAction func onImperialChanged(_ sender: Any) {
        triggerImperialValueChange()
    }

    @IBAction func onSiTouchDown(_ sender: Any) {
        siTextField.becomeFirstResponder()
        siTextField.selectedTextRange =  siTextField.textRange(from: siTextField.beginningOfDocument, to: siTextField.endOfDocument)
    }

    @IBAction func onImperialTouchDown(_ sender: Any) {
        imperialTextField.becomeFirstResponder()
        imperialTextField.selectedTextRange =  imperialTextField.textRange(from: imperialTextField.beginningOfDocument, to: imperialTextField.endOfDocument)
    }
}
