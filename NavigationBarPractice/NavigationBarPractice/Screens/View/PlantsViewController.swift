//
//  ViewController.swift
//  NavigationBarPractice
//
//  Created by yutong on 2021/10/26.
//

import UIKit

class PlantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var viewModel = {
        PlantsViewModel()
    }()

    var loadingIndicatorView:UIActivityIndicatorView?
    var totalViewY:CGFloat = 0
    var navViewH:CGFloat = 0
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    func initView() {
        loadingIndicatorView = UIActivityIndicatorView(style: .medium)
        loadingIndicatorView!.frame = CGRect(origin: view.center, size: (loadingIndicatorView?.frame.size)!)
        view.addSubview(loadingIndicatorView!)
        totalViewY = totalView.frame.minY
        navViewH = navView.frame.height
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func initViewModel() {
        loadingIndicatorView!.startAnimating()
        viewModel.getPlants()
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.loadingIndicatorView!.stopAnimating()
                self?.totalLabel.text = "Total \(self?.viewModel.plantCellViewModels.count ?? 0) Plants."
                self?.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.plantCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getCellH(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return plantHeightDic.keys.contains(indexPath) ? plantHeightDic[indexPath]! : viewModel.getCellH(indexPath.row)
    }
    
    var plantHeightDic = [IndexPath:CGFloat]()
    var lastIndexPath:IndexPath?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCellIdentifier", for: indexPath) as! PlantTableViewCell
        cell.cellViewModel = viewModel.getCellViewModel(at: indexPath)
        plantHeightDic[indexPath] = cell.cellH
        lastIndexPath = indexPath
        return cell
    }
    
    var lastScrollOffset = CGPoint(x: 0, y: 0)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let statusH = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if scrollView.contentOffset.y > lastScrollOffset.y {
            if lastIndexPath != nil {
                if viewModel.checkRowForGetNewCells(lastIndexPath!.row) {
                    loadingIndicatorView!.startAnimating()
                    viewModel.getPlants()
                }
            }
        }

        let offsetY = scrollView.contentOffset.y
        let totalMinY = totalView.frame.minY
        if (offsetY > 0 && totalMinY > statusH) || (offsetY < 0 && totalMinY < totalViewY-1) {
            var totalY = totalMinY-offsetY
            totalY = totalY < statusH ? statusH : totalY
            totalY = totalY > totalViewY ? totalViewY :totalY
            totalView.frame = CGRect(origin: CGPoint(x: 0, y: totalY), size: totalView.frame.size)
            navView.frame = CGRect(origin: navView.frame.origin, size: CGSize(width: navView.frame.width, height: totalY))
            scrollView.frame = CGRect(x: 0, y: totalView.frame.maxY, width: scrollView.frame.width, height: scrollView.frame.height+offsetY)
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        
        lastScrollOffset = scrollView.contentOffset
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
}

