import SwiftUI

struct SalariesView: View {

    private let style: Style = Style()
    private let workingExperienceDescriptions = [
        1: "рік",
        2: "роки",
        3: "роки",
        4: "роки",
        5: "років",
        6: "років",
        7: "років",
        8: "років",
        9: "років"
    ]

    @ObservedObject private var salaryService: SalaryService = SalaryService(
        source: SalariesCsvSource(
            url: "https://raw.githubusercontent.com/imax/dou-salaries/master/data/2020_june_mini.csv"
        )
    )

    @State private var workingExperience: Float64 = 2
    @State private var selectedCityIndex: Int = 0
    @State private var selectedCity: String = "Винница"
    @State private var selectedJobsPositionsIndex: Int = 0
    @State private var selectedJobPositionIndex: Int = 0
    @State private var selectedJobPosition: String = "Junior Software Engineer"
    @State private var selectedSoftwareEngineeringProgrammingLanguageIndex: Int = 0
    @State private var selectedSoftwareEngineeringProgrammingLanguage: String = "1С"
    @State private var selectedQualityAssuranceSpecializationIndex: Int = 0
    @State private var selectedQualityAssuranceSpecialization: String = "Manual QA"

    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: style.navigationBarHeaderSize,
                weight: UIFont.Weight.semibold
            )
        ]
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Вхідні данні")) {
                    NavigationLink(
                        destination: SalariesCitiesView(
                            cities: salaryService.cities,
                            selectedCityIndex: $selectedCityIndex,
                            selectedCity: $selectedCity
                        )
                    ) {
                        HStack {
                            Text("Місто")
                            Spacer()
                            Text("\(selectedCity)").foregroundColor(Color.gray)
                        }
                    }
                    NavigationLink(
                        destination: SalariesJobsPositionsView(
                            jobsPositions: [
                                salaryService.softwareEngineeringJobsPositions,
                                salaryService.qualityAssuranceJobsPositions,
                                salaryService.managementJobsPositions,
                                salaryService.otherJobsPositions
                            ],
                            jobsPositionsHeaders: ["Розробка", "Тестування", "Менеджмент", "Iнше"],
                            selectedJobsPositionsIndex: $selectedJobsPositionsIndex,
                            selectedJobPositionIndex: $selectedJobPositionIndex,
                            selectedJobPosition: $selectedJobPosition
                        )
                    ) {
                        HStack {
                            Text("Посада")
                            Spacer()
                            Text("\(selectedJobPosition)").foregroundColor(Color.gray)
                        }
                    }

                    if salaryService.softwareEngineeringJobsPositions.contains(selectedJobPosition) {
                        NavigationLink(
                            destination: SalariesSoftwareEngineeringProgrammingLanguagesView(
                                programmingLanguages: salaryService.softwareEngineeringProgrammingLanguages,
                                selectedProgrammingLanguageIndex: $selectedSoftwareEngineeringProgrammingLanguageIndex,
                                selectedProgrammingLanguage: $selectedSoftwareEngineeringProgrammingLanguage
                            )
                        ) {
                            HStack {
                                Text("Мова програмування")
                                Spacer()
                                Text("\(selectedSoftwareEngineeringProgrammingLanguage)").foregroundColor(Color.gray)
                            }
                        }
                    }

                    if salaryService.qualityAssuranceJobsPositions.contains(selectedJobPosition) {
                        NavigationLink(
                            destination: SalariesQualityAssuranceSpesializationsView(
                                spesializations: salaryService.qualityAssuranceSpesializations,
                                selectedSesializationIndex: $selectedQualityAssuranceSpecializationIndex,
                                selectedSesialization: $selectedQualityAssuranceSpecialization
                            )
                        ) {
                            HStack {
                                Text("Спеціалізація")
                                Spacer()
                                Text("\(selectedQualityAssuranceSpecialization)").foregroundColor(Color.gray)
                            }
                        }
                    }

                    VStack(alignment: .leading) {
                        if Int(workingExperience) < 1 {
                            Text("Досвід: менше року")
                        }

                        if Int(workingExperience) >= 10 {
                            Text("Досвід: 10 та більше років")
                        }
                        
                        if Int(workingExperience) >= 1 && Int(workingExperience) < 10 {
                            Text("Досвід: \(Int(workingExperience)) \(workingExperienceDescriptions[Int(workingExperience)]!)")
                        }
                        
                        HStack {
                            Image(systemName: "minus")
                            Slider(value: $workingExperience, in: 0...10, step: 1).accentColor(Color.blue)
                            Image(systemName: "plus")
                        }
                    }
                }.textCase(nil)

                if salaryService.softwareEngineeringJobsPositions.contains(selectedJobPosition) {
                    let salaryQuartileCalculation = SoftwareEngineeringSalaryQuartile(
                        salaryService: salaryService,
                        city: selectedCity,
                        workingExperience: workingExperience,
                        jobPosition: selectedJobPosition,
                        programmingLanguage: selectedSoftwareEngineeringProgrammingLanguage
                    ).calculate()

                    CalculatedQuartileView(
                        firstQuartile: salaryQuartileCalculation.first,
                        median: salaryQuartileCalculation.median,
                        thirdQuartile: salaryQuartileCalculation.third,
                        submissionsNumber: salaryQuartileCalculation.submissionsNumber
                    )
                }
                
                if salaryService.qualityAssuranceJobsPositions.contains(selectedJobPosition) {
                    let salaryQuartileCalculation = QualityAssuranceSalaryQuartile(
                        salaryService: salaryService,
                        city: selectedCity,
                        workingExperience: workingExperience,
                        jobPosition: selectedJobPosition,
                        specialization: selectedQualityAssuranceSpecialization
                    ).calculate()

                    CalculatedQuartileView(
                        firstQuartile: salaryQuartileCalculation.first,
                        median: salaryQuartileCalculation.median,
                        thirdQuartile: salaryQuartileCalculation.third,
                        submissionsNumber: salaryQuartileCalculation.submissionsNumber
                    )
                }
                
                if salaryService.managementJobsPositions.contains(selectedJobPosition) {
                    let salaryQuartileCalculation = ManagementSalaryQuartile(
                        salaryService: salaryService,
                        city: selectedCity,
                        workingExperience: workingExperience,
                        jobPosition: selectedJobPosition
                    ).calculate()

                    CalculatedQuartileView(
                        firstQuartile: salaryQuartileCalculation.first,
                        median: salaryQuartileCalculation.median,
                        thirdQuartile: salaryQuartileCalculation.third,
                        submissionsNumber: salaryQuartileCalculation.submissionsNumber
                    )
                }
                
                if salaryService.otherJobsPositions.contains(selectedJobPosition) {
                    let salaryQuartileCalculation = OtherSalaryQuartile(
                        salaryService: salaryService,
                        city: selectedCity,
                        workingExperience: workingExperience,
                        jobPosition: selectedJobPosition
                    ).calculate()

                    CalculatedQuartileView(
                        firstQuartile: salaryQuartileCalculation.first,
                        median: salaryQuartileCalculation.median,
                        thirdQuartile: salaryQuartileCalculation.third,
                        submissionsNumber: salaryQuartileCalculation.submissionsNumber
                    )
                }
            }.navigationBarTitle(
                style.navigationBarHeaderNameUkrainian,
                displayMode: .inline
            ).listStyle(
                GroupedListStyle()
            )
        }
    }
    
    struct Style {
        public let navigationBarHeaderSize: CGFloat = 20
        public let navigationBarHeaderNameUkrainian: String = "Зарплати"
        public let navigationBarHeaderNameRussian: String = "Зарплаты"
    }
}


