//
//  Dictionary+Extensions.swift
//  SImperial
//
//  Created by Petteri Parkkila on 11/01/17.
//  Copyright © 2017 Pietu. All rights reserved.
//

import Foundation

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
  var result = lhs
  rhs.forEach{ result[$0] = $1 }
  return result
}
