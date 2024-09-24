//
//  StoryboardMenuViewController.swift
//  WeSplit
//
//  Created by Виталий Овсянников on 24.09.2024.
//

import UIKit

protocol MenuControllerDelegate: AnyObject {
	var selectedPercent: Int { get }

	func selectedPercent(_ percent: Int)
}

final class StoryboardMenuViewController: UITableViewController {
	weak var delegate: MenuControllerDelegate?

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		101
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "PercentCell", for: indexPath) as? PercentCell
		else { return UITableViewCell() }

		cell.percent = indexPath.row
		if cell.percent == delegate?.selectedPercent { cell.accessoryType = .checkmark }

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.selectedPercent(indexPath.row)
		navigationController?.popViewController(animated: true)
	}
}

final class PercentCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!

	var percent: Int {
		get { Int(label.text?.components(separatedBy: " ").first ?? "0") ?? 0 }
		set { label.text = "\(newValue) %" }
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		accessoryType = .none
	}
}
