import UIKit

var str = "Hello, playground"
var abc = "abc"
print(Array(str))

extension String {
    func check() -> Bool {
        let allCharacters = Array(self)
        if Set(allCharacters).count == allCharacters.count {
            return true
        } else {
            return false
        }
    }
}

print(str.check())
print(abc.check())
