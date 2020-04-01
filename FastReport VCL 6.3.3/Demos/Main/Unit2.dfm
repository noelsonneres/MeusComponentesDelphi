object ReportData: TReportData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 619
  Width = 630
  object Customers: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    IndexFieldNames = 'Company'
    TableName = 'CUSTOMER'
    Left = 24
    Top = 64
    object CustomersCustNo: TFloatField
      FieldName = 'CustNo'
    end
    object CustomersCompany: TStringField
      FieldName = 'Company'
      Size = 30
    end
    object CustomersAddr1: TStringField
      FieldName = 'Addr1'
      Size = 30
    end
    object CustomersAddr2: TStringField
      FieldName = 'Addr2'
      Size = 30
    end
    object CustomersCity: TStringField
      FieldName = 'City'
      Size = 15
    end
    object CustomersState: TStringField
      FieldName = 'State'
    end
    object CustomersZip: TStringField
      FieldName = 'Zip'
      Size = 10
    end
    object CustomersCountry: TStringField
      FieldName = 'Country'
    end
    object CustomersPhone: TStringField
      FieldName = 'Phone'
      Size = 15
    end
    object CustomersFAX: TStringField
      FieldName = 'FAX'
      Size = 15
    end
    object CustomersTaxRate: TFloatField
      FieldName = 'TaxRate'
    end
    object CustomersContact: TStringField
      FieldName = 'Contact'
    end
    object CustomersLastInvoiceDate: TDateTimeField
      FieldName = 'LastInvoiceDate'
    end
  end
  object LineItems: TADOTable
    Connection = ADOConnection1
    IndexFieldNames = 'OrderNo'
    MasterFields = 'OrderNo'
    MasterSource = OrderSource
    TableName = 'ITEMS'
    Left = 168
    Top = 64
    object LineItemsOrderNo: TFloatField
      FieldName = 'OrderNo'
      Visible = False
    end
    object LineItemsItemNo: TFloatField
      FieldName = 'ItemNo'
    end
    object LineItemsPartNo: TFloatField
      FieldName = 'PartNo'
    end
    object LineItemsPartName: TStringField
      FieldKind = fkLookup
      FieldName = 'PartName'
      LookupDataSet = Parts
      LookupKeyFields = 'PartNo'
      LookupResultField = 'Description'
      KeyFields = 'PartNo'
      Size = 30
      Lookup = True
    end
    object LineItemsQty: TIntegerField
      FieldName = 'Qty'
    end
    object LineItemsPrice: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'Price'
      LookupDataSet = Parts
      LookupKeyFields = 'PartNo'
      LookupResultField = 'ListPrice'
      KeyFields = 'PartNo'
      Lookup = True
    end
    object LineItemsDiscount: TFloatField
      FieldName = 'Discount'
      DisplayFormat = '#0.#%'
      EditFormat = '##.#'
      Precision = 3
    end
    object LineItemsTotal: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Total'
      Calculated = True
    end
    object LineItemsExtendedPrice: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'ExtendedPrice'
      Calculated = True
    end
  end
  object Parts: TADOTable
    Connection = ADOConnection1
    TableName = 'PARTS'
    Left = 240
    Top = 64
    object PartsPartNo: TFloatField
      FieldName = 'PartNo'
    end
    object PartsVendorNo: TFloatField
      FieldName = 'VendorNo'
    end
    object PartsDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object PartsOnHand: TFloatField
      FieldName = 'OnHand'
    end
    object PartsOnOrder: TFloatField
      FieldName = 'OnOrder'
    end
    object PartsCost: TCurrencyField
      FieldName = 'Cost'
    end
    object PartsListPrice: TCurrencyField
      FieldName = 'ListPrice'
    end
  end
  object CustomerSource: TDataSource
    DataSet = Customers
    Left = 24
    Top = 108
  end
  object LineItemSource: TDataSource
    DataSet = LineItems
    Left = 168
    Top = 108
  end
  object PartSource: TDataSource
    DataSet = Parts
    Left = 240
    Top = 108
  end
  object RepQuery: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from customer a, orders b, items c, parts d'
      'where a.custno = b.custno'
      '  and b.orderno = c.orderno'
      '  and c.partno = d.partno'
      'order by a.company, b.orderno')
    Left = 24
    Top = 228
    object RepQueryaCustNo: TFloatField
      FieldName = 'a.CustNo'
    end
    object RepQueryCompany: TWideStringField
      FieldName = 'Company'
      Size = 30
    end
    object RepQueryAddr1: TWideStringField
      FieldName = 'Addr1'
      Size = 30
    end
    object RepQueryAddr2: TWideStringField
      FieldName = 'Addr2'
      Size = 30
    end
    object RepQueryCity: TWideStringField
      FieldName = 'City'
      Size = 15
    end
    object RepQueryState: TWideStringField
      FieldName = 'State'
    end
    object RepQueryZip: TWideStringField
      FieldName = 'Zip'
      Size = 10
    end
    object RepQueryCountry: TWideStringField
      FieldName = 'Country'
    end
    object RepQueryPhone: TWideStringField
      FieldName = 'Phone'
      Size = 15
    end
    object RepQueryFAX: TWideStringField
      FieldName = 'FAX'
      Size = 15
    end
    object RepQueryaTaxRate: TFloatField
      FieldName = 'a.TaxRate'
    end
    object RepQueryContact: TWideStringField
      FieldName = 'Contact'
    end
    object RepQueryLastInvoiceDate: TDateTimeField
      FieldName = 'LastInvoiceDate'
    end
    object RepQuerybOrderNo: TFloatField
      FieldName = 'b.OrderNo'
    end
    object RepQuerybCustNo: TFloatField
      FieldName = 'b.CustNo'
    end
    object RepQuerySaleDate: TDateTimeField
      FieldName = 'SaleDate'
    end
    object RepQueryShipDate: TDateTimeField
      FieldName = 'ShipDate'
    end
    object RepQueryEmpNo: TIntegerField
      FieldName = 'EmpNo'
    end
    object RepQueryShipToContact: TWideStringField
      FieldName = 'ShipToContact'
    end
    object RepQueryShipToAddr1: TWideStringField
      FieldName = 'ShipToAddr1'
      Size = 30
    end
    object RepQueryShipToAddr2: TWideStringField
      FieldName = 'ShipToAddr2'
      Size = 30
    end
    object RepQueryShipToCity: TWideStringField
      FieldName = 'ShipToCity'
      Size = 15
    end
    object RepQueryShipToState: TWideStringField
      FieldName = 'ShipToState'
    end
    object RepQueryShipToZip: TWideStringField
      FieldName = 'ShipToZip'
      Size = 10
    end
    object RepQueryShipToCountry: TWideStringField
      FieldName = 'ShipToCountry'
    end
    object RepQueryShipToPhone: TWideStringField
      FieldName = 'ShipToPhone'
      Size = 15
    end
    object RepQueryShipVIA: TWideStringField
      FieldName = 'ShipVIA'
      Size = 7
    end
    object RepQueryPO: TWideStringField
      FieldName = 'PO'
      Size = 15
    end
    object RepQueryTerms: TWideStringField
      FieldName = 'Terms'
      Size = 6
    end
    object RepQueryPaymentMethod: TWideStringField
      FieldName = 'PaymentMethod'
      Size = 7
    end
    object RepQueryItemsTotal: TFloatField
      FieldName = 'ItemsTotal'
    end
    object RepQuerybTaxRate: TFloatField
      FieldName = 'b.TaxRate'
    end
    object RepQueryFreight: TFloatField
      FieldName = 'Freight'
    end
    object RepQueryAmountPaid: TFloatField
      FieldName = 'AmountPaid'
    end
    object RepQuerycOrderNo: TFloatField
      FieldName = 'c.OrderNo'
    end
    object RepQueryItemNo: TFloatField
      FieldName = 'ItemNo'
    end
    object RepQuerycPartNo: TFloatField
      FieldName = 'c.PartNo'
    end
    object RepQueryQty: TIntegerField
      FieldName = 'Qty'
    end
    object RepQueryDiscount: TFloatField
      FieldName = 'Discount'
    end
    object RepQuerydPartNo: TFloatField
      FieldName = 'd.PartNo'
    end
    object RepQueryVendorNo: TFloatField
      FieldName = 'VendorNo'
    end
    object RepQueryDescription: TWideStringField
      FieldName = 'Description'
      Size = 30
    end
    object RepQueryOnHand: TFloatField
      FieldName = 'OnHand'
    end
    object RepQueryOnOrder: TFloatField
      FieldName = 'OnOrder'
    end
    object RepQueryCost: TFloatField
      FieldName = 'Cost'
    end
    object RepQueryListPrice: TFloatField
      FieldName = 'ListPrice'
    end
  end
  object RepQuerySource: TDataSource
    DataSet = RepQuery
    Left = 24
    Top = 272
  end
  object CustomersDS: TfrxDBDataset
    UserName = 'Customers'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CustNo=Cust No'
      'Company=Company'
      'Addr1=Addr1'
      'Addr2=Addr2'
      'City=City'
      'State=State'
      'Zip=Zip'
      'Country=Country'
      'Phone=Phone'
      'FAX=FAX'
      'TaxRate=Tax Rate'
      'Contact=Contact'
      'LastInvoiceDate=Last Invoice Date')
    DataSource = CustomerSource
    BCDToCurrency = False
    Left = 24
    Top = 152
  end
  object ItemsDS: TfrxDBDataset
    UserName = 'Items'
    CloseDataSource = False
    FieldAliases.Strings = (
      'OrderNo=Order No'
      'ItemNo=Item No'
      'PartNo=Part No'
      'PartName=Part Name'
      'Qty=Qty'
      'Price=Price'
      'Discount=Discount'
      'Total=Total'
      'ExtendedPrice=Extended Price')
    DataSource = LineItemSource
    BCDToCurrency = False
    Left = 168
    Top = 152
  end
  object PartDS: TfrxDBDataset
    UserName = 'Parts'
    CloseDataSource = False
    FieldAliases.Strings = (
      'PartNo=Part No'
      'VendorNo=Vendor No'
      'Description=Description'
      'OnHand=On Hand'
      'OnOrder=On Order'
      'Cost=Cost'
      'ListPrice=List Price')
    DataSource = PartSource
    BCDToCurrency = False
    Left = 240
    Top = 152
  end
  object QueryDS: TfrxDBDataset
    UserName = 'Sales'
    CloseDataSource = False
    FieldAliases.Strings = (
      'a.CustNo=Cust No'
      'Company=Company'
      'Addr1=Addr1'
      'Addr2=Addr2'
      'City=City'
      'State=State'
      'Zip=Zip'
      'Country=Country'
      'Phone=Phone'
      'FAX=FAX'
      'a.TaxRate=a.TaxRate'
      'Contact=Contact'
      'LastInvoiceDate=LastInvoiceDate'
      'b.OrderNo=Order No'
      'b.CustNo=b.CustNo'
      'SaleDate=Sale Date'
      'ShipDate=ShipDate'
      'EmpNo=EmpNo'
      'ShipToContact=ShipToContact'
      'ShipToAddr1=ShipToAddr1'
      'ShipToAddr2=ShipToAddr2'
      'ShipToCity=ShipToCity'
      'ShipToState=ShipToState'
      'ShipToZip=ShipToZip'
      'ShipToCountry=ShipToCountry'
      'ShipToPhone=ShipToPhone'
      'ShipVIA=ShipVIA'
      'PO=PO'
      'Terms=Terms'
      'PaymentMethod=PaymentMethod'
      'ItemsTotal=ItemsTotal'
      'b.TaxRate=b.TaxRate'
      'Freight=Freight'
      'AmountPaid=AmountPaid'
      'c.OrderNo=c.OrderNo'
      'ItemNo=ItemNo'
      'c.PartNo=Part No'
      'Qty=Qty'
      'Discount=Discount'
      'd.PartNo=d.PartNo'
      'VendorNo=VendorNo'
      'Description=Description'
      'OnHand=OnHand'
      'OnOrder=OnOrder'
      'Cost=Cost'
      'ListPrice=List Price')
    DataSource = RepQuerySource
    BCDToCurrency = False
    Left = 24
    Top = 316
  end
  object Bio: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'biolife'
    Left = 96
    Top = 228
  end
  object BioSource: TDataSource
    DataSet = Bio
    Left = 96
    Top = 272
  end
  object BioDS: TfrxDBDataset
    UserName = 'Bio'
    CloseDataSource = False
    FieldAliases.Strings = (
      'Species No=Species No'
      'Category=Category'
      'Common_Name=Common Name'
      'Species Name=Species Name'
      'Length (cm)=Length (cm)'
      'Length_In=Length In'
      'Notes=Notes'
      'Graphic=Graphic')
    DataSource = BioSource
    BCDToCurrency = False
    Left = 96
    Top = 316
  end
  object Country: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'country'
    Left = 168
    Top = 228
  end
  object CountrySource: TDataSource
    DataSet = Country
    Left = 168
    Top = 272
  end
  object CountryDS: TfrxDBDataset
    UserName = 'Country'
    CloseDataSource = False
    FieldAliases.Strings = (
      'Name=Name'
      'Capital=Capital'
      'Continent=Continent'
      'Area=Area'
      'Population=Population')
    DataSource = CountrySource
    BCDToCurrency = False
    Left = 168
    Top = 316
  end
  object Cross: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'crosstest'
    Left = 240
    Top = 228
  end
  object CrossSource: TDataSource
    DataSet = Cross
    Left = 240
    Top = 272
  end
  object CrossDS: TfrxDBDataset
    UserName = 'Cross'
    CloseDataSource = False
    DataSource = CrossSource
    BCDToCurrency = False
    Left = 240
    Top = 316
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='#39'c:\Projects\Main\d' +
      'emo.MDB'#39';'
    LoginPrompt = False
    Mode = cmRead
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 36
    Top = 12
  end
  object ADOConnection2: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='#39'c:\Projects\Main\N' +
      'orthwind.MDB'#39';'
    LoginPrompt = False
    Mode = cmRead
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 364
    Top = 12
  end
  object Orders: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    IndexFieldNames = 'CustNo'
    MasterFields = 'CustNo'
    MasterSource = CustomerSource
    TableName = 'ORDERS'
    Left = 96
    Top = 64
    object OrdersOrderNo: TFloatField
      FieldName = 'OrderNo'
    end
    object OrdersCustNo: TFloatField
      FieldName = 'CustNo'
      Required = True
    end
    object OrdersCustCompany: TStringField
      FieldKind = fkLookup
      FieldName = 'CustCompany'
      LookupDataSet = Customers
      LookupKeyFields = 'CustNo'
      LookupResultField = 'Company'
      KeyFields = 'CustNo'
      Lookup = True
    end
    object OrdersSaleDate: TDateTimeField
      FieldName = 'SaleDate'
    end
    object OrdersShipDate: TDateTimeField
      FieldName = 'ShipDate'
    end
    object OrdersEmpNo: TIntegerField
      FieldName = 'EmpNo'
      Required = True
    end
    object OrdersShipToContact: TStringField
      FieldName = 'ShipToContact'
    end
    object OrdersShipToAddr1: TStringField
      FieldName = 'ShipToAddr1'
      Size = 30
    end
    object OrdersShipToAddr2: TStringField
      FieldName = 'ShipToAddr2'
      Size = 30
    end
    object OrdersShipToCity: TStringField
      FieldName = 'ShipToCity'
      Size = 15
    end
    object OrdersShipToState: TStringField
      FieldName = 'ShipToState'
    end
    object OrdersShipToZip: TStringField
      FieldName = 'ShipToZip'
      Size = 10
    end
    object OrdersShipToCountry: TStringField
      FieldName = 'ShipToCountry'
    end
    object OrdersShipToPhone: TStringField
      FieldName = 'ShipToPhone'
      Size = 15
    end
    object OrdersShipVIA: TStringField
      FieldName = 'ShipVIA'
      Size = 7
    end
    object OrdersPO: TStringField
      FieldName = 'PO'
      Size = 15
    end
    object OrdersTerms: TStringField
      FieldName = 'Terms'
      Size = 6
    end
    object OrdersPaymentMethod: TStringField
      FieldName = 'PaymentMethod'
      Size = 7
    end
    object OrdersItemsTotal: TCurrencyField
      FieldName = 'ItemsTotal'
    end
    object OrdersTaxRate: TFloatField
      FieldName = 'TaxRate'
    end
    object OrdersFreight: TCurrencyField
      FieldName = 'Freight'
    end
    object OrdersAmountPaid: TCurrencyField
      FieldName = 'AmountPaid'
    end
  end
  object OrderSource: TDataSource
    DataSet = Orders
    Left = 96
    Top = 108
  end
  object OrdersDS: TfrxDBDataset
    UserName = 'Orders'
    CloseDataSource = False
    FieldAliases.Strings = (
      'OrderNo=Order No'
      'CustNo=Cust No'
      'CustCompany=Cust Company'
      'SaleDate=Sale Date'
      'ShipDate=Ship Date'
      'EmpNo=Emp No'
      'ShipToContact=Ship To Contact'
      'ShipToAddr1=Ship To Addr1'
      'ShipToAddr2=Ship To Addr2'
      'ShipToCity=Ship To City'
      'ShipToState=Ship To State'
      'ShipToZip=Ship To Zip'
      'ShipToCountry=Ship To Country'
      'ShipToPhone=Ship To Phone'
      'ShipVIA=Ship VIA'
      'PO=PO'
      'Terms=Terms'
      'PaymentMethod=Payment Method'
      'ItemsTotal=Items Total'
      'TaxRate=Tax Rate'
      'Freight=Freight'
      'AmountPaid=Amount Paid')
    DataSource = OrderSource
    BCDToCurrency = False
    Left = 96
    Top = 152
  end
  object MapOrders: TADOTable
    Connection = ADOConnection2
    CursorType = ctStatic
    IndexFieldNames = 'OrderID'
    MasterFields = 'OrderID'
    MasterSource = MapOrderDetailsSource
    TableName = 'Orders'
    Left = 360
    Top = 64
    object MapOrdersOrderID: TAutoIncField
      FieldName = 'OrderID'
      ReadOnly = True
    end
    object MapOrdersCustomerID: TWideStringField
      FieldName = 'CustomerID'
      Size = 5
    end
    object MapOrdersEmployeeID: TIntegerField
      FieldName = 'EmployeeID'
    end
    object MapOrdersOrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object MapOrdersRequiredDate: TDateTimeField
      FieldName = 'RequiredDate'
    end
    object MapOrdersShippedDate: TDateTimeField
      FieldName = 'ShippedDate'
    end
    object MapOrdersShipVia: TIntegerField
      FieldName = 'ShipVia'
    end
    object MapOrdersFreight: TBCDField
      FieldName = 'Freight'
      Precision = 19
    end
    object MapOrdersShipName: TWideStringField
      FieldName = 'ShipName'
      Size = 40
    end
    object MapOrdersShipAddress: TWideStringField
      FieldName = 'ShipAddress'
      Size = 60
    end
    object MapOrdersShipCity: TWideStringField
      FieldName = 'ShipCity'
      Size = 15
    end
    object MapOrdersShipRegion: TWideStringField
      FieldName = 'ShipRegion'
      Size = 15
    end
    object MapOrdersShipPostalCode: TWideStringField
      FieldName = 'ShipPostalCode'
      Size = 10
    end
    object MapOrdersShipCountry: TWideStringField
      FieldName = 'ShipCountry'
      Size = 15
    end
    object MapOrdersLatitude: TFloatField
      FieldName = 'Latitude'
    end
    object MapOrdersLongitude: TFloatField
      FieldName = 'Longitude'
    end
  end
  object MapOrderDetails: TADOTable
    Connection = ADOConnection2
    CursorType = ctStatic
    IndexFieldNames = 'OrderID'
    TableName = 'Order Details'
    Left = 360
    Top = 232
    object MapOrderDetailsOrderID: TIntegerField
      FieldName = 'OrderID'
    end
    object MapOrderDetailsProductID: TIntegerField
      FieldName = 'ProductID'
    end
    object MapOrderDetailsUnitPrice: TBCDField
      FieldName = 'UnitPrice'
      Precision = 19
    end
    object MapOrderDetailsQuantity: TSmallintField
      FieldName = 'Quantity'
    end
    object MapOrderDetailsDiscount: TFloatField
      FieldName = 'Discount'
    end
  end
  object MapOrdersSource: TDataSource
    DataSet = MapOrders
    Left = 360
    Top = 112
  end
  object MapOrderDetailsSource: TDataSource
    DataSet = MapOrderDetails
    Left = 360
    Top = 280
  end
  object MapOrdersDS: TfrxDBDataset
    UserName = 'MapOrders'
    CloseDataSource = False
    DataSource = MapOrdersSource
    BCDToCurrency = False
    Left = 360
    Top = 160
  end
  object MapOrderDetailsDS: TfrxDBDataset
    UserName = 'MapOrderDetails'
    CloseDataSource = False
    DataSource = MapOrderDetailsSource
    BCDToCurrency = False
    Left = 360
    Top = 328
  end
  object MapOrdersDS2: TfrxDBDataset
    UserName = 'MapOrders2'
    CloseDataSource = False
    DataSource = MapOrdersSource2
    BCDToCurrency = False
    Left = 472
    Top = 152
  end
  object MapOrders2: TADOTable
    Connection = ADOConnection2
    CursorType = ctStatic
    IndexFieldNames = 'OrderID'
    TableName = 'Orders'
    Left = 472
    Top = 56
    object AutoIncField1: TAutoIncField
      FieldName = 'OrderID'
      ReadOnly = True
    end
    object WideStringField1: TWideStringField
      FieldName = 'CustomerID'
      Size = 5
    end
    object IntegerField1: TIntegerField
      FieldName = 'EmployeeID'
    end
    object DateTimeField1: TDateTimeField
      FieldName = 'OrderDate'
    end
    object DateTimeField2: TDateTimeField
      FieldName = 'RequiredDate'
    end
    object DateTimeField3: TDateTimeField
      FieldName = 'ShippedDate'
    end
    object IntegerField2: TIntegerField
      FieldName = 'ShipVia'
    end
    object BCDField1: TBCDField
      FieldName = 'Freight'
      Precision = 19
    end
    object WideStringField2: TWideStringField
      FieldName = 'ShipName'
      Size = 40
    end
    object WideStringField3: TWideStringField
      FieldName = 'ShipAddress'
      Size = 60
    end
    object WideStringField4: TWideStringField
      FieldName = 'ShipCity'
      Size = 15
    end
    object WideStringField5: TWideStringField
      FieldName = 'ShipRegion'
      Size = 15
    end
    object WideStringField6: TWideStringField
      FieldName = 'ShipPostalCode'
      Size = 10
    end
    object WideStringField7: TWideStringField
      FieldName = 'ShipCountry'
      Size = 15
    end
    object FloatField1: TFloatField
      FieldName = 'Latitude'
    end
    object FloatField2: TFloatField
      FieldName = 'Longitude'
    end
  end
  object MapOrdersSource2: TDataSource
    DataSet = MapOrders2
    Left = 472
    Top = 104
  end
  object MapOrderDetailsExtended: TADOTable
    Connection = ADOConnection2
    CursorType = ctStatic
    IndexFieldNames = 'OrderID'
    MasterFields = 'OrderID'
    MasterSource = MapOrdersSource2
    TableName = 'Order Details Extended'
    Left = 472
    Top = 216
    object IntegerField5: TIntegerField
      FieldName = 'OrderID'
    end
    object IntegerField6: TIntegerField
      FieldName = 'ProductID'
    end
    object BCDField3: TBCDField
      FieldName = 'UnitPrice'
      Precision = 19
    end
    object SmallintField2: TSmallintField
      FieldName = 'Quantity'
    end
    object FloatField4: TFloatField
      FieldName = 'Discount'
    end
    object MapOrderDetailsExtendedProductName: TWideStringField
      FieldName = 'ProductName'
      Size = 40
    end
    object MapOrderDetailsExtendedExtendedPrice: TBCDField
      FieldName = 'ExtendedPrice'
      ReadOnly = True
      Precision = 19
    end
  end
  object MapOrderDetailsExtendedSource: TDataSource
    DataSet = MapOrderDetailsExtended
    Left = 472
    Top = 264
  end
  object MapOrderDetailsExtendedDS: TfrxDBDataset
    UserName = 'MapOrderDetailsExtended'
    CloseDataSource = False
    DataSource = MapOrderDetailsExtendedSource
    BCDToCurrency = False
    Left = 472
    Top = 312
  end
  object NACities: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'nacities'
    Left = 24
    Top = 392
  end
  object NACitiesSource: TDataSource
    DataSet = NACities
    Left = 24
    Top = 448
  end
  object NACitiesDS: TfrxDBDataset
    UserName = 'NACities'
    CloseDataSource = False
    DataSource = NACitiesSource
    BCDToCurrency = False
    Left = 24
    Top = 504
  end
  object NARivers: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'narivers'
    Left = 96
    Top = 392
  end
  object NARiversSource: TDataSource
    DataSet = NARivers
    Left = 96
    Top = 448
  end
  object LineStringDS: TfrxDBDataset
    UserName = 'NARivers'
    CloseDataSource = False
    DataSource = NARiversSource
    BCDToCurrency = False
    Left = 96
    Top = 504
  end
  object NAStates: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'nastates'
    Left = 168
    Top = 392
  end
  object NAStatesSource: TDataSource
    DataSet = NAStates
    Left = 168
    Top = 448
  end
  object NAStatesDS: TfrxDBDataset
    UserName = 'NAStates'
    CloseDataSource = False
    DataSource = NAStatesSource
    BCDToCurrency = False
    Left = 168
    Top = 504
  end
end
