//
//  FormComponent.swift
//  SVFormBuilder
//
//  Created by Srinivas Vemuri on 05/03/18.
//  Copyright © 2018 Srinivas Vemuri. All rights reserved.
//

import Foundation

public class FormComponent {
    
    public var fieldName : String = "Field Name"
    public var fieldValue : String = ""
    public var hint : String = ""
    
    public var fieldNameAllignment : CTTextAlignment = .left
    public var fieldNameColor : UIColor = .black
    public var hintColor : UIColor = .lightGray
    
    public var isMandatory : Bool = true
    public var isReadOnly : Bool = false
    public var isEnabled : Bool = true
    public var isValidationPassed : Bool = false
}
