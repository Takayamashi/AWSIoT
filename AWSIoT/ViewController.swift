//
//  ViewController.swift
//  AWSIoT
//
//  Created by Ryuichi Takayama on 2018/07/06.
//  Copyright © 2018年 takayamashi. All rights reserved.
//

import UIKit
import AWSLambda
import AWSCognito
import AWSCore
import AWSMobileClient
import AWSAuthCore
import AWSAuthUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //cognitoの指定ここはcognitoのサンプルコードを丸写し
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APNortheast1,
                                                                identityPoolId:"ap-northeast-1:dc7c778b-08aa-4ac2-9211-13740c239210")
        
        let configuration = AWSServiceConfiguration(region:.APNortheast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func LambdaLock(key: String){
        let lambdaInvoker = AWSLambdaInvoker.default()
        let jsonObject: [String: Any] = ["key1" : key,
                                         "isError" : false]
        
        lambdaInvoker.invokeFunction("myFunc_iot", jsonObject: jsonObject).continueWith(block: {(task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error {
                print("Error: \(error)")
                return nil
            }
            if let JSONDictionary = task.result {
                print("Result: \(JSONDictionary)")
            }
            return nil
        })
    }
    
    
    func LambdaDynamo(){
        let lambdaInvoker = AWSLambdaInvoker.default()
        let jsonObject: [String: Any] = ["key1" : "OK",
                                         "isError" : false]
        
        lambdaInvoker.invokeFunction("myDynamoDB_get", jsonObject: jsonObject).continueWith(block: {(task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error {
                print("Error: \(error)")
                return nil
            }
            if let JSONDictionary = task.result {
                print("Result: \(JSONDictionary)")
            }
            return nil
        })
    }
    
    
    //lockのボタン（左）押したらjsonObjectをlambdaに送る
    @IBAction func Lock(_ sender: Any) {
        
        LambdaLock(key: "0")
        LambdaDynamo()
    }
    

    
    //unlockのボタン（右）押したらjsonObjectをlambdaに送る
    @IBAction func Unlock(_ sender: Any) {
        
        LambdaLock(key: "1")
        LambdaDynamo()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

