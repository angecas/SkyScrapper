//
//  HomeViewController.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 09/06/2024.
//

import UIKit
import CryptoKit

class HomeViewController: UIViewController {
    private var serpApiManager: SerpApiManager = SerpApiManager()
    private var flightParameters = SearchFlightsParameters(departureId: "CDG", arrivalId: "AUS", outboundDate: "2024-08-11", returnDate: "2024-09-11")
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        var mySharedSecret = SecretKeys.API_KEY
        var myPassword = SecretKeys.SECRET_KEY
//        let passwordData = mySharedSecret.data(using: .utf8)!
//        let sharedSecretData = myPassword.data(using: .utf8)!
//        
//
//        let aesKey = HKDF<SHA512>.deriveKey(
//                    inputKeyMaterial: passwordData,
//                    info: sharedSecretData,
//                    outputByteCount: 32)
//

        print(mySharedSecret)
        print(myPassword)
    }
    
    private func setupLayout() {
        let mySharedSecret = SecretKeys.API_KEY
        let myPassword = SecretKeys.SECRET_KEY

        let skyBlue = UIColor(hex: "#cfecf7")
        self.view.backgroundColor = skyBlue
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 64),
            searchButton.widthAnchor.constraint(equalToConstant: 64),
        ])
    }
    
    @objc
    private func pressed() {
        Task {
            await serpApiManager.searchFlightsRequest(parameters: flightParameters)
        }
    }
}
