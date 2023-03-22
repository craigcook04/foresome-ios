//
//  LocationController.swift
//  meetwise
//
//  Created by hitesh on 21/11/20.
//  Copyright © 2020 hitesh. All rights reserved.
//

import UIKit
import MapKit

open class LocationPicker: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Types
    
    public enum NavigationItemOrientation {
        case left
        case right
    }
    
    public enum LocationType: Int {
        case currentLocation
        case searchLocation
        case alternativeLocation
    }
    
    
    // MARK: - Completion closures
    open var selectCompletion: ((LocationItem) -> Void)?
    open var pickCompletion: ((LocationItem) -> Void)?
    open var deleteCompletion: ((LocationItem) -> Void)?
    open var locationDeniedHandler: ((LocationPicker) -> Void)?
    // MARK: Optional variables
    open weak var delegate: LocationPickerDelegate?
    open weak var dataSource: LocationPickerDataSource?
    open var alternativeLocations: [LocationItem]?
    open var locationDeniedAlertController: UIAlertController?
    open var isAllowArbitraryLocation = false
    open var preselectedIndex: Int?
    
    // MARK: UI Customizations
    open var currentLocationText = "Current Location"
    open var searchBarPlaceholder = "Search for location"
    open var locationDeniedAlertTitle = "Location access denied"
    open var locationDeniedAlertMessage = "Grant location access to use current location"
    open var locationDeniedGrantText = "Grant"
    open var locationDeniedCancelText = "Cancel"
    open var defaultLongitudinalDistance: Double = 1000
    open var searchDistance: Double = 10000
    open var defaultSearchCoordinate: CLLocationCoordinate2D?
    open var isMapViewZoomEnabled = true
    open var isMapViewShowsUserLocation = true
    open var isMapViewScrollEnabled = true
    open var isRedirectToExactCoordinate = true
    open var isAlternativeLocationEditable = false
    open var isForceReverseGeocoding = false
    open var tableViewBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    open var currentLocationIconColor = #colorLiteral(red: 0.1176470588, green: 0.5098039216, blue: 0.3568627451, alpha: 1)
    open var searchResultLocationIconColor = #colorLiteral(red: 0.1176470588, green: 0.5098039216, blue: 0.3568627451, alpha: 1)
    open var alternativeLocationIconColor = #colorLiteral(red: 0.1176470588, green: 0.5098039216, blue: 0.3568627451, alpha: 1)
    open var pinColor = #colorLiteral(red: 0.1176470588, green: 0.5098039216, blue: 0.3568627451, alpha: 1)
    open var primaryTextColor = #colorLiteral(red: 0.34902, green: 0.384314, blue: 0.427451, alpha: 1)
    open var secondaryTextColor = #colorLiteral(red: 0.541176, green: 0.568627, blue: 0.584314, alpha: 1)
    open var currentLocationIcon: UIImage? = nil
    open var searchResultLocationIcon: UIImage? = nil
    open var alternativeLocationIcon: UIImage? = nil
    open var pinImage: UIImage? = nil
    open var pinShadowViewDiameter: CGFloat = 5
    
    // MARK: - UI Elements
    public let searchBar = UISearchBar()
    public let tableView = UITableView()
    public let mapView = MKMapView()
    public let pinView = UIImageView()
    public let pinShadowView = UIView()
    public let resultView = BottomResultView()
    
    
    open private(set) var barButtonItems: (doneButtonItem: UIBarButtonItem, cancelButtonItem: UIBarButtonItem)?
    
    
    // MARK: Attributes
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var selectedLocationItem: LocationItem?
    private var searchResultLocations = [LocationItem]()
    
    private var alternativeLocationCount: Int {
        return alternativeLocations?.count ?? dataSource?.numberOfAlternativeLocations() ?? 0
    }
    
    open var longitudinalDistance: Double!
    open var isMapViewCenterChanged = false
    
    private var pinViewCenterYConstraint: NSLayoutConstraint!
    private var pinViewImageHeight: CGFloat {
        return pinView.image!.size.height
    }
    
    
    // MARK: Customs
    public func addBarButtons(doneButtonItem: UIBarButtonItem? = nil,
                              cancelButtonItem: UIBarButtonItem? = nil,
                              doneButtonOrientation: NavigationItemOrientation = .right) {
        let doneButtonItem = doneButtonItem ?? UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        doneButtonItem.isEnabled = false
        doneButtonItem.target = self
        doneButtonItem.action = #selector(doneButtonDidTap(barButtonItem:))
        
        let cancelButtonItem = cancelButtonItem ?? UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        cancelButtonItem.target = self
        cancelButtonItem.action = #selector(cancelButtonDidTap(barButtonItem:))
        
        switch doneButtonOrientation {
        case .right:
            navigationItem.leftBarButtonItem = cancelButtonItem
            navigationItem.rightBarButtonItem = doneButtonItem
        case .left:
            navigationItem.leftBarButtonItem = doneButtonItem
            navigationItem.rightBarButtonItem = cancelButtonItem
        }
        
        barButtonItems = (doneButtonItem, cancelButtonItem)
    }
    
    public func setColors(themeColor: UIColor? = nil, primaryTextColor: UIColor? = nil, secondaryTextColor: UIColor? = nil) {
        self.currentLocationIconColor = themeColor ?? self.currentLocationIconColor
        self.searchResultLocationIconColor = themeColor ?? self.searchResultLocationIconColor
        self.alternativeLocationIconColor = themeColor ?? self.alternativeLocationIconColor
        self.pinColor = themeColor ?? self.pinColor
        self.primaryTextColor = primaryTextColor ?? self.primaryTextColor
        self.secondaryTextColor = secondaryTextColor ?? self.secondaryTextColor
    }
    
    public func setLocationDeniedAlertControllerTexts(title: String? = nil, message: String? = nil, grantText: String? = nil, cancelText: String? = nil) {
        self.locationDeniedAlertTitle = title ?? self.locationDeniedAlertTitle
        self.locationDeniedAlertMessage = message ?? self.locationDeniedAlertMessage
        self.locationDeniedGrantText = grantText ?? self.locationDeniedGrantText
        self.locationDeniedCancelText = cancelText ?? self.locationDeniedCancelText
    }
    
    open func shouldShowSearchResult(for mapItem: MKMapItem) -> Bool {
        return true
    }
    
    
    // MARK: - View Controller
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        longitudinalDistance = defaultLongitudinalDistance
        
        setupLocationManager()
        setupViews()
        layoutViews()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let index = preselectedIndex, index < 1 + searchResultLocations.count + alternativeLocationCount {
//            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
//            tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
//        }
        
        tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard barButtonItems?.doneButtonItem == nil else { return }
        
        if let locationItem = selectedLocationItem {
            locationDidPick(locationItem: locationItem)
        }
    }
    
    
    // MARK: Initializations
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        searchBar.delegate = self
        searchBar.placeholder = searchBarPlaceholder
        searchBar.showsCancelButton = true
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.textColor = primaryTextColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = tableViewBackgroundColor
        
        mapView.isZoomEnabled = isMapViewZoomEnabled
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.isScrollEnabled = isMapViewScrollEnabled
        mapView.showsUserLocation = isMapViewShowsUserLocation
        mapView.delegate = self
        
        pinView.image = pinImage ?? StyleKit.imageOfPinIconFilled(color: pinColor)
        
        pinShadowView.layer.cornerRadius = pinShadowViewDiameter / 2
        pinShadowView.clipsToBounds = false
        pinShadowView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        pinShadowView.layer.shadowColor = UIColor.black.cgColor
        pinShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        pinShadowView.layer.shadowRadius = 2
        pinShadowView.layer.shadowOpacity = 1
        
        if isMapViewScrollEnabled {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureInMapViewDidRecognize(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            mapView.addGestureRecognizer(panGestureRecognizer)
        }
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(mapView)
        mapView.addSubview(pinShadowView)
        mapView.addSubview(pinView)
        
        view.addSubview(resultView)
        
        resultView.callBacks(didSelect: { (locationItem) in
            self.selectedLocationItem = locationItem
            self.dismiss(animated: true, completion: nil)
        }) {
            self.selectedLocationItem = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancelAction(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func layoutViews() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinShadowView.translatesAutoresizingMaskIntoConstraints = false
        resultView.translatesAutoresizingMaskIntoConstraints = false
        
        let searchBarConstraints = [
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        NSLayoutConstraint.activate(searchBarConstraints)
        NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: searchBar, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: searchBar, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        NSLayoutConstraint(item: pinView, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        pinViewCenterYConstraint = NSLayoutConstraint(item: pinView, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1, constant: -pinViewImageHeight / 2)
        pinViewCenterYConstraint.isActive = true
        
        NSLayoutConstraint(item: pinShadowView, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pinShadowView, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pinShadowView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: pinShadowViewDiameter).isActive = true
        NSLayoutConstraint(item: pinShadowView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: pinShadowViewDiameter).isActive = true
        
        let resultViewConstraints = [
            resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(resultViewConstraints)
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: Gesture Recognizer
    
    @objc func panGestureInMapViewDidRecognize(panGestureRecognizer: UIPanGestureRecognizer) {
        switch(panGestureRecognizer.state) {
        case .began:
            isMapViewCenterChanged = true
            selectedLocationItem = nil
            geocoder.cancelGeocode()
            
            searchBar.text = nil
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
            if let doneButtonItem = barButtonItems?.doneButtonItem {
                doneButtonItem.isEnabled = false
            }
        default:
            break
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    // MARK: Buttons
    
    @objc private func doneButtonDidTap(barButtonItem: UIBarButtonItem) {
        if let locationItem = selectedLocationItem {
            dismiss(animated: true, completion: nil)
            locationDidPick(locationItem: locationItem)
        }
    }
    
    @objc private func cancelButtonDidTap(barButtonItem: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UI Mainipulations
    
    private func showMapView(withCenter coordinate: CLLocationCoordinate2D, distance: Double) {
//        mapViewHeightConstraint.constant = mapViewHeight
        
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 0 , longitudinalMeters: distance)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func closeMapView() {
//        mapViewHeightConstraint.constant = 0
        self.mapView(isHidden: true)
    }
    
    
    // MARK: Location Handlers
    public func selectLocationItem(_ locationItem: LocationItem) {
        print("place mark calls")
        selectedLocationItem = locationItem
//        searchBar.text = locationItem.name
        resultView.locationItem = locationItem
        if let coordinate = locationItem.coordinate {
            showMapView(withCenter: coordinateObject(fromTuple: coordinate), distance: longitudinalDistance)
        } else {
            closeMapView()
        }
        barButtonItems?.doneButtonItem.isEnabled = true
        locationDidSelect(locationItem: locationItem)
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard error == nil else {
                print(error!)
                return
            }
            guard let placemarks = placemarks else { return }
            var placemark = placemarks[0]
            if !self.isRedirectToExactCoordinate {
                placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: placemark.addressDictionary as? [String : NSObject])
            }
            
            if !self.searchBar.isFirstResponder {
                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                
                self.selectLocationItem(LocationItem(mapItem: mapItem))
            }
            
//            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.03, longitude: 118.14)
            
//            self.showMapView(withCenter: placemark.location!.coordinate , distance: 300)
            
//            let span = MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, span: <#T##MKCoordinateSpan#>)
//            let region = MKCoordinateRegionMake(coordinate, span)
//            self.mapView.setRegion(region, animated: true)
        })
    }
    
}


// MARK: - Callbacks

extension LocationPicker {
    
    @objc open func locationDidSelect(locationItem: LocationItem) {
        selectCompletion?(locationItem)
        delegate?.locationDidSelect?(locationItem: locationItem)
    }
    
    @objc open func locationDidPick(locationItem: LocationItem) {
        pickCompletion?(locationItem)
        delegate?.locationDidPick?(locationItem: locationItem)
    }
    
    open func alternativeLocationDidDelete(locationItem: LocationItem) {
        deleteCompletion?(locationItem)
        dataSource?.commitAlternativeLocationDeletion?(locationItem: locationItem)
    }
    
    @nonobjc public func locationDidDeny(locationPicker: LocationPicker) {
        locationDeniedHandler?(self)
        delegate?.locationDidDeny?(locationPicker: self)
        
        if locationDeniedHandler == nil && delegate?.locationDidDeny == nil {
            if let alertController = locationDeniedAlertController {
                present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: locationDeniedAlertTitle, message: locationDeniedAlertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: locationDeniedGrantText, style: .default, handler: { (alertAction) in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                }))
                alertController.addAction(UIAlertAction(title: locationDeniedCancelText, style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}


// MARK: Search Bar Delegate

extension LocationPicker: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.mapView(isHidden: true)
    }
    
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            let localSearchRequest = MKLocalSearch.Request()
            localSearchRequest.naturalLanguageQuery = searchText
            
            if let currentCoordinate = locationManager.location?.coordinate {
                localSearchRequest.region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: searchDistance, longitudinalMeters: searchDistance)
            } else if let defaultSearchCoordinate = defaultSearchCoordinate, CLLocationCoordinate2DIsValid(defaultSearchCoordinate) {
                localSearchRequest.region = MKCoordinateRegion(center: defaultSearchCoordinate, latitudinalMeters: searchDistance, longitudinalMeters: searchDistance)
            }
            MKLocalSearch(request: localSearchRequest).start(completionHandler: { (localSearchResponse, error) -> Void in
                
                guard searchText == searchBar.text else {
                    // Ensure that the result is valid for the most recent searched text
                    return
                }
                guard error == nil,
                    let localSearchResponse = localSearchResponse, localSearchResponse.mapItems.count > 0 else {
                        if self.isAllowArbitraryLocation {
                            let locationItem = LocationItem(locationName: searchText)
                            self.searchResultLocations = [locationItem]
                        } else {
                            self.searchResultLocations = []
                        }
                        self.tableView.reloadData()
                        return
                }
                
                print("search bar text ******** \(searchText)")
                self.searchResultLocations = localSearchResponse.mapItems.filter({ (mapItem) -> Bool in
                    return self.shouldShowSearchResult(for: mapItem)
                }).map({ LocationItem(mapItem: $0) })
                
                if self.isAllowArbitraryLocation {
                    let locationFound = self.searchResultLocations.filter({
                        $0.name.lowercased() == searchText.lowercased()}).count > 0
                    
                    if !locationFound {
                        // Insert arbitrary location without coordinate
                        let locationItem = LocationItem(locationName: searchText)
                        self.searchResultLocations.insert(locationItem, at: 0)
                    }
                }
                
                self.tableView.reloadData()
            })
        } else {
            selectedLocationItem = nil
            searchResultLocations.removeAll()
            tableView.reloadData()
            closeMapView()
            if let doneButtonItem = barButtonItems?.doneButtonItem {
                doneButtonItem.isEnabled = false
            }
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: Table View Delegate and Data Source
extension LocationPicker: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + searchResultLocations.count + alternativeLocationCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LocationCell!
        
        if indexPath.row == 0 {
            cell = LocationCell(locationType: .currentLocation, locationItem: nil)
            cell.locationNameLabel.text = currentLocationText
            cell.iconView.image = currentLocationIcon ?? StyleKit.imageOfMapPointerIcon(color: currentLocationIconColor)
        } else if indexPath.row > 0 && indexPath.row <= searchResultLocations.count {
            let index = indexPath.row - 1
            cell = LocationCell(locationType: .searchLocation, locationItem: searchResultLocations[index])
            cell.iconView.image = searchResultLocationIcon ?? StyleKit.imageOfSearchIcon(color: searchResultLocationIconColor)
        } else if indexPath.row > searchResultLocations.count && indexPath.row <= alternativeLocationCount + searchResultLocations.count {
            let index = indexPath.row - 1 - searchResultLocations.count
            let locationItem = (alternativeLocations?[index] ?? dataSource?.alternativeLocation(at: index))!
            cell = LocationCell(locationType: .alternativeLocation, locationItem: locationItem)
            cell.iconView.image = alternativeLocationIcon ?? StyleKit.imageOfPinIcon(color: alternativeLocationIconColor)
        }
        cell.locationNameLabel.textColor = primaryTextColor
        cell.locationAddressLabel.textColor = secondaryTextColor
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        longitudinalDistance = defaultLongitudinalDistance
        
        if indexPath.row == 0 {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                locationDidDeny(locationPicker: self)
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                break
            }
            if let currentLocation = locationManager.location {
                reverseGeocodeLocation(currentLocation)
            }
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! LocationCell
            let locationItem = cell.locationItem!
            let coordinate = locationItem.coordinate
            if (coordinate != nil && self.isForceReverseGeocoding) {
                print("select first")
                reverseGeocodeLocation(CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude))
            } else {
                print("select second")
                selectLocationItem(locationItem)
            }
        }
        self.mapView(isHidden: false)
    }
    
    public func mapView(isHidden:Bool) {
        self.tableView.isHidden = !isHidden
        self.mapView.isHidden = isHidden
        self.resultView.isHidden = isHidden
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isAlternativeLocationEditable && indexPath.row > searchResultLocations.count && indexPath.row <= alternativeLocationCount + searchResultLocations.count
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! LocationCell
            let locationItem = cell.locationItem!
            let index = indexPath.row - 1 - searchResultLocations.count
            alternativeLocations?.remove(at: index)
            
            alternativeLocationDidDelete(locationItem: locationItem)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}


// MARK: Map View Delegate

extension LocationPicker: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if !animated {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                self.pinView.frame.origin.y -= self.pinViewImageHeight / 2
                }, completion: nil)
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        longitudinalDistance = getLongitudinalDistance(fromMapRect: mapView.visibleMapRect)
        if isMapViewCenterChanged {
            isMapViewCenterChanged = false
            if #available(iOS 10, *) {
                let coordinate = mapView.centerCoordinate
                reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            } else {
                let adjustedCoordinate = gcjToWgs(coordinate: mapView.centerCoordinate)
                reverseGeocodeLocation(CLLocation(latitude: adjustedCoordinate.latitude, longitude: adjustedCoordinate.longitude))
            }
        }
        
        if !animated {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                self.pinView.frame.origin.y += self.pinViewImageHeight / 2
                }, completion: nil)
        }
    }
    
}


// MARK: Location Manager Delegate

extension LocationPicker: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (tableView.indexPathForSelectedRow as NSIndexPath?)?.row == 0 {
            let currentLocation = locations[0]
            reverseGeocodeLocation(currentLocation)
            guard #available(iOS 9.0, *) else {
                locationManager.stopUpdatingLocation()
                return
            }
        }
    }
    
}
