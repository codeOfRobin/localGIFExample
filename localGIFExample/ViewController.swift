//
//  ViewController.swift
//  localGIFExample
//
//  Created by Robin Malhotra on 06/12/16.
//  Copyright © 2016 Robin Malhotra. All rights reserved.
//

import AsyncDisplayKit

class ViewController: UIViewController {

	let loader = ASNetworkImageNode()
	override func viewDidLoad() {
		super.viewDidLoad()
		let bundleURL = Bundle.main.url(forResource: "dancing-banana", withExtension: "gif")
		loader.url = bundleURL
		view.addSubnode(loader)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillLayoutSubviews() {
		loader.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

