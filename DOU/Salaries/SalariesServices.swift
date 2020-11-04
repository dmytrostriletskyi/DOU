
import Foundation

import SigmaSwiftStatistics

class SalaryService: ObservableObject {
    
    public let source: SalariesCsvSource
    
    @Published var cities: [String] = [String]()
    @Published var softwareEngineeringSalaries: [SoftwareEngineeringSalary] = [SoftwareEngineeringSalary]()
    @Published var qualityAssuranceSalaries: [QualityAssuranceSalary] = [QualityAssuranceSalary]()
    @Published var managementSalaries: [ManagementSalary] = [ManagementSalary]()
    @Published var otherSalaries: [OtherSalary] = [OtherSalary]()
    @Published var softwareEngineeringJobsPositions: [String] = [String]()
    @Published var qualityAssuranceJobsPositions: [String] = [String]()
    @Published var managementJobsPositions: [String] = [String]()
    @Published var otherJobsPositions: [String] = [String]()
    @Published var softwareEngineeringProgrammingLanguages: [String] = [String]()
    @Published var qualityAssuranceSpesializations: [String] = [String]()

    init(source: SalariesCsvSource) {
        self.source = source
        getAll()
    }

    public func getAll() -> Void {
        guard let parsedSalaries = self.source.parse() else {
            return
        }
    
        self.cities = parsedSalaries.cities.sorted { $0 < $1 }
        self.softwareEngineeringSalaries = parsedSalaries.parsedSoftwareEngineeringSalaries
        self.qualityAssuranceSalaries = parsedSalaries.parsedQualityAssuranceSalaries
        self.managementSalaries = parsedSalaries.parsedManagementSalaries
        self.otherSalaries = parsedSalaries.parsedOtherSalaries
        self.softwareEngineeringJobsPositions = parsedSalaries.parsedSoftwareEngineeringSalaries.getJobsPositions()
        self.qualityAssuranceJobsPositions = parsedSalaries.parsedQualityAssuranceSalaries.getJobsPositions()
        self.managementJobsPositions = parsedSalaries.parsedManagementSalaries.getJobsPositions()
        self.otherJobsPositions = parsedSalaries.parsedOtherSalaries.getJobsPositions()
        self.softwareEngineeringProgrammingLanguages = parsedSalaries.parsedSoftwareEngineeringSalaries.getProgrammingLanguages()
        self.qualityAssuranceSpesializations = parsedSalaries.parsedQualityAssuranceSalaries.getSpecializations()
    }
}

extension Array where Element == SoftwareEngineeringSalary {

    func getJobsPositions() -> [String] {
        return [
            "Junior Software Engineer",
            "Software Engineer",
            "Senior Software Engineer",
            "Team/Technical Lead",
            "System Architect"
        ]
    }
    
    func getProgrammingLanguages() -> [String] {
        var uniqueProgrammingLanguages: [String] = [String]()
        
        for salary in self {
            if !uniqueProgrammingLanguages.contains(salary.programmingLanguage) {
                uniqueProgrammingLanguages.append(salary.programmingLanguage)
            }
        }

        return uniqueProgrammingLanguages.sorted { $0 < $1 }
    }
}

extension Array where Element == QualityAssuranceSalary {

    func getJobsPositions() -> [String] {
        return [
            "Junior QA engineer",
            "QA Engineer",
            "Senior QA engineer",
            "QA Tech Lead"
        ]
    }
    
    func getSpecializations() -> [String] {
        var uniqueSpecializations: [String] = [String]()
        
        for salary in self {
            if !uniqueSpecializations.contains(salary.specialization) {
                uniqueSpecializations.append(salary.specialization)
            }
        }

        return uniqueSpecializations
    }
}

extension Array where Element == ManagementSalary {

    func getJobsPositions() -> [String] {
        return [
            "Project manager",
            "Product Manager",
            "Senior Project manager / Program Manager",
            "Director of Engineering / Program Director"
        ]
    }
}

extension Array where Element == OtherSalary {

    func getJobsPositions() -> [String] {
        var uniqueJobsPositions: [String] = [String]()
        
        for salary in self {
            if !uniqueJobsPositions.contains(salary.jobPosition) {
                uniqueJobsPositions.append(salary.jobPosition)
            }
        }

        return uniqueJobsPositions.sorted { $0 < $1 }
    }
}

class SoftwareEngineeringSalaryQuartile {
    
    public let salaryService: SalaryService
    public let city: String
    public let workingExperience: Float64
    public let jobPosition: String
    public let programmingLanguage: String
    
    private let lessThanYearWorkingExperiences: [Float64] = [0.25, 0.5]
    
    init(salaryService: SalaryService, city: String, workingExperience: Float64, jobPosition: String, programmingLanguage: String) {
        self.salaryService = salaryService
        self.city = city
        self.jobPosition = jobPosition
        self.workingExperience = workingExperience
        self.programmingLanguage = programmingLanguage
    }
    
