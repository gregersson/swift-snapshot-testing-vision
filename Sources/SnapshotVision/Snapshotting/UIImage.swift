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
                            // TODO: no force unwrap?
                            callback(snap.cgImage!)
                        }
                }
            }
    }

    public static var vision: Snapshotting {
        vision()
    }
}
