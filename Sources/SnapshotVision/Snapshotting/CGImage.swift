import Foundation
import UIKit
import VisionImageScan
import CoreGraphics
import SnapshotTesting

extension Snapshotting where Value == CGImage, Format == StringWithDebugImage {
    public static func vision(
        strategy: TextCollectionStrategy<String> = .default
    ) -> Snapshotting {
        Snapshotting(
            pathExtension: "txt",
            diffing: Diffing<StringWithDebugImage>.visionLines,
            asyncSnapshot: { image in

                Async { callback in
                    Task {
                        let imageScanner = ImageScanner(
                            requestHandler: .init(cgImage: image),
                            imageSize: CGSize(width: image.width, height: image.height),
                            configuration: strategy.scannerConfiguration)
                        let texts = try await imageScanner.lookForTexts()

                        let debugImage = DiffingDebugImage {
                            DiffingDebugImage.render(
                                matches: texts,
                                on: UIImage(cgImage:image))
                        }

                        let diffableText = strategy.textMatchReducer.reduce(texts)
                        callback((diffableText, debugImage))
                    }
                }
            })
    }

    public static var vision: Snapshotting {
        vision()
    }
}
