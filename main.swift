import Foundation

let lionelBank = LionelBank()
if CommandLine.argc < 2 {
  lionelBank.interactiveMode()
} else {
  lionelBank.staticMode()
}

