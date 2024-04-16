import UIKit
import SnapshotTesting

extension Snapshotting where Value == UIImage, Format == StringWithDebugImage {
    public static func vision(
        strategy: TextCollectionStrategy<String> = .default
    ) -> Snapshotting {
        Snapshotting<CGImage, StringWithDebugImage>.vision(
            strategy: strategy)
            .asyncPullback { otherValue in
                Async { callback in
                    Snapshotting<UIImage, UIImage>
                        .image()
                        .snapshot(otherValue).run { snap in
                            guard let image = snap.cgImage
                            else {
                                fatalError("Failed to get CGImage from UIImage: \(snap)")
                            }
                            callback(image)
                        }
                }
            }
    }

    public static var vision: Snapshotting {
        vision()
    }
}
