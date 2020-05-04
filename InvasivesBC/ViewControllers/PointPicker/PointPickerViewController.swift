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
    let minPointRadius: Double = 1
    let maxPointRadius: Double = 100
    let regionRadius: CLLocationDistance = 200
    let chooseRatiusText = "Tap a new location, or use the slider to add a radius for your work area."
    let chooseLocationText = "Tap to set a location"
    
    // MARK: Variables
    var locationManager: CLLocationManager = CLLocationManager()
    var locationAuthorizationstatus: CLAuthorizationStatus?
    var currentLocation: CLLocation?
    var radiusOverlay: MKCircle?
    var selectedPoint: CLLocationCoordinate2D? {
        didSet {
            setConfirmButton()
            setState()
        }
    }
    var radius: Double = 50 {
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
    @IBOutlet weak var radiusField: UITextField!
    @IBOutlet weak var radiusBar: UIView!
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
        Alert.show(title: "Selected", message: "location:(\(location.latitude), \(location.longitude))\nradius: \(radius)")
        print("show form")
    }
    
    @IBAction func locationAction(_ sender: Any) {
        focusOnCurrent()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.radius = Double(sender.value)
    }
    
    @IBAction func radiusValueChanged(_ sender: UITextField) {
        guard
            let text = sender.text,
            text.isDouble,
            Double(text)! >= minPointRadius,
            Double(text)! <= maxPointRadius
            else {
                return
        }
        radius = Double(text)?.roundToDecimal(0) ?? minPointRadius
        slider.setValue(Float(radius), animated: true)
    }
    
    // MARK: Style & Setup
    func style() {
        styleFillButton(button: confirmButton)
        styleFillButton(button: locationButton)
        setConfirmButton()
        setNavigationBar(hidden: false, style: .default)
        setupSlider()
        setState()
        styleCard(layer: descriptionBar.layer)
        styleCard(layer: radiusBar.layer)
    }
    
    /// Initialize slider with initial, min and max values & style
    func setupSlider() {
        slider.minimumValue = Float(minPointRadius)
        slider.maximumValue = Float(maxPointRadius)
        slider.tintColor = Colors.primary
        slider.setValue(Float(radius), animated: true)
    }
    
    /// show or hide the confirmation button if needed
    func setConfirmButton() {
        confirmButton.isHidden = selectedPoint == nil
        animateIt()
    }
    
    /// Set the state of the page: Selecting point or selecting radius
    func setState() {
        let shouldShowRadius = selectedPoint != nil
        descriptionLabel.text = shouldShowRadius ? chooseRatiusText : chooseLocationText
        descriptionLabel.font = Fonts.getPrimaryMedium(size: 17)
        radiusBar.isHidden = shouldShowRadius ? false : true
        radiusField.text = "\(radius.roundToDecimal(0))"
        animateIt()
        guard let point = selectedPoint else {
            return
        }
        showRadius(around: point, radius: radius)
        slider.setValue(Float(radius), animated: true)
    }
    
    /// Display Radius circle overlay at location with given radius.
    /// - Parameters:
    ///   - location: coordinates
    ///   - radius: circle radius
    func showRadius(around location: CLLocationCoordinate2D, radius: Double) {
        if let existing = radiusOverlay {
            mapView.removeOverlay(existing)
        }
        radiusOverlay = MKCircle(center: location, radius: radius)
        mapView.addOverlay(radiusOverlay!)
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
