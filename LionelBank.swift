/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

enum OptionType: String {
  case login = "login"
  case topup = "topup"
  case pay = "pay"
  case quit = "quit"
  case unknown
  
  init(value: String) {
    switch value {
    case "topup": self = .topup
    case "login": self = .login
    case "pay": self = .pay
    case "quit": self = .quit
    default: self = .unknown
    }
  }
}

class LionelBank {
  static let sharedInstance = BankSharedInstanceManager()
  let consoleIO = ConsoleIO()
  
  func staticMode() {
    
  }
  
  func getOption(_ userString: String) -> (option:OptionType, value: String) {
    if userString.hasPrefix(OptionType.login.rawValue) {
      return (.login, userString)
    }
    else if userString.hasPrefix(OptionType.topup.rawValue) {
      return (.topup, userString)
    }
    else if userString.hasPrefix(OptionType.pay.rawValue) {
      return (.pay, userString)
    }
    else if userString.hasPrefix(OptionType.quit.rawValue) {
      return (.quit, userString)
    }
    
    return (.unknown, userString)
  }
  
  func interactiveMode() {
    consoleIO.writeMessage("______ Welcome to Lionel Bank Command Line Interface ______")
    var shouldQuit = false
    while !shouldQuit {
      let (option, value) = getOption(consoleIO.getInput())
      switch option {
      case .topup:
        let filteredString = value.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: OptionType.topup.rawValue, with: "")
        let amount = filteredString.westernArabicNumeralsOnly
        consoleIO.writeMessage("TOPUP FLOW\n")
        if let intAmount = Int(amount) {
          LionelBank.sharedInstance.topUp(intAmount)
        }
      case .login:
        consoleIO.writeMessage("LOGIN FLOW\n")
        let filteredString = value.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: OptionType.login.rawValue, with: "")
        LionelBank.sharedInstance.login(name: filteredString)
      case .pay:
        consoleIO.writeMessage("PAY FLOW\n")
        let filteredString = value.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: OptionType.pay.rawValue, with: "")
        let amount = filteredString.westernArabicNumeralsOnly
        let userString = filteredString.replacingOccurrences(of: amount, with: "")
        if let user = LionelBank.sharedInstance.findUser(name: userString), let intBalance = Int(amount) {
          LionelBank.sharedInstance.createTransaction(user, amount: intBalance)
        }
        else {
          consoleIO.writeMessage("\(userString) does not exist. Transaction cancelled")
        }
      case .quit:
        shouldQuit = true
      default:
        consoleIO.writeMessage("Unknown option \(value)", to: .error)
      }
    }
  }
}
