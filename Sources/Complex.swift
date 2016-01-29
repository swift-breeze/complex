// Copyright (c) 2016 David Turnbull
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and/or associated documentation files (the
// "Materials"), to deal in the Materials without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Materials, and to
// permit persons to whom the Materials are furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Materials.
//
// THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.


#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif


public protocol ArithmeticType : Hashable, SignedNumberType, FloatingPointType {
    init(_: Double)
    init(_: Float)
    func +(_: Self, _: Self) -> Self
    func -(_: Self, _: Self) -> Self
    func *(_: Self, _: Self) -> Self
    func /(_: Self, _: Self) -> Self
}
extension Double: ArithmeticType {
    public var i:Complex<Double> {
        return Complex<Double> (0,self)
    }
}
extension Float: ArithmeticType {
    public var i:Complex<Float> {
        return Complex<Float> (0,self)
    }
}


public struct Complex<T:ArithmeticType> : FloatLiteralConvertible, IntegerLiteralConvertible, Equatable {
    // Complex numbers are immutable
    public let real:T
    public let imag:T

    public init(_ real:T = 0, _ imag:T = 0) {
        self.real = real
        self.imag = imag
    }

    public init(_ x:Complex<Double>) {
        self.real = T(x.real)
        self.imag = T(x.imag)
    }

    public init(_ x:Complex<Float>) {
        self.real = T(x.real)
        self.imag = T(x.imag)
    }

    // Init from polar components
    public init(rho:T, theta:T) {
        self.real = rho * Complex.XXcos(theta)
        self.imag = rho * Complex.XXsin(theta)

    }

    public init(integerLiteral value:IntegerLiteralType) {
        self.real = T(value)
        self.imag = 0
    }

    public init(floatLiteral value:FloatLiteralType) {
        self.real = T(value)
        self.imag = 0
    }

    public var abs:T {
        return Complex.XXsqrt(real * real + imag * imag)
    }

    public var arg:T {
        return Complex.XXatan2(imag, real)
    }

    public var norm:T {
        let a = abs
        return a * a
    }

    public var conj:Complex<T> {
        return Complex<T>(real, -imag)
    }


    // Yuk... ??

    private static func XXcos(x:T) -> T {
        if let z = x as? Double {
            return cos(z) as! T
        }
        if let z = x as? Float {
            return cosf(z) as! T
        }
        preconditionFailure()
    }

    private static func XXsin(x:T) -> T {
        if let z = x as? Double {
            return sin(z) as! T
        }
        if let z = x as? Float {
            return sinf(z) as! T
        }
        preconditionFailure()
    }

    private static func XXsqrt(x:T) -> T {
        if let z = x as? Double {
            return sqrt(z) as! T
        }
        if let z = x as? Float {
            return sqrtf(z) as! T
        }
        preconditionFailure()
    }

    private static func XXatan2(x:T, _ y:T) -> T {
        if let z = x as? Double {
            return atan2(z, y as! Double) as! T
        }
        if let z = x as? Float {
            return atan2f(z, y as! Float) as! T
        }
        preconditionFailure()
    }

}


@warn_unused_result
public func==<T:ArithmeticType>(x:Complex<T>, y:Complex<T>) -> Bool {
    return x.real == y.real && x.imag == y.imag
}

@warn_unused_result
public prefix func -<T:ArithmeticType>(x: Complex<T>) -> Complex<T> {
    return Complex<T>(-x.real, -x.imag)
}

@warn_unused_result
public func +<T:ArithmeticType>(x1: Complex<T>, x2: Complex<T>) -> Complex<T> {
    return Complex<T>(x1.real + x2.real, x1.imag + x2.imag)
}

@warn_unused_result
public func +<T:ArithmeticType>(x1: Complex<T>, x2: T) -> Complex<T> {
    return Complex<T>(x1.real + x2, x1.imag)
}

@warn_unused_result
public func +<T:ArithmeticType>(x1: T, x2: Complex<T>) -> Complex<T> {
    return Complex<T>(x1 + x2.real, x2.imag)
}

// Allows for literals like `3+3.i`
@warn_unused_result
public func +<T:ArithmeticType>(x1: Int, x2: Complex<T>) -> Complex<T> {
    return Complex<T>(T(x1) + x2.real, x2.imag)
}

@warn_unused_result
public func -<T:ArithmeticType>(x1: Complex<T>, x2: Complex<T>) -> Complex<T> {
    return Complex<T>(x1.real - x2.real, x1.imag - x2.imag)
}

@warn_unused_result
public func -<T:ArithmeticType>(x1: Complex<T>, x2: T) -> Complex<T> {
    return Complex<T>(x1.real - x2, x1.imag)
}

@warn_unused_result
public func -<T:ArithmeticType>(x1: T, x2: Complex<T>) -> Complex<T> {
    return Complex<T>(x1 - x2.real, x2.imag)
}

@warn_unused_result
public func *<T:ArithmeticType>(x1: Complex<T>, x2: Complex<T>) -> Complex<T> {
    return Complex<T>(
        x1.real * x2.real - x1.imag * x2.imag,
        x1.imag * x2.real + x1.real * x2.imag
    )
}

@warn_unused_result
public func *<T:ArithmeticType>(x1: Complex<T>, x2: T) -> Complex<T> {
    return Complex<T>(x1.real * x2, x1.imag * x2)
}

@warn_unused_result
public func *<T:ArithmeticType>(x1: T, x2: Complex<T>) -> Complex<T> {
    return Complex<T>(x1 * x2.real, x1 * x2.imag)
}

@warn_unused_result
public func /<T:ArithmeticType>(x1: Complex<T>, x2: Complex<T>) -> Complex<T> {
    let cd = x2.real * x2.real + x2.imag * x2.imag
    return Complex<T>(
        (x1.real * x2.real + x1.imag * x2.imag) / cd,
        (x1.imag * x2.real - x1.real * x2.imag) / cd
    )
}

@warn_unused_result
public func /<T:ArithmeticType>(x1: Complex<T>, x2: T) -> Complex<T> {
    return Complex<T>(
        x1.real / x2,
        x1.imag / x2
    )
}

@warn_unused_result
public func /<T:ArithmeticType>(x1: T, x2: Complex<T>) -> Complex<T> {
    let cd = x2.real * x2.real + x2.imag * x2.imag
    return Complex<T>(
        (x1 * x2.real) / cd,
        (-x1 * x2.imag) / cd
    )
}
