import Foundation
import Vision

extension ImageScanner {
    /// Configuration for ImageScanner.
    public struct Configuration {
        /// Filter out matches below this confidence
        public let minimumConfidence: Float

        /// Use this to customize the VNRecognizeTextRequest
        public let modifyRequest: (inout VNRecognizeTextRequest) -> Void

        public init(minimumConfidence: Float = 0,
                    modifyRequest: @escaping (inout VNRecognizeTextRequest) -> Void = { _ in }) {
            self.minimumConfidence = minimumConfidence
            self.modifyRequest = modifyRequest
        }
    }
}

/// Ergonomics
extension ImageScanner.Configuration {
    public static var `default`: Self {
        .accurate
    }

    public static var accurate: Self {
        .init { $0.recognitionLevel = .accurate }
    }

    public static var fast: Self {
        .init { $0.recognitionLevel = .fast }
    }
}


