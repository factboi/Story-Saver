//
//  FeaturesPageViewController.swift
//  Story Saver
//
//  Created by factboi on 29.05.2020.
//  Copyright © 2020 fact.inc. All rights reserved.
//

import UIKit

class FeaturesPageViewController: UIPageViewController {
	
	lazy var viewControllerList: [UIViewController] = {
		let onboardingViewController = OnboardingViewController()
		let subscriptionsViewController = SubscriptionsViewController()
		return [onboardingViewController, subscriptionsViewController]
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let firstVC = viewControllerList.first else {
			return
		}
		if let onboardingVC = viewControllerList.first as? OnboardingViewController {
			onboardingVC.onNextButtonClicked = { [unowned self] in
				guard let currentViewController = self.viewControllers?.first else { return }
				
				guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
				
				self.setViewControllers([nextViewController], direction: .forward, animated: true)
			}
		}
		dataSource = self
		setViewControllers([firstVC], direction: .forward, animated: true)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension FeaturesPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let index = viewControllerList.firstIndex(of: viewController) else {
			return nil
		}
		let prevIndex = index - 1
		guard prevIndex >= 0 else {
			return nil
		}
		guard viewControllerList.count > prevIndex else {
			return nil
		}
		return viewControllerList[prevIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let index = viewControllerList.firstIndex(of: viewController) else {
			return nil
		}
		let nextIndex = index + 1
		
		guard nextIndex >= 0 else {
			return nil
		}
		guard viewControllerList.count != nextIndex else {
			return nil
		}
		
		guard viewControllerList.count > nextIndex else {
			return nil
		}
		
		return viewControllerList[nextIndex]
	}
	
	
}
