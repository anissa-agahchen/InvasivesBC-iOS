//
//  PointPickerViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-05-04.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit
import MapKit

class PointPickerViewController: BaseViewController {
    
    // MARK: Constsnts
    let minArea: Double = 1
    let maxArea: Double = 100
    let regionRadius: CLLocationDistance = 200
    let chooseAreaText = "Tap a new location, or use the slider to add an estimated area for your work area."
    let chooseLocationText = "Tap to set a location"
    
    // MARK: Variables
    var locationManager: CLLocationManager = CLLocationManager()
    var locationAuthorizationstatus: CLAuthorizationStatus?
    var currentLocation: CLLocation?
    var areaOverlay: MKCircle?
    var selectedPoint: CLLocationCoordinate2D? {
        didSet {
            setConfirmButton()
            setState()
        }
    }
    var area: Double = 50 {
        didSet {
            setState()
        }
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var areaField: UITextField!
    @IBOutlet weak var areaBar: UIView!
    @IBOutlet weak var descriptionBar: UIView!
    
    // MARK: States
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        setupMap()
        addTapGestureRecognizer()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        style()
    }
    
    // MARK: Outlet Actions
    @IBAction func okayAction(_ sender: Any) {
        guard let location = selectedPoint else {return}
        Alert.show(title: "Selected", message: "location:(\(location.latitude), \(location.longitude))\narea: \(area)")
        print("show form")
    }
    
    @IBAction func locationAction(_ sender: Any) {
        focusOnCurrent()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.area = Double(sender.value)
    }
    
    @IBAction func areaValueChanged(_ sender: UITextField) {
        guard
            let text = sender.text,
            text.isDouble,
            Double(text)! >= minArea,
            Double(text)! <= maxArea
            else {
                return
        }
        area = Double(text)?.roundToDecimal(0) ?? minArea
        slider.setValue(Float(area), animated: true)
    }
    
    // MARK: Style & Setup
    func style() {
        self.title = "Work Area"
        styleFillButton(button: confirmButton)
        styleFillButton(button: locationButton)
        setConfirmButton()
        setNavigationBar(hidden: false, style: .default)
        setupSlider()
        setState()
        styleCard(layer: descriptionBar.layer)
        styleCard(layer: areaBar.layer)
    }
    
    /// Initialize slider with initial, min and max values & style
    func setupSlider() {
        slider.minimumValue = Float(minArea)
        slider.maximumValue = Float(maxArea)
        slider.tintColor = Colors.primary
        slider.setValue(Float(area), animated: true)
    }
    
    /// show or hide the confirmation button if needed
    func setConfirmButton() {
        confirmButton.isHidden = selectedPoint == nil
        animateIt()
    }
    
    /// Set the state of the page: Selecting point or selecting radius
    func setState() {
        let shouldShowArea = selectedPoint != nil
        descriptionLabel.text = shouldShowArea ? chooseAreaText : chooseLocationText
        descriptionLabel.font = Fonts.getPrimaryMedium(size: 17)
        areaBar.isHidden = shouldShowArea ? false : true
        areaField.text = "\(area.roundToDecimal(0))"
        animateIt()
        guard let point = selectedPoint else {
            return
        }
        showArea(around: point, area: area)
        slider.setValue(Float(area), animated: true)
    }
    
    /// Display Circle Area around location with give area
    /// - Parameters:
    ///   - location: coordinates
    ///   - area: circle area
    func showArea(around location: CLLocationCoordinate2D, area: Double) {
        if let existing = areaOverlay {
            mapView.removeOverlay(existing)
        }
        let radius = sqrt(area / Double.pi)
        print("area: \(area)\n Radius: \(radius)")
        areaOverlay = MKCircle(center: location, radius: radius)
        mapView.addOverlay(areaOverlay!)
    }
}

// MARK: Location
extension PointPickerViewController: CLLocationManagerDelegate {
    
    /// Setup Location services
    func setupLocation() {
        locationManager.delegate = self
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Location Delegates
    
    /// Set user's current location coodinates on change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
        }
    }
    
    
    /// Handle user having disabled location access
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationAuthorizationstatus = status
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    /// Present an alert asking for user's location access  - will open settings
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Location Access Disabled",
                                                message: "We need permission",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
}

// MARK: Map
extension PointPickerViewController: MKMapViewDelegate {
    
    /// Setup map
    func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // Set map region
        var noLocation = CLLocationCoordinate2D()
        // set view region
        noLocation.latitude = 48.424251
        noLocation.longitude = -123.365729
        let viewRegion = MKCoordinateRegion.init(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
        
        // Begin listening for user location
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    /// Move displlayed map region to location
    /// - Parameters:
    ///   - latitude: coordinate lat
    ///   - longitude: coordinate long
    func moveMapTo(latitude: Double, longitude: Double) {
        let loc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegion.init(center: loc,latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /// Center map on user's current location
    func focusOnCurrent() {
        let loc = locationManager.location?.coordinate
        guard let location = loc else { return }
        moveMapTo(latitude: location.latitude, longitude: location.longitude)
    }
    
    
    /// Drop a pin at location
    /// - Parameter location: coordinates
    func dropPin(location: CLLocationCoordinate2D) {
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = location
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(myAnnotation)
    }
    
    
    /// Drop pin and move map to coordinates
    /// - Parameter location: coordinates
    func selectPoint(location: CLLocationCoordinate2D) {
        dropPin(location: location)
        selectedPoint = location
        moveMapTo(latitude: location.latitude, longitude: location.longitude)
    }
    
    // MARK: Map Delegates
    /// Handle the display of Circle overlay for radius
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = Colors.primary.withAlphaComponent(0.7)
            return circleRenderer
        }
        else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

// MARK: Interactions
extension PointPickerViewController: UIGestureRecognizerDelegate {
    
    /// Add a gesture recogrnizer to recoganize a tap spot on the map
    func addTapGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    /// Handles a tapped location on the map: Select the coordinates at the tapped location
    /// - Parameter gestureRecognizer: UILongPressGestureRecognizer
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let loc = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        selectPoint(location: loc)
    }
}
