import SnapshotTesting
import SwiftUI

extension Snapshotting where Value: SwiftUI.View, Format == StringWithDebugImage {
    public static func vision(
        strategy: TextCollectionStrategy<String> = .default,
        drawHierarchyInKeyWindow: Bool = false,
        layout: SwiftUISnapshotLayout = .sizeThatFits,
        traits: UITraitCollection = .init()
    ) -> Snapshotting {
        Snapshotting<UIImage, StringWithDebugImage>.vision(
            strategy: strategy)
            .asyncPullback{ otherValue in
                Async { callback in
                    Snapshotting<Value, UIImage>.image(
                        drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
                        layout: layout,
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
