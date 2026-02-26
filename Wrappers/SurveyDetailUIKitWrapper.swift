//
//  SurveyDetailUIKitWrapper.swift
//  SurveyApp
//
//  Created by Nettem Taraka Ram Teja on 25/02/26.
//

import SwiftUI
import CoreData

struct SurveyDetailUIKitWrapper: UIViewControllerRepresentable {
    
    let survey: SurveyEntity
    
    func makeUIViewController(context: Context) -> SurveyDetailViewController {
        let storyboard = UIStoryboard(name: "SurveyDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SurveyDetailViewController") as! SurveyDetailViewController
        vc.survey = survey
        return vc
    }

    func updateUIViewController(_ uiViewController: SurveyDetailViewController, context: Context) { }
}
