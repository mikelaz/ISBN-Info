//
//  ViewController.swift
//  ISBN-Info
//
//  Created by Mikel Aguirre on 11/3/16.
//  Copyright © 2016 Mikel Aguirre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var entradaTexto: UITextField!
    
    @IBOutlet weak var textViewResultado: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configurarTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configurarTextField (){
        entradaTexto.placeholder = NSLocalizedString("Introduzca ISBN a buscar", comment: "")
        entradaTexto.returnKeyType = .Search
        entradaTexto.clearButtonMode = .Always
        entradaTexto.keyboardType = .NumbersAndPunctuation
        entradaTexto.spellCheckingType = .No
        entradaTexto.autocorrectionType = .No
    }
    
    func llamadaSincronaOpenLibrary (isbn: String)->String{
        
        var urlString = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urlString = "\(urlString)\(isbn)"
        let url = NSURL (string: urlString)
        let datos:NSData? = NSData(contentsOfURL: url!)
        if datos != nil{
            let resultado = NSString(data:datos!, encoding: NSUTF8StringEncoding)
            if resultado == "{}"{
                return ("ISBN no encontrado")
            }else{
                return resultado! as String
            }
        }else{
            return ("Error en la conexión con openlibrary.org")
        }
        
    }
    
    func lanzarAlerta(titulo: String, mensaje: String){
        // Initialize Alert Controller
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .Alert)
        
        // Initialize Actions
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .Default) { (action) -> Void in
            print("Aceptado")
        }
        
        // Add Actions
        alertController.addAction(accionAceptar)
        
        // Present Alert Controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        
        //Lanzado al hacer click en buscar (finalizar edición)
        textViewResultado.text!.removeAll()
        if (entradaTexto.text!.isEmpty){
            lanzarAlerta("Aviso", mensaje: "Introduzca un ISBN")
        }else{
            textViewResultado.text = llamadaSincronaOpenLibrary(entradaTexto.text!)
        }
        //ocultar teclado
        sender.resignFirstResponder()
    }
    

}

