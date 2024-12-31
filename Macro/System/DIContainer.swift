//
//  DIContainer.swift
//  Macro
//
//  Created by leejina on 11/7/24.
//


class DIContainer {
    
    static let shared: DIContainer = DIContainer()
    
    private init() {
        self._appState = .init()
        self._jangdanDataSource = .init(appState: self._appState)!
        self._soundManager = .init(appState: self._appState)!
        
        self._templateUseCase = TemplateImplement(jangdanRepository: self._jangdanDataSource, appState: self._appState)
        self._tempoUseCase = TempoImplement(jangdanRepository: self._jangdanDataSource)
        self._metronomeOnOffUseCase = MetronomeOnOffImplement(jangdanRepository: self._jangdanDataSource, soundManager: _soundManager)
        self._accentUseCase = AccentImplement(jangdanRepository: self._jangdanDataSource)
        self._tapTapUseCase = TapTapImplement(tempoUseCase: self._tempoUseCase)
        
        self._metronomeViewModel = MetronomeViewModel(templateUseCase: self._templateUseCase, metronomeOnOffUseCase: self._metronomeOnOffUseCase, tempoUseCase: self._tempoUseCase, accentUseCase: self._accentUseCase, taptapUseCase: self._tapTapUseCase)
        
        self._controlViewModel =
        MetronomeControlViewModel(jangdanRepository: self._jangdanDataSource, taptapUseCase: self._tapTapUseCase, tempoUseCase: self._tempoUseCase, metronomeOnOffUseCase: self._metronomeOnOffUseCase)
        
        self._homeViewModel = HomeViewModel(metronomeOnOffUseCase: self._metronomeOnOffUseCase)
        self._customJangdanListViewModel = CustomJangdanListViewModel(templateUseCase: self._templateUseCase)
        self._builtInJangdanPracticeViewModel = BuiltInJangdanPracticeViewModel(templateUseCase: self._templateUseCase, metronomeOnOffUseCase: self._metronomeOnOffUseCase)
        self._customJangdanPracticeViewModel = CustomJangdanPracticeViewModel(templateUseCase: self._templateUseCase, metronomeOnOffUseCase: self._metronomeOnOffUseCase)
        self._customJangdanCreateViewModel = CustomJangdanCreateViewModel(templateUseCase: self._templateUseCase, metronomeOnOffUseCase: self._metronomeOnOffUseCase)
        
        self._router = .init()
    }
    
    // ViewModel
    private var _metronomeViewModel: MetronomeViewModel
    var metronomeViewModel: MetronomeViewModel {
        self._metronomeViewModel
    }
    
    // controllerViewModel
    private var _controlViewModel: MetronomeControlViewModel
    var controlViewModel: MetronomeControlViewModel {
        self._controlViewModel
    }
    
    private var _homeViewModel: HomeViewModel
    var homeViewModel: HomeViewModel {
        self._homeViewModel
    }
    
    private var _customJangdanListViewModel: CustomJangdanListViewModel
    var customJangdanListViewModel: CustomJangdanListViewModel {
        self._customJangdanListViewModel
    }
    
    private var _builtInJangdanPracticeViewModel: BuiltInJangdanPracticeViewModel
    var builtInJangdanPracticeViewModel: BuiltInJangdanPracticeViewModel {
        self._builtInJangdanPracticeViewModel
    }
    
    private var _customJangdanPracticeViewModel: CustomJangdanPracticeViewModel
    var customJangdanPracticeViewModel: CustomJangdanPracticeViewModel {
        self._customJangdanPracticeViewModel
    }
    
    private var _customJangdanCreateViewModel: CustomJangdanCreateViewModel
    var customJangdanCreateViewModel: CustomJangdanCreateViewModel {
        self._customJangdanCreateViewModel
    }
    
    // UseCase Implements
    private var _templateUseCase: TemplateImplement
    private var _tempoUseCase: TempoImplement
    private var _metronomeOnOffUseCase: MetronomeOnOffImplement
    private var _accentUseCase: AccentImplement
    private var _tapTapUseCase: TapTapImplement
    
    private var _jangdanDataSource: JangdanDataManager
    private var _soundManager: SoundManager
    
    //router
    private var _router: Router
    var router: Router {
        self._router
    }
    
    //appState
    private var _appState: AppState
    var appState: AppState {
        self._appState
    }
    
}
