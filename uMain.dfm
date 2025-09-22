object MainService: TMainService
  OnCreate = ServiceCreate
  DisplayName = 'MainService'
  OnContinue = ServiceContinue
  OnExecute = ServiceExecute
  OnPause = ServicePause
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 480
  Width = 640
  object TimerService: TTimer
    Enabled = False
    OnTimer = TimerServiceTimer
    Left = 224
    Top = 72
  end
end