struct CalculatedQuartileView: View {
    
    public let firstQuartile: Int
    public let median: Int
    public let thirdQuartile: Int
    public let submissionsNumber: Int
    
    var body: some View {
        Section(header:
            HStack {
                Text("Розрахунок")
                Spacer()
                Text("\(submissionsNumber) анкет(и)")
            }
        ) {
            HStack {
                Text("I квартиль")
                Spacer()
                Text("$\(String(firstQuartile))").foregroundColor(Color.gray)
            }
            HStack {
                Text("Медіана")
                Spacer()
                Text("$\(String(median))").foregroundColor(Color.gray)
            }
            HStack {
                Text("III квартиль")
                Spacer()
                Text("$\(String(thirdQuartile))").foregroundColor(Color.gray)
            }
        }.textCase(nil)

        Section(header: HStack {
            Button(action: {
                UIApplication.shared.open(
                    URL(string: "https://github.com/devua/csv/tree/master/salaries")!
                )
            }) {
                Text("Дані опитування в CSV форматі ") +
                Text("за посилання на Github").foregroundColor(Color.blue) +
                Text(".")
            }.foregroundColor(Color.gray)
        }) {}.textCase(nil)
    }
}

struct SalariesCitiesView: View {
    
    @State public var cities: [String]

    @Binding public var selectedCityIndex: Int
    @Binding public var selectedCity: String

