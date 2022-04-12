inherited ServiceVideos: TServiceVideos
  OldCreateOrder = True
  Height = 171
  Width = 252
  inherited FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=videomonitoring.db')
  end
  object Videos: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      
        'select Id, VideoId, ServerId, Description, SizeInBytes from vide' +
        'os')
    Left = 112
    Top = 32
    object VideosId: TWideStringField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 40
    end
    object VideosVideoId: TWideStringField
      FieldName = 'VideoId'
      Origin = 'VideoId'
      Size = 40
    end
    object VideosServerId: TWideStringField
      FieldName = 'ServerId'
      Origin = 'ServerId'
      Size = 40
    end
    object VideosDescription: TWideStringField
      FieldName = 'Description'
      Origin = 'Description'
      Size = 200
    end
    object VideosSizeInBytes: TIntegerField
      FieldName = 'SizeInBytes'
      Origin = 'SizeInBytes'
    end
  end
  object VideoContent: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select serverid, videoid, content, sizeinbytes from videos')
    Left = 168
    Top = 32
    object VideoContentContent: TBlobField
      FieldName = 'Content'
      Origin = 'Content'
    end
    object VideoContentServerId: TWideStringField
      FieldName = 'ServerId'
      Origin = 'ServerId'
      Size = 40
    end
    object VideoContentVideoId: TWideStringField
      FieldName = 'VideoId'
      Origin = 'VideoId'
      Size = 40
    end
    object VideoContentSizeInBytes: TIntegerField
      FieldName = 'SizeInBytes'
      Origin = 'SizeInBytes'
    end
  end
end
