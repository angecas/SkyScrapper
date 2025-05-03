//
//  HomeViewController.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 09/06/2024.
//

import UIKit
import CryptoKit
import Combine

class HomeViewController: UIViewController {
    private var originSearchHeightConstraint: NSLayoutConstraint!
    private var departureSearchHeightConstraint: NSLayoutConstraint!
    private var viewModel: HomeViewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Let's fly!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#202124")?.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var originSearch: SearchFlightComponent = {
        let originSearch = SearchFlightComponent(image: UIImage(systemName: "airplane.departure"), placeholder: "Where from?")
        originSearch.airportOptions = viewModel.aiports.origin
        originSearch.onAirportSelected = { selectedAirport in
            self.viewModel.selectedAiports.origin = selectedAirport
        }
        originSearch.translatesAutoresizingMaskIntoConstraints = false
        return originSearch
    }()
    
    private lazy var destinSearch: SearchFlightComponent = {
        let departureSearch = SearchFlightComponent(image: UIImage(systemName: "airplane.arrival"), placeholder: "Where to?")
        departureSearch.airportOptions = viewModel.aiports.origin
        departureSearch.onAirportSelected = { selectedAirport in
            self.viewModel.selectedAiports.depart = selectedAirport
        }
        departureSearch.translatesAutoresizingMaskIntoConstraints = false
        return departureSearch
    }()
    
    private lazy var date: SearchFlightComponent = {
        let originSearch = SearchFlightComponent(image: UIImage(systemName: "airplane.arrival"), placeholder: "Where to?")
        originSearch.airportOptions = viewModel.aiports.origin
        originSearch.onAirportSelected = { selectedAirport in
            self.viewModel.selectedAiports.origin = selectedAirport
        }
        originSearch.translatesAutoresizingMaskIntoConstraints = false
        return originSearch
    }()
        
    private lazy var imageContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let uiImage = UIImage(systemName: "arrow.up.and.down.circle")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: uiImage)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 42),
            imageView.heightAnchor.constraint(equalToConstant: 42),
            container.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        return container
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isUserInteractionEnabled = true
        scroll.bounces = false
        scroll.backgroundColor = UIColor(hex: "#202124")
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        scrollView.addGestureRecognizer(tapGesture)
        stackView.addGestureRecognizer(tapGesture)
        imageContainerView.addGestureRecognizer(tapGesture)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        viewModel.$aiports
            .receive(on: DispatchQueue.main)
            .sink {[weak self] airport in
                self?.originSearch.setData(with: airport.origin)
                self?.destinSearch.setData(with: airport.depart)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedAiports
            .receive(on: DispatchQueue.main)
            .sink {[weak self] origin, depart in
                self?.originSearch.selectAiport(selected: origin)
                self?.originSearch.theOtherSelected = depart
                self?.destinSearch.selectAiport(selected: depart)
                self?.destinSearch.theOtherSelected = origin
            }
            .store(in: &cancellables)
        
        originSearch.heightPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHeight in
                self?.originSearchHeightConstraint.constant = newHeight
                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)
        
        destinSearch.heightPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHeight in
                self?.departureSearchHeightConstraint.constant = newHeight
                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)
        
        viewModel.fetchAirportData()
        
        self.dismissKeyboard()
        
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor(hex: "#202124")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false

        view.addSubview(scrollView)
        view.addSubview(searchButton)
        scrollView.addSubview(stackView)
        
        let calendarComponent = CalendarComponentViewController()
        calendarComponent.view.translatesAutoresizingMaskIntoConstraints = false
        calendarComponent.view.addGestureRecognizer(tapGesture)
        addChild(calendarComponent)
        
        stackView.addArrangedSubview(originSearch)
        stackView.addArrangedSubview(imageContainerView)
        stackView.addArrangedSubview(destinSearch)
        stackView.addArrangedSubview(calendarComponent.view)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        originSearchHeightConstraint = originSearch.heightAnchor.constraint(equalToConstant: 52)
        departureSearchHeightConstraint = destinSearch.heightAnchor.constraint(equalToConstant: 52)
                
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: searchButton.topAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            originSearchHeightConstraint,
            departureSearchHeightConstraint,
            
//            imageView.heightAnchor.constraint(equalToConstant: 48),
//            imageView.widthAnchor.constraint(equalToConstant: 48),

            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 52),
            
            calendarComponent.view.heightAnchor.constraint(equalToConstant: 120),
        ])
    }

    @objc
    private func didTapImageView() {
        guard let origin = viewModel.selectedAiports.origin, let depart = viewModel.selectedAiports.depart else {return}
        
        viewModel.selectedAiports.origin = depart
        viewModel.selectedAiports.depart = origin
    }
    
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: view)
        if !(originSearch.frame.contains(touchLocation) || destinSearch.frame.contains(touchLocation)) {
            originSearch.dismissKeyboardAndHideTable()
            destinSearch.dismissKeyboardAndHideTable()
        }
    }
}
//arranjar os textfields.. o texto interfere com a pesquisa
//guardar no user f¡defaults a loclizaçao
//initadcar a pesquisa com a localizaçao atual
//disable da table view o local que ja esteja no outro texfuield