    private func areFloatsEqual(first: Float64, second: Float64) -> Bool {
        return fabs(first - second) < Float64.ulpOfOne
    }
    
    private func filterWorkingExperience(first: Float64, second: Float64) -> Bool {
        
        if first.isLess(than: 1) && second.isLess(than: 1) {
            return true
        }
        
        if areFloatsEqual(first: first, second: second) {
            return true
        }
        
        return false
    }
    
    public func calculate() -> (first: Int, median: Int, third: Int, submissionsNumber: Int) {
        
        let softwareEngineeringSalaries: [SoftwareEngineeringSalary] = salaryService.softwareEngineeringSalaries
            .filter { city == $0.city }
            .filter { jobPosition == $0.jobPosition }
            .filter { programmingLanguage == $0.programmingLanguage }
            .filter { filterWorkingExperience(first: workingExperience, second: $0.workingExperience) }
            .sorted { $0.salary < $1.salary }

        if softwareEngineeringSalaries.count == 0 {
            return (0, 0, 0, 0)
        }
        
        if softwareEngineeringSalaries.count == 1 {
            let singleSoftwareEngineeringSalary: SoftwareEngineeringSalary = softwareEngineeringSalaries[0]
            return (Int(singleSoftwareEngineeringSalary.salary), Int(singleSoftwareEngineeringSalary.salary), Int(singleSoftwareEngineeringSalary.salary), 1)
        }
        
        let salaries: [Double] = softwareEngineeringSalaries.map { Double($0.salary) }

        var firstQuantileSlice: [Double]
        var thirdQuantileSlice: [Double]
        
        let salariesMiddle: Int = salaries.count / 2
        
        if salaries.count % 2 == 0 {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    salariesMiddle...(salaries.count - 1)
                ]
            )
        } else {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    (salariesMiddle + 1)...(salaries.count - 1)
                ]
            )
        }
            
        let median: Int = Int(Sigma.median(salaries)!)
        let firstQuantile: Int = Int(Sigma.quantiles.method7(firstQuantileSlice, probability: 0.5)!)
        let thirdQuantile: Int = Int(Sigma.quantiles.method7(thirdQuantileSlice, probability: 0.5)!)

        return (firstQuantile, median, thirdQuantile, salaries.count)
    }
}

class QualityAssuranceSalaryQuartile {
    
    public let salaryService: SalaryService
    public let city: String
    public let workingExperience: Float64
    public let jobPosition: String
    public let specialization: String
    
    private let lessThanYearWorkingExperiences: [Float64] = [0.25, 0.5]
    
    init(salaryService: SalaryService, city: String, workingExperience: Float64, jobPosition: String, specialization: String) {
        self.salaryService = salaryService
        self.city = city
        self.jobPosition = jobPosition
        self.workingExperience = workingExperience
        self.specialization = specialization
    }
    
    private func areFloatsEqual(first: Float64, second: Float64) -> Bool {
        return fabs(first - second) < Float64.ulpOfOne
    }
    
    private func filterWorkingExperience(first: Float64, second: Float64) -> Bool {
        
        if first.isLess(than: 1) && second.isLess(than: 1) {
            return true
        }
        
        if areFloatsEqual(first: first, second: second) {
            return true
        }
        
        return false
    }
    
    public func calculate() -> (first: Int, median: Int, third: Int, submissionsNumber: Int) {
        let qualityAssuranceSalaries: [QualityAssuranceSalary] = salaryService.qualityAssuranceSalaries
            .filter { city == $0.city }
            .filter { jobPosition == $0.jobPosition }
            .filter { specialization == $0.specialization }
            .filter { filterWorkingExperience(first: workingExperience, second: $0.workingExperience) }
            .sorted { $0.salary < $1.salary }

        if qualityAssuranceSalaries.count == 0 {
            return (0, 0, 0, 0)
        }
        
        if qualityAssuranceSalaries.count == 1 {
            let singleQualityAssuranceSalary: QualityAssuranceSalary = qualityAssuranceSalaries[0]
            return (Int(singleQualityAssuranceSalary.salary), Int(singleQualityAssuranceSalary.salary), Int(singleQualityAssuranceSalary.salary), 1)
        }
        
        let salaries: [Double] = qualityAssuranceSalaries.map { Double($0.salary) }

        var firstQuantileSlice: [Double]
        var thirdQuantileSlice: [Double]
        
        let salariesMiddle: Int = salaries.count / 2
        
        if salaries.count % 2 == 0 {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    salariesMiddle...(salaries.count - 1)
                ]
            )
        } else {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    (salariesMiddle + 1)...(salaries.count - 1)
                ]
            )
        }
            
        let median: Int = Int(Sigma.median(salaries)!)
        let firstQuantile: Int = Int(Sigma.quantiles.method7(firstQuantileSlice, probability: 0.5)!)
        let thirdQuantile: Int = Int(Sigma.quantiles.method7(thirdQuantileSlice, probability: 0.5)!)

        return (firstQuantile, median, thirdQuantile, salaries.count)
    }
}

