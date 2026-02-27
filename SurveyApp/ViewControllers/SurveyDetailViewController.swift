//
//  SurveyDetailViewController.swift
//  SurveyApp
//
//  Created by Nettem Taraka Ram Teja on 24/02/26.
//

import UIKit
import CoreData

class SurveyDetailViewController: UIViewController {

    var survey: SurveyEntity?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var serviceRatingLabel: UILabel!
    @IBOutlet weak var supportRatingLabel: UILabel!
    @IBOutlet weak var satisfactionRatingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        guard let survey = survey else { return }

        nameLabel.text = "Name: \(survey.name ?? "")"
        emailLabel.text = "Email: \(survey.email ?? "")"
        phoneLabel.text = "Phone: \(survey.phone ?? "")"
        carModelLabel.text = "Car Model: \(survey.carModel ?? "")"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        serviceDateLabel.text = "Service Date: \(formatter.string(from: survey.serviceDate ?? Date()))"

        serviceRatingLabel.text = "Service Rating: \(survey.serviceRating)"
        supportRatingLabel.text = "Support Rating: \(survey.supportRating)"
        satisfactionRatingLabel.text = "Satisfaction Rating: \(survey.satisfactionRating)"
    }
}
