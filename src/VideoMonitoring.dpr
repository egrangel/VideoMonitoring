program VideoMonitoring;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.Logger,
  Horse.Logger.Provider.Console,
  Horse.HandleException,
  Horse.OctetStream,
  Horse.JWT,
  Controllers.Servers in 'controllers\Controllers.Servers.pas',
  Controllers.Videos in 'controllers\Controllers.Videos.pas',
  Providers.Connection in 'providers\Providers.Connection.pas' {ProviderConnection: TDataModule},
  Services.Servers in 'services\Services.Servers.pas' {ServiceServers: TDataModule},
  Services.Videos in 'services\Services.Videos.pas' {ServiceVideos: TDataModule},
  Controllers.Recycler in 'controllers\Controllers.Recycler.pas',
  Services.Recycler in 'services\Services.Recycler.pas',
  Controllers.Users in 'controllers\Controllers.Users.pas',
  Providers.Authorization in 'providers\Providers.Authorization.pas',
  Configs.Login in 'configs\Configs.Login.pas',
  Services.Users in 'services\Services.Users.pas' {ServiceUsers: TDataModule},
  Providers.Encrypt in 'providers\Providers.Encrypt.pas',
  Configs.Encrypt in 'configs\Configs.Encrypt.pas';

var
  LLogFileConfig: THorseLoggerConsoleConfig;

begin
  LLogFileConfig := THorseLoggerConsoleConfig.New
    .SetLogFormat('${request_clientip} [${time}] ${request_user_agent} "${request_method} ${request_path_info} ${request_version}" ${response_status} ${response_content_length}');

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New(LLogFileConfig));

  THorse
    .Use(THorseLoggerManager.HorseCallback)
    .Use(Jhonson)
    .Use(OctetStream)
    .Use(HandleException);

  Controllers.Users.Registry;
  Controllers.Servers.Registry;
  Controllers.Videos.Registry;
  Controllers.Recycler.Registry;

  THorse.Listen(9000);
end.
