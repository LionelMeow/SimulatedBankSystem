//
//  BankSharedInstanceManager.swift
//  LionelBank
//
//  Created by A2339 on 22/05/2021.
//  Copyright © 2021 Razeware. All rights reserved.
//

import Foundation

class BankSharedInstanceManager {
  var users = [User]()
  var ledger = [OwnTo]()
  var currentUser: User?
  
  
  func createUser(_ name: String) {
    let user = User(name: name, balance: 0, ownTo: nil)
    
    for user in users where user.name == name {
      print("Operation failed: User already existed")
    }
    users.append(user)
  }
  
  func createTransaction(_ user: User, amount: Int) {
    guard let curUser = currentUser else { return print("Current user not established") }
    let oldCurrentUser = curUser
    let oldPayToUser = user
    let balance = curUser.balance
    
    let offset = balance - amount
    
    if offset >= 0 {
      // still have balance
      curUser.balance -= amount
      user.balance += amount
      print("Current user :\(curUser.name) paid to \(user.name) with \(amount)\n")
      
      updateUser(oldCurrentUser, newUser: curUser)
      updateUser(oldPayToUser, newUser: user)
      
      if let existing = findLedger(curUser.name, ownToPersonName: user.name) {
        let offset = existing.amount - amount
        if offset > 0 {
          let newOwnTo: OwnTo = OwnTo(debtPerson: curUser, ownPerson: user, amount: existing.amount - amount)
          updateLedger(existing, newOwnTo: newOwnTo)
        }
        else {
          let newOwnTo: OwnTo = OwnTo(debtPerson: curUser, ownPerson: user, amount: 0)
          updateLedger(existing, newOwnTo: newOwnTo)
        }
      }
      
      validateOtherUserDebt(firstUser: curUser, otherUser: user)
    }
    else {
      // dont have enough
      let currentUserBalance = curUser.balance
      createTransaction(user, amount: currentUserBalance)
      
      let positiveOffset = abs(offset)
      updateUser(curUser, newUser: User(name: curUser.name, balance: 0, ownTo: curUser.ownTo))
      guard let newCurrentUser = currentUser else { return }
      
      if let existing = findLedger(newCurrentUser.name, ownToPersonName: user.name) {
        let newOwnTo: OwnTo = OwnTo(debtPerson: newCurrentUser, ownPerson: user, amount: existing.amount + positiveOffset)
        print("Current user :\(curUser.name) own to \(user.name) with \(newOwnTo.amount)")
        updateLedger(existing, newOwnTo: newOwnTo)
      }
      else {
        let newOwnTo: OwnTo = OwnTo(debtPerson: newCurrentUser, ownPerson: user, amount: positiveOffset)
        ledger.append(newOwnTo)
        print("Current user :\(curUser.name) own to \(user.name) with \(newOwnTo.amount)")
      }
    }
    
    currentUser = curUser
  }
  
  func login(name: String) {
    var hasUser = false
    for user in users where user.name == name {
      currentUser = user
      hasUser = true
      print("Hello, \(user.name)!")
      print("Your Balance is: \(user.balance)!\n")
      
      if let own = findOwnLedger() {
        for i in own {
          print("You: \(currentUser?.name ?? "") owe \(i.ownPerson.name): \(i.amount)")
        }
      }
      
      if let own = findOtherLedger() {
        for i in own {
          print("You: \(i.debtPerson.name) owe \(currentUser?.name ?? ""): \(i.amount)")
        }
      }
    }
    
    if !hasUser {
      createUser(name)
      login(name: name)
    }
  }
  
  func findUser(name: String) -> User? {
    for user in users where user.name == name {
      return user
    }
    return nil
  }
  
  func topUp(_ amount: Int) {
    guard let curUser = currentUser else { return print("Current user not established") }
    let oldUser = curUser
    let newBalance = curUser.balance + amount
    curUser.balance = newBalance
    
    print("New Balance for \(curUser.name) is : \(newBalance)")
    
    updateUser(oldUser, newUser: curUser)
    currentUser = curUser
    // check for current ownTo
    for own in self.ledger where own.debtPerson.name == curUser.name {
      if own.amount > 0 {
        let justPayAmountFlag = own.amount < curUser.balance
        createTransaction(own.ownPerson, amount: justPayAmountFlag ? own.amount : curUser.balance)
      }
    }
  }
  
  func updateUser(_ user: User, newUser: User) {
    guard let index = users.firstIndex(of: user) else { return print("Index out of bound, transaction failed for current user")}
    users[index] = user
  }
  
  func updateLedger(_ ownTo: OwnTo, newOwnTo: OwnTo) {
    guard let index = ledger.firstIndex(of: ownTo) else { return print("Index out of bound, transaction failed for current user")}
    if newOwnTo.amount == 0 {
      ledger.remove(at: index)
    }
    else {
      ledger[index] = newOwnTo
    }
  }
  
  func findLedger(_ selfName: String, ownToPersonName: String) -> OwnTo? {
    for own in self.ledger where own.debtPerson.name == selfName && own.ownPerson.name == ownToPersonName {
      return own
    }
    
    return nil
  }
  
  func findOwnLedger() -> [OwnTo]? {
    guard let curUser = currentUser else { return nil }
    return ledger.filter {$0.debtPerson.name == curUser.name }
  }
  
  func findOtherLedger() -> [OwnTo]? {
    guard let curUser = currentUser else { return nil }
    return ledger.filter {$0.ownPerson.name == curUser.name }
  }
  
  func validateOtherUserDebt(firstUser: User, otherUser: User) {
    currentUser = otherUser
    
    for own in self.ledger where own.debtPerson.name == otherUser.name {
      if own.amount > 0 {
        let justPayAmountFlag = own.amount < otherUser.balance
        createTransaction(own.ownPerson, amount: justPayAmountFlag ? own.amount : otherUser.balance)
      }
    }
    
    currentUser = firstUser
  }
}
