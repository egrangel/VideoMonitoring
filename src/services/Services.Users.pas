unit Services.Users;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, System.JSON, Ragna;

type
  TServiceUsers = class(TProviderConnection)
    Users: TFDQuery;
    UsersId: TFDAutoIncField;
    UsersName: TWideStringField;
    UsersUserName: TWideStringField;
    UsersPassword: TWideStringField;
  private
  public
    function IsValid(const UserName, Password: String): Boolean;
    function Post(User: TJSONObject): TFDQuery;
    function Get: TFDQuery;
  end;


implementation

uses
  Providers.Encrypt;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServiceUsers }

function TServiceUsers.Get: TFDQuery;
begin
  UsersPassword.Visible := False;
  Result := Users.OpenUp;
end;

function TServiceUsers.IsValid(const UserName, Password: String): Boolean;
begin
  Result := not Users.Where(UsersUsername).Equals(Username).&And(UsersPassword).Equals(TProviderEncrypt.Encrypt(Password))
      .OpenUp.IsEmpty;
end;

function TServiceUsers.Post(User: TJSONObject): TFDQuery;
var
  Password: string;
begin
  Password := TProviderEncrypt.Encrypt(User.GetValue<string>('password'));
  User.RemovePair('password').Free;
  User.AddPair('password', Password);
  Users.New(User).OpenUp;
  UsersPassword.Visible := False;
  Result := Users;
end;

end.
