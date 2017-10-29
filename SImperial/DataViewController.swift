//
//  DataViewController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 21/11/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
  @IBOutlet weak var fromMinusButton: UIButton!
  @IBOutlet weak var toMinusButton: UIButton!
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
    self.view.addGestureRecognizer(tap)
    self.view.layer.backgroundColor = UIColor(red: (45/255.0), green: (204/255.0), blue: (211/255.0), alpha: 0.7).cgColor
    self.fromTextField.delegate = self
    self.toTextField.delegate = self
    setUpTextFieldBorders(self.fromTextField)
    setUpTextFieldBorders(self.toTextField)
  }

  func setUpTextFieldBorders(_ textField: UITextField) {
    let rect = textField.frame
    let layer = textField.layer
    let bottomBorder = CALayer()
    let rightBorder = CALayer()
    let width = CGFloat(1.5)

    let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor

    bottomBorder.borderColor = color
    rightBorder.borderColor = color

    bottomBorder.frame = CGRect(x: 0, y: rect.size.height - width, width:  rect.size.width, height: rect.size.height)
    rightBorder.frame = CGRect(x: rect.size.width - width, y: 0, width:  rect.size.width, height: rect.size.height - width)

    bottomBorder.borderWidth = width
    rightBorder.borderWidth = width
    layer.addSublayer(bottomBorder)
    layer.addSublayer(rightBorder)
    layer.masksToBounds = true
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

  func getUnit(_ units: [Dictionary<String,Dimension>], unitName: String) -> Dictionary<String,Dimension>? {
    let foundUnits = units.filter({(unit: Dictionary<String,Dimension>) -> Bool in
      if let key = unit.keys.first {
        return key == unitName
      } else {
        return false
      }
    })
    return foundUnits.first
  }

  func getUnit(unitName: String, measurement: MyMeasurement) -> Dictionary<String, Dimension>? {
    if let foundSIUnit = getUnit(measurement.SIValues, unitName: unitName) {
      return foundSIUnit
    } else {
      return getUnit(measurement.imperialValues, unitName: unitName)
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
        let toUnitName = defaultUnits["toUnit"] as! String
        if let fUnit = getUnit(unitName: fromUnitName, measurement: measurement), let tUnit = getUnit(unitName: toUnitName, measurement: measurement) {
          fromUnit = fUnit
          toUnit = tUnit
        } else {
          fromUnit = measurement.SIValues[0]
          toUnit = measurement.imperialValues[0]
          self.defaults.set(mergeWithDefaults(["fromUnit": fromUnit.keys.first as Any , "toUnit": toUnit.keys.first as Any]), forKey: measurement.header)
        }
        if let fromValue = defaultUnits["fromValue"] {
          self.fromTextField.text = String(describing: fromValue)
        }
        if let toValue = defaultUnits["toValue"] {
          self.toTextField.text = String(describing: toValue)
        }
      } else {
        fromUnit = measurement.SIValues[0]
        toUnit = measurement.imperialValues[0]
        self.defaults.set(mergeWithDefaults(["fromUnit": fromUnit.keys.first as Any, "toUnit": toUnit.keys.first as Any]), forKey: measurement.header)
      }
      let fromUnitName = fromUnit.keys.first
      self.fromButton.setTitle(fromUnitName, for: .normal)
      self.selectedFromUnit = fromUnit[fromUnitName!]
      let toUnitName = toUnit.keys.first
      self.toButton.setTitle(toUnitName, for: .normal)
      self.selectedToUnit = toUnit[toUnitName!]
      self.toValues = self.getValuesBy(dimension: selectedToUnit!, SIValues: measurement.SIValues, imperialValues: measurement.imperialValues)
      self.fromValues = self.getValuesBy(dimension: selectedFromUnit!, SIValues: measurement.SIValues, imperialValues: measurement.imperialValues)
      if (measurement.hasMinusValues) {
        fromMinusButton.isHidden = false
        toMinusButton.isHidden = false
        determineInvertButtonsTexts()
      } else {
        fromMinusButton.isHidden = true
        toMinusButton.isHidden = true
      }
    } else {
      self.dataLabel!.text = ""
      self.fromButton.setTitle("", for: .normal)
      self.toButton.setTitle("", for: .normal)
    }
  }

  func determineButtonText(_ text: String, button: UIButton) {
    if text.hasPrefix("-") {
      button.setTitle("Convert to Positive", for: .normal)
    } else {
      button.setTitle("Convert to Negative", for: .normal)
    }
  }

  func determineInvertButtonsTexts() {
    if let fromText = fromTextField.text {
      determineButtonText(fromText, button: fromMinusButton)
    }
    if let toText = toTextField.text {
      determineButtonText(toText, button: toMinusButton)
    }
  }

  func fromUnitSelected(fromUnit: Dictionary<String,Dimension>) {
    self.defaults.set(mergeWithDefaults(["fromUnit": fromUnit.keys.first!]), forKey: self.dataLabel!.text!)
    let fromUnitName = fromUnit.keys.first
    self.fromButton.setTitle(fromUnitName, for: .normal)
    self.selectedFromUnit = fromUnit[fromUnitName!]
    self.triggerFromValueChange()
  }

  public func toUnitSelected(toUnit: Dictionary<String,Dimension>) {
    self.defaults.set(mergeWithDefaults(["toUnit": toUnit.keys.first!]), forKey: self.dataLabel!.text!)
    let toUnitName = toUnit.keys.first
    self.toButton.setTitle(toUnitName, for: .normal)
    self.selectedToUnit = toUnit[toUnitName!]
    self.triggerFromValueChange()
  }

  func launchPopOver(_ sender: UIButton, _ compelition: @escaping (_ unit: Dictionary<String, Dimension>) -> Void) {
    if let selections = self.unitSelections {
      let VC = storyboard?.instantiateViewController(withIdentifier: "popoverController") as! PopOverViewController
      VC.unitSelections = selections
      VC.compelition = compelition
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
      self.launchPopOver(sender, fromUnitSelected)
    }
  }

  @IBAction func toButtonClick(_ sender: UIButton) {
    if self.toValues.count > 1 {
      unitSelections = self.toValues
      self.launchPopOver(sender, toUnitSelected)
    }
  }

  internal func triggerFromValueChange() {
    if let measurement = self.dataObject {
      if let fromText = self.fromTextField.text {
        var toText = ""
        if let fromValue = Double(fromText) {
          let toValue = measurement.convert(fromUnit: self.selectedFromUnit!, toUnit: self.selectedToUnit!, fromValue: fromValue)
          toText = String(round(100 * toValue) / 100)
          self.toTextField.text = toText
        } else {
          self.toTextField.text = ""
        }
        self.defaults.set(mergeWithDefaults(["fromValue": fromText, "toValue": toText]), forKey: self.dataLabel!.text!)
      } else {
        self.toTextField.text = ""
        self.defaults.set(mergeWithDefaults(["fromValue": "", "toValue": ""]), forKey: self.dataLabel!.text!)
      }
      determineInvertButtonsTexts()
    }
  }

  internal func triggerToValueChange() {
    if let measurement = self.dataObject {
      if let toText = self.toTextField.text {
        var fromText = ""
        if let toValue = Double(toText) {
          let fromValue = measurement.convert(fromUnit: self.selectedToUnit!, toUnit: self.selectedFromUnit!, fromValue: toValue)
          fromText = String(round(100 * fromValue) / 100)
          self.fromTextField.text = fromText
        } else {
          self.fromTextField.text = ""
        }
        self.defaults.set(mergeWithDefaults(["fromValue": fromText, "toValue": toText]), forKey: self.dataLabel!.text!)
      } else {
        self.fromTextField.text = ""
        self.defaults.set(mergeWithDefaults(["fromValue": "", "toValue": ""]), forKey: self.dataLabel!.text!)
      }
      determineInvertButtonsTexts()
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    switch string {
    case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
      return true
    case ".":
      if let chars = textField.text?.characters {
        var decimalCount = 0
        for character in chars {
          if character == "." {
            decimalCount += 1
          }
        }
        return !(decimalCount == 1)
      } else {
        return false
      }
    case "":
      return true
    default:
      return false
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
    if let defaultUnits = defaults.dictionary(forKey: self.dataLabel!.text!) {
      let formerFromUnitName = defaultUnits["fromUnit"] as! String
      let formerToUnitName = defaultUnits["toUnit"] as! String
      self.fromValues = formerToValues
      self.toValues = formerFromValues
      self.selectedFromUnit = formerSelectedToUnit
      self.selectedToUnit = formerSelectedFromUnit
      self.defaults.set(mergeWithDefaults(["fromUnit": formerToUnitName, "toUnit": formerFromUnitName]), forKey: self.dataLabel!.text!)
      self.fromButton.setTitle(formerToUnitName, for: .normal)
      self.toButton.setTitle(formerFromUnitName, for: .normal)
      self.triggerFromValueChange()
    }
  }

  @IBAction func fromMinusButtonClick(_ sender: Any) {
    if var text = fromTextField.text {
      if text.hasPrefix("-") {
        text = text.replacingOccurrences(of: "-", with: "")
      } else {
        text = "-\(text)"
      }
      fromTextField.text = text
      self.triggerFromValueChange()
    }
  }

  @IBAction func toMinusButtonClick(_ sender: Any) {
    if var text = toTextField.text {
      if text.hasPrefix("-") {
        text = text.replacingOccurrences(of: "-", with: "")
      } else {
        text = "-\(text)"
      }
      toTextField.text = text
      self.triggerToValueChange()
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

  func mergeWithDefaults(_ newValues: Dictionary<String,Any>) -> Dictionary<String,Any> {
    if let defaultUnits = defaults.dictionary(forKey: self.dataLabel.text!) {
      return defaultUnits + newValues
    } else {
      return newValues
    }
  }
}
