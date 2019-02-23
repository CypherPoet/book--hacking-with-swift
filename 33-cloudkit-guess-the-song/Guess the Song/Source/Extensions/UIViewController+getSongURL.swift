import UIKit

extension UIViewController {
    static func getSongURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("song.m4a")
    }
}
