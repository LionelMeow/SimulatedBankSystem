//
//  Models.swift
//  LionelBank
//
//  Created by A2339 on 22/05/2021.
//  Copyright © 2021 Razeware. All rights reserved.
//

import Foundation

class User: Equatable {
  var name: String
  var balance: Int = 0
  var ownTo: [OwnTo]?
  
  init(name: String, balance: Int, ownTo: [OwnTo]?) {
    self.name = name
    self.balance = balance
    self.ownTo = ownTo
  }
  
  static func ==(lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name && lhs.balance == rhs.balance && lhs.ownTo == rhs.ownTo
  }
}

class OwnTo: Equatable  {
  var debtPerson: User
  var ownPerson: User
  var amount: Int
  
  init(debtPerson: User, ownPerson: User, amount : Int) {
    self.debtPerson = debtPerson
    self.amount = amount
    self.ownPerson = ownPerson
  }
  
  static func ==(lhs: OwnTo, rhs: OwnTo) -> Bool {
    return lhs.debtPerson == rhs.debtPerson && lhs.ownPerson == rhs.ownPerson && lhs.amount == rhs.amount
  }
}
