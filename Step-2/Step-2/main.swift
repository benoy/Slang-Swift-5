//
//  main.swift
//  Step-2
//
//  Created by Binoy Vijayan on 3/25/18.
//  Copyright © 2018 Binoy Vijayan. All rights reserved.
//

import Foundation


let expBldr = ExpressionBuilder("-2*(3+3)")
let exp = expBldr.expression
print("\(exp?.evaluate(nil) ?? 0)")


