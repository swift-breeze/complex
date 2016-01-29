# Complex

Complex is a module for numbers with an imaginary element.

To use, include dependency in your `Package.swift`:
```swift
let package = Package(
    dependencies: [
        .Package(url: "https://github.com/swift-breeze/complex.git", majorVersion: 1)
    ]
)
```
Then add to your swift program:
```swift
import Complex
```

## The basics

Some initializers:
```swift
let a = Complex(3.14, 2.72)
let b = Complex<Float>(3.14 + 2.72.i)
let c = 3.14 + 2.72.i
let d = 3+3.i
```

Complex numbers are immutable in this implementation. You can reassign the entire
number but there is no method to change only the real or imaginary elements.
```swift
var a = Complex(3.14, 2.72)
a = 3+3.i
a.real = 99 // Won't compile
```
