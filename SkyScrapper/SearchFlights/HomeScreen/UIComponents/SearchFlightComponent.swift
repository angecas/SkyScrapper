//
//  FlighTextField.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 26/01/2025.
//

import UIKit
import Combine

final class SearchFlightComponent: UIView, UITableViewDataSource {
    var heightPublisher = PassthroughSubject<CGFloat, Never>()

    private(set) var selectedAirport: AirportData?
    var theOtherSelected: AirportData?
    var airportOptions: [AirportData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var allAirportOptions: [AirportData] = []
    var onAirportSelected: ((AirportData) -> Void)?
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.leftView = imageView
        textField.rightView = labelContainerView
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        textField.placeholder = placeholder
        textField.font = UIFont(name: "AmericanTypewriter", size: 14)
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 4
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AirportTableViewCell.self, forCellReuseIdentifier: AirportTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return imageView
    }()
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelContainerView: UIView = {
        let container = UIView()
        container.addSubview(labelView)
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            labelView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            labelView.topAnchor.constraint(equalTo: container.topAnchor),
            labelView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }()

    private var placeholder: String?
    
    init(image: UIImage?, placeholder: String?) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        self.imageView.image = image
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(textField)
        addSubview(tableView)
        
        textField.delegate = self
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 52),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewHeightConstraint,
        ])
    }
    
    func setData(with data: [AirportData]) {
        self.allAirportOptions = data
        self.airportOptions = data
        tableView.reloadData()
        updateTableViewHeight()
    }

    func dismissKeyboardAndHideTable() {
        textField.resignFirstResponder()
        tableView.isHidden = true
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        
        let maxHeight: CGFloat = 200
        let tableHeight: CGFloat = tableView.isHidden ? 0 : min(tableView.contentSize.height, maxHeight)
        
        tableViewHeightConstraint.constant = tableHeight
        
        let totalComponentHeight = 52 + tableHeight
        heightPublisher.send(totalComponentHeight)

        self.layoutIfNeeded()
    }
    
    func selectAiport(selected airport: AirportData?) {
        guard let data = airport else { return }
        selectedAirport = data
        textField.text = data.airport.city
        tableView.isHidden = true
        labelView.text = data.airport.iata
        updateTableViewHeight()
    }
}

extension SearchFlightComponent: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airportOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AirportTableViewCell.reuseIdentifier, for: indexPath) as? AirportTableViewCell else {
            return UITableViewCell()
        }
        let isSelected = airportOptions[indexPath.row].airport.iata == selectedAirport?.airport.iata
        let isDisabled = airportOptions[indexPath.row].airport.iata == theOtherSelected?.airport.iata
        cell.configure(with: airportOptions[indexPath.row].airport, isSelected: isSelected || isDisabled)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isDisabled = airportOptions[indexPath.row].airport.iata == theOtherSelected?.airport.iata
        guard !isDisabled else { return }
        
        let selected = airportOptions[indexPath.row]
        selectedAirport = selected
        textField.text = selected.airport.city
        tableView.isHidden = true
        textField.resignFirstResponder()
        labelView.text = selected.airport.iata
        updateTableViewHeight()
        onAirportSelected?(selected)
    }
    
}
extension SearchFlightComponent: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
        updateTableViewHeight()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tableView.isHidden = true
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let query = textField.text?.lowercased(), !query.isEmpty else {
            airportOptions = allAirportOptions
            tableView.reloadData()
            updateTableViewHeight()
            return
        }

        airportOptions = allAirportOptions.filter {
            $0.airport.city.lowercased().contains(query)
            || $0.airport.iata?.lowercased().contains(query) ?? false
        }

        tableView.reloadData()
        updateTableViewHeight()
    }
}
