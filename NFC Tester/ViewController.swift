//
//  ViewController.swift
//  NFC Tester
//
//  Created by Bruno Philipe on 6/6/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet var textView: UITextView!

	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		log(date: Date(), title: "ViewController")
	}

	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)

		setLogReceiver()
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	fileprivate func setLogReceiver()
	{
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate
		{
			appDelegate.logReceiver = self
		}
	}

	private lazy var titleMessageAttributes: [NSAttributedString.Key: NSObject] =
	{
		return [
			NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 12.0)!
		] as [NSAttributedString.Key: NSObject]
	}()

	private lazy var bodyMessageAttributes: [NSAttributedString.Key: NSObject] =
	{
		return [
			NSAttributedString.Key.font: UIFont(name: "Menlo", size: 12.0)!
			] as [NSAttributedString.Key: NSObject]
	}()

	private lazy var logDateFormatter: DateFormatter =
	{
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .medium

		return formatter
	}()

	fileprivate func log(date: Date = Date(), title: String)
	{
		log(message: logDateFormatter.string(from: date), title: title)
	}

	fileprivate func log(message: String, title: String)
	{
		DispatchQueue.main.async
			{
				let newText = self.textView.attributedText.mutableCopy() as! NSMutableAttributedString

				newText.append(NSAttributedString(string: "\n"))
				newText.append(NSAttributedString(string: "[\(title) \(self.logDateFormatter.string(from: Date()))] ", attributes: self.titleMessageAttributes))
				newText.append(NSAttributedString(string: message, attributes: self.bodyMessageAttributes))

				self.textView.attributedText = newText
				self.textView.scrollRangeToVisible(NSMakeRange(newText.length, 0))
			}
	}
}

extension ViewController // IBActions
{
	@IBAction func didTapNewSession(_ sender: Any)
	{
		setLogReceiver()
	}

	@IBAction func didTapAddMarker(_ sender: Any)
	{
		log(title: "Marker")
	}

	@IBAction func didTapClearLog(_ sender: Any)
	{
		textView.attributedText = NSAttributedString(string: "")
	}
}

extension ViewController: LogReceiver
{
	func log(_ message: String)
	{
		log(message: message, title: "NFC Session")
	}
}
