import Foundation
import VisionImageScan

/// Reduce the TextMatches to something more palatable.
public struct TextMatchReducer<T> {
    public let reduce: ([TextMatch]) -> T

    public init(reduce: @escaping ([TextMatch]) -> T) {
        self.reduce = reduce
    }
}

/// Ergonomics
extension TextMatchReducer {
    /// The default reducer returns a single string with a match on each line.
    public static var `default`: TextMatchReducer<String> {
        .init { matches in
            let matchesWithoutDiacritics = TextMatchReducer<Any>.stripDiacritics(matches: matches)
            let matchesSortedInLTRReadingOrder = TextMatchReducer<Any>.sortTopToBottomLeftToRight(matches: matchesWithoutDiacritics)

            // You get a line, you get a line.. EVERYBODY GETS A LINE!!
            return matchesSortedInLTRReadingOrder.map { match in
                match.text
            }.joined(separator: "\n")
        }
    }
}

/// Some convenience helpers that are used by default reducer.
extension TextMatchReducer where T == Any {

    public static func stripDiacritics(
        matches: [TextMatch]
    ) -> [TextMatch] {
        return matches.map { match in
            TextMatch(
                text: match.text
                    .applyingTransform(.stripDiacritics,
                                       reverse: false) ?? match.text,
                boundingBox: match.boundingBox)
        }
    }

    public static func sortTopToBottomLeftToRight(
        matches: [TextMatch]
    ) -> [TextMatch] {
        matches.sorted { a, b in
            let aBox = a.boundingBox
            let bBox = b.boundingBox
            let overlapsVertically = {
                let aFullWidth = aBox.union(
                    .init(x: -.infinity,
                          y: aBox.origin.y,
                          width: .infinity,
                          height: aBox.height))
                return aFullWidth.intersects(bBox)
            }()
            // Crude check to prioritise leftmost match
            // if an overlap is found.
            // TODO: Cluster vertically overlapping rects?
            if overlapsVertically {
                return aBox.origin.x < bBox.origin.x
            } else {
                return aBox.origin.y < bBox.origin.y
            }
        }
    }
}
