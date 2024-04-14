import Foundation

/// Represents a text match from ImageScanner
public struct TextMatch {
    public let text: String
    public let boundingBox: CGRect

    public init(text: String,
                boundingBox: CGRect) {
        self.text = text
        self.boundingBox = boundingBox
    }
}
