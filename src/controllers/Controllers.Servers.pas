unit Controllers.Servers;


interface

uses
  Horse, Services.Servers, System.JSON, Ragna, System.SysUtils;

procedure Registry;

implementation

procedure DoGetServerHealth(Res: THorseResponse);
begin
  Res.Send(TJSONObject.Create).Status(THTTPStatus.OK);
end;

procedure DoGetServerAvailable(Req: THorseRequest; Res: THorseResponse);
var
  Servers: TServiceServers;
begin
  var ServerId: String := EmptyStr;

  Servers := TServiceServers.Create(nil);
  try
    Req.Params.TryGetValue('server_id', ServerId);

    Servers.GetServerAvailable(ServerId);

    Res.Send(TJSONString.Create('UP'));
  finally
    Servers.Free;
  end;
end;

procedure DoGetServer(Req: THorseRequest; Res: THorseResponse);
var
  Servers: TServiceServers;
begin
  var ServerId: String := EmptyStr;

  Servers := TServiceServers.Create(nil);
  try
    Req.Params.TryGetValue('server_id', ServerId);

    Res.Send(Servers.Get(ServerId).ToJSONArray());
  finally
    Servers.Free;
  end;
end;

procedure DoDeleteServer(Req: THorseRequest; Res: THorseResponse);
var
  Servers: TServiceServers;
begin
  var ServerId: String := EmptyStr;

  Servers := TServiceServers.Create(nil);
  try
    Req.Params.TryGetValue('server_id', ServerId);

    Servers.Delete(ServerId);
    Res.Send(TJSONString.Create('deleted')).Status(THttpStatus.NoContent);
  finally
    Servers.Free;
  end;
end;

procedure DoPostServer(Req: THorseRequest; Res: THorseResponse);
var
  Servers: TServiceServers;
begin
  Servers := TServiceServers.Create(nil);

   try
    Res.Send(Servers.Post(Req.Body<TJSONObject>).ToJSONObject()).Status(THTTPStatus.Created);
  finally
    Servers.Free;
  end;
end;

procedure DoPatchServer(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('update server');
end;

procedure Registry;
begin
  THorse
    .Post('/api/servers',DoPostServer)
    .Get('/api/servers',DoGetServer)
    .Get('/api/servers/:server_id',DoGetServer)
    .Get('/api/servers/:server_id/health',DoGetServerHealth)
    .Get('/api/servers/:server_id/available',DoGetServerAvailable)
    .Patch('/api/servers/:server_id',DoPatchServer)
    .Delete('/api/servers/:server_id',DoDeleteServer);
end;

end.
