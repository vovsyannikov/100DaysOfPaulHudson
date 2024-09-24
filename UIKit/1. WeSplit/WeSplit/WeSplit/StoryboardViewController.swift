//
//  StoryboardViewController.swift
//  WeSplit
//
//  Created by Виталий Овсянников on 24.09.2024.
//

import UIKit

class StoryboardMainViewController: UITableViewController {
	@IBOutlet weak var lblSumm: UITextField!
	@IBOutlet weak var btnPeopleCount: UIButton!
	@IBOutlet weak var cellPeopleCount: UITableViewCell!

	@IBOutlet weak var lblTipAmount: UILabel!

	@IBOutlet weak var lblTotalAmount: UILabel!
	@IBOutlet weak var lblSplitAmount: UILabel!

	var summ: Double {
		get { Double(lblSumm.text ?? "0") ?? 0 }
		set {
			lblSumm.text = "\(newValue)"
			updateTotals()
		}
	}

	var peopleCount = 2
//	var peopleCount: Int {
//		get { Int(btnPeopleCount.titleLabel?.text ?? "0") ?? 0 }
//		set { btnPeopleCount.setTitle("\(newValue)", for: .normal) }
//	}

	var selectedPercent: Int {
		get { Int(lblTipAmount.text?.components(separatedBy: " ").first ?? "0") ?? 0 }
		set {
			lblTipAmount.text = "\(newValue) %"
			updateTotals()
		}
	}

	var totalAmount: Double {
		let tip = summ * Double(selectedPercent) / 100

		return summ + tip
	}
	var splitAmount: Double {
		totalAmount / Double(peopleCount)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		let peopleCountItems = (2..<100).map { count in
			UIAction(title: "\(count)") { _ in
				self.peopleCount = count
				self.updateTotals()
			}
		}
		let menu = UIMenu(
			options: [.displayInline, .singleSelection],
			children: peopleCountItems
		)

		btnPeopleCount.menu = menu

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPeopleCountMenu))
		cellPeopleCount.addGestureRecognizer(tapGesture)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		guard let vc = segue.destination as? StoryboardMenuViewController else { return }
		vc.delegate = self
	}

	@IBAction func summChanged(_ sender: UITextField) {
		updateTotals()
	}

	@objc func openPeopleCountMenu() {
		btnPeopleCount.performPrimaryAction()
	}

	private func updateTotals() {
		lblTotalAmount.text = "\(totalAmount)"
		lblSplitAmount.text = "\(splitAmount)"
	}
}

extension StoryboardMainViewController: MenuControllerDelegate {
	func selectedPercent(_ percent: Int) {
		selectedPercent = percent
	}
}

#Preview {
	let vc = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()!

	vc
}
