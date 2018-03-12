//
//  SVForm.swift
//  SVFormBuilder
//
//  Created by Srinivas Vemuri on 12/03/18.
//  Copyright © 2018 Srinivas Vemuri. All rights reserved.
//

import Foundation

public final class SVForm {
    
    var sections : [SVSection] = [SVSection]()
    
    public func addSection(sectionInit:(SVSection)->(SVSection)) {
        let section = sectionInit(SVSection())
        sections.append(section)
    }
}
