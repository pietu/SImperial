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
    var dataObject: MyMeasurement? = nil
    var selectedFromUnit: Dimension? = nil
    var selectedToUnit: Dimension? = nil
    var fromValues: [Dictionary<String, Dimension>] = []
    var toValues: [Dictionary<String, Dimension>] = []
    var unitSelections: [Dictionary<String,Dimension>]? = nil
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

    func getValuesBy(dimension: Dimension, SIValues: [Dictionary<String, Dimension>], imperialValues: [Dictionary<String, Dimension>]) -> [Dictionary<String, Dimension>] {
        let foundFromSIValues = SIValues.filter({(unit: Dictionary<String,Dimension>) -> Bool in
          if let key = unit.keys.first {
            return unit[key] == dimension
          } else {
            return false
          }
        })
        if foundFromSIValues.count > 0 {
            return SIValues
        } else {
            return imperialValues
        }
    }

    func getUnit(unitName: String, measurement: MyMeasurement) -> Dictionary<String, Dimension> {
      let foundFromSIValues = measurement.SIValues.filter({(unit: Dictionary<String,Dimension>) -> Bool in
        if let key = unit.keys.first {
          return key == unitName
        } else {
          return false
        }
      })
      if (foundFromSIValues.count > 0) {
        return foundFromSIValues.first!
      } else {
        let foundFromImperialValues = measurement.imperialValues.filter({(unit: Dictionary<String,Dimension>) -> Bool in
          if let key = unit.keys.first {
            return key == unitName
          } else {
            return false
          }
        })
        return foundFromImperialValues.first!
      }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fromButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.toButton.titleLabel?.textAlignment = NSTextAlignment.center
        if let measurement = self.dataObject {
            self.dataLabel!.text = measurement.header
            var fromUnit: Dictionary<String,Dimension> = [:]
            var toUnit: Dictionary<String,Dimension> = [:]
            if let defaultUnits = defaults.dictionary(forKey: measurement.header) {
                let fromUnitName = defaultUnits["fromUnit"] as! String
                fromUnit = getUnit(unitName: fromUnitName, measurement: measurement)
                let toUnitName = defaultUnits["toUnit"] as! String
                toUnit = getUnit(unitName: toUnitName, measurement: measurement)
            } else {
                fromUnit = measurement.SIValues[0]
                toUnit = measurement.imperialValues[0]
                self.defaults.set(["fromUnit": fromUnit.keys.first, "toUnit": toUnit.keys.first], forKey: measurement.header)
            }
            let fromUnitName = fromUnit.keys.first
            self.fromButton.setTitle(fromUnitName, for: .normal)
            self.selectedFromUnit = fromUnit[fromUnitName!]
            let toUnitName = toUnit.keys.first
            self.toButton.setTitle(toUnitName, for: .normal)
            self.selectedToUnit = toUnit[toUnitName!]
            self.toValues = self.getValuesBy(dimension: selectedToUnit!, SIValues: measurement.SIValues, imperialValues: measurement.imperialValues)
            self.fromValues = self.getValuesBy(dimension: selectedFromUnit!, SIValues: measurement.SIValues, imperialValues: measurement.imperialValues)
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

    func fromUnitSelected(fromUnit: Dictionary<String,Dimension>) {
      if let measurement = self.dataObject {
        let defaultUnits = defaults.dictionary(forKey: measurement.header)
        let toUnit = getUnit(unitName: defaultUnits?["toUnit"] as! String, measurement: measurement)
        self.defaults.set(["fromUnit": fromUnit.keys.first, "toUnit": toUnit.keys.first], forKey: self.dataLabel!.text!)
        let fromUnitName = fromUnit.keys.first
        self.fromButton.setTitle(fromUnitName, for: .normal)
        self.selectedFromUnit = fromUnit[fromUnitName!]
        self.triggerFromValueChange()
      }
    }

    public func toUnitSelected(toUnit: Dictionary<String,Dimension>) {
      if let measurement = self.dataObject {
        let defaultUnits = defaults.dictionary(forKey: measurement.header)
        let fromUnit = getUnit(unitName: defaultUnits?["fromUnit"] as! String, measurement: measurement)
        self.defaults.set(["fromUnit": fromUnit.keys.first, "toUnit": toUnit.keys.first], forKey: self.dataLabel!.text!)
        let toUnitName = toUnit.keys.first
        self.toButton.setTitle(toUnitName, for: .normal)
        self.selectedToUnit = toUnit[toUnitName!]
        self.triggerFromValueChange()
      }
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
      if let measurement = self.dataObject {
        let formerFromValues = self.fromValues
        let formerSelectedFromUnit = self.selectedFromUnit
        let formerToValues = self.toValues
        let formerSelectedToUnit = self.selectedToUnit
        let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!)
        let formerFromUnit = getUnit(unitName: defaultUnits?["fromUnit"] as! String, measurement: measurement)
        let formerToUnit = getUnit(unitName: defaultUnits?["toUnit"] as! String, measurement: measurement)
        
        self.fromValues = formerToValues
        self.toValues = formerFromValues
        self.selectedFromUnit = formerSelectedToUnit
        self.selectedToUnit = formerSelectedFromUnit
        self.defaults.set(["fromUnit": formerToUnit.keys.first, "toUnit": formerFromUnit.keys.first], forKey: self.dataLabel!.text!)
        self.fromButton.setTitle(formerToUnit.keys.first, for: .normal)
        self.toButton.setTitle(formerFromUnit.keys.first, for: .normal)
        self.triggerFromValueChange()
      }
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
