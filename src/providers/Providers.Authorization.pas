unit Providers.Authorization;

interface

uses Horse, Horse.JWT;

function Authorization: THorseCallback;

implementation

uses Configs.Login;

function Authorization: THorseCallback;
var
  Config: TConfigLogin;
begin
  Result := HorseJWT(Config.Secret);
end;

end.

