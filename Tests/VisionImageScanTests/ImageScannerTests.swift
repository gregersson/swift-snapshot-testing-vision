import XCTest
import SwiftUI
import SnapshotTesting

@testable import VisionImageScan

@available(iOS 16.0, *)
final class ImageScannerTests: XCTestCase {

    @MainActor func helloWorldImage() throws -> UIImage {
        let renderer = ImageRenderer(content: Text("Hello, world!").background(Color.white))
        let uiImage = try XCTUnwrap(renderer.uiImage)
        return uiImage
    }

    @MainActor func testAccurate() async throws {
        let uiImage = try helloWorldImage()
        let scanner = try XCTUnwrap(ImageScanner(image: uiImage,
                                                 configuration: .accurate))
        let texts = try await scanner.lookForTexts()
        assertSnapshot(of: texts, as: .dump)
    }

    @MainActor func testFast() async throws {
        let uiImage = try helloWorldImage()
        let scanner = try XCTUnwrap(ImageScanner(image: uiImage,
                                                 configuration: .fast))
        let texts = try await scanner.lookForTexts()
        assertSnapshot(of: texts, as: .dump)
    }

    @MainActor func testFastButPicky() async throws {
        let uiImage = try helloWorldImage()
        let scanner = try XCTUnwrap(ImageScanner(
            image: uiImage,
            configuration: .init(
                minimumConfidence: 0.95,
                modifyRequest: { $0.recognitionLevel = .fast})))
        let texts = try await scanner.lookForTexts()
        assertSnapshot(of: texts, as: .dump)
    }
}

extension ImageScanner {
    init?(image: UIImage,
          configuration: Configuration = .default) {
        guard let cgImage = image.cgImage
        else {
            return nil
        }
        self.init(requestHandler: .init(cgImage: cgImage),
                  imageSize: image.size,
                  configuration: configuration)
    }
}
