object ReportData: TReportData
  OldCreateOrder = False
  Left = 278
  Top = 149
  Height = 138
  Width = 208
  object animals: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'animals.dbf'
    Left = 8
  end
  object biolife: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'biolife.db'
    Left = 56
  end
  object clients: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'clients.dbf'
    Left = 104
  end
  object customer: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'customer.db'
    Left = 152
  end
  object animalsDB: TfrxDBDataset
    UserName = 'animals'
    CloseDataSource = False
    DataSet = animals
    Left = 8
    Top = 56
  end
  object biolifeDB: TfrxDBDataset
    UserName = 'biolifeDB'
    CloseDataSource = False
    DataSet = biolife
    Left = 56
    Top = 56
  end
  object clientsBD: TfrxDBDataset
    UserName = 'clients'
    CloseDataSource = False
    DataSet = clients
    Left = 104
    Top = 56
  end
  object customerDB: TfrxDBDataset
    UserName = 'customer'
    CloseDataSource = False
    DataSet = customer
    Left = 152
    Top = 56
  end
end
