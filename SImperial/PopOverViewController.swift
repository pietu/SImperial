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
  var compelition: ((_ unit: Dictionary<String,Dimension>) -> Void)? = nil
  var unitSelections: [Dictionary<String,Dimension>]? = nil

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
      if let name = selections[indexPath.row].keys.first {
        cell.textLabel?.text = name + ",  " + (selections[indexPath.row][name]?.symbol)!
      }
    } else {
      cell.textLabel?.text = "No content available"
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let selections = self.unitSelections {
      if let cb = compelition {
        cb(selections[indexPath.row])
      }
    }
    self.dismiss(animated: true, completion: nil)
  }
}
