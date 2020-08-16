//
//  RestaurantDetailViewController.swift
//  WhatsToEat
//
//  Created by Jonell on 6/19/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {
    private enum Constants {
        static let navigationBarColor: UIColor = .WhatsToEatPrimary
        static let backgroundColor = UIColor.white

        static let contentStackViewBottomAnchor: CGFloat = UIDevice().hasBottomSafeAreaInset ? 0 : -15.0
        
        static let nameLabelLeadingAnchor: CGFloat = 10.0
        static let nameLabelTrailingAnchor: CGFloat = -10.0
        
        static let directionsPhoneButtonsStackViewLeadingAnchor: CGFloat = 15
        static let directionsPhoneButtonsStackViewTrailingAnchor: CGFloat = -15.0
        
        static let bannerImageViewHeightMultiplier: CGFloat = 0.3
        static let nameLabelContainerViewHeightMultiplier: CGFloat = 0.05
        static let categoryLabelHeightMultiplier: CGFloat = 0.05
        static let distanceRatingPriceStackViewHeightMultiplier: CGFloat = 0.035
        static let reviewCountLabelHeightMultiplier: CGFloat = 0.025
        static let addressLabelHeightMultiplier: CGFloat = 0.1
        static let actionButtonsContainerViewHeightMultiplier: CGFloat = 0.1
        static let detailPhotosCollectionViewHeightMultiplier: CGFloat = 0.3
        
        static let activityIndicatorHeightAnchor: CGFloat = 50.0
    }
    
    // MARK: - Properties
            
    // MARK: Content Stack View
    
    private let contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        return contentStackView
    }()
    
    // MARK: Banner Section
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.navigationBarColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: Name and Category Section
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .restaurantDetailName
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let nameLabelContainerView: UIView = {
        let nameLabelContainer = UIView()
        nameLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        return nameLabelContainer
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .restaurantDetailCategory
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: Distance, Rating and Price Section
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .restaurantDetailDistance
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemYellow
        return label
    }()
    
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .restaurantDetailPrice
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemGreen
        return label
    }()
    
    private let distanceRatingPriceStackView: UIStackView = {
        let distanceRatingPriceStackView = UIStackView()
        distanceRatingPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        distanceRatingPriceStackView.axis = .horizontal
        distanceRatingPriceStackView.alignment = .fill
        distanceRatingPriceStackView.distribution = .fillEqually
        return distanceRatingPriceStackView
    }()
    
    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .restaurantDetailReviewCount
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: Address Section
    
    private let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = .restaurantDetailAddress
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .center
        return addressLabel
    }()
    
    // MARK: Detail Photos Section
    
    private lazy var detailPhotosCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
    
        let detailPhotosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        detailPhotosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        detailPhotosCollectionView.delegate = self
        detailPhotosCollectionView.dataSource = self
        detailPhotosCollectionView.register(SupplementaryImageCollectionViewCell.self, forCellWithReuseIdentifier: SupplementaryImageCollectionViewCell.reuseIdentifier)
        detailPhotosCollectionView.isScrollEnabled = false
        detailPhotosCollectionView.delaysContentTouches = false
        detailPhotosCollectionView.backgroundColor = .clear
        detailPhotosCollectionView.alpha = 0
        return detailPhotosCollectionView
    }()
    
    // MARK: Business Hours Section
    
    private let businessHoursLabel: UILabel = {
        let businessHoursLabel = UILabel()
        businessHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        businessHoursLabel.font = .restaurantDetailBusinessHours
        businessHoursLabel.textAlignment = .center
        businessHoursLabel.numberOfLines = 0
        businessHoursLabel.alpha = 0
        return businessHoursLabel
    }()
    
    // MARK: Directions and Phone Section
    
    private let actionButtonsContainerView: UIView = {
        let directionsPhoneButtonsContainer = UIView()
        directionsPhoneButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        return directionsPhoneButtonsContainer
    }()
    
    private let actionButtonsStackView: UIStackView = {
        let directionsPhoneButtonsStackView = UIStackView()
        directionsPhoneButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        directionsPhoneButtonsStackView.axis = .horizontal
        directionsPhoneButtonsStackView.alignment = .fill
        directionsPhoneButtonsStackView.distribution = .fillEqually
        directionsPhoneButtonsStackView.spacing = 15
        return directionsPhoneButtonsStackView
    }()
    
    private lazy var directionsButton: AnimatedButton = {
        let directionsButton = AnimatedButton()
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        directionsButton.addTarget(self, action: #selector(directionsButtonPressed), for: .touchUpInside)
        directionsButton.setTitle(" Maps ", for: .normal)
        directionsButton.titleLabel?.font = .restaurantDetailDirecions
        directionsButton.setImage(.directionsIcon, for: .normal)
        directionsButton.tintColor = .white
        directionsButton.backgroundColor = .systemBlue
        directionsButton.adjustsImageWhenHighlighted = false
        return directionsButton
    }()
    
    private lazy var yelpButton: AnimatedButton = {
        let yelpButton =  AnimatedButton()
        yelpButton.translatesAutoresizingMaskIntoConstraints = false
        yelpButton.addTarget(self, action: #selector(yelpButtonPressed), for: .touchUpInside)
        yelpButton.setImage(.yelpLogo, for: .normal)
        yelpButton.adjustsImageWhenHighlighted = false
        yelpButton.imageView?.contentMode = .scaleAspectFit
        yelpButton.backgroundColor = UIColor(named: "YelpRed")
        yelpButton.clipsToBounds = true
        return yelpButton
    }()
    
    private lazy var phoneButton: AnimatedButton = {
        let phoneButton = AnimatedButton()
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.addTarget(self, action: #selector(phoneButtonPressed), for: .touchUpInside)
        phoneButton.setImage(.phoneIcon, for: .normal)
        phoneButton.setTitle(" Call ", for: .normal)
        phoneButton.titleLabel?.font = .restaurantDetailPhone
        phoneButton.tintColor = .white
        phoneButton.adjustsImageWhenHighlighted = false
        phoneButton.backgroundColor = .systemOrange
        return phoneButton
    }()
    
    // MARK: Activity Indicator
    
    private let activityIndicatorContainerView: UIView = {
        let activityIndicatorContainer = UIView()
        activityIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.backgroundColor = .clear
        return activityIndicatorContainer
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Constants.navigationBarColor
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
        
    // MARK: View Model
    
    private var viewModel: RestaurantDetailViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: RestaurantDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
    }
    
    // MARK: - Layout
    
    private func setupView() {
        view.backgroundColor = Constants.backgroundColor
        
        bannerImageView.imageFromUrl(urlString: viewModel.imageURL)

        nameLabel.text = viewModel.name
        categoryLabel.text = viewModel.category
        distanceLabel.text = viewModel.distance
        ratingImageView.image = viewModel.rating
        priceLabel.text = viewModel.price
        reviewCountLabel.text = viewModel.reviewCount
        addressLabel.text = viewModel.address

        directionsButton.layer.cornerRadius = 10.0
        yelpButton.layer.cornerRadius = 10.0
        phoneButton.layer.cornerRadius = 10.0
        
        activityIndicator.startAnimating()

        nameLabelContainerView.addSubview(nameLabel)
        
        distanceRatingPriceStackView.addArrangedSubview(distanceLabel)
        distanceRatingPriceStackView.addArrangedSubview(ratingImageView)
        distanceRatingPriceStackView.addArrangedSubview(priceLabel)
        
        actionButtonsStackView.addArrangedSubview(directionsButton)
        actionButtonsStackView.addArrangedSubview(yelpButton)
        actionButtonsStackView.addArrangedSubview(phoneButton)
        actionButtonsContainerView.addSubview(actionButtonsStackView)
        
        contentStackView.addArrangedSubview(bannerImageView)
        
        contentStackView.addArrangedSubview(createSpacerView(dimension: .height, 20.0))
        contentStackView.addArrangedSubview(nameLabelContainerView)
        contentStackView.addArrangedSubview(categoryLabel)

        contentStackView.addArrangedSubview(createSpacerView(dimension: .height, 10.0))
        contentStackView.addArrangedSubview(distanceRatingPriceStackView)
        
        contentStackView.addArrangedSubview(createSpacerView(dimension: .height, 5.0))
        contentStackView.addArrangedSubview(reviewCountLabel)
        
        contentStackView.addArrangedSubview(addressLabel)
        
        contentStackView.addArrangedSubview(createSpacerView(dimension: .height, 10.0))
        contentStackView.addArrangedSubview(detailPhotosCollectionView)
        
        contentStackView.addArrangedSubview(businessHoursLabel)
        
        contentStackView.addArrangedSubview(createSpacerView(dimension: .height, 5.0))
        contentStackView.addArrangedSubview(actionButtonsContainerView)

        activityIndicatorContainerView.addSubview(activityIndicator)
        
        view.addSubview(contentStackView)
        view.addSubview(activityIndicatorContainerView)
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.contentStackViewBottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: nameLabelContainerView.leadingAnchor, constant: Constants.nameLabelLeadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: nameLabelContainerView.trailingAnchor, constant: Constants.nameLabelTrailingAnchor),
            
            bannerImageView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: Constants.bannerImageViewHeightMultiplier),
            nameLabelContainerView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: Constants.nameLabelContainerViewHeightMultiplier),
            categoryLabel.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: Constants.categoryLabelHeightMultiplier),
            distanceRatingPriceStackView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: Constants.distanceRatingPriceStackViewHeightMultiplier),
            reviewCountLabel.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: Constants.reviewCountLabelHeightMultiplier),
            
            addressLabel.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: Constants.addressLabelHeightMultiplier),
            
            actionButtonsContainerView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: Constants.actionButtonsContainerViewHeightMultiplier),
            actionButtonsStackView.leadingAnchor.constraint(equalTo: actionButtonsContainerView.leadingAnchor, constant: Constants.directionsPhoneButtonsStackViewLeadingAnchor),
            actionButtonsStackView.trailingAnchor.constraint(equalTo: actionButtonsContainerView.trailingAnchor, constant: Constants.directionsPhoneButtonsStackViewTrailingAnchor),
            actionButtonsStackView.topAnchor.constraint(equalTo: actionButtonsContainerView.topAnchor),
            actionButtonsStackView.bottomAnchor.constraint(equalTo: actionButtonsContainerView.bottomAnchor),
            
            detailPhotosCollectionView.heightAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: Constants.detailPhotosCollectionViewHeightMultiplier),
            
            activityIndicatorContainerView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            activityIndicatorContainerView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            activityIndicatorContainerView.topAnchor.constraint(equalTo: detailPhotosCollectionView.topAnchor),
            activityIndicatorContainerView.bottomAnchor.constraint(equalTo: detailPhotosCollectionView.bottomAnchor),
            
            activityIndicator.heightAnchor.constraint(equalToConstant: Constants.activityIndicatorHeightAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: Constants.activityIndicatorHeightAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainerView.centerYAnchor)
        ])
    }

    private enum SpacerDimension { case height; case width }
    private func createSpacerView(dimension: SpacerDimension, _ value: CGFloat? = nil) -> UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        if let value = value {
            switch dimension {
            case .height:
                NSLayoutConstraint.activate([
                    spacerView.heightAnchor.constraint(equalToConstant: value)
                ])
            case .width:
                NSLayoutConstraint.activate([
                    spacerView.widthAnchor.constraint(equalToConstant: value)
                ])
            }
        }
        return spacerView
    }
    
    @objc private func yelpButtonPressed() {
        if let mediaURL = URL(string: viewModel.url), UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL)
        }
    }
    
    @objc private func directionsButtonPressed() {
        let coordinate = CLLocationCoordinate2D(latitude: viewModel.latitude, longitude: viewModel.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = viewModel.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @objc private func phoneButtonPressed() {        
        if let url = URL(string: "tel://\(viewModel.phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - UICollectionView

extension RestaurantDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.supplementaryImageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SupplementaryImageCollectionViewCell.reuseIdentifier, for: indexPath) as? SupplementaryImageCollectionViewCell else {
            fatalError("Failed to dequeue a \(String(describing: SupplementaryImageCollectionViewCell.self)) cell")
        }
        if let cellViewModel = viewModel.supplementaryImageViewModelFor(indexPath) {
            cell.configure(with: cellViewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.supplementaryImageViewModelFor(indexPath) else {
            return
        }
        
        let photoDetailViewController = PhotoDetailViewController()
        photoDetailViewController.setImage(UIImage(data: cellViewModel.imageData))
        photoDetailViewController.modalPresentationStyle = .overCurrentContext
        present(photoDetailViewController, animated: false, completion: nil)
    }
}

extension RestaurantDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3.15
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

// MARK: - RestaurantDetailViewModelDelegate
extension RestaurantDetailViewController: RestaurantDetailViewModelDelegate {
    func didReceiveRestaurantDetails() {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.activityIndicator.stopAnimating()

                    self.detailPhotosCollectionView.reloadData()
                    self.detailPhotosCollectionView.alpha = 1
                    
                    self.businessHoursLabel.text = self.viewModel.businessHours
                    self.businessHoursLabel.alpha = 1
                },
                completion: { _ in
                    self.activityIndicatorContainerView.isHidden = true
                }
            )
        }
    }
    
    func errorOccurred(errorMessage: String) {
        DispatchQueue.main.async {
            let errorAlertController = UIAlertController.generateDismissableErrorAlertController(errorMessage: errorMessage)
            self.present(errorAlertController, animated: true, completion: nil)
        }
    }
}

