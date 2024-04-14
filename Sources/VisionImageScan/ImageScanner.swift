import Foundation
import Vision

/// Helper that looks for texts in images
public struct ImageScanner {
    let handler: VNImageRequestHandler
    let imageSize: CGSize
    let configuration: Configuration

    public init(requestHandler: VNImageRequestHandler,
                imageSize: CGSize,
                configuration: Configuration) {
        self.handler = requestHandler
        self.imageSize = imageSize
        self.configuration = configuration
    }

    /// Looks for texts and returns them. The TextMatches bounding boxes are mapped to the image dimensions.
    public func lookForTexts() async throws -> [TextMatch] {
        var request = VNRecognizeTextRequest()
        configuration.modifyRequest(&request)

        try self.handler.perform([request])

        guard let observations = request.results else {
            return []
        }

        let matches: [TextMatch] = observations.compactMap { observation in
            // Filter out low confidence matches
            let candidates = observation.topCandidates(10).filter { match in
                match.confidence >= configuration.minimumConfidence
            }

            guard let topTextCandidate = candidates.first?.string
            else {
                return nil
            }

            return .init(
                text: topTextCandidate,
                boundingBox: cgRect(observation: observation,
                                    in: imageSize))
        }

        return matches
    }

    private func cgRect(
        observation: VNRecognizedTextObservation,
        in imageSize: CGSize
    ) -> CGRect {
        return CGRect(x: observation.topLeft.x * imageSize.width,
                      y: imageSize.height - observation.topLeft.y * imageSize.height,
                      width: observation.boundingBox.width * imageSize.width,
                      height: observation.boundingBox.height * imageSize.height)
    }
}