    var body: some View {
        List(cities.indices, id: \.self) { index in
            Button(action: {
                self.selectedCityIndex = index
                self.selectedCity = cities[index]
            }) {
                HStack {
                    Text(cities[index]).foregroundColor(Color.black)
                    Spacer()
                    if index == self.selectedCityIndex {
                        CheckMarkButtonIcon()
                    }
                }
            }
        }.navigationBarTitle(
            "Місто"
        ).listStyle(
            GroupedListStyle()
        )
    }
}

struct SalariesJobsPositionsView: View {

    @State public var jobsPositions: [[String]]
    @State public var jobsPositionsHeaders: [String]
    
    @Binding public var selectedJobsPositionsIndex: Int
    @Binding public var selectedJobPositionIndex: Int
    @Binding public var selectedJobPosition: String
    
    var body: some View {
        List {
            ForEach(jobsPositions.indices, id: \.self) { JobsPositionsIndex in
                Section(header:
                    Text(jobsPositionsHeaders[JobsPositionsIndex])
                ) {
                    ForEach(jobsPositions[JobsPositionsIndex].indices, id: \.self) { JobPositionIndex in
                        Button(action: {
                            self.selectedJobsPositionsIndex = JobsPositionsIndex
                            self.selectedJobPositionIndex = JobPositionIndex
                            self.selectedJobPosition = jobsPositions[JobsPositionsIndex][JobPositionIndex]
                        }) {
                            HStack {
                                Text(jobsPositions[JobsPositionsIndex][JobPositionIndex]).foregroundColor(Color.black)
                                Spacer()
                                if JobsPositionsIndex == self.selectedJobsPositionsIndex && JobPositionIndex == self.selectedJobPositionIndex {
                                    CheckMarkButtonIcon()
                                }
                            }
                        }
                    }
                }.textCase(nil)
            }
        }.navigationBarTitle(
            "Посада"
        ).listStyle(
            GroupedListStyle()
        )
    }
}

struct SalariesSoftwareEngineeringProgrammingLanguagesView: View {

    @State public var programmingLanguages: [String]

    @Binding public var selectedProgrammingLanguageIndex: Int
    @Binding public var selectedProgrammingLanguage: String

    var body: some View {
        List(programmingLanguages.indices, id: \.self) { index in
            Button(action: {
                self.selectedProgrammingLanguageIndex = index
                self.selectedProgrammingLanguage = programmingLanguages[index]
            }) {
                HStack {
                    Text(programmingLanguages[index]).foregroundColor(Color.black)
                    Spacer()
                    if index == self.selectedProgrammingLanguageIndex {
                        CheckMarkButtonIcon()
                    }
                }
            }
        }.navigationBarTitle(
            "Мова програмування"
        ).listStyle(
            GroupedListStyle()
        )
    }
}

struct SalariesQualityAssuranceSpesializationsView: View {

    @State public var spesializations: [String]

    @Binding public var selectedSesializationIndex: Int
    @Binding public var selectedSesialization: String

    var body: some View {
        List(spesializations.indices, id: \.self) { index in
            Button(action: {
                self.selectedSesializationIndex = index
                self.selectedSesialization = spesializations[index]
            }) {
                HStack {
                    Text(spesializations[index]).foregroundColor(Color.black)
                    Spacer()
                    if index == self.selectedSesializationIndex {
                        CheckMarkButtonIcon()
                    }
                }
            }
        }.navigationBarTitle(
            "Cпеціалізація"
        ).listStyle(
            GroupedListStyle()
        )
    }
}

struct SalariesView_Previews: PreviewProvider {
    static var previews: some View {
        SalariesView()
    }
}
