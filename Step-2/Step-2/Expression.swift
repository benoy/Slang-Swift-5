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

public enum Operator{
    case plus
    case minus
    case times
    case divide
}

public class RuntimeContext {
    
    public init() {}
}

public class Expression {
    
    init() {}
    
    func evaluate( _ iContext:RuntimeContext?) ->Double { return 0.0 }
}

public class NumericConstant:Expression{
    
    private var value:Double = 0
    
    init( _ iValue:Double){
        super.init()
        value = iValue
    }
    
    override func evaluate( _ iContext:RuntimeContext?)->Double {
    
        return value
    }
}


public class BinaryExpression:Expression{
    
    private var exp1:Expression?
    private var exp2:Expression?
    private var op :Operator?
    
    init(_ iExp1:Expression , _ iExp2:Expression, _ iOp:Operator){
       
        self.exp1 = iExp1
        self.exp2 = iExp2
        self.op = iOp
    }
    
    override func evaluate( _ iContext:RuntimeContext?)->Double {
        
        switch self.op! {
            case .plus:
                return exp1!.evaluate(iContext) + exp2!.evaluate(iContext)
            case .minus:
                return exp1!.evaluate(iContext) - exp2!.evaluate(iContext)
            case .times:
                return exp1!.evaluate(iContext) * exp2!.evaluate(iContext)
            case .divide:
                return exp1!.evaluate(iContext) / exp2!.evaluate(iContext)
        }
    }
}

public class UnaryExpression:Expression{
    
    private var exp:Expression?
    private var op :Operator?
    
    init(_ iExp:Expression , _ iOp:Operator){

        self.exp = iExp
        self.op = iOp
    }
    
    override func evaluate( _ iContext:RuntimeContext?)->Double {
        
        switch self.op! {
            case .plus:
                return exp!.evaluate(iContext)
            case .minus:
                return -(exp!.evaluate(iContext))
            default:
                return exp!.evaluate(iContext)
        }
    }
}

