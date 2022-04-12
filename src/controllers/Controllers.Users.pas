unit Controllers.Users;

interface

uses
  Horse, System.JSON, Ragna, System.SysUtils, System.Classes,
  Jose.CORE.JWT, Jose.CORE.Builder, Providers.Authorization, Configs.Login,
  System.DateUtils, Horse.JWT, Services.Users;

procedure Registry;

implementation

procedure DoPostLogin(Req: THorseRequest; Res: THorseResponse);
var
  ServiceUsers: TServiceUsers;
begin
  ServiceUsers := TServiceUsers.Create(nil);

  try
    Res.Send(ServiceUsers.Post(Req.Body<TJSONObject>).ToJSONObject).Status(THTTPStatus.Created);
  finally
    ServiceUsers.Free;
  end;
end;

procedure DoGetLogin(Req: THorseRequest; Res: THorseResponse);
var
  JWT: TJWT;
  Claims: TJWTClaims;
  Config: TConfigLogin;
begin
  JWT := TJWT.Create;
  Claims := JWT.Claims;
  Claims.JSON := TJSONObject.Create;
  Claims.IssuedAt := Now;
  Claims.Expiration := IncHour(Now, Config.Expires);
  Res.Send(TJSONObject.Create.AddPair('token', TJOSE.SHA256CompactToken(Config.Secret, JWT)));
end;

procedure Registry;
begin
  THorse
  .AddCallback(BasicAuthorization())
  .Get('/api/login', DoGetLogin)
  .AddCallback(Authorization())
  .Post('/api/login',DoPostLogin);
end;

end.
