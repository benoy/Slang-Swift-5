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

public class Expression {
    
    init() { }
    func evaluate( _ irContext:RuntimeContext?) throws -> SymbolInfo? { return nil }
    func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo { return .illegal}
    func getType()-> TypeInfo { return .illegal }
    func compile( _ egContext:ExeGenContext?)->Bool{ return false }
}

public class BooleanConstant:Expression{
    
    private var symbolInfo:SymbolInfo? = nil
    private var type:TypeInfo = .illegal

    init( _ iValue:Bool){
        symbolInfo = SymbolInfo()
        symbolInfo?.bool = iValue
        symbolInfo?.type = .bool
    }
    
    override func evaluate( _ irContext:RuntimeContext?)->SymbolInfo? {
        
        return symbolInfo
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo {
        
        type = symbolInfo?.type ?? .illegal
        return type
    }
    
    override func getType()-> TypeInfo {

        return type
    }
    
    override func compile( _ egContext:ExeGenContext?)->Bool{
    
    }
}

public class NumericConstant:Expression{
    
    private var symbolInfo:SymbolInfo? = nil
    private var type:TypeInfo = .illegal
    
    init( _ iValue:Double){
        symbolInfo = SymbolInfo()
        symbolInfo?.double = iValue
        symbolInfo?.type = .numeric
    }
    
    override func evaluate( _ irContext:RuntimeContext?)->SymbolInfo? {
        
        return symbolInfo
    }
    
    override func typeCheck(_ icContext:CompilationContext?)throws -> TypeInfo {
        
        type = symbolInfo?.type ?? .illegal
        return type
    }
    
    override func getType()-> TypeInfo {
        
        return type
    }
}

public class StringLitteral:Expression{
   
    private var symbolInfo:SymbolInfo? = nil
    private var type:TypeInfo = .illegal
    
    init( _ iValue:String){
        symbolInfo = SymbolInfo()
        symbolInfo?.string = iValue
        symbolInfo?.type = .string
    }
    
    override func evaluate( _ irContext:RuntimeContext?)->SymbolInfo? {
        
        return symbolInfo
    }
    
    override func typeCheck(_ icContext:CompilationContext?)throws -> TypeInfo {
        
        type = symbolInfo?.type ?? .illegal

        return type
    }
    
    override func getType()-> TypeInfo {
        
        return type
    }
}

public class Variable:Expression{
    
    public var name:String = ""
    private var type:TypeInfo = .illegal
    
    init( _ symbolInfo:SymbolInfo){
        self.name = symbolInfo.name
    }
    
    init( _ icContext:CompilationContext , _ iName:String , _ iValue:Double){
        
        let symbolInfo = SymbolInfo()
        symbolInfo.name = iName
        symbolInfo.type = .numeric
        symbolInfo.double = iValue
        icContext.sybolTable?.add(symbolInfo)
        self.name = iName
    }
    
    init( _ icContext:CompilationContext , _ iName:String , _ iValue:Bool){
        
        let symbolInfo = SymbolInfo()
        symbolInfo.name = iName
        symbolInfo.type = .bool
        symbolInfo.bool = iValue
        icContext.sybolTable?.add(symbolInfo)
        self.name = iName
    }
    
    init( _ icContext:CompilationContext , _ iName:String , _ iValue:String){
        
        let symbolInfo = SymbolInfo()
        symbolInfo.name = iName
        symbolInfo.type = .string
        symbolInfo.string = iValue
        icContext.sybolTable?.add(symbolInfo)
        self.name = iName
    }
    
    override func evaluate( _ irContext:RuntimeContext?)->SymbolInfo? {
        
        return irContext?.sybolTable?.get(name) ?? nil
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws-> TypeInfo {
        
        type = icContext?.sybolTable?.get(name).type ?? .illegal
        
        return type
    }
    
    override func getType()-> TypeInfo {

        return type
    }
}

public class BinaryPlus:Expression{
    
    private var exp1:Expression?
    private var exp2:Expression?
    private var type:TypeInfo = .illegal
    
    init( _ iExp1:Expression , _ iExp2:Expression){

        self.exp1 = iExp1
        self.exp2 = iExp2
    }
    
