unit uDeleteFiles;

interface
uses Classes, SysUtils, System.IOUtils,
     System.Types, WinApi.Windows, uLogProvider, uDebugTool;
type
  TDeleteFiles = class(TObject)
  private
    FLogProvider : TLogProvider;
    FDebugTool : TDebugTool;
  public
    constructor Create(const LogProvider: TLogProvider);
    destructor Destroy;
    procedure DeleteFilesOlderThan(ADirectory: string; ATime: TDateTime);
    function FileTimeToDateTime(const AFileTime: TFileTime): TDateTime;
  end;


implementation

constructor TDeleteFiles.Create(const LogProvider: TLogProvider);
begin
  FLogProvider := LogProvider;
  FDebugTool := TDebugTool.Create(FLogProvider);
end;

destructor TDeleteFiles.Destroy;
begin
  if Assigned(FLogProvider) then FLogProvider.Destroy;
  inherited;
end;

function TDeleteFiles.FileTimeToDateTime(const AFileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  // Convert the file time to local file time
  if not FileTimeToLocalFileTime(AFileTime, LocalFileTime) then
    RaiseLastOSError;
  // Convert the local file time to system time
  if not FileTimeToSystemTime(LocalFileTime, SystemTime) then
    RaiseLastOSError;
  // Convert the system time to Delphi's TDateTime
  Result := SystemTimeToDateTime(SystemTime);
end;


procedure TDeleteFiles.DeleteFilesOlderThan(ADirectory: string; ATime: TDateTime);
var
  LFiles: TStringDynArray;
begin
  FDebugTool.DebugMessage('begin DeleteFilesOlderThan');
  FDebugTool.DebugMessage('  Params: ADirectory=' + ADirectory + ',ATime=' + DateTimeToStr(ATime));

  LFiles := TDirectory.GetFiles(ADirectory, '*',
              TSearchOption.soTopDirectoryOnly,
              function (const Path: string;
                        const SR: TSearchRec): Boolean
              begin
                var dt := FileTimeToDateTime(SR.FindData.ftLastAccessTime);
                Result := dt < ATime;
              end);

  for var LFileName in LFiles do
  begin
    FDebugTool.DebugMessage('  deleting file ' + LFileName);
  end;
  FDebugTool.DebugMessage('end DeleteFilesOlderThan');
end;

end.
