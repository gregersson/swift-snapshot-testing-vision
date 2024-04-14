import Foundation
import VisionImageScan

/// Configuration object  used for snapshotting text gathered using vision.
public struct TextCollectionStrategy<T> {
    public let scannerConfiguration: ImageScanner.Configuration
    public let textMatchReducer: TextMatchReducer<T>

    public init(scannerConfiguration: ImageScanner.Configuration,
                textMatchReducer: TextMatchReducer<T>) {
        self.scannerConfiguration = scannerConfiguration
        self.textMatchReducer = textMatchReducer
    }
}

extension TextCollectionStrategy {
    /// Collect all string matches and reduce them to a single string
    public static var `default`: TextCollectionStrategy<String> {
        .init(scannerConfiguration: .default,
              textMatchReducer: .default)
    }
}
