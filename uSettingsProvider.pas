unit uSettingsProvider;

interface

uses System.SysUtils, System.Classes, System.Types, System.IniFiles,
 System.IOUtils, uSettings;

type
  TSettingsProvider = class(TObject)
  private
    FIniFile : TIniFile;
    FIniPath : string;
    FSettings : TSettings;
    LogPathDefault : string;
    function LoadDirectories() : TStringDynArray;
    procedure SaveDirectories(dirs : TStringDynArray);
  public
    constructor Create;
    property Settings : TSettings read FSettings;
    procedure LoadSettings;
    procedure SaveSettings(settings : TSettings);
  end;


implementation

const SystemSection = 'System';
      DirectorySection = 'Directory';
      OlderThanDaysIdentification = 'Days';
      LogsIdentification = 'Logs';
      DirIdentification = 'Dir';

constructor TSettingsProvider.Create;
begin
  FSettings := TSettings.Create();
  FIniPath := TPath.ChangeExtension(ParamStr(0), '.ini');
  FIniFile := TIniFile.Create(FIniPath);
  LogPathDefault := ExtractFileDir(ParamStr(0));
  if not FileExists(FIniPath) then
  begin
    LoadSettings;
    SaveSettings(FSettings);
  end;
end;

procedure TSettingsProvider.LoadSettings;
const DefaultDays = 30;
begin
  if not Assigned(FSettings) then
  begin
    FSettings := TSettings.Create();
  end;

  try
    FSettings.OlderThanDays := FIniFile.ReadInteger(SystemSection,OlderThanDaysIdentification,DefaultDays);
    FSettings.LogDirectory := FIniFile.ReadString(SystemSection,LogsIdentification, LogPathDefault);
    FSettings.Directories := LoadDirectories();
  finally
  end;
end;

procedure TSettingsProvider.SaveSettings(settings : TSettings);
begin
  if not Assigned(settings) then
  begin
    settings := TSettings.Create();
  end;

  try
    FIniFile.WriteInteger(SystemSection,OlderThanDaysIdentification,settings.OlderThanDays);
    FIniFile.WriteString(SystemSection,LogsIdentification,settings.LogDirectory);
    SaveDirectories(settings.Directories);
  finally
    FIniFile.UpdateFile;
  end;
end;

function TSettingsProvider.LoadDirectories() : TStringDynArray;
var iCounter : Integer;
    bDone : Boolean;
    sDirKey : string;
    sDirValue : string;
    dirs: TStringDynArray;
begin
  SetLength(dirs,0);

  iCounter:= 1;
  bDone := False;

  while not bDone do
  begin
    sDirKey := Format('%s%d',[DirIdentification,iCounter]);
    sDirValue := FIniFile.ReadString(DirectorySection,sDirKey, EmptyStr);
    if sDirValue = EmptyStr then
      bDone := True
    else
    begin
      SetLength(dirs,iCounter);
      dirs[iCounter-1] := sDirValue;
      inc(iCounter);
    end;
  end;

  Result := dirs;
end;

procedure TSettingsProvider.SaveDirectories(dirs : TStringDynArray);
var i : Integer;
    sDirKey : string;
begin
  for i := Low(dirs) to High(dirs) do
  begin
    sDirKey := Format('%s%d',[DirIdentification,(i + 1)]);
    FIniFile.WriteString(DirectorySection,sDirKey,dirs[i]);
  end;
end;

end.
