//
//  main.swift
//  Step-3
//
//  Created by Binoy Vijayan on 3/25/18.
//  Copyright © 2018 Binoy Vijayan. All rights reserved.
//

import Foundation

var str:String = "PRINTLINE 2*10;" + "\n" + "PRINTLINE 10;\n PRINT 2*10;\n"
var parser = RDParser(str)
var list = parser.parse()
for stmt in list{
    _ = stmt.execute(nil)
}

str = "PRINTLINE -2*10;" + "\n" + "PRINTLINE -10*-1;\n PRINT 2*10;\n"
parser = RDParser(str)
list = parser.parse()
for stmt in list{
    _ = stmt.execute(nil)
}
