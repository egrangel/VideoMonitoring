unit Providers.Authorization;

interface

uses
  Horse, Horse.JWT, Services.Users, Horse.BasicAuthentication;

function Authorization: THorseCallback;
function BasicAuthorization: THorseCallback;
function DoBasicAuthentication(const Username, Password: string): Boolean;

implementation

uses Configs.Login;

function DoBasicAuthentication(const Username, Password: string): Boolean;
var
  Users: TServiceUsers;
begin
  Users := TServiceUsers.Create(nil);
  try
    Result := Users.IsValid(Username, Password);
  finally
    Users.Free;
  end;
end;

function BasicAuthorization: THorseCallback;
begin
  Result := HorseBasicAuthentication(DoBasicAuthentication);
end;

function Authorization: THorseCallback;
var
  Config: TConfigLogin;
begin
  Result := HorseJWT(Config.Secret);
end;

end.

