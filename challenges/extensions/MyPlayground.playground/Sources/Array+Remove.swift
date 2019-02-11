import Foundation

extension Array where Iterator.Element: Comparable {
    public mutating func remove(item: Element) {
        if let index = self.index(of: item) {
            self.remove(at: index)
        }
    }
}
