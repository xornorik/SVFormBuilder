//
//  SVTextView.swift
//  SVFormBuilder
//
//  Created by Tijme Gommers on 07/03/18.
//  Copyright © 2018 Tijme Gommers. All rights reserved.
//

import UIKit

open class SVTextView: UITextView {
    
    private weak var userDelegate: UITextViewDelegate?
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initSVTextView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSVTextView()
    }
    
    override open var delegate: UITextViewDelegate? {
//        get { return userDelegate }
//        set { userDelegate = newValue }
        didSet {
            userDelegate = delegate
            super.delegate = self
        }
    }
    
    open override func layoutSubviews() {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    private func initSVTextView() {
        super.delegate = self
    }
    
    // Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    // The UITextView placeholder text
    @IBInspectable public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    // Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    // Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
    }
    
}

extension SVTextView : UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.userDelegate?.textViewDidBeginEditing?(self)
    }
    
    // When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    public func textViewDidChange(_ textView: UITextView) {
        
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
        self.userDelegate?.textViewDidChange?(self)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.userDelegate?.textViewShouldBeginEditing?(self) ?? true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.userDelegate?.textViewShouldEndEditing?(self) ?? true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.userDelegate?.textViewDidEndEditing?(self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.userDelegate?.textView?(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        self.userDelegate?.textViewDidChangeSelection?(self)
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.userDelegate?.textView?(self, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.userDelegate?.textView?(self, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
}
