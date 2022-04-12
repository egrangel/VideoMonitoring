unit Services.Videos;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  System.JSON, Ragna, FireDAC.VCLUI.Wait, Horse, System.NetEncoding;

type
  TServiceVideos = class(TProviderConnection)
    Videos: TFDQuery;
    VideosId: TWideStringField;
    VideosVideoId: TWideStringField;
    VideosServerId: TWideStringField;
    VideosDescription: TWideStringField;
    VideosSizeInBytes: TIntegerField;
    VideoContent: TFDQuery;
    VideoContentContent: TBlobField;
    VideoContentServerId: TWideStringField;
    VideoContentVideoId: TWideStringField;
    VideoContentSizeInBytes: TIntegerField;
  private
  public
    function Post(ServerId: String; Video: TJSONObject): TFDQuery;
    function GetVideoById(ServerId, VideoId: String): TFDQuery;
    function GetVideoBinary(ServerId, VideoId: String): TStream;
    function GetVideoByServer(ServerId: String): TFDQuery;
    procedure Delete(ServerId, VideoId: String);
    procedure PatchVideoBinary(ServerId, VideoId: String;
      Video: TJSONObject);
  end;

implementation

{$R *.dfm}

{ TServiceVideos }

procedure TServiceVideos.Delete(ServerId, VideoId: String);
begin
  GetVideoById(ServerId, VideoId);

  if Videos.IsEmpty then
    raise EHorseException.New.Error('Record not found.').Status(THTTPStatus.NotFound);

  Videos.Delete;
end;

function TServiceVideos.GetVideoBinary(ServerId,VideoId: String): TStream;
var
  OutputStream: TMemoryStream;
begin
  if String.IsNullOrEmpty(ServerId) or String.IsNullOrEmpty(VideoId) then
    raise EHorseException.New.Error('Invalid parameters.').Status(THTTPStatus.BadRequest);

  VideoContent.Where(VideosServerId).Equals(ServerId)
      .&And(VideosVideoId).Equals(VideoId).OpenUp;

  if VideoContent.IsEmpty then
    raise EHorseException.New.Error('Record not found.').Status(THTTPStatus.NotFound);

  OutputStream := TMemoryStream.Create;

  VideoContentContent.SaveToStream(OutputStream);

  OutputStream.Position := 0;

  Result := OutputStream;
end;

function TServiceVideos.GetVideoById(ServerId,VideoId: String): TFDQuery;
begin
  if String.IsNullOrEmpty(ServerId) or String.IsNullOrEmpty(VideoId) then
    raise EHorseException.New.Error('Invalid parameters.').Status(THTTPStatus.BadRequest);

  Result := Videos.Where(VideosServerId).Equals(ServerId)
    .&And(VideosVideoId).Equals(VideoId).OpenUp;

  if Videos.IsEmpty then
    raise EHorseException.New.Error('Record not found.').Status(THTTPStatus.NotFound);
end;

function TServiceVideos.GetVideoByServer(ServerId: String): TFDQuery;
begin
  if String.IsNullOrEmpty(ServerId)  then
    raise EHorseException.New.Error('Invalid parameters.').Status(THTTPStatus.BadRequest);

  Result := Videos.Where(VideosServerId).Equals(ServerId).OpenUp;

  if Videos.IsEmpty then
    raise EHorseException.New.Error('Record not found.').Status(THTTPStatus.NotFound);
end;

function TServiceVideos.Post(ServerId: String; Video: TJSONObject): TFDQuery;
begin
  Video.RemovePair('id');
  Video.AddPair('id',TGUID.NewGuid.ToString());

  Video.RemovePair('videoid');
  Video.AddPair('videoid',TGUID.NewGuid.ToString());

  Video.RemovePair('serverid');
  Video.AddPair('serverid',TJSONString.Create(ServerId));

  Videos.New(Video).OpenUp;
  Result := Videos;
end;

procedure TServiceVideos.PatchVideoBinary(ServerId, VideoId: String; Video: TJSONObject);
var
  InputStream, OutputStream: TStringStream;
begin
  InputStream := TStringStream.Create(Video.GetValue('content').ToString,TEncoding.UTF8);
  OutputStream := TStringStream.Create;

  try
    VideoContent.Where(VideosServerId).Equals(ServerId)
      .&And(VideosVideoId).Equals(VideoId).OpenUp;

    if VideoContent.IsEmpty then
      raise EHorseException.New.Error('Record not found.').Status(THTTPStatus.NotFound);

    VideoContent.Edit;


    TNetEncoding.Base64.Decode(InputStream,OutputStream);
    OutputStream.Position := 0;

    VideoContentContent.LoadFromStream(OutputStream);
    VideoContentSizeInBytes.AsInteger := OutputStream.Size;
    VideoContent.Post;

  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end;

end.