    override func evaluate( _ irContext:RuntimeContext?) throws ->SymbolInfo? {
        
        let evalLeft = try exp1?.evaluate(irContext)
        let rightLeft = try exp2?.evaluate(irContext)
        
        if evalLeft?.type == .numeric && rightLeft?.type == .numeric {
            let retSymbolInfo = SymbolInfo()
            retSymbolInfo.type = .numeric
            retSymbolInfo.double = (evalLeft?.double)! + (rightLeft?.double)!
            
            return retSymbolInfo
        }else if evalLeft?.type == .string && rightLeft?.type == .string {
            let retSymbolInfo = SymbolInfo()
            retSymbolInfo.type = .string
            retSymbolInfo.string = (evalLeft?.string)! + (rightLeft?.string)!
            
            return retSymbolInfo
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo {
        
        let leftType = try exp1?.typeCheck(icContext)
        let rightType = try exp1?.typeCheck(icContext)
        if leftType == rightType && (leftType == .numeric ||  leftType == .string) {
            type = leftType!
            
            return type
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func getType()-> TypeInfo {
     
        return type
    }
}

public class BinaryMinus:Expression{
    
    private var exp1:Expression?
    private var exp2:Expression?
    private var type:TypeInfo = .illegal
    
    init( _ iExp1:Expression , _ iExp2:Expression){
        self.exp1 = iExp1
        self.exp2 = iExp2
    }
    
    override func evaluate( _ irContext:RuntimeContext?) throws ->SymbolInfo? {
        
        let evalLeft = try exp1?.evaluate(irContext)
        let rightLeft = try exp2?.evaluate(irContext)
        
        if evalLeft?.type == .numeric && rightLeft?.type == .numeric {
            let retSymbolInfo = SymbolInfo()
            retSymbolInfo.type = .numeric
            retSymbolInfo.double = (evalLeft?.double)! - (rightLeft?.double)!
            
            return retSymbolInfo
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo {
        
        let leftType = try exp1?.typeCheck(icContext)
        let rightType = try exp1?.typeCheck(icContext)
        if leftType == rightType && leftType == .numeric {
            type = leftType!
            
            return type
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func getType()-> TypeInfo {
        
        return type
    }
}

public class Multiplication:Expression{
    
    private var exp1:Expression?
    private var exp2:Expression?
    private var type:TypeInfo = .illegal
    
    init( _ iExp1:Expression , _ iExp2:Expression){
        self.exp1 = iExp1
        self.exp2 = iExp2
    }
    
    override func evaluate( _ irContext:RuntimeContext?) throws ->SymbolInfo? {
        
        let evalLeft = try exp1?.evaluate(irContext)
        let rightLeft = try exp2?.evaluate(irContext)
        
        if evalLeft?.type == .numeric && rightLeft?.type == .numeric {
            let retSymbolInfo = SymbolInfo()
            retSymbolInfo.type = .numeric
            retSymbolInfo.double = (evalLeft?.double)! * (rightLeft?.double)!
            
            return retSymbolInfo
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo {
        
        let leftType = try exp1?.typeCheck(icContext)
        let rightType = try exp1?.typeCheck(icContext)
        if leftType == rightType && leftType == .numeric {
            type = leftType!
            
            return type
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func getType()-> TypeInfo {
        
        return type
    }
}

public class Division:Expression{
    
    private var exp1:Expression?
    private var exp2:Expression?
    private var type:TypeInfo = .illegal
    
    init( _ iExp1:Expression , _ iExp2:Expression){
        self.exp1 = iExp1
        self.exp2 = iExp2
    }
    
    override func evaluate( _ irContext:RuntimeContext?) throws ->SymbolInfo? {
        
        let evalLeft = try exp1?.evaluate(irContext)
        let rightLeft = try exp2?.evaluate(irContext)
        
        if evalLeft?.type == .numeric && rightLeft?.type == .numeric {
            let retSymbolInfo = SymbolInfo()
            retSymbolInfo.type = .numeric
            retSymbolInfo.double = (evalLeft?.double)! / (rightLeft?.double)!
            
            return retSymbolInfo
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo {
        
        let leftType = try exp1?.typeCheck(icContext)
        let rightType = try exp1?.typeCheck(icContext)
        if leftType == rightType && leftType == .numeric {
            type = leftType!
            
            return type
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func getType()-> TypeInfo {
        
        return type
    }
}


public class UnaryPlus:Expression{
    
    private var exp:Expression?
    private var type:TypeInfo = .illegal
    
    init(_ iExp:Expression ){
        self.exp = iExp
    }
    
    override func evaluate( _ irContext:RuntimeContext?) throws ->SymbolInfo? {
        
        let eval = try exp?.evaluate(irContext)
        
        if eval?.type == .numeric{
            let retSymbolInfo = SymbolInfo()
            retSymbolInfo.type = .numeric
            retSymbolInfo.double = (eval?.double)!
            
            return retSymbolInfo
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo {
        
        let leftType = try exp?.typeCheck(icContext)
        
        if leftType == .numeric {
            type = leftType!
            
            return type
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func getType()-> TypeInfo {
        
        return type
    }
}

public class UnaryMinus:Expression{
    
    private var exp:Expression?
    private var type:TypeInfo = .illegal
    
    init(_ iExp:Expression ){
        self.exp = iExp
    }
    
    override func evaluate( _ irContext:RuntimeContext?) throws ->SymbolInfo? {
        
        let eval = try exp?.evaluate(irContext)
        
        if eval?.type == .numeric{
            let retSymbolInfo = SymbolInfo()
            retSymbolInfo.type = .numeric
            retSymbolInfo.double = -(eval?.double)!
            
            return retSymbolInfo
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func typeCheck(_ icContext:CompilationContext?) throws -> TypeInfo {
        
        let leftType = try exp?.typeCheck(icContext)
        
        if leftType == .numeric {
            type = leftType!
            
            return type
        }else{
            throw SlangError.typeMismatchError
        }
    }
    
    override func getType()-> TypeInfo {
        
        return type
    }
}

