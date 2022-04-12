unit Configs.Login;

interface

type
  TConfigLogin = record
  private
    function GetExpires: Integer;
    function GetSecret: string;
  public
    property Expires: Integer read GetExpires;
    property Secret: string read GetSecret;
  end;

implementation

uses System.SysUtils;

function TConfigLogin.GetExpires: Integer;
begin
  //this could be get for instance, from GetEnvironmentVariable('LOGIN_EXPIRE').ToInteger('1');
  Result := 1;
end;

function TConfigLogin.GetSecret: string;
begin
  //this could be get for instance from GetEnvironmentVariable('LOGIN_SECRET');
  Result := 'prova-tecnica-seventh';
end;

end.

