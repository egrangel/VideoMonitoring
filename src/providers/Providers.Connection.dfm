object ProviderConnection: TProviderConnection
  OldCreateOrder = False
  Height = 150
  Width = 215
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=videomonitoring.db')
    Left = 40
    Top = 32
  end
end
