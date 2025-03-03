#
# Be sure to run `pod lib lint MKLoRaWAN-AE.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKLoRaWAN-AE'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MKLoRaWAN-AE.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lovexiaoxia/MKLoRaWAN-AE'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lovexiaoxia' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/lovexiaoxia/MKLoRaWAN-AE.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKLoRaWAN-AE' => ['MKLoRaWAN-AE/Assets/*.png']
  }
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKLoRaWAN-AE/Classes/CTMediator/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'CTMediator'
  end
  
  s.subspec 'DatabaseManager' do |ss|
    
    ss.subspec 'SyncDatabase' do |sss|
      sss.source_files = 'MKLoRaWAN-AE/Classes/DatabaseManager/SyncDatabase/**'
    end
    
    ss.subspec 'LogDatabase' do |sss|
      sss.source_files = 'MKLoRaWAN-AE/Classes/DatabaseManager/LogDatabase/**'
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'FMDB'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKLoRaWAN-AE/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKLoRaWAN-AE/Classes/Target/**'
    
    ss.dependency 'MKLoRaWAN-AE/Functions'
  end
  
  s.subspec 'ConnectModule' do |ss|
    ss.source_files = 'MKLoRaWAN-AE/Classes/ConnectModule/**'
    
    ss.dependency 'MKLoRaWAN-AE/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'Expand' do |ss|
    
    ss.subspec 'TextButtonCell' do |sss|
      sss.source_files = 'MKLoRaWAN-AE/Classes/Expand/TextButtonCell/**'
    end
    
    ss.subspec 'FilterCell' do |sss|
      sss.subspec 'FilterBeaconCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Expand/FilterCell/FilterBeaconCell/**'
      end
      
      sss.subspec 'FilterByRawDataCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Expand/FilterCell/FilterByRawDataCell/**'
      end
      
      sss.subspec 'FilterEditSectionHeaderView' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Expand/FilterCell/FilterEditSectionHeaderView/**'
      end
      
      sss.subspec 'FilterNormalTextFieldCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Expand/FilterCell/FilterNormalTextFieldCell/**'
      end
      
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'AuxiliaryPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/AuxiliaryPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/DownlinkPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/VibrationPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/ManDownPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/TamperAlarmPage/Controller'
        
      end
    end
    
    ss.subspec 'AxisSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/AxisSettingPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/AxisSettingPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/AxisSettingPage/Model/**'
      end
    end
    
    ss.subspec 'BatteryConsumptionPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BatteryConsumptionPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/BatteryConsumptionPage/Model'
        ssss.dependency 'MKLoRaWAN-AE/Functions/BatteryConsumptionPage/View'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BatteryConsumptionPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BatteryConsumptionPage/View/**'
      end
    end
    
    ss.subspec 'BleFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BleFixPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-AE/Functions/BleFixPage/Model'
        ssss.dependency 'MKLoRaWAN-AE/Functions/BleFixPage/View'
      
        ssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BleFixPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BleFixPage/View/**'
      end
    end
    
    ss.subspec 'BleSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BleSettingsPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/BleSettingsPage/Model'
        ssss.dependency 'MKLoRaWAN-AE/Functions/BleSettingsPage/View'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BleSettingsPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/BleSettingsPage/View/**'
      end
      
    end
    
    ss.subspec 'DebuggerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DebuggerPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/DebuggerPage/View'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DebuggerPage/View/**'
      end
      
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DeviceInfoPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/DeviceInfoPage/Model'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/UpdatePage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/SelftestPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/DebuggerPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/BatteryConsumptionPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DeviceInfoPage/Model/**'
      end
      
    end
    
    ss.subspec 'DeviceModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DeviceModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/StandbyModePage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/TimingModePage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/PeriodicModePage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/MotionModePage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/TimeSegmentedModePage/Controller'
      end
    end
    
    ss.subspec 'DeviceSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DeviceSettingPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/DeviceSettingPage/Model'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/SynDataPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/IndicatorSettingsPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/DeviceInfoPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/OnOffSettingsPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DeviceSettingPage/Model/**'
      end
      
    end
    
    ss.subspec 'DownlinkPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/DownlinkPage/Controller/**'
      end
    end
    
    ss.subspec 'FilterPages' do |sss|
      
      sss.subspec 'FilterByAdvNamePage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByAdvNamePage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByAdvNamePage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByAdvNamePage/Model/**'
        end
      end
      
      sss.subspec 'FilterByBeaconPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByBeaconPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBeaconPage/Header'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBeaconPage/Model'
          
        end
        
        ssss.subspec 'Header' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByBeaconPage/Header/**'
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByBeaconPage/Model/**'
          
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBeaconPage/Header'
        end
      end
      
      sss.subspec 'FilterByMacPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByMacPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByMacPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByMacPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByOtherPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByOtherPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByOtherPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByOtherPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByPirPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByPirPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByPirPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByPirPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByRawDataPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByRawDataPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByRawDataPage/Model'
          
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBeaconPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByUIDPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByURLPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByTLMPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByTofPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBXPButtonPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBXPTagPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByOtherPage/Controller'
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByPirPage/Controller'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByRawDataPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByTofPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByTofPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByTofPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByTofPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByTLMPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByTLMPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByTLMPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByTLMPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByUIDPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByUIDPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByUIDPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByUIDPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByURLPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByURLPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByURLPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByURLPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByBXPButtonPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByBXPButtonPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBXPButtonPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByBXPButtonPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByBXPTagPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByBXPTagPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-AE/Functions/FilterPages/FilterByBXPTagPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/FilterPages/FilterByBXPTagPage/Model/**'
        end
      end
      
    end
    
    ss.subspec 'GeneralPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/GeneralPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/GeneralPage/Model'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/DeviceModePage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/AuxiliaryPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/BleSettingsPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/AxisSettingPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/GeneralPage/Model/**'
      end
      
    end
    
    ss.subspec 'IndicatorSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/IndicatorSettingsPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/IndicatorSettingsPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/IndicatorSettingsPage/Model/**'
      end
      
    end
    
    ss.subspec 'LCGpsFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LCGpsFixPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/LCGpsFixPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LCGpsFixPage/Model/**'
      end
      
    end
    
    ss.subspec 'LoRaApplicationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LoRaApplicationPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/LoRaApplicationPage/Model'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/MessageTypePage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LoRaApplicationPage/Model/**'
      end
      
    end
    
    ss.subspec 'LoRaPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LoRaPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/LoRaPage/Model'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/LoRaSettingPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/LoRaApplicationPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LoRaPage/Model/**'
      end
      
    end
    
    ss.subspec 'LoRaSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LoRaSettingPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/LoRaSettingPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/LoRaSettingPage/Model/**'
      end
      
    end
    
    ss.subspec 'ManDownPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/ManDownPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/ManDownPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/ManDownPage/Model/**'
      end
    end
    
    ss.subspec 'MessageTypePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/MessageTypePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/MessageTypePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/MessageTypePage/Model/**'
      end
    end
    
    ss.subspec 'MotionModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/MotionModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/MotionModePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/MotionModePage/Model/**'
      end
      
    end
    
    ss.subspec 'OnOffSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/OnOffSettingsPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/OnOffSettingsPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/OnOffSettingsPage/Model/**'
      end
      
    end
    
    ss.subspec 'OutdoorFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/OutdoorFixPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/OutdoorFixPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/OutdoorFixPage/Model/**'
      end
      
    end
    
    ss.subspec 'PeriodicModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/PeriodicModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/PeriodicModePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/PeriodicModePage/Model/**'
      end
      
    end
    
    ss.subspec 'PositionPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/PositionPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/PositionPage/Model'
                
        ssss.dependency 'MKLoRaWAN-AE/Functions/BleFixPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/LCGpsFixPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/OutdoorFixPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/PositionPage/Model/**'
      end
      
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/ScanPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/ScanPage/Model'
        ssss.dependency 'MKLoRaWAN-AE/Functions/ScanPage/View'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/TabBarPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/ScanPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/ScanPage/View/**'
        ssss.dependency 'MKLoRaWAN-AE/Functions/ScanPage/Model'
      end
    end
    
    ss.subspec 'SelftestPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/SelftestPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/SelftestPage/View'
        ssss.dependency 'MKLoRaWAN-AE/Functions/SelftestPage/Model'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/SelftestPage/View/**'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/SelftestPage/Model/**'
      end
    end
    
    ss.subspec 'StandbyModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/StandbyModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/StandbyModePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/StandbyModePage/Model/**'
      end
    end
    
    ss.subspec 'SynDataPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/SynDataPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/SynDataPage/View'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/SynDataPage/View/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/LoRaPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/PositionPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/GeneralPage/Controller'
        ssss.dependency 'MKLoRaWAN-AE/Functions/DeviceSettingPage/Controller'
      end
    end
    
    ss.subspec 'TamperAlarmPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TamperAlarmPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/TamperAlarmPage/Model'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TamperAlarmPage/Model/**'
      end
    end
    
    ss.subspec 'TimeSegmentedModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TimeSegmentedModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/TimeSegmentedModePage/Model'
        ssss.dependency 'MKLoRaWAN-AE/Functions/TimeSegmentedModePage/View'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TimeSegmentedModePage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TimeSegmentedModePage/View/**'
      end
    end
    
    ss.subspec 'TimingModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TimingModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/TimingModePage/Model'
        ssss.dependency 'MKLoRaWAN-AE/Functions/TimingModePage/View'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TimingModePage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/TimingModePage/View/**'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/UpdatePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/UpdatePage/Model'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/UpdatePage/Model/**'
      end
    end
    
    ss.subspec 'VibrationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/VibrationPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-AE/Functions/VibrationPage/Model'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-AE/Classes/Functions/VibrationPage/Model/**'
      end
    end
    
    ss.dependency 'MKLoRaWAN-AE/SDK'
    ss.dependency 'MKLoRaWAN-AE/DatabaseManager'
    ss.dependency 'MKLoRaWAN-AE/CTMediator'
    ss.dependency 'MKLoRaWAN-AE/ConnectModule'
    ss.dependency 'MKLoRaWAN-AE/Expand'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'iOSDFULibrary',   '4.13.0'
    
  end
  
end
