inherited ServiceServers: TServiceServers
  OldCreateOrder = True
  Height = 170
  Width = 296
  object Servers: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select id, name, ip, port from servers')
    Left = 104
    Top = 32
    object ServersId: TWideStringField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 40
    end
    object ServersName: TWideStringField
      FieldName = 'Name'
      Origin = 'Name'
      Size = 200
    end
    object ServersIp: TWideStringField
      FieldName = 'Ip'
      Origin = 'Ip'
      Size = 40
    end
    object ServersPort: TIntegerField
      FieldName = 'Port'
      Origin = 'Port'
    end
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 200
    Top = 88
  end
  object RESTClient: TRESTClient
    Params = <>
    Left = 200
    Top = 32
  end
end
