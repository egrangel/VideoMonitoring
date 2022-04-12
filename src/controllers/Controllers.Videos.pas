unit Controllers.Videos;


interface

uses
  Horse, Services.Videos, System.JSON, Ragna, System.SysUtils, System.Classes,
  System.NetEncoding;

procedure Registry;

implementation


procedure DoGetVideoBinary(Req: THorseRequest; Res: THorseResponse);
var
  Videos: TServiceVideos;
  VideoStream: TMemoryStream;
  OutputStream: TStringStream;
  JsonOutput: TJSONObject;
begin
  var VideoId: String := EmptyStr;
  var ServerId: String := EmptyStr;

  Videos := TServiceVideos.Create(nil);
  OutputStream := TStringStream.Create;
  JsonOutput := TJSONObject.Create;

  try
    Req.Params.TryGetValue('server_id', ServerId);
    Req.Params.TryGetValue('video_id', VideoId);

    VideoStream := TMemoryStream(Videos.GetVideoBinary(ServerId, VideoId));

    TNetEncoding.Base64.Encode(VideoStream,OutputStream);

    JsonOutput.AddPair('serverid',ServerId);
    JsonOutput.AddPair('videoid',VideoId);
    JsonOutput.AddPair('content',OutputStream.DataString);

    Res.Send(JsonOutput);
  finally
    Videos.Free;
  end;
end;

procedure DoGetVideoByServer(Req: THorseRequest; Res: THorseResponse);
var
  Videos: TServiceVideos;
begin
  var ServerId: String := EmptyStr;

  Videos := TServiceVideos.Create(nil);
  try
    Req.Params.TryGetValue('server_id', ServerId);

    Res.Send(Videos.GetVideoByServer(ServerId).ToJSONArray());
  finally
    Videos.Free;
  end;
end;

procedure DoGetVideoById(Req: THorseRequest; Res: THorseResponse);
var
  Videos: TServiceVideos;
begin
  var VideoId: String := EmptyStr;
  var ServerId: String := EmptyStr;

  Videos := TServiceVideos.Create(nil);
  try
    Req.Params.TryGetValue('server_id', ServerId);
    Req.Params.TryGetValue('video_id', VideoId);

    Res.Send(Videos.GetVideoById(ServerId,VideoId).ToJSONArray());
  finally
    Videos.Free;
  end;
end;

procedure DoDeleteVideo(Req: THorseRequest; Res: THorseResponse);
var
  Videos: TServiceVideos;
begin
  var VideoId: String := EmptyStr;
  var ServerId: String := EmptyStr;

  Videos := TServiceVideos.Create(nil);
  try
    Req.Params.TryGetValue('server_id', ServerId);
    Req.Params.TryGetValue('video_id', VideoId);

    Videos.Delete(ServerId, VideoId);
    Res.Send(TJSONString.Create).Status(THttpStatus.NoContent);
  finally
    Videos.Free;
  end;
end;

procedure DoPostVideo(Req: THorseRequest; Res: THorseResponse);
var
  Videos: TServiceVideos;
  ServerId: String;
begin
  Videos := TServiceVideos.Create(nil);

   try
    Req.Params.TryGetValue('server_id',ServerId);
    Res.Send(Videos.Post(ServerId, Req.Body<TJSONObject>).ToJSONObject()).Status(THTTPStatus.Created);
  finally
    Videos.Free;
  end;
end;

procedure DoPatchVideo(Req: THorseRequest; Res: THorseResponse);
var
  Videos: TServiceVideos;
begin
  var VideoId: String := EmptyStr;
  var ServerId: String := EmptyStr;

  Videos := TServiceVideos.Create(nil);
  try
    Req.Params.TryGetValue('server_id', ServerId);
    Req.Params.TryGetValue('video_id', VideoId);

    Videos.PatchVideoBinary(ServerId,VideoId,Req.Body<TJSONObject>);

    Res.Send(TJSONString.Create('Binary content uploaded')).Status(THttpStatus.Created);
  finally
    Videos.Free;
  end;
end;

procedure Registry;
begin
  THorse
    .Post('/api/servers/:server_id/videos',DoPostVideo)
    .Get('/api/servers/:server_id/videos',DoGetVideoByServer)
    .Get('/api/servers/:server_id/videos/:video_id',DoGetVideoById)
    .Get('/api/servers/:server_id/videos/:video_id/binary',DoGetVideoBinary)
    .Patch('/api/servers/:server_id/videos/:video_id/binary',DoPatchVideo)
    .Delete('/api/servers/:server_id/videos/:video_id',DoDeleteVideo);
end;

end.
