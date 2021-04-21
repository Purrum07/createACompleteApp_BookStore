//
//  ViewController.swift
//  TestURLSession
//
//  Created by user192467 on 4/13/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var idTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func performRequestButton(_ sender: UIButton) {
        makeGetCall(idTextField.text!, descriptionTextView, closure)
    }
    
    public typealias UpdateTitleClosure = (String?, UITextView?) -> Void
    
    var closure: UpdateTitleClosure = {
        (title, textView) in
        print(title!)
        DispatchQueue.main.async {
            textView!.text = title
        }
    }
    
    func makeGetCall(_ id: String, _ descriptionTextView: UITextView, _ handler: @escaping UpdateTitleClosure) {
        let todoEndpoint: String = "https://tec-foundit.herokuapp.com/api/item/\(id)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest){
            (data, response, error) in
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let todoResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                            
                guard let todoTitle = todoResponse["description"] as? String else {
                        print("Could not get todo title from JSON")
                        return
                }
                            
                handler(todoTitle, descriptionTextView)
                } catch  {
                print("error trying to convert data to JSON")
                    return
                }


                
        }
        task.resume()
    }

}

