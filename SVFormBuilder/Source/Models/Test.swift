//
//  Test.swift
//  SVFormBuilder
//
//  Created by Srinivas Vemuri on 12/03/18.
//  Copyright © 2018 Srinivas Vemuri. All rights reserved.
//

import Foundation

class Test {
    
    let form = SVForm()
    
    func doSomething() {
        form.addSection { (section) -> (SVSection) in
            section.name = "First Section"
            section.backgroundColor = UIColor.black
            section.textColor = UIColor.white
            
            section.addRow(rowInit: { (row) -> (SVRow) in
                let textFC = TextFC()
                textFC.fieldName = "Enter your name"
                row.formComponent = textFC
                return row
            })
            
            return section
        }
    }
}
