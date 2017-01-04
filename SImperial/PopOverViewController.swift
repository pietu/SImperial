//
//  PopOverViewController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 05/12/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var isFromUnit: Bool = false
    var unitSelections: [Dictionary<String,Dimension>]? = nil
    var parentController: DataViewController? = nil
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selections = self.unitSelections {
            return selections.count
        } else {
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "unitCell")
        cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 17)
        if let selections = self.unitSelections {
            cell.textLabel?.text = selections[indexPath.row].keys.first
        } else {
            cell.textLabel?.text = "No content available"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selections = self.unitSelections {
            if let parent = self.parentController {
                if self.isFromUnit {
                    parent.fromUnitSelected(fromUnit: selections[indexPath.row])
                } else {
                    parent.toUnitSelected(toUnit: selections[indexPath.row])
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
