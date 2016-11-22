//
//  DataViewController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 21/11/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var siLabel: UILabel!
    @IBOutlet weak var imperialLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var siTextField: UITextField!
    @IBOutlet weak var imperialTextField: UITextField!
    var dataObject: Measurement? = nil
    var selectedSiUnit: String? = nil
    var selectedImperialUnit: String? = nil

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
            let imperialUnit = measurement.imperialValues[0]
            self.siLabel!.text = siUnit.object(forKey: "name") as! String?
            self.imperialLabel!.text = imperialUnit.object(forKey: "name") as! String?
            selectedSiUnit = siUnit.object(forKey: "abbreviation") as! String?
            selectedImperialUnit = imperialUnit.object(forKey: "abbreviation") as! String?
        } else {
            self.dataLabel!.text = ""
            self.siLabel!.text = ""
            self.imperialLabel!.text = ""
        }
    }
    
    
    @IBAction func onSiChanged(_ sender: Any) {
        if let measurement = dataObject {
            if let siText = siTextField.text {
                if let siValue = Double(siText) {
                    let imperialValue = measurement.convert(fromUnit: self.selectedSiUnit!, toUnit: self.selectedImperialUnit!, fromValue: siValue)
                    imperialTextField.text = String(round(10 * imperialValue) / 10)
                    
                } else {
                    imperialTextField.text = ""
                }
            } else {
                imperialTextField.text = ""
            }
        }
    }
    
    @IBAction func onImperialChanged(_ sender: Any) {
        if let measurement = dataObject {
            if let imperialText = imperialTextField.text {
                if let imperialValue = Double(imperialText) {
                    let siValue = measurement.convert(fromUnit: self.selectedImperialUnit!, toUnit: self.selectedImperialUnit!, fromValue: imperialValue)
                    siTextField.text = String(round(10 * siValue) / 10)
                    
                } else {
                    siTextField.text = ""
                }
            } else {
                siTextField.text = ""
            }
        }
    }
}

