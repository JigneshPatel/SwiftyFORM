// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import SwiftyFORM

class Tutorial2_ChildViewController_ViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder += ViewControllerFormItem().title("Go to view controller").viewController(FirstViewController.self)
	}
}
