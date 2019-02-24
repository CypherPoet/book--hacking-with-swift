import UIKit

extension UIViewController {
    static func getSoundURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("sound.m4a")
    }
}
