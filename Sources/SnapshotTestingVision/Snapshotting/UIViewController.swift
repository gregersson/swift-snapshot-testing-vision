import UIKit
import SnapshotTesting

extension Snapshotting where Value == UIViewController, Format == StringWithDebugImage {

    public static func vision(
        strategy: TextCollectionStrategy<String> = .default,
        drawHierarchyInKeyWindow: Bool = false,
        size: CGSize? = nil,
        traits: UITraitCollection = .init()
    ) -> Snapshotting {
        Snapshotting<UIImage, StringWithDebugImage>.vision(
            strategy: strategy)
            .asyncPullback{ otherValue in
                Async { callback in
                    Snapshotting<UIViewController, UIImage>.image(
                        drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
                        size: size,
                        traits: traits)
                    .snapshot(otherValue).run { snap in
                        callback(snap)
                    }
                }
            }
    }

    public static var vision: Snapshotting {
        vision()
    }
}
