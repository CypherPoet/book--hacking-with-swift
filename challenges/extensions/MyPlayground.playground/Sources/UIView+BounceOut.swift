import UIKit

// Uses animation to scale its size down to
// 0.0001 over a specified number of seconds.
extension UIView {
    public func bounceOut(duration: TimeInterval) {
        UIView.animate(
            withDuration: duration,
            animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            }
        )
    }
}
