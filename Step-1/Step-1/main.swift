//
//  main.swift
//  Step-1
//
//  Created by Binoy Vijayan on 2/12/18.
//  Copyright © 2018 SAS Groupe. All rights reserved.
//

import Foundation

var exp:Expression = BinaryExpression(NumericConstant(5) , NumericConstant(10), .plus)
print("\(exp.evaluate(nil))")

exp = UnaryExpression( BinaryExpression(exp , NumericConstant(20) , .times ) , .minus) 
print("\(exp.evaluate(nil))")
