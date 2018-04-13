////////////////////////////////////////////////////////
//
//  This software is released as per the clauses of MIT License
//
//
//  The MIT License
//
//  Copyright (c) 2016, Binoy Vijayan.
//
//                      benoy.apple@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//

import Foundation

let path1 = "/Users/binoyvijayan/Binoy/Experiments/SLANG-Tutorial/Step-4/script/First.sl"
let path2 = "/Users/binoyvijayan/Binoy/Experiments/SLANG-Tutorial/Step-4/script/Second.sl"
let path3 = "/Users/binoyvijayan/Binoy/Experiments/SLANG-Tutorial/Step-4/script/Third.sl"

let cContext = CompilationContext()
let rContext = RuntimeContext()

var slanfScript1 =  try? String(contentsOfFile: path1)
var rdParser1 = RDParser(slanfScript1!)
var stmts1 = rdParser1.parse(cContext)
for stmt in stmts1{
   _ = try? stmt.execute(rContext)
}

//var slanfScript2 =  try? String(contentsOfFile: path2)
//var rdParser2 = RDParser(slanfScript2!)
//var stmts2 = rdParser2.parse(cContext)
//for stmt in stmts2{
//    _ = try? stmt.execute(rContext)
//}
//
//var slanfScript3 =  try? String(contentsOfFile: path3)
//var rdParser3 = RDParser(slanfScript3!)
//var stmts3 = rdParser3.parse(cContext)
//for stmt in stmts3{
//    _ = try? stmt.execute(rContext)
//}



