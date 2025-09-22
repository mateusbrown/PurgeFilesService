unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls, uSettings, uSettingsProvider, uLogProvider, uDebugTool, uDeleteFiles;

type
  TMainService = class(TService)
    TimerService: TTimer;
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceExecute(Sender: TService);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure TimerServiceTimer(Sender: TObject);
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
    FSettings : TSettings;
    FLogProvider : TLogProvider;
    FLogPath : string;
    procedure LoadInitials();
    procedure UnLoadInitials();

  public
    { Public declarations }
    function GetServiceController: TServiceController; override;
  end;

var
  MainService: TMainService;

implementation

{$R *.dfm}

procedure TMainService.LoadInitials;
var settingsProvider : TSettingsProvider;
begin
  settingsProvider := TSettingsProvider.Create;
  settingsProvider.LoadSettings;
  FSettings := settingsProvider.Settings;
  FLogPath := Format('%s%sLog_%s.log',[FSettings.LogDirectory,PathDelim,StringReplace(DateToStr(Now),'/','',[rfReplaceAll])]);
  FLogProvider := TLogProvider.Create(FLogPath);
  FLogProvider.TraceLog('LoadInitials Ready');
end;

procedure TMainService.UnLoadInitials;
begin
  FLogProvider.TraceLog('UnLoadInitials');
  FLogProvider.Destroy;
end;

procedure TMainService.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  FLogProvider.TraceLog('ServiceContinue');
  TimerService.Enabled := Continued;
end;

procedure TMainService.ServiceCreate(Sender: TObject);
begin
  TimerService.Enabled := True;
end;

procedure TMainService.ServiceExecute(Sender: TService);
begin
  FLogProvider.TraceLog('ServiceExecute');
end;

procedure TMainService.ServicePause(Sender: TService; var Paused: Boolean);
begin
  FLogProvider.TraceLog('ServicePause');
  TimerService.Enabled := Paused;
end;

procedure TMainService.ServiceShutdown(Sender: TService);
begin
  FLogProvider.TraceLog('ServiceShutdown');
end;

procedure TMainService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  FLogProvider.TraceLog('ServiceStart');
  TimerService.Enabled := True;
end;

procedure TMainService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  FLogProvider.TraceLog('ServiceStop');
  TimerService.Enabled := False;
end;

procedure TMainService.TimerServiceTimer(Sender: TObject);
var deleteOlderThan : TDateTime;
    debugTool : TDebugTool;
    deleteFiles : TDeleteFiles;
    dir : string;
    i : integer;
begin
  TimerService.Enabled := False;
  LoadInitials;
  debugTool := TDebugTool.Create(FLogProvider);
  deleteFiles := TDeleteFiles.Create(FLogProvider);
  debugTool.DebugMessage('begin TFilePurgerService.Timer1Timer');
  try
    FLogProvider.TraceLog('Timer Start');
    try
      if (FSettings.OlderThanDays > 0) and (Length(FSettings.Directories) > 0) then
      begin
        deleteOlderThan := Now - FSettings.OlderThanDays;
        FLogProvider.TraceLog(Format('Delete files before %s',[DateTimeToStr(deleteOlderThan)]));
        for i := Low(FSettings.Directories) to High(FSettings.Directories) do
        begin
          dir := FSettings.Directories[i];
          FLogProvider.InfoLog(Format('Deleting files from %s',[dir]));
          deleteFiles.DeleteFilesOlderThan(dir, deleteOlderThan);
        end;
      end;
    except
      on e: exception do
      begin
        debugTool.DebugMessage(e.Message);
        FLogProvider.ErrorLog(e.Message);
      end;
    end;
    TimerService.Interval := 60 * 1000 * 15;
  finally
    FLogProvider.TraceLog('Timer End');
    debugTool.DebugMessage('end TFilePurgerService.Timer1Timer');
    UnLoadInitials;
    TimerService.Enabled := True;
  end;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MainService.Controller(CtrlCode);
end;

function TMainService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;
end.
