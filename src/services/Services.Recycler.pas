unit Services.Recycler;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client, System.JSON,
  Horse, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Ragna;

type
  IServiceRecycler = interface
    procedure Post(Days: string);
  end;


  TServiceRecycler = class(TInterfacedObject, IServiceRecycler)
  private
  public
    procedure Post(Days: String);
  end;

implementation

{ TServiceRecycler }

procedure TServiceRecycler.Post(Days: String);
var
  FDConnection: TFDConnection;
  qry: TFDQuery;
begin
  if String.IsNullOrEmpty(Days) or (String.ToInteger(Days) = 0) then
    raise EHorseException.New.Error('Parameter invalid').Status(THTTPStatus.BadRequest);

  FDConnection := TFDConnection.Create(nil);
  qry := TFDQuery.Create(nil);
  try
    FDConnection.Params.DriverID := 'SQLite';
    FDConnection.Params.Database := 'videomonitoring.db';

    qry.Connection := FDConnection;
    qry.SQL.Text := format('delete from videos where date(DateInsert) < date(''now'',''-%s day'')',[Days]);
    qry.ExecSQL;

    //for process runtime simulation purpose only
    var I: Integer;
    for I := 1 to 10 do
      Sleep(1000);
  finally
    qry.Free;
    FDConnection.Free;
  end;
end;

end.
