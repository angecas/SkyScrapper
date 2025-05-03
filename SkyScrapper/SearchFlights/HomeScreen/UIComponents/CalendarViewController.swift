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
        textField.placeholder = "Departure (dd/mm/yyyy)"
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
        textField.placeholder = "Return (dd/mm/yy)"
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
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
        setupLayout()
    }
    
    func updateMultiSelect(_ newSelection: [DateComponents] = []) {
        for newDate in newSelection {
            if let newDateObj = Calendar.current.date(from: newDate),
               !selectionDates.contains(where: { $0 != nil && Calendar.current.isDate($0!, inSameDayAs: newDateObj) }) {
                selectionDates.append(newDateObj)
            }
        }

        if selectionDates.count > 2 {
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
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if let formatted = newText.formattedAsDateInput() {
            textField.text = formatted
        }

        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        guard let text = textField.text, let finalDate = dateFormatter.date(from: text) else { return true }
                
        calendarView.visibleDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: finalDate)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: finalDate)
        updateMultiSelect([dateComponents])
        
        return true
    }
}
