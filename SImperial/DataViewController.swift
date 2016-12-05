//
//  DataViewController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 21/11/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var imperialButton: UIButton!
    @IBOutlet weak var siButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var siTextField: UITextField!
    @IBOutlet weak var imperialTextField: UITextField!
    var dataObject: Measurement? = nil
    var selectedSiUnit: String? = nil
    var selectedImperialUnit: String? = nil
    var unitSelections: [String]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let measurement = dataObject {
            self.dataLabel!.text = measurement.header
            let siUnit = measurement.SIValues[0]
            let siText = siUnit.object(forKey: "name") as! String?
            self.siButton.setTitle(siText, for: .normal)
            selectedSiUnit = siUnit.object(forKey: "abbreviation") as! String?

            let imperialUnit = measurement.imperialValues[0]
            let imperialText = imperialUnit.object(forKey: "name") as! String?
            imperialButton.setTitle(imperialText, for: .normal)
            selectedImperialUnit = imperialUnit.object(forKey: "abbreviation") as! String?
        } else {
            self.dataLabel!.text = ""
            self.siButton.setTitle("", for: .normal)
            self.imperialButton.setTitle("", for: .normal)
        }
    }
    
    public func unitSelected(isSIUnit: Bool, name: String) {
        if let measurement = self.dataObject {
            if (isSIUnit) {
                let siUnit = measurement.SIValues.filter({(unit: NSDictionary) -> Bool in
                    return unit.object(forKey: "name") as! String == name
                })[0]
                self.siButton.setTitle(name, for: .normal)
                self.selectedSiUnit = siUnit.object(forKey: "abbreviation") as! String?
                triggerSIValueChange()
            } else {
                let imperialUnit = measurement.imperialValues.filter({(unit: NSDictionary) -> Bool in
                    return unit.object(forKey: "name") as! String == name
                })[0]
                self.imperialButton.setTitle(name, for: .normal)
                self.selectedImperialUnit = imperialUnit.object(forKey: "abbreviation") as! String?
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
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func siButtonClick(_ sender: UIButton) {
        if let measurement = dataObject {
            if measurement.SIValues.count > 1 {
                unitSelections = measurement.SIValues.map({ (unit: NSDictionary) -> String in
                    return unit.object(forKey: "name") as! String
                })
                launchPopOver(sender, true)
            }
        }
    }

    @IBAction func imperialButtonClick(_ sender: UIButton) {
        if let measurement = dataObject {
            if measurement.imperialValues.count > 1 {
                unitSelections = measurement.imperialValues.map({ (unit: NSDictionary) -> String in
                    return unit.object(forKey: "name") as! String
                })
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
