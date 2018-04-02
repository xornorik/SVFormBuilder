//
//  SVStringField.swift
//  SVFormBuilder
//
//  Created by Srinivas on 10/03/18.
//  Copyright © 2018 Srinivas. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable open class SVStringField: UIView {
    
    var view: UIView!
    
    @IBOutlet open var textField: UITextField!
    @IBOutlet var fieldNameLabel: UILabel!
    @IBOutlet var fieldIcon: UIImageView!
    @IBOutlet var hintLabel: UILabel!
    
    @IBOutlet var hintLabelConstraint: NSLayoutConstraint!
    @IBOutlet var fieldIconConstraint: NSLayoutConstraint!

    open var beginEditing: ((SVStringField)->())?
    open var finishEditing: ((SVStringField)->())?
    
    open var fieldValue: String {
        get { return textField.text ?? "" }
        set { textField.text = fieldValue }
    }
    
    open var isFieldMandatory: Bool = true
    open var regex: String?
    
    @IBInspectable var fieldName: String = "Field Name" {
        didSet {
            fieldNameLabel.text = fieldName
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var hint: String = "" {
        didSet {
            showHintLabel()
            hintLabel.text = hint
        }
    }
    
    @IBInspectable var initialValue: String = "" {
        didSet {
            textField.text = initialValue
        }
    }
    
    @IBInspectable var minLength: Int = 0
    @IBInspectable var maxLength: Int = 300
    
    @IBInspectable open var enabled: Bool = true {
        didSet {
            enabled ? self.enable() : self.disable()
        }
    }
    
    @IBInspectable open var readOnly: Bool = false {
        didSet {
            textField.isEnabled = !readOnly
        }
    }
    
    @IBInspectable open var textColor: UIColor = .black {
        didSet {
            textField.textColor = textColor
        }
    }
    
    @IBInspectable open var fieldNameColor: UIColor = .black {
        didSet {
            fieldNameLabel.textColor = fieldNameColor
        }
    }
    
    @IBInspectable open var hintLabelColor: UIColor = .darkGray {
        didSet {
            hintLabel.textColor = hintLabelColor
        }
    }
    
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            textField.addBorderWithColor(borderWidth: 1, borderColor: borderColor)
        }
    }
    
    @IBInspectable open var fieldBackgroundColor: UIColor = UIColor.clear {
        didSet {
            textField.backgroundColor = fieldBackgroundColor
        }
    }
    
    open var keyboardType: UIKeyboardType = UIKeyboardType.default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    open var accessoryView: UIView = UIView() {
        didSet {
            textField.inputAccessoryView = accessoryView
        }
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        hint.isEmpty ? hideHintLabel() : showHintLabel()
        self.textField.backgroundColor = fieldBackgroundColor
        //Offset text by 5px from border
        self.textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.textField.delegate = self
    }
    
    func loadViewFromNib() -> UIView {
        
        let podBundle = Bundle(for: SVStringField.self)
        let nib = UINib(nibName: "SVStringField", bundle: podBundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
        init(formComponent:FormComponent) {
            super.init(frame: CGRect.zero)
            
            if let formComponent = formComponent as? TextFC {
                self.fieldValue = formComponent.fieldName
                self.isFieldMandatory = formComponent.isMandatory
                self.placeholder = formComponent.placeholder
                self.hint = formComponent.hint
                //TODO: Complete
            }
        }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    @objc open func didFinishEditing() {
        textField.resignFirstResponder()
        finishEditing?(self)
    }
    
    open func enable() {
        self.layer.opacity = 1.0
        textField.isEnabled = true
    }
    
    open func disable() {
        self.layer.opacity = 0.5
        textField.isEnabled = false
    }
    
    open func isEnabled() -> Bool {
        return textField.isEnabled
    }
    
    open func validateField(textEntered:String) -> Bool {
        
        func basicValidation() -> Bool {
            guard isFieldMandatory == true else {return true}
            return textEntered.count > minLength
        }
        
        guard let regexString = self.regex else {
            return basicValidation()
        }
        
        let regexTest = NSPredicate(format:"SELF MATCHES %@", regexString)
        return regexTest.evaluate(with: textEntered) && basicValidation()
    }
    
    fileprivate func showHintLabel() {
        hintLabelConstraint.priority = UILayoutPriority(rawValue: 600)
    }
    
    fileprivate func hideHintLabel() {
        hintLabelConstraint.priority = UILayoutPriority(rawValue: 999)
    }
    
    fileprivate func showValidationError() {
        textField.addBorderWithColor(borderWidth: 1, borderColor: .red)
    }
    
    fileprivate func hideValidationError() {
        textField.addBorderWithColor(borderWidth: 1, borderColor: borderColor)
    }
}

extension SVStringField : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        beginEditing?(self)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateField(textEntered: textField.text ?? "") ? hideValidationError() : showValidationError()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= maxLength
    }
}

func ==(lhs: SVStringField, rhs: SVStringField) -> Bool {
    return (lhs.fieldName == rhs.fieldName)
}