class ManagementSalaryQuartile {
    
    public let salaryService: SalaryService
    public let city: String
    public let workingExperience: Float64
    public let jobPosition: String

    init(salaryService: SalaryService, city: String, workingExperience: Float64, jobPosition: String) {
        self.salaryService = salaryService
        self.city = city
        self.jobPosition = jobPosition
        self.workingExperience = workingExperience
    }
    
    private func areFloatsEqual(first: Float64, second: Float64) -> Bool {
        return fabs(first - second) < Float64.ulpOfOne
    }
    
    private func filterWorkingExperience(first: Float64, second: Float64) -> Bool {
        
        if first.isLess(than: 1) && second.isLess(than: 1) {
            return true
        }
        
        if areFloatsEqual(first: first, second: second) {
            return true
        }
        
        return false
    }
    
    public func calculate() -> (first: Int, median: Int, third: Int, submissionsNumber: Int) {
        let managementSalaries: [ManagementSalary] = salaryService.managementSalaries
            .filter { city == $0.city }
            .filter { jobPosition == $0.jobPosition }
            .filter { filterWorkingExperience(first: workingExperience, second: $0.workingExperience) }
            .sorted { $0.salary < $1.salary }
    
        if managementSalaries.count == 0 {
            return (0, 0, 0, 0)
        }
        
        if managementSalaries.count == 1 {
            let singleManagementSalary: ManagementSalary = managementSalaries[0]
            return (Int(singleManagementSalary.salary), Int(singleManagementSalary.salary), Int(singleManagementSalary.salary), 1)
        }
        
        let salaries: [Double] = managementSalaries.map { Double($0.salary) }

        var firstQuantileSlice: [Double]
        var thirdQuantileSlice: [Double]
        
        let salariesMiddle: Int = salaries.count / 2
        
        if salaries.count % 2 == 0 {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    salariesMiddle...(salaries.count - 1)
                ]
            )
        } else {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    (salariesMiddle + 1)...(salaries.count - 1)
                ]
            )
        }
            
        let median: Int = Int(Sigma.median(salaries)!)
        let firstQuantile: Int = Int(Sigma.quantiles.method7(firstQuantileSlice, probability: 0.5)!)
        let thirdQuantile: Int = Int(Sigma.quantiles.method7(thirdQuantileSlice, probability: 0.5)!)

        return (firstQuantile, median, thirdQuantile, salaries.count)
    }
}

class OtherSalaryQuartile {
    
    public let salaryService: SalaryService
    public let city: String
    public let workingExperience: Float64
    public let jobPosition: String

    init(salaryService: SalaryService, city: String, workingExperience: Float64, jobPosition: String) {
        self.salaryService = salaryService
        self.city = city
        self.jobPosition = jobPosition
        self.workingExperience = workingExperience
    }
    
    private func areFloatsEqual(first: Float64, second: Float64) -> Bool {
        return fabs(first - second) < Float64.ulpOfOne
    }
    
    private func filterWorkingExperience(first: Float64, second: Float64) -> Bool {
        
        if first.isLess(than: 1) && second.isLess(than: 1) {
            return true
        }
        
        if areFloatsEqual(first: first, second: second) {
            return true
        }
        
        return false
    }
    
    public func calculate() -> (first: Int, median: Int, third: Int, submissionsNumber: Int) {
        let otherSalaries: [OtherSalary] = salaryService.otherSalaries
            .filter { city == $0.city }
            .filter { jobPosition == $0.jobPosition }
            .filter { filterWorkingExperience(first: workingExperience, second: $0.workingExperience) }
            .sorted { $0.salary < $1.salary }
    
        if otherSalaries.count == 0 {
            return (0, 0, 0, 0)
        }
        
        if otherSalaries.count == 1 {
            let singleotherSalary: OtherSalary = otherSalaries[0]
            return (Int(singleotherSalary.salary), Int(singleotherSalary.salary), Int(singleotherSalary.salary), 1)
        }
        
        let salaries: [Double] = otherSalaries.map { Double($0.salary) }

        var firstQuantileSlice: [Double]
        var thirdQuantileSlice: [Double]
        
        let salariesMiddle: Int = salaries.count / 2
        
        if salaries.count % 2 == 0 {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    salariesMiddle...(salaries.count - 1)
                ]
            )
        } else {
            firstQuantileSlice = Array(
                salaries[
                    0...(salariesMiddle - 1)
                ]
            )
            
            thirdQuantileSlice = Array(
                salaries[
                    (salariesMiddle + 1)...(salaries.count - 1)
                ]
            )
        }
            
        let median: Int = Int(Sigma.median(salaries)!)
        let firstQuantile: Int = Int(Sigma.quantiles.method7(firstQuantileSlice, probability: 0.5)!)
        let thirdQuantile: Int = Int(Sigma.quantiles.method7(thirdQuantileSlice, probability: 0.5)!)

        return (firstQuantile, median, thirdQuantile, salaries.count)
    }
}
