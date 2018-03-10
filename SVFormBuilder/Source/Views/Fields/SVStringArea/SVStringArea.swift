//
//  SVStringArea.swift
//  SVFormBuilder
//
//  Created by Srinivas Vemuri on 07/03/18.
//  Copyright © 2018 Srinivas Vemuri. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable open class SVStringArea: UIView {
    
    var view: UIView!
    
    @IBOutlet open var textView: SVTextView!
    @IBOutlet var fieldNameLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!
    
    @IBOutlet var hintLabelConstraint: NSLayoutConstraint!
    
    open var beginEditing: ((SVStringArea)->())?
    open var finishEditing: ((SVStringArea)->())?
    open var adjustHeightCallback:(()->())?
    
    open var fieldValue: String {
        get { return textView.text ?? "" }
        set { textView.text = fieldValue }
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
            textView.placeholder = placeholder
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
            textView.text = initialValue
        }
    }
    
    @IBInspectable var minLength: Int = 0
    @IBInspectable var maxLength: Int = 300
    
    @IBInspectable var isScrollEnabled: Bool = false {
        didSet {
            textView.isScrollEnabled = isScrollEnabled
        }
    }
    
    @IBInspectable open var enabled: Bool = true {
        didSet {
            enabled ? self.enable() : self.disable()
        }
    }
    
    @IBInspectable open var readOnly: Bool = false {
        didSet {
            textView.isEditable = !readOnly
        }
    }
    
    @IBInspectable open var textColor: UIColor = .black {
        didSet {
            textView.textColor = textColor
        }
    }
    
    @IBInspectable open var fieldNameColor: UIColor = .black {
        didSet {
            fieldNameLabel.textColor = fieldNameColor
        }
    }
    
    @IBInspectable open var hintLabelColor: UIColor = .lightGray {
        didSet {
            hintLabel.textColor = hintLabelColor
        }
    }
    
    @IBInspectable open var fieldBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.2) {
        didSet {
            textView.backgroundColor = fieldBackgroundColor
        }
    }
    
    open var keyboardType: UIKeyboardType = UIKeyboardType.default {
        didSet {
            textView.keyboardType = keyboardType
        }
    }
    
    open var accessoryView: UIView = UIView() {
        didSet {
            textView.inputAccessoryView = accessoryView
        }
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        hint.isEmpty ? hideHintLabel() : showHintLabel()
        self.textView.backgroundColor = fieldBackgroundColor
        self.textView.delegate = self
        self.textView.isScrollEnabled = false
    }
    
    func loadViewFromNib() -> UIView {
        
        let podBundle = Bundle(for: SVStringArea.self)
        let nib = UINib(nibName: "SVStringArea", bundle: podBundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
    }
    
//    init(formComponenet:FormComponent) {
//        super.init(frame: CGRect.zero)
//    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    @objc open func didFinishEditing() {
        textView.resignFirstResponder()
        finishEditing?(self)
    }
    
    open func enable() {
        self.layer.opacity = 1.0
        textView.isEditable = true
    }
    
    open func disable() {
        self.layer.opacity = 0.5
        textView.isEditable = false
    }
    
    open func isEnabled() -> Bool {
        return textView.isEditable
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
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.red.cgColor
    }
    
    fileprivate func hideValidationError() {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.clear.cgColor
    }
}

extension SVStringArea : UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        beginEditing?(self)
    }
    
    public func textViewDidChange(_ textView: UITextView) {

        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))

        // Resize only when size has changed
        if size.height != newSize.height {
            adjustHeightCallback?()
        }

        validateField(textEntered: textView.text) ? hideValidationError() : showValidationError()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxLength
    }
}

func ==(lhs: SVStringArea, rhs: SVStringArea) -> Bool {
    return (lhs.fieldName == rhs.fieldName)
}
