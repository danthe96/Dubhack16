import UIKit

class CustomNavigationController: UINavigationController {
    
    override func shouldAutorotate() -> Bool {
        if !viewControllers.isEmpty {
            
            // Check if this ViewController is the one you want to disable roration on
            if topViewController!.isKindOfClass(BattleViewController) {               //ViewController is the name of the topmost viewcontroller
                
                // If true return false to disable it
                return false
            }
        }
        
        // Else normal rotation enabled
        return true
    }}

