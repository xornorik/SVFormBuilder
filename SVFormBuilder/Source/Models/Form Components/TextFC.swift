//
//  TextFC.swift
//  SVFormBuilder
//
//  Created by Srinivas Vemuri on 12/03/18.
//  Copyright © 2018 Srinivas Vemuri. All rights reserved.
//

import Foundation

public enum FormComponentStyle {
    case underlined
    case bordered
}

public class TextFC : FormComponent {
    
    public var placeholder = ""
    public var fieldIcon = ""
    
    public var minLength = 0
    public var maxLength = 300
    
    public var textColor = UIColor.black
    public var backgroundColor = UIColor.clear
    public var style = FormComponentStyle.underlined
    public var borderLineColor = UIColor.black
    
}
