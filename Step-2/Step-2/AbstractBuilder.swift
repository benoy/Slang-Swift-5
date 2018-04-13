//
//  AbstractBuilder.swift
//  Step-2
//
//  Created by Binoy Vijayan on 3/25/18.
//  Copyright © 2018 Binoy Vijayan. All rights reserved.
//

import Foundation

public class AbstractBuilder{
    
}

public class ExpressionBuilder:AbstractBuilder{
    
    private var expStr:String = ""
    
    init( _ iExpStr:String){
        self.expStr = iExpStr
    }
    
    public var expression:Expression?{
        
        get{
            let rdParser = RDParser(self.expStr)
            return rdParser.callExpression()
        }
    }
}
