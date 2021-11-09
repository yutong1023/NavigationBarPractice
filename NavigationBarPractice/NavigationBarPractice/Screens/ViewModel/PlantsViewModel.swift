//
//  PlantsViewModel.swift
//  NavigationBarPractice
//
//  Created by yutong on 2021/11/9.
//

import UIKit

class PlantsViewModel: NSObject {
    private var plantsService: PlantsService

    var reloadTableView: (() -> Void)?
    
    var plantsData:PlantsData?
    var plants = Plants()

    var plantCellViewModels = [PlantCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    init(plantsService: PlantsService = PlantsService()) {
        self.plantsService = plantsService
    }
    
    func getCellH(_ row:Int) -> CGFloat {
        if plantCellViewModels.count < row { return 211 }
        
        let data = plantCellViewModels[row]
        let minX:Double = 173
        let minY:Double = 6
        let offsetH:Double = 1
        let lineH:Double = 20.34
        let cellW = Double(UIScreen.main.bounds.width)
        let dataW:Double = cellW - minX - 10
        let charW:Double = 18.5
        
        var lines = ceil(Double(data.name.count)*charW/dataW)
        var h = minY*2+offsetH*2+lineH*lines
        
        lines = ceil(Double(data.location.count)*charW/dataW)
        h += lines*lineH
        
        lines = ceil(Double(data.feature.count)*charW/dataW)
        h += lines*lineH
        
        return CGFloat(h)
    }

    
    func checkRowForGetNewCells(_ row:Int) -> Bool {
        return row > plants.count - plantsService.limit && currentOffset < plants.count
    }

    var currentOffset = -1
    func getPlants() {
        let offset = plants.count
        if offset <= currentOffset { return }
        currentOffset = offset
        plantsService.offset = offset
        plantsService.getPlants { success, model, error in
            if success, let plantsData = model {
                self.fetchData(plantsData: plantsData)
            } else {
                print(error!)
            }
        }
    }
    
    func fetchData(plantsData: PlantsData) {
        self.plantsData = plantsData
        var vms = self.plantCellViewModels
        var ps = self.plants
        for plant in plantsData.result.results {
            ps.append(plant)
            vms.append(createCellModel(plant: plant))
        }
        plants = ps
        plantCellViewModels = vms
    }
    
    func createCellModel(plant: Plant) -> PlantCellViewModel {
        return PlantCellViewModel(id: "\(plant._id)", name: plant.F_Name_Ch, location: plant.F_Location, feature: plant.F_Feature, pic01URL: plant.F_Pic01_URL)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PlantCellViewModel {
        return plantCellViewModels[indexPath.row]
    }

}
