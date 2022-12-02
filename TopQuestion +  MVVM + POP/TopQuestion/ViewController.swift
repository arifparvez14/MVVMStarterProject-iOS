//
//  ViewController.swift
//  TopQuestion
//
//  Created by Muhammad Ariful Islam on 30/11/22.
//

import UIKit

class ViewController: UIViewController {

    let vm = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.fetchQuestionData()
    }
}

