import Foundation
import SnapshotTesting
import XCTest
import UIKit

extension Diffing where Value == StringWithDebugImage {

    public static var visionLines: Diffing {
        Diffing(
            toData: { stringWithDebugImage in
                // Ignore the debugimage and just convert the diffoutput
                Data(stringWithDebugImage.diffOutput.utf8)
            },

            fromData: { data in
                (diffOutput:String(decoding: data, as: UTF8.self),
                 debugImage: .noImage) // DebugImage is omitted from data.
            },

            diff: { old, new in
                guard var diff = Diffing<String>.lines.diff(old.0, new.0)
                else {
                    return .none
                }
                diff.0 = "Open image attachment to browse which texts where actually found\n" + diff.0
                if let attachmentImage = new.debugImage.generate(){
                    let attachment = XCTAttachment(image: attachmentImage)
                    attachment.name = "Actual matches annotated with line numbers"
                    diff.1.append(attachment)
                }
                return diff
            })
    }
}
