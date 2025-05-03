//
//  AirportTableViewCell.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 14/12/2024.
//

import UIKit

class AirportTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "AirportTableViewCell"
    
    private let airportNameLabel: UILabel = {
        let label = UILabel()
//        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingMiddle
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()    
    private let airportIataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let cellImageView: UIImageView = {
        let uiImage = UIImage(systemName: "airplane")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: uiImage)
        view.tintColor = .black
        view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        
        // Add subviews
        contentView.addSubview(airportNameLabel)
        contentView.addSubview(airportIataLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(cellImageView)
        
        // Set content hugging and compression resistance priorities
        airportNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        airportNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        airportIataLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        airportIataLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // Activate layout constraints
        NSLayoutConstraint.activate([
            // ImageView constraints
            cellImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellImageView.widthAnchor.constraint(equalToConstant: 24),
            cellImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Airport name label
            airportNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            airportNameLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 16),
            airportNameLabel.trailingAnchor.constraint(equalTo: airportIataLabel.leadingAnchor, constant: -8),
            
            // IATA label
            airportIataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            airportIataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            airportIataLabel.leadingAnchor.constraint(greaterThanOrEqualTo: airportNameLabel.trailingAnchor, constant: 8),

            // City label
            cityLabel.topAnchor.constraint(equalTo: airportNameLabel.bottomAnchor, constant: 4),
            cityLabel.leadingAnchor.constraint(equalTo: airportNameLabel.leadingAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }

    // MARK: - Configure Cell
    func configure(with airport: AirportInfo, isSelected: Bool) {
        self.contentView.backgroundColor = isSelected ? .systemGray5 : .white

        airportNameLabel.text = airport.name
        airportIataLabel.text = airport.iata
        if !airport.city.isEmpty && !airport.country.isEmpty {
            cityLabel.text = airport.city + ",  \(airport.country)"
        }
    }
}
