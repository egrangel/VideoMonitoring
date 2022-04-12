unit Services.Servers;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, Ragna, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, System.JSON, Horse, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TServiceServers = class(TProviderConnection)
    Servers: TFDQuery;
    ServersId: TWideStringField;
    ServersName: TWideStringField;
    ServersIp: TWideStringField;
    ServersPort: TIntegerField;
    RESTRequest: TRESTRequest;
    RESTClient: TRESTClient;
  private
  public
    function Post(Server: TJSONObject): TFDQuery;
    function Get(ServerId: String): TFDQuery;
    procedure GetServerAvailable(ServerId: String);
    procedure Delete(ServerId: String);
  end;

implementation

{$R *.dfm}

procedure TServiceServers.Delete(ServerId: String);
begin
  Get(ServerId);

  if Servers.IsEmpty then
    raise EHorseException.New.Error('Record not found.').Status(THTTPStatus.NotFound);

  Servers.Delete;
end;

function TServiceServers.Get(ServerId: String): TFDQuery;
begin
  if not String.IsNullOrEmpty(ServerId) then
    Result := Servers.Where(ServersId).Equals(ServerId).OpenUp
  else
    Result := Servers.OpenUp;

  if Servers.IsEmpty then
    raise EHorseException.New.Error('Record not found.').Status(THTTPStatus.NotFound);
end;

procedure TServiceServers.GetServerAvailable(ServerId: String);
begin
  if String.IsNullOrEmpty(ServerId) then
    raise EHorseException.New.Error('Invalid parameter.').Status(THTTPStatus.BadRequest);

  Servers.Where(ServersId).Equals(ServerId).OpenUp;

  RestClient.BaseURL := Concat('http://',ServersIp.AsString,':',ServersPort.AsString);

  RestRequest.Resource := format('/api/servers/%s/health',[ServersId.AsString]);
  RestRequest.Execute;
end;

function TServiceServers.Post(Server: TJSONObject): TFDQuery;
begin
  Servers.New(Server).OpenUp;
  Result := Servers;
end;

end.
