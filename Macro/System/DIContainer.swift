//
//  DIContainer.swift
//  Macro
//
//  Created by leejina on 11/7/24.
//


class DIContainer {
    
    static let shared: DIContainer = DIContainer()
    
    private init() {
        self.appState = .init()
        self.jangdanDataSource = .init(appState: self.appState)!
        self.soundManager = .init(appState: self.appState)!
        
        self.templateUseCase = TemplateImplement(jangdanRepository: self.jangdanDataSource, appState: self.appState)
        self.tempoUseCase = TempoImplement(jangdanRepository: self.jangdanDataSource)
        self.metronomeOnOffUseCase = MetronomeOnOffImplement(jangdanRepository: self.jangdanDataSource, soundManager: soundManager)
        self.accentUseCase = AccentImplement(jangdanRepository: self.jangdanDataSource)
        self.dynamicIconUseCase = DynamicIconImplement()
        
        self.widgetManager = LiveActivityManager(jangdanRepository: self.jangdanDataSource, metronomeOnOffUseCase: self.metronomeOnOffUseCase, tempoUseCase: self.tempoUseCase)
        
        self.metronomeViewModel = MetronomeViewModel(templateUseCase: self.templateUseCase, metronomeOnOffUseCase: self.metronomeOnOffUseCase, tempoUseCase: self.tempoUseCase, accentUseCase: self.accentUseCase)
        
        self.controlViewModel =
        MetronomeControlViewModel(jangdanRepository: self.jangdanDataSource, tempoUseCase: self.tempoUseCase, metronomeOnOffUseCase: self.metronomeOnOffUseCase)
        
        self.homeViewModel = HomeViewModel(metronomeOnOffUseCase: self.metronomeOnOffUseCase, dynamicIconUseCase: self.dynamicIconUseCase)
        self.customJangdanListViewModel = CustomJangdanListViewModel(templateUseCase: self.templateUseCase)
        self.builtInJangdanPracticeViewModel = BuiltInJangdanPracticeViewModel(templateUseCase: self.templateUseCase, metronomeOnOffUseCase: self.metronomeOnOffUseCase, widgetManager: self.widgetManager)
        self.customJangdanPracticeViewModel = CustomJangdanPracticeViewModel(templateUseCase: self.templateUseCase, metronomeOnOffUseCase: self.metronomeOnOffUseCase)
        self.customJangdanCreateViewModel = CustomJangdanCreateViewModel(templateUseCase: self.templateUseCase, metronomeOnOffUseCase: self.metronomeOnOffUseCase)
        
        self.router = .init()
    }
    
    // ViewModel
    private(set) var metronomeViewModel: MetronomeViewModel
    
    private(set) var controlViewModel: MetronomeControlViewModel
    
    private(set) var homeViewModel: HomeViewModel
    
    private(set) var customJangdanListViewModel: CustomJangdanListViewModel
    
    private(set) var builtInJangdanPracticeViewModel: BuiltInJangdanPracticeViewModel
    
    private(set) var customJangdanPracticeViewModel: CustomJangdanPracticeViewModel
    
    private(set) var customJangdanCreateViewModel: CustomJangdanCreateViewModel
    
    // UseCase Implements
    private var templateUseCase: TemplateImplement
    private var tempoUseCase: TempoImplement
    private var metronomeOnOffUseCase: MetronomeOnOffImplement
    private var accentUseCase: AccentImplement
    private var dynamicIconUseCase: DynamicIconImplement
    
    // Service
    private var jangdanDataSource: JangdanDataManager
    private var soundManager: SoundManager
    
    // Router
    private(set) var router: Router
    
    // AppState
    private(set) var appState: AppState
    
    // Widget
    private(set) var widgetManager: WidgetManager
    
}
