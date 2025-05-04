//
//  CalendarView.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 05/02/2025.
//

import Combine
import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    func viewController(_ controller: CalendarViewController, didSelectDates dates: [Date?])
}

class CalendarViewController: UIViewController {
    weak var delegate: CalendarViewControllerDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    private let dateLimit: Int
    private var multiSelect: UICalendarSelectionMultiDate?
    var calendarToKeyboardConstraint: NSLayoutConstraint!
    var calendarToBottomConstraint: NSLayoutConstraint!

    var selectionDates: [Date?] = []
    
    init(dateLimit: Int) {
        self.dateLimit = dateLimit
        super.init(nibName: nil, bundle: nil)
        self.multiSelect = UICalendarSelectionMultiDate(delegate: self)
        calendarView.selectionBehavior = multiSelect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        let currentLocale = Locale.current
        calendarView.locale = Locale(identifier: currentLocale.identifier)
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = .white
        calendarView.tintColor = .systemBlue
        calendarView.availableDateRange = DateInterval(start: Date(), end: Date.distantFuture)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    private lazy var dateField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "AmericanTypewriter", size: 14)
        textField.placeholder = "Departure"
        textField.adjustsFontSizeToFitWidth = true
        textField.borderStyle = .roundedRect
        textField.delegate = self
        let leftView = UIImageView(image: UIImage(systemName: "calendar.circle"))
        leftView.tintColor = UIColor(hex: "#202124")
        leftView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        leftView.contentMode = .scaleAspectFit
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.leftView = leftView
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var secondDateField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Return"
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont(name: "AmericanTypewriter", size: 14)
        textField.borderStyle = .roundedRect
        textField.delegate = self
        let leftView = UIImageView(image: UIImage(systemName: "calendar.circle"))
        leftView.tintColor = UIColor(hex: "#202124")
        leftView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        leftView.contentMode = .scaleAspectFit
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.leftView = leftView
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(calendarView)
        view.addSubview(dateField)
        view.addSubview(secondDateField)
                
        calendarToKeyboardConstraint = calendarView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        calendarToBottomConstraint = calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            dateField.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            dateField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateField.heightAnchor.constraint(equalToConstant: 40),
            dateField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width/2) - 40),
            
            secondDateField.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            secondDateField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            secondDateField.heightAnchor.constraint(equalToConstant: 40),
            secondDateField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width/2) - 40),
            
            calendarView.topAnchor.constraint(equalTo: dateField.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarToBottomConstraint,
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let selectedDates: [Date?] = multiSelect?.selectedDates.map {
            Calendar.current.date(from: $0)
        } ?? []

        delegate?.viewController(self, didSelectDates: selectedDates)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let selectedDateComponents = self.selectionDates.compactMap({ date -> DateComponents? in
            guard let date = date else { return nil }
            return Calendar.current.dateComponents([.year, .month, .day], from: date)
        })
        self.updateMultiSelect(selectedDateComponents)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupLayout()
    }
    
    func updateMultiSelect(_ newSelection: [DateComponents] = []) {
        for newDate in newSelection {
            if let newDateObj = Calendar.current.date(from: newDate),
               !selectionDates.contains(where: { $0 != nil && Calendar.current.isDate($0!, inSameDayAs: newDateObj) }) {
                selectionDates.append(newDateObj)
            }
        }

        if selectionDates.count > dateLimit {
            selectionDates.remove(at: 1)
        }

        let updated = selectionDates.compactMap {
            $0.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current

    
        if let earliest = selectionDates.compactMap({ $0 }).min(by: { $0 < $1 }) {
            dateField.text = dateFormatter.string(from: earliest)
        }
        if selectionDates.count > 1 {
            if let oldest = selectionDates.compactMap({ $0 }).min(by: { $0 > $1 }) {
                secondDateField.text = dateFormatter.string(from: oldest)
            }
        }
        
        multiSelect?.selectedDates = updated
    }

    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: view)
        if !(dateField.frame.contains(touchLocation) || secondDateField.frame.contains(touchLocation)) {
            dismissKeyboard()
        }
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        calendarToBottomConstraint.isActive = false
        calendarToKeyboardConstraint.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        calendarToKeyboardConstraint.isActive = false
        calendarToBottomConstraint.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension CalendarViewController: UICalendarSelectionMultiDateDelegate {
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        updateMultiSelect(selection.selectedDates)
    }

    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate: DateComponents) {
        selectionDates.removeAll {
            guard let deselectedDate = didDeselectDate.date, let current = $0 else { return false }
            return Calendar.current.isDate(current, inSameDayAs: deselectedDate)
        }

        let updatedSelection = selectionDates.compactMap {
            $0.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        }
        multiSelect?.selectedDates = updatedSelection
    }

    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
        return true
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canDeselectDate dateComponents: DateComponents) -> Bool {
        return true
    }
}

extension CalendarViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }

        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        let digitsOnly = newText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        let limited = String(digitsOnly.prefix(8))

        var formatted = ""
        var cursorOffset = 0
        for (index, char) in limited.enumerated() {
            if index == 2 || index == 4 {
                formatted.append("/")
                if range.location >= index {
                    cursorOffset += 1
                }
            }
            formatted.append(char)
        }

        textField.text = formatted

        if let startPosition = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count + cursorOffset),
           let textRange = textField.textRange(from: startPosition, to: startPosition) {
            textField.selectedTextRange = textRange
        }
        return false
    }

    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        
//        guard let formatted = newText.formattedAsDateInput() else { return false }
//
//        let beginning = textField.beginningOfDocument
//        if let _ = textField.position(from: beginning, offset: range.location + string.count) {
//            textField.text = formatted
//
//            let offset = min(formatted.count, range.location + string.count)
//            if let newPosition = textField.position(from: beginning, offset: offset) {
//                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
//            }
//        }
//        return false
//    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(
            string: "dd/mm/yyyy",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5),
                         .font: UIFont.systemFont(ofSize: 14)
            ]        )
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from: textField.text ?? "")


        if let date = date, date > Date() && !selectionDates.contains(date) {
            calendarView.visibleDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            updateMultiSelect([dateComponents])
        } else {
            textField.text = nil
        }
        return true
    }
}
