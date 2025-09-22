unit uSettings;

interface
uses System.SysUtils, System.Classes, System.Types;
type
  TSettings = class(TObject)
  private
    FOlderThanDays : Integer;
    FDirectories : TStringDynArray;
    FLogDirectory : String;
    procedure SetOlderThanDays(Value : Integer);
    procedure SetDirectories(Value : TStringDynArray);
    procedure SetLogDirectory(Value : string);
  public
    property OlderThanDays: Integer read FOlderThanDays write SetOlderThanDays;
    property Directories : TStringDynArray read FDirectories write SetDirectories;
    property LogDirectory : String read FLogDirectory write SetLogDirectory;
    constructor Create;
  end;

implementation

procedure TSettings.SetOlderThanDays(Value: Integer);
begin
  FOlderThanDays := Value;
end;

constructor TSettings.Create;
begin
  SetLength(FDirectories,0);
  FOlderThanDays := 0;
  FLogDirectory := EmptyStr;
end;

procedure TSettings.SetDirectories(Value: TStringDynArray);
begin
  FDirectories := Value;
end;

procedure TSettings.SetLogDirectory(Value : string);
begin
  FLogDirectory := Value;
end;

end.
