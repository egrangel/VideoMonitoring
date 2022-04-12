unit Controllers.Recycler;

interface

uses
  Horse, Services.Recycler, System.Classes, System.JSON, System.SysUtils,
  System.Threading, Providers.Authorization, Configs.Login;

procedure Registry;

implementation

var
  RecyclerTask: ITask;

procedure DoPostRecycler(Req: THorseRequest; Res: THorseResponse);
var
  Days: String;
begin
  Req.Params.TryGetValue('days',Days);

  try
    if Assigned(RecyclerTask) and (RecyclerTask.Status = TTaskStatus.Running) then
      raise EHorseException.New.Error('Recycling process already running').Status(THTTPStatus.Conflict);

    RecyclerTask := TTask.Create(
    procedure
    begin
      var ServiceRecycler: IServiceRecycler;
      ServiceRecycler := TServiceRecycler.Create;

      ServiceRecycler.Post(Days);
    end);

    RecyclerTask.Start;
  finally
    Res.Send(TJSONString.Create('Recycling process started')).Status(THTTPStatus.OK);
  end;

end;

procedure DoStatusRecycler(Res: THorseResponse);
begin
  var ResponseMessage: String := 'not running';

  if Assigned(RecyclerTask) and (RecyclerTask.Status = TTaskStatus.Running) then
    ResponseMessage := 'running';

  Res.Send(TJSONString.Create(ResponseMessage)).Status(THTTPStatus.OK);
end;

procedure Registry;
begin
  THorse
    .AddCallback(Authorization())
    .Post('/api/recycler/process/:days',DoPostRecycler)
    .AddCallback(Authorization())
    .Get('/api/recycler/status',DoStatusRecycler);
end;

end.
