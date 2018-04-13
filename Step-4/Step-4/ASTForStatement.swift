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

public class Statement{
    
    public func execute( _ irContext:RuntimeContext?)throws ->SymbolInfo?{ return nil }
}

public class PrintStatement:Statement{
    
    var exp:Expression? = nil
    
    init(_ iExp:Expression){
        self.exp = iExp
    }
    
    override public func execute( _ irContext:RuntimeContext?) throws ->SymbolInfo?{
    
        guard let val = try? exp?.evaluate(irContext) else{
            throw SlangError.undefinedSymbol
        }
        let typ = val!.type
        let str = typ == .string ? val!.string :(typ == .numeric ? "\(val!.double)" :( typ == .bool ?(  val!.bool == true ? "TRUE": "FALSE"): "" ) )
        print("\(str)")
        
        return nil
    }
}

public class PrintLineStatement:Statement{
    
    var exp:Expression?
    
    init(_ iExp:Expression){
        self.exp = iExp
    }

    override public func execute( _ irContext:RuntimeContext?)throws ->SymbolInfo?{
        
        guard let val = try? exp?.evaluate(irContext) else{
            throw SlangError.undefinedSymbol
        }
        let typ = val!.type
        let str = typ == .string ? val!.string :(typ == .numeric ? "\(val!.double)" :( typ == .bool ?(  val!.bool == true ? "TRUE": "FALSE"): "" ) )
        print("\(str)\n")
        
        return nil
    }
}

public class VariableDeclStatement:Statement{
    
    var symblInfo:SymbolInfo? =  nil
    var variable:Variable? = nil
    
    init(_ iSymbolInfo:SymbolInfo){
        self.symblInfo = iSymbolInfo
    }
    
    override public func execute( _ irContext:RuntimeContext?)throws ->SymbolInfo?{
        
        irContext?.sybolTable?.add(symblInfo!)
        variable = Variable(symblInfo!)
        
        return nil
    }
}

public class AssignmentStatement:Statement{

    private var variable:Variable?
    private var exp:Expression?
    
    init(_ iVariable:Variable , _ iExp:Expression){
        variable = iVariable
        exp = iExp
    }
    
    init(_ iSymbolInfo:SymbolInfo ,_ iExp:Expression){
        variable = Variable(iSymbolInfo)
        exp = iExp
    }
    
    override public func execute( _ irContext:RuntimeContext?)throws ->SymbolInfo?{
        
        guard let tempSymbol = try exp?.evaluate(irContext) else{
            throw SlangError.undefinedSymbol
        }
        irContext?.sybolTable?.assign(variable!, tempSymbol)
            
        return nil
    }
}


