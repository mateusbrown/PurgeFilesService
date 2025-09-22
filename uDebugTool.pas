unit uDebugTool;

interface
uses uLogProvider, Winapi.Windows;

type
  TDebugTool = class(TObject)
  private
    FLogProvider : TLogProvider;
  public
    constructor Create(const LogProvider : TLogProvider);
    destructor Destroy; override;
    procedure DebugMessage(const AMessage : string);
  end;

implementation

constructor TDebugTool.Create(const LogProvider: TLogProvider);
begin
  FLogProvider := LogProvider;
end;

destructor TDebugTool.Destroy;
begin
  if Assigned(FLogProvider) then FLogProvider.Destroy;
  inherited;
end;

procedure TDebugTool.DebugMessage(const AMessage: string);
begin
  OutputDebugString(PChar(AMessage));

  if Assigned(FLogProvider) then
  begin
    FLogProvider.DebugLog(AMessage);
  end;
end;

end.
