//
//  MainScreenViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/6/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?
    )
}

class MainScreenRouter: Router {
    unowned let mainScreenViewModel: MainScreenViewModel
    
    init(viewModel: MainScreenViewModel) {
        mainScreenViewModel = viewModel
    }
    
    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        guard let route = MainScreenViewController.Route(rawValue: routeID) else {
            return
        }
        
        switch route {
        case .logout:
            routeToAuthViewController(from: context)
        case .challenge:
            routeToChallengeTestViewController(from: context)
        case .test:
            routeToTestViewController(from: context, parameters: parameters)
        default:
            break
        }
    }
    
    func routeToAuthViewController(from context: UIViewController) {
        guard let authViewController = context.storyboard?.instantiateViewController(withIdentifier: QuizAuthViewController.storyboardID) else {
            return
        }
        
        context.present(authViewController, animated: true, completion: nil)
    }
    
    func routeToTestViewController(from context: UIViewController, parameters: Any?) {
        guard let startingTestData = parameters as? MainScreenViewModel.StartingTestData else { return }
        
        context.performSegue(withIdentifier: MainScreenViewController.SegueIdentifier.quizInTestNavigationViewController.rawValue, sender: startingTestData)
    }
    
    func routeToChallengeTestViewController(from context: UIViewController) {
        guard let startingTestData = mainScreenViewModel.startingDataForChallengeMode() else { return }
        
        context.performSegue(withIdentifier: MainScreenViewController.SegueIdentifier.quizInTestNavigationViewController.rawValue, sender: startingTestData)
    }
}

class MainScreenViewController: UIViewController, SegueHandler {
    
    enum Route: String {
        case logout
        case test
        case challenge
        case history 
    }
    
    @IBOutlet weak var historyBarButtonIten: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    let mainScreenViewModel = MainScreenViewModel()
    var mainScreenRouter: MainScreenRouter!
    let quizAuthModule = QuizAuthModule()
    var categoriesTableViewDataSource: QuizPickerTableViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScreenRouter = MainScreenRouter(viewModel: mainScreenViewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainScreenViewModel.isUserLogIn { (result) in
            if result {
                DispatchQueue.main.async { [weak self] in
                    self?.setUpCategoriesTableView()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.mainScreenRouter.route(to: Route.logout.rawValue, from: strongSelf, parameters: nil)
                }
            }
        }
        
        self.title = mainScreenViewModel.title
       
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        
        self.navigationController?.isToolbarHidden = false
    }

    @IBAction func logOutButtonPressed(_ sender: Any) {
        mainScreenViewModel.logOut()
        mainScreenRouter.route(to: Route.logout.rawValue, from: self, parameters: nil)
    }
    
    @IBAction func challengeButtonPressed(_ sender: Any) {
        mainScreenRouter.route(to: Route.challenge.rawValue, from: self, parameters: nil)
    }
    
    func setUpCategoriesTableView() {
        mainScreenViewModel.fetchCategories { [weak self] (result) in
            
            guard case MainScreenViewModel.FetchResult.success = result else {
                return
            }
            
            guard let strongSelf = self else { return }
            let cellSettings = strongSelf.mainScreenViewModel.quizPickerTableViewCellSettings
        
            DispatchQueue.main.async {
                strongSelf.categoriesTableViewDataSource = QuizPickerTableViewDataSource(tableView: strongSelf.categoriesTableView,
                                                                                         mode: .categories,
                                                                                         dataSource: cellSettings)
                
                self?.categoriesTableView.dataSource = self?.categoriesTableViewDataSource
                self?.categoriesTableViewDataSource?.quizPickerTableViewDelegate = self
                
                strongSelf.categoriesTableView.reloadData()
            }
        }
    }
    
    func presentStartTestAlert(startingTestData: MainScreenViewModel.StartingTestData) {
        let startTestAlert = UIAlertController(title: "Start test", message: "Start this test?", preferredStyle: UIAlertControllerStyle.alert)
        
        let startButtonAction = UIAlertAction(title: "Start", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.mainScreenRouter.route(to: Route.test.rawValue, from: strongSelf, parameters: startingTestData)
        })
        
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in })
        
        startTestAlert.addAction(startButtonAction)
        startTestAlert.addAction(cancelButtonAction)
        
        self.present(startTestAlert, animated: true) { 
            print("startTestAlert presented")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .quizInTestNavigationViewController:
            guard let navigationControler = segue.destination as? UINavigationController else {
                return
            }
            
            guard let quizInTestViewController = navigationControler.topViewController as? QuizTestViewController else {
                return
            }
            
            guard let startingTestData = sender as? MainScreenViewModel.StartingTestData else {
                return
            }
            
            quizInTestViewController.testCategory = startingTestData.testCategory
            quizInTestViewController.testMode = startingTestData.testMode
            
        case .quizHistoryViewControllerSegueStoryboardID:
            break
        }
    }
    
    enum SegueIdentifier: String {
        case quizInTestNavigationViewController = "quizInTestNavigationViewControllerSegueStoryboardID"
        case quizHistoryViewControllerSegueStoryboardID = "quizHistoryViewControllerSegueStoryboardID"
    }
}

extension MainScreenViewController: QuizPickerTableViewCellDelegate {
    func cellDidClicked(cellID: String) {
        print("Controller tells: cell with \(cellID) ID did clicked")
        
        guard let testCategory = mainScreenViewModel.category(fromCategoryID: cellID) else {
            return
        }
        
        let startingTestData = MainScreenViewModel.StartingTestData(.normal, testCategory)
        presentStartTestAlert(startingTestData: startingTestData)
    }
}
