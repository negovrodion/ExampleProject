//
//  CurrenciesListTableViewCell.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CurrenciesListTableViewCellDelegate
protocol CurrenciesListTableViewCellDelegate: class {
    func didChangeValue(cell: UITableViewCell, value: String)
    func didBecomeFirstResponder(cell: UITableViewCell)
}

// MARK: - CurrenciesListTableViewCell
final class CurrenciesListTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let toolbarHeight = CGFloat(50)
        static let placeholderForCurrencyValue = "0"
        static let maxInputTextLength = 25
    }
    
    // MARK: - Properties
    weak var delegate: CurrenciesListTableViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet private weak var shortName: UILabel!
    @IBOutlet private weak var currencyValue: UITextField!
    
    // MARK: - Lyfecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addDoneButtonOnKeyboard()
    }
    
    // MARK: - Functions
    func configure(with model: CurrenciesListViewCellModel, delegate: CurrenciesListTableViewCellDelegate) {
        shortName.text            = model.curName
        currencyValue.text        = model.value
        currencyValue.placeholder = Constants.placeholderForCurrencyValue
        currencyValue.delegate    = self
        self.delegate             = delegate
    }
    
    func showKeyboardForCurrencyValue() {
        currencyValue.becomeFirstResponder()
    }
    
    func updateCurrencyValue(with text: String) {
        currencyValue.text = text
    }
    
    // MARK: - Private functions
    private func addDoneButtonOnKeyboard() {
        let doneToolbar      = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: Constants.toolbarHeight))
        doneToolbar.barStyle = .default
        let flexSpace        = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                               target: nil, action: nil)
        let done             = UIBarButtonItem(title: String.Strings.done, style: UIBarButtonItemStyle.done,
                                               target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        currencyValue.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        currencyValue.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension CurrenciesListTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard textField.text?.isEmpty == false || string != "." || string != "," else { return false }
        guard let count = textField.text?.count,
            count < Constants.maxInputTextLength || string == "" else { return false }
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string).replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: " ", with: "")

        delegate?.didChangeValue(cell: self, value: newText)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBecomeFirstResponder(cell: self)
    }
    
}
