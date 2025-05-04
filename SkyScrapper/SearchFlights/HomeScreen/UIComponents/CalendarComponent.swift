//
//  CalendarComponent.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 19/04/2025.
//

import UIKit
import Combine

class CalendarComponentViewController: UIViewController {
    @Published var selectedDates: [Date?] = []
    private var cancellables = Set<AnyCancellable>()
    private let dateLimit: Int
    private let vc: CalendarViewController

    private lazy var whenToLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick a date"
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var selectDatesLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var leavingTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "From",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.textColor = .white
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var returnTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "To",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
                         .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        textField.textColor = .white
        textField.keyboardType = .numberPad
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
        
    private lazy var calendarImageView: UIImageView = {
        let calendarImageView = UIImageView()
        calendarImageView.image = UIImage(systemName: "calendar")
        calendarImageView.tintColor = .white
        calendarImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        calendarImageView.addGestureRecognizer(gestureRecognizer)
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
        return calendarImageView
    }()
    
    init() {
        self.dateLimit = 2
        self.vc = CalendarViewController(dateLimit: 2)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vc.delegate = self
        setupLayout()
        
        $selectedDates
            .sink { [weak self] dates in
                let nonNilDates = dates.compactMap { $0 }
                guard nonNilDates.count > 0 else { return }

                var orderedDates = nonNilDates.sorted()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                
                if dates.count > self?.dateLimit ?? 0 {
                    orderedDates.remove(at: 1)
                }

                if let leavingDate = orderedDates.first {
                    self?.leavingTextField.text = dateFormatter.string(from: leavingDate)
                }

                if orderedDates.count > 1, let returnDate = orderedDates.last {
                    self?.returnTextField.text = dateFormatter.string(from: returnDate)
                } else {
                    self?.returnTextField.text = nil
                }
                print(dates.count, "----")
                self?.vc.selectionDates = dates
            }
            .store(in: &cancellables)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        view.addSubview(whenToLabel)
        
        view.addSubview(calendarImageView)
        view.addSubview(leavingTextField)
        view.addSubview(selectDatesLabel)
        view.addSubview(returnTextField)
        
        let horizontalStack = UIStackView(arrangedSubviews: [
            calendarImageView,
            leavingTextField,
            selectDatesLabel,
            returnTextField
        ])
        
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fillProportionally
        horizontalStack.spacing = 8
        horizontalStack.setCustomSpacing(24, after: calendarImageView)
        
        view.addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            whenToLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            whenToLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whenToLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whenToLabel.heightAnchor.constraint(equalToConstant: 52),
            
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: whenToLabel.bottomAnchor),

            calendarImageView.heightAnchor.constraint(equalToConstant: 26),
            calendarImageView.widthAnchor.constraint(equalToConstant: 26),
        ])
    }
    
    @objc
    private func didTapImageView() {
        vc.modalPresentationStyle = .formSheet
        let targetSize = vc.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        vc.sheetPresentationController?.detents = [.custom(resolver: { context in
            return targetSize.height
        })]
        self.navigationController?.present(vc, animated: true)
    }
        
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: view)
        if !(leavingTextField.frame.contains(touchLocation) || returnTextField.frame.contains(touchLocation)) {
            dismissKeyboard()
            leavingTextField.resignFirstResponder()
            returnTextField.resignFirstResponder()
        }
    }
}

extension CalendarComponentViewController: UITextFieldDelegate {
    
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(
            string: "dd/mm/yyyy",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
                         .font: UIFont.systemFont(ofSize: 14)
            ]        )
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        textField.attributedPlaceholder = NSAttributedString(
            string: textField == leavingTextField ? "From" : "To",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
                         .font: UIFont.systemFont(ofSize: 16)
            ]        )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: textField.text ?? "")

        if let date = date, date > Date() && !selectedDates.contains(date) {
            selectedDates.append(date)
        } else {
            textField.text = nil
        }
        return true
    }
}



extension CalendarComponentViewController: CalendarViewControllerDelegate {
    func viewController(_ controller: CalendarViewController, didSelectDates dates: [Date?]) {
        selectedDates = dates
    }
}
