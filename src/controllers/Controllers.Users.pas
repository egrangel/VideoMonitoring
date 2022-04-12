unit Controllers.Users;

interface

uses
  Horse, System.JSON, Ragna, System.SysUtils, System.Classes,
  Jose.CORE.JWT, Jose.CORE.Builder, Providers.Authorization, Configs.Login,
  System.DateUtils;

function IsLoginValid(PUser, PPassword: String): Boolean;
function CreateJWTToken: TJSONObject;

procedure Registry;

implementation

procedure DoGetLogin(Req: THorseRequest; Res: THorseResponse);
var
  LUser,
  LPassword: String;
begin
  Req.Query.TryGetValue('user',LUser);
  Req.Query.TryGetValue('password',LPassword);

  if not IsLoginValid(LUser,LPassword) then
    raise EHorseException.New.Error('invalid authentication').Status(THTTPStatus.Unauthorized);

  Res.Send(CreateJWTToken).Status(THTTPStatus.Created);
end;

function IsLoginValid(PUser, PPassword: String): Boolean;
begin
  //here should be the authentication validations
  Result := PUser.Equals('prova') and PPassword.Equals('seventh');
end;

function CreateJWTToken: TJSONObject;
var
  JWT: TJWT;
  Claims: TJWTClaims;
  Config: TConfigLogin;
begin
  JWT := TJWT.Create;
  Claims := JWT.Claims;
  Claims.JSON := TJSONObject.Create;
  Claims.Issuer := 'Seventh';
  Claims.IssuedAt := Now;
  Claims.Expiration := IncHour(Now, Config.Expires);
  Result := TJSONObject.Create.AddPair('token', TJOSE.SHA256CompactToken(Config.Secret, JWT));
end;

procedure Registry;
begin
  THorse.Get('/api/login', DoGetLogin);
end;

end.
