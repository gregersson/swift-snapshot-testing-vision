import UIKit
import struct VisionImageScan.TextMatch

public struct DiffingDebugImage {
    let generate: () -> UIImage?
}

extension DiffingDebugImage {
    public static var noImage: DiffingDebugImage = .init(generate: { nil })

    public static func render(matches: [TextMatch],
                on image: UIImage) -> UIImage {
        let size = image.size
        let renderer = UIGraphicsImageRenderer(size: size)

        let newImage = renderer.image { context in
            image.draw(at: .zero)
            for (index, match) in matches.enumerated() {
                UIColor.systemPink.withAlphaComponent(0.7).setStroke()
                // Draw the bounding box for each match
                context.stroke(match.boundingBox)

                // Draw the line number of each match
                let lineNumber = "\(index+1)"
                let textStyle = NSMutableParagraphStyle()
                textStyle.alignment = .center

                lineNumber.draw(in: match.boundingBox,
                                withAttributes: [
                                    .paragraphStyle: textStyle,
                                    .foregroundColor: UIColor.red,
                                    .backgroundColor: UIColor.white.withAlphaComponent(0.7)
                                ])
            }
        }
        return newImage
    }
}
