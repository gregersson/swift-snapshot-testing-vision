# 📸👀🤖 SnapshotVision

Snapshot testing your views based on what texts they contain.

This package runs text recognition using Apples Vision framework (https://developer.apple.com/documentation/vision/) 
and generates snapshot text files from views or viewcontrollers.

It is used as an extension to the PointFree SnapshotTesting package: https://github.com/pointfreeco/swift-snapshot-testing

## Why
Image based snapshot testing is great for testing visual components. But when you want to test a lot of views that 
only use components that are already pixel tested - using images for snapshotting is a bit redundant.
You will also get a lot of failures for the snapshot images of views when a common visual component changes.

Using text recognition on your views might not give you a perfect quality assurance, but it should serve as a robust 
minimum test. If some text is no longer visible in your view, something has probably gone wrong.

## Usage
SnapshotVision provides a .vision snapshotting strategy that fits into the assertSnapshot assertion from SnapshotTesting. 
The standard output is a text file with each line containing a text match of the view. 

Don't forget to specify a frame to your SwiftUI Views.

```swift
import XCTest
import SwiftUI
import SnapshotTesting
import SnapshotVision

class HelloWorldTests: XCTestCase {

    func testHelloWorld() throws {
        let view = Text("Hello world!")
            .frame(width: 100, height: 100)

        assertSnapshot(of: view, as: .vision)
    }
}
```

### Customization
It should be possible to customize mostly everything to your needs.

The .vision strategies are implemented as pullbacks of the image snapshot strategies of SnapshotTesting. In addition 
to the argument lists of the each original strategy, you can specify a TextCollectionStrategy.

The TextCollectionStrategy consists of two parts:
- ImageScanner.configuration: can be used to customize the VNRecognizeTextRequest passed to vision.
- TextMatchReducer: can be customized to change the behavior of reducing the textmatches into something diffable.

## Installation
You need SnapshotTesting for this, so follow their installation instructions:
https://github.com/pointfreeco/swift-snapshot-testing?tab=readme-ov-file#installation
And then add this package in the same way. :)

