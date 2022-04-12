inherited ServiceUsers: TServiceUsers
  OldCreateOrder = True
  object Users: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select id, name,  username, password from users')
    Left = 104
    Top = 32
    object UsersId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object UsersName: TWideStringField
      FieldName = 'Name'
      Origin = 'Name'
      Size = 200
    end
    object UsersUserName: TWideStringField
      FieldName = 'UserName'
      Origin = 'UserName'
      Size = 200
    end
    object UsersPassword: TWideStringField
      FieldName = 'Password'
      Origin = 'Password'
      Size = 200
    end
  end
end
