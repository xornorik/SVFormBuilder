//
//  Section.swift
//  SVFormBuilder
//
//  Created by Srinivas Vemuri on 12/03/18.
//  Copyright © 2018 Srinivas Vemuri. All rights reserved.
//

import Foundation

public class SVSection {
    
    public var name = ""
    
    public var textColor = UIColor.black
    public var backgroundColor = UIColor.lightGray
    
    var rows:[SVRow] = [SVRow]()
    
    public func addRow(rowInit:(SVRow)->(SVRow)) {
        let row = rowInit(SVRow())
        rows.append(row)
    }
}
