import XCTest
import SnapshotTesting
@testable import SnapshotTestingVision
import SwiftUI
import VisionImageScan

@available(iOS 16.0, *)
final class SnapshotVisionTests: XCTestCase {

    var testView: some View {
        VStack {
            Text("Hello, world!")
            Text("Hello again.")
            HStack {
                Text("Left")
                Spacer()
                Text("Right")
            }
            Text("The quick brown fox jumps over the lazy dog")
            HStack {
                Spacer()
                Text("Good bye")
            }
        }
        .background(Color.white)
        .frame(width: 200, height: 200)
    }

    @MainActor
    func testSwiftUIView() async throws {
        assertSnapshot(of: testView, as: .vision)
    }

    @MainActor
    func testUIViewController() async throws {
        // Maybe cheating, but we are basically just checking that the
        // type is correctly resolved.
        assertSnapshot(of: UIHostingController(rootView: testView),
                       as: .vision)
    }

    @MainActor
    func testUIView() async throws {
        // Maybe cheating, but we are basically just checking that the
        // type is correctly resolved.
        assertSnapshot(of: UIHostingController(rootView: testView).view,
                       as: .vision)
    }

    @MainActor
    func testFast() async throws {
        assertSnapshot(of: testView,
                       as: .vision(
                        strategy: .init(scannerConfiguration: .fast,
                                        textMatchReducer: .default)))
    }

    @MainActor
    func testWithoutWhitespace() async throws {
        let strategy = TextCollectionStrategy(
            scannerConfiguration: .fast,
            textMatchReducer: .init(
                reduce: { matches in
                    let matchesWithoutDiacritics = TextMatchReducer.stripDiacritics(matches: matches)
                    let sorted = TextMatchReducer.sortTopToBottomLeftToRight(matches: matchesWithoutDiacritics)
                    return sorted.map { match in
                        match.text.filter{ !$0.isWhitespace }
                    }.joined(separator: "")
                }))
        assertSnapshot(of: testView,
                       as: .vision(strategy: strategy))
    }
}
