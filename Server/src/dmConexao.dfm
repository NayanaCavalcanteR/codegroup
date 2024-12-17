object dtmConexao: TdtmConexao
  OnDestroy = DataModuleDestroy
  Height = 255
  Width = 395
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=Teste'
      'User_Name=postgres'
      'Password=postgres'
      'Server=localhost'
      'DriverID=PG')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 48
    Top = 32
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 160
    Top = 32
  end
  object FDQuery: TFDQuery
    ActiveStoredUsage = []
    Connection = FDConnection
    Left = 48
    Top = 104
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\TesteDelphi\DLL\dll32\libpq.dll'
    Left = 288
    Top = 32
  end
end
