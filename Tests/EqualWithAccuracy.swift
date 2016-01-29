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


import XCTest
import Complex


func XCTAssertEqualWithAccuracy<T: ArithmeticType>(@autoclosure expression1: () -> Complex<T>, @autoclosure _ expression2: () -> Complex<T>, accuracy: T, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__)
{
    let e1 = expression1()
    let e2 = expression2()
    let dist = abs(accuracy.distanceTo(0))
    let msg = "\(e1) is not equal to \(e2) +/- (\(accuracy)) - \(message)"
    XCTAssert(
        abs(e1.real.distanceTo(e2.real)) <= dist &&
        abs(e1.imag.distanceTo(e2.imag)) <= dist,
        msg, file: file, line: line)
}
