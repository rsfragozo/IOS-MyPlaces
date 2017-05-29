import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        mapView.delegate = self
    }
    
    @IBAction func btnOndeEstouClick(_ sender: AnyObject) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let local = locations.last!
        let regiao = MKCoordinateRegion(center: local.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(regiao, animated: true)
        manager.stopUpdatingLocation()
    }
    
    func adicionarLocal(_ local: Local) {
        mapView.addAnnotation(local)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! AdicionarLocalViewController
        dest.vcMapa = self
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let id = "marcador"
        
        if let local = annotation as? Local {
            var view: MKPinAnnotationView
            if let deqView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
                as? MKPinAnnotationView {
                    deqView.annotation = local
                    view = deqView
            } else {
                view = MKPinAnnotationView(annotation: local, reuseIdentifier: id)
                view.canShowCallout = true
            }
            
            view.pinTintColor = local.cor()
            return view
        }
        return nil
    }
}
