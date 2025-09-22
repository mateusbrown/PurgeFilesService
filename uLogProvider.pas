unit uLogProvider;

interface
uses System.Classes, System.SysUtils;
type
  TLogProvider = class(TObject)
  private
    FLogFile: TextFile;
    FLogPath : string;
    FIsOpen: Boolean;
    procedure OpenLogFile;
  public
    constructor Create(LogPath : string);
    destructor Destroy; override;
    procedure CloseLog;
    procedure WriteLog(const content: string; const tp : string);
    property IsOpen: Boolean read FIsOpen;
    procedure ErrorLog(const content: string);
    procedure WarningLog(const content: string);
    procedure InfoLog(const content: string);
    procedure TraceLog(const content: string);
    procedure DebugLog(const content: string);
  end;

implementation

constructor TLogProvider.Create(LogPath: string);
begin
  FLogPath := LogPath;
  FIsOpen := False;
  OpenLogFile;
end;

procedure TLogProvider.OpenLogFile;
begin
  AssignFile(FLogFile, FLogPath);
  if FileExists(FLogPath) then
    Append(FLogFile)
  else
    Rewrite(FLogFile);
  FIsOpen := True;
end;

procedure TLogProvider.ErrorLog(const content: string);
begin
  WriteLog(content, 'ERROR');
end;

procedure TLogProvider.WarningLog(const content: string);
begin
  WriteLog(content, 'WARNING');
end;

procedure TLogProvider.InfoLog(const content: string);
begin
  WriteLog(content, 'INFO');
end;

procedure TLogProvider.TraceLog(const content: string);
begin
  WriteLog(content, 'TRACE');
end;

procedure TLogProvider.DebugLog(const content: string);
begin
  WriteLog(content, 'DEBUG');
end;

procedure TLogProvider.WriteLog(const content: string; const tp : string);
var
  LogMsg: string;
begin
  if not FIsOpen then
    OpenLogFile;
  LogMsg := Format('[%s][%s] %s', [DateTimeToStr(Now), tp, content]);
  WriteLn(FLogFile, LogMsg);
  Flush(FLogFile);
end;

destructor TLogProvider.Destroy;
begin
  if FIsOpen then
    CloseLog;
  inherited;
end;

procedure TLogProvider.CloseLog;
begin
  if FIsOpen then
  begin
    CloseFile(FLogFile);
    FIsOpen := False;
  end;
end;

end.
