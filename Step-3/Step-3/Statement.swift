//
//  Statement.swift
//  Step-3
//
//  Created by Binoy Vijayan on 3/25/18.
//  Copyright © 2018 Binoy Vijayan. All rights reserved.
//

import Foundation

public class Statement{
    
    public func execute( _ iContext:RuntimeContext?)->Bool{ return false }
}

public class PrintStatement:Statement{
    
    var exp:Expression? = nil
    
    init(_ iExp:Expression){
        self.exp = iExp
    }
    
    override public func execute( _ iContext:RuntimeContext?)->Bool{
    
        let val  = exp?.evaluate(iContext)
        print("\(val!)")
        
        return true
    }
}

public class PrintLineStatement:Statement{
    
    var exp:Expression?
    
    init(_ iExp:Expression){
        self.exp = iExp
    }
    
    override public func execute( _ iContext:RuntimeContext?)->Bool{
        
        let val  = exp?.evaluate(iContext)
        print("\(val!)\n")
        
        return true
    }
}
