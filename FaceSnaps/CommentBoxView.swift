//
//  CommentBoxView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

// This class contains the form and submit button, as well as the textView delegate methods for the comment form
class CommentBoxView: UIView {
    
    var height: NSLayoutConstraint!
    
    let placeholder = "Add a comment..."
    
    var delegate: CommentSubmissionDelegate!
    
    let divider: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    lazy var commentTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = true
        tv.font = .systemFont(ofSize: 14.0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.contentInset = UIEdgeInsetsMake(-4,-4,0,0)
        tv.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        tv.isScrollEnabled = false
        tv.keyboardType = .twitter
        return tv
    }()
    
    var commentTextViewHeight: NSLayoutConstraint!
    
    func setPlaceholder() {
        commentTextView.text = placeholder
        commentTextView.textColor = .lightGray
    }
    
    func setTextPosToBeginning(textView: UITextView) {
        DispatchQueue.main.async {
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    var lastLine: Float =  1
    
    lazy var postButton: UIButton = {
        let btn = UIButton()
        let darkBlue = UIColor(red: 56/255.0, green: 151/255.0, blue: 240/255.0, alpha: 1.0)
        let lightBlue = UIColor(red: 180/255.0, green: 218/255.0, blue: 255/255.0, alpha: 1.0)
        btn.setTitleColor(darkBlue, for: .normal)
        btn.setTitleColor(lightBlue, for: .disabled)
        btn.setTitleColor(lightBlue, for: .highlighted)
        btn.setTitle("Post", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
        btn.addTarget(self, action: #selector(handlePostComment), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        return btn
    }()
    
    convenience init(delegate: CommentSubmissionDelegate) {
        self.init()
        self.delegate = delegate
        
        setPlaceholder()
        
        height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 52.0)
        
        commentTextViewHeight = NSLayoutConstraint(item: commentTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        addSubview(divider)
        addSubview(commentTextView)
        addSubview(postButton)
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            divider.leftAnchor.constraint(equalTo: leftAnchor),
            divider.rightAnchor.constraint(equalTo: rightAnchor),
            divider.topAnchor.constraint(equalTo: topAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            commentTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            commentTextView.centerYAnchor.constraint(equalTo: centerYAnchor),
            commentTextView.widthAnchor.constraint(equalToConstant: frame.width - 72),
            commentTextViewHeight,
            postButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            postButton.leftAnchor.constraint(equalTo: commentTextView.rightAnchor, constant: 12),
        ])
        
    }
    
    func handlePostComment() {
        delegate.didSubmitComment(withText: commentTextView.text)
    }
    
    func togglePostButton(enabled: Bool) {
        postButton.isEnabled = enabled
    }
    
    func showKeyboard() {
        commentTextView.becomeFirstResponder()
    }
    
    func sizeTextView() {
        let fittingSize = CGSize(width: commentTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let size = commentTextView.sizeThatFits(fittingSize)
        commentTextViewHeight.constant = size.height
        commentTextView.setContentOffset(.zero, animated: false)
    }
    
}

// MARK: - UITextViewDelegate
extension CommentBoxView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = commentTextView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let maxHeight: CGFloat = 103.5
        var newFrame = textView.frame
        let height = min(maxHeight, newSize.height)
        newFrame.size = CGSize(width: fixedWidth, height: height)
        
        if newSize.height > maxHeight {
            commentTextView.isScrollEnabled = true
        } else {
            commentTextView.isScrollEnabled = false
        }

        // Do not grow textView if we're going from 6 -> 7
        adjustTextViewHeight(newFrame: newFrame)
        
        lastLine = textView.numLines()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            setTextPosToBeginning(textView: textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            // We have text, do not show the placeholder
            // Now check if the only text is the placeholder and remove it if needed
            // Unless theyve hit the delete btton with the placeholder displayed
            if textView.text == placeholder {
                if text.utf16.count == 0 {
                    // Back button hit
                    return false // ignore backbutton
                }
                textView.textColor = .black
                textView.text = ""
            }
            // Resize the textView to accomodate replacementText
            togglePostButton(enabled: true)
            return true
        } else {
            // No text, show the placeholder
            setPlaceholder()
            setTextPosToBeginning(textView: textView)
            // Resize the textView to one line
            adjustTextViewHeight(newFrame: CGRect(x: 0, y: 0, width: commentTextView.frame.width, height: 20.0))
            togglePostButton(enabled: false)
            return false
        }
    }
    
    private func adjustTextViewHeight(newFrame: CGRect) {
        // Do not grow textView if we're going from 6 -> 7
        DispatchQueue.main.async {
            self.commentTextViewHeight.constant = newFrame.size.height
            NotificationCenter.default.post(name: .textViewWillChangeHeightNotification, object: nil)
        }
    }
    
    
    
}


