import Foundation

import UIKit
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AdicionarLocalViewController : UIViewController,
    CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var segTipo: UISegmentedControl!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var pickEndereco: UIPickerView!
    
    @IBOutlet weak var btnSalvar: UIBarButtonItem!
    @IBOutlet weak var btnAqui: UIButton!
    
    let locationManager = CLLocationManager()
    var localSelecionado: CLPlacemark? = nil
    var locais = [CLPlacemark]()
    var vcMapa : ViewController?
    
    override func viewDidLoad() {
        btnSalvar.isEnabled = false
        btnAqui.isEnabled = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        pickEndereco.delegate = self
        pickEndereco.dataSource = self
    }
    
    func verificarSalvar() {
        btnSalvar.isEnabled =
            !txtNome.text!.isEmpty &&
            localSelecionado != nil
    }
    
    func formataLocal(_ local : CLPlacemark) -> String {
        let campos = local.addressDictionary!
        let endereco = campos["FormattedAddressLines"] as! NSArray
        return endereco.componentsJoined(by: ", ")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let local = locations.last!
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(local,
            completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    print("Erro: \(error!.localizedDescription)")
                    return
                }
                
                if placemarks?.count > 0 {
                    let marco = placemarks![0] as CLPlacemark
                    self.txtNome.text = marco.name
                    self.txtEndereco.text = self.formataLocal(marco)
                    self.localSelecionado = marco
                    self.verificarSalvar()
                }
            }
        )
    }
    
    @IBAction func btnAquiClick(_ sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func txtNomeEdited(_ sender: AnyObject) {
        verificarSalvar()
    }
    
    @IBAction func btnCancelarClick(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func txtEnderecoEdited(_ sender: AnyObject) {
        locais = []
        localSelecionado = nil
        pickEndereco.reloadAllComponents()
        verificarSalvar()
        
        CLGeocoder().geocodeAddressString(txtEndereco.text!,
            completionHandler: { (placemarkList, error) -> Void in
                if placemarkList == nil {
                    return
                }
                self.locais = placemarkList!
                self.pickEndereco.reloadAllComponents()
                
                if placemarkList!.count == 1 {
                    self.localSelecionado = placemarkList![0]
                    self.verificarSalvar()
                }
            }
        )
    }
    
    @IBAction func btnSalvarClick(_ sender: AnyObject) {
        let local = Local(nome: txtNome.text!, coordenada: localSelecionado!.location!.coordinate);
        if (!txtDescricao.text!.isEmpty) {
            local.subtitle = txtDescricao.text!;
        }
        local.tipo = TipoLocal.array()[segTipo.selectedSegmentIndex]
        
        vcMapa?.adicionarLocal(local)
        
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locais.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return formataLocal(locais[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        localSelecionado = locais[row]
        verificarSalvar()
    }
}
