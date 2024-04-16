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

                let fontSize = match.boundingBox.height * 0.7

                let nameTextAttributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                ]
                let nameTextSize = lineNumber.size(withAttributes: nameTextAttributes)

                let rect = CGRect(origin: .init(x: match.boundingBox.midX - nameTextSize.width/2.0,
                                                y: match.boundingBox.midY - nameTextSize.height/2.0),
                                  size: nameTextSize)

                lineNumber.draw(in: rect,
                                withAttributes: [
                                    .font: UIFont.systemFont(ofSize: fontSize),
                                    .foregroundColor: UIColor.red,
                                    .backgroundColor: UIColor.white.withAlphaComponent(0.9)
                                ])
            }
        }
        return newImage
    }
}
