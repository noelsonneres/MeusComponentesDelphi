object ServerMethodDM: TServerMethodDM
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  OnWelcomeMessage = ServerMethodDataModuleWelcomeMessage
  OnMassiveProcess = ServerMethodDataModuleMassiveProcess
  Height = 278
  Width = 358
  object RESTDWPoolerFD: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 164
    Top = 15
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    OnPrepareConnection = RESTDWDriverFD1PrepareConnection
    Connection = Server_FDConnection
    Left = 53
    Top = 60
  end
  object Server_FDConnection: TFDConnection
    Params.Strings = (
      'Database=D:\DW\CORE\Demos\EMPLOYEE.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    FetchOptions.AssignedValues = [evCursorKind]
    FetchOptions.CursorKind = ckDefault
    UpdateOptions.AssignedValues = [uvCountUpdatedRecords]
    ConnectedStoredUsage = []
    LoginPrompt = False
    Transaction = FDTransaction1
    OnError = Server_FDConnectionError
    BeforeConnect = Server_FDConnectionBeforeConnect
    Left = 53
    Top = 15
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 109
    Top = 60
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 81
    Top = 60
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 109
    Top = 15
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 137
    Top = 60
  end
  object FDTransaction1: TFDTransaction
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = Server_FDConnection
    Left = 81
    Top = 15
  end
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovDateTime
            ParamName = 'result'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'inputdata'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'resultstring'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'servertime'
        OnReplyEvent = DWServerEvents1EventsservertimeReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'sql'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'loaddatasetevent'
        OnReplyEvent = DWServerEvents1EventsloaddataseteventReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'getemployee'
        OnReplyEvent = DWServerEvents1EventsgetemployeeReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'segundoparam'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'getemployeeDW'
        OnReplyEvent = DWServerEvents1EventsgetemployeeDWReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovInteger
            ParamName = 'mynumber'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovInteger
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'eventint'
        OnReplyEvent = DWServerEvents1EventseventintReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovDateTime
            ParamName = 'mydatetime'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovDateTime
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'eventdatetime'
        OnReplyEvent = DWServerEvents1EventseventdatetimeReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'entrada'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'helloworldPJ'
        OnReplyEvent = DWServerEvents1EventshelloworldReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'result'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'entrada'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'helloworldRDW'
        OnReplyEvent = DWServerEvents1EventshelloworldRDWReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'sql1'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'sql2'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'sql3'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'sql4'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'sql5'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovBoolean
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'athorarioliberar'
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmDataware
        Name = 'assyncevent'
        OnReplyEvent = DWServerEvents1EventsassynceventReplyEvent
      end>
    ContextName = 'SE1'
    Left = 80
    Top = 105
  end
  object FDQuery1: TFDQuery
    Connection = Server_FDConnection
    SQL.Strings = (
      '')
    Left = 137
    Top = 15
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 165
    Top = 60
  end
  object DWServerEvents2: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'helloworld'
        OnReplyEvent = DWServerEvents2Eventshelloworld2ReplyEvent
      end>
    ContextName = 'SE2'
    Left = 108
    Top = 105
  end
  object DWServerContext1: TDWServerContext
    IgnoreInvalidParams = False
    ContextList = <
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'entrada'
            Encoded = True
          end>
        ContentType = 'text/html'
        ContextName = 'init'
        Routes = [crAll]
        IgnoreBaseHeader = False
        OnReplyRequest = DWServerContext1ContextListinitReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'index'
        Routes = [crAll]
        IgnoreBaseHeader = False
        OnReplyRequest = DWServerContext1ContextListindexReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'openfile'
        Routes = [crAll]
        IgnoreBaseHeader = False
        OnReplyRequestStream = DWServerContext1ContextListopenfileReplyRequestStream
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'php'
        Routes = [crAll]
        IgnoreBaseHeader = False
        OnReplyRequest = DWServerContext1ContextListphpReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'angular'
        Routes = [crAll]
        IgnoreBaseHeader = False
        OnReplyRequest = DWServerContext1ContextListangularReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'zsend'
        Routes = [crAll]
        IgnoreBaseHeader = False
        OnReplyRequest = DWServerContext1ContextListzsendReplyRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'webpascal'
        DefaultHtml.Strings = (
          '')
        Routes = [crAll]
        ContextRules = dwcrEmployee
        IgnoreBaseHeader = False
      end>
    BaseContext = 'www'
    RootContext = 'index'
    Left = 136
    Top = 105
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 193
    Top = 60
  end
  object dwcrEmployee: TDWContextRules
    ContentType = 'text/html'
    MasterHtml.Strings = (
      '<!DOCTYPE html>'
      '<html lang="pt-br">'
      '<head>'
      '    <meta charset="UTF-8">'
      ''
      
        '    <meta http-equiv="Content-Type" content="text/html; charset=' +
        'UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1, shrink-to-fit=no">'
      
        '    <meta name="description" content="Consumindo servidor RestDa' +
        'taware">'
      '    <link rel="icon" href="img/browser.ico">'
      ''
      
        '    <link rel="alternate" type="application/rss+xml" title="RSS ' +
        '2.0" href="http://www.datatables.net/rss.xml">'
      
        '    <link rel="stylesheet" type="text/css" href="https://cdnjs.c' +
        'loudflare.com/ajax/libs/twitter-bootstrap/4.1.1/css/bootstrap.cs' +
        's">'
      
        '    <link rel="stylesheet" type="text/css" href="https://cdn.dat' +
        'atables.net/1.10.19/css/dataTables.bootstrap4.min.css">'
      ''
      ''
      
        '    <script type="text/javascript" language="javascript" src="ht' +
        'tps://code.jquery.com/jquery-3.3.1.js"></script>'
      
        '    <script type="text/javascript" language="javascript" src="ht' +
        'tps://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></' +
        'script>'
      
        '    <script type="text/javascript" language="javascript" src="ht' +
        'tps://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js' +
        '"></script>'
      ''
      '    {%labeltitle%}'
      ''
      
        '    <link rel="stylesheet" type="text/css" href="//cdn.datatable' +
        's.net/1.10.15/css/jquery.dataTables.css">'
      ''
      '</head>'
      '<body>'
      '    {%navbar%}'
      '    {%datatable%}'
      '    {%incscripts%} '
      '</body>'
      '</html>')
    MasterHtmlTag = '$body'
    IncludeScripts.Strings = (
      '<script src="https://code.jquery.com/jquery-1.12.4.js"></script>'
      
        '    <script src="https://cdn.datatables.net/1.10.16/js/jquery.da' +
        'taTables.min.js"></script>'
      '    <script type="text/javascript">'
      '        $(document).ready(function () {'
      
        '            var datatable = $('#39'#my-table'#39').DataTable({ //dataTab' +
        'le tamb'#233'm funcionar'
      
        '                dom: "Bfrtip", // Use dom: '#39'Blfrtip'#39', para fazer' +
        ' o seletor "por p'#225'gina" aparecer.'
      '                ajax: {'
      '                    url: window.location + '#39'&dwmark:datatable'#39','
      '                    type: '#39'GET'#39','
      
        '                    '#39'beforeSend'#39': function (request) {request.se' +
        'tRequestHeader("content-type","application/x-www-form-urlencoded' +
        '; charset=UTF-8");},'
      '                    dataSrc: '#39#39'},'
      '                stateSave: true,'
      '                columns: ['
      '                    {title: '#39'CODIGO'#39', data: '#39'EMP_NO'#39'},'
      '                    {title: '#39'NOME'#39', data: '#39'FIRST_NAME'#39'},'
      '                    {title: '#39'SOBRENOME'#39', data: '#39'LAST_NAME'#39'},'
      '                    {title: '#39'TELEFONE'#39', data: '#39'PHONE_EXT'#39'},'
      '                    {title: '#39'DATA'#39', data: '#39'HIRE_DATE'#39'},'
      
        '                    {title: '#39'EMPREGO/PAIS'#39', data: '#39'JOB_COUNTRY'#39'}' +
        ','
      '                    {title: '#39'SALARIO'#39', data: '#39'SALARY'#39'},'
      '                ],'
      '            });'
      '            console.log(datatable);'
      '        });'
      '    </script>')
    IncludeScriptsHtmlTag = '{%incscripts%}'
    Items = <
      item
        ContextTag = '<title>Consumindo servidor RestDataware</title>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'labeltitle'
        TagReplace = '{%labeltitle%}'
        ObjectName = 'labeltitle'
      end
      item
        ContextTag = 
          '<nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap' +
          ' p-0">'#13#10'        <a class="navbar-brand col-sm-3 col-md-2 mr-0" h' +
          'ref="index.html">'#13#10'            <img src="imgs/logodw.png" alt="R' +
          'EST DATAWARE" title="REST DATAWARE"/>'#13#10'        </a>'#13#10'        <h4' +
          ' style="color: #fff">Consumindo API REST (RDW) com Javascript</h' +
          '4>'#13#10'    </nav>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'navbar'
        TagReplace = '{%navbar%}'
        ObjectName = 'navbar'
      end
      item
        ContextTag = 
          '<main role="main" class="col-md-9 ml-sm-auto col-lg-12 pt-3 px-4' +
          '">'#13#10'        <div class="d-flex justify-content-between flex-wrap' +
          ' flex-md-nowrap align-pessoas-center pb-2 mb-3 border-bottom">'#13#10 +
          '            <h5 class="">Listagem de EMPREGADOS </h5>'#13#10'        <' +
          '/div>'#13#10'    </main>'#13#10#13#10'    <div class="col-xs-12 col-sm-12 col-md' +
          '-12 col-lg-12">'#13#10'        <div id="data-table_wrapper" class="dat' +
          'aTables_wrapper form-inline dt-bootstrap no-footer">'#13#10'          ' +
          '  <table id="my-table" class="display"></table>'#13#10'        </div>'#13 +
          #10'    </div>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'datatable'
        TagReplace = '{%datatable%}'
        ObjectName = 'datatable'
        OnRequestExecute = dwcrEmployeeItemsdatatableRequestExecute
      end>
    Left = 221
    Top = 121
  end
  object dwscEmployeeCRUD: TDWServerContext
    IgnoreInvalidParams = False
    ContextList = <
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'list'
        DefaultHtml.Strings = (
          '')
        Routes = [crAll]
        ContextRules = dwcrEmployee
        IgnoreBaseHeader = False
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'login'
        DefaultHtml.Strings = (
          '<!doctype html>'
          '<html>'
          '  <head>'
          #9'    <meta charset="utf-8">'
          #9'    <meta http-equiv="X-UA-Compatible" content="IE=edge">'
          
            #9'    <meta name="viewport" content="width=device-width, initial-' +
            'scale=1, shrink-to-fit=no">'
          #9'    <meta name="description" content="">'
          #9'    <meta name="author" content="">'
          #9'    <link rel="icon" href="layout/img/favicon.png">'
          ''
          #9'    <title>Genesis - Dicomvix</title>'
          ''
          #9'    <!-- Bootstrap core CSS -->'
          #9'    <link href="css/bootstrap.min.css" rel="stylesheet">'
          ''
          #9'    <!-- Custom styles for this template -->'
          #9'    <link href="css/signin.css" rel="stylesheet">'
          ''
          #9'    <script src="plugins/jquery/jquery.js"></script>'
          
            '                      <link href="signaturepad_css/jquery.signat' +
            'urepad.css" rel="stylesheet">'
          
            #9#9'<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3' +
            '.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxl' +
            'twRo8QtmkMRdAu8=" crossorigin="anonymous"></script>'
          #9'    <script src="plugins/jQueryUI/jquery-ui.js"></script>'
          #9'    <script src="js/bootstrap.min.js"></script>'
          '  </head>'
          ''
          '  <body>  '
          #9'<nav class="navbar navbar-expand-lg navbar-light bg-light">'
          
            #9'  <img class="sm-8 img-responsive logo_genesis" src="img/logo-g' +
            'enesis1.png">'
          
            #9'  <button class="navbar-toggler" type="button" data-toggle="col' +
            'lapse" data-target="#navbarNav" aria-controls="navbarNav" aria-e' +
            'xpanded="false" aria-label="Toggle navigation">'
          #9#9'<span class="navbar-toggler-icon"></span>'
          #9'  </button>'
          #9'  <div class="collapse navbar-collapse" id="navbarNav">  '#9'     '
          '          {%LabelMenu%}         '
          #9'  </div>'
          #9'</nav>'
          '    $body    '
          '          '
          '    <!-- Bootstrap core JavaScript'
          '    ================================================== -->'
          
            '    <!-- Placed at the end of the document so the pages load fas' +
            'ter -->'
          '      '
          '    <!-- jQuery first, then Popper.js, then Bootstrap JS -->'
          
            '    <script src="./www/plugins/jquery/jquery.slim.min.js" integr' +
            'ity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8a' +
            'btTE1Pi6jizo" crossorigin="anonymous"></script>'
          
            '    <script src="./www/plugins/popper/umd/popper.min.js" integri' +
            'ty="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l' +
            '8WvCWPIPm49" crossorigin="anonymous"></script>'
          
            '    <script src="./www/plugins/bootstrap/js/bootstrap.min.js" in' +
            'tegrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6' +
            'OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>'
          
            '    <script type="text/javascript" src="js/jquery.mask.min.js"><' +
            '/script> '
          '    <script type="text/javascript" src="js/mask.js"></script>'
          '    <script type="text/javascript" src="js/funcoes.js"></script>'
          
            #9'<script type="text/javascript" src="js/jquery.dataTables.js"></' +
            'script>    '
          
            #9'<script type="text/javascript" src="js/dataTables.bootstrap.js"' +
            '></script>'#9
          '  </body>'
          '</html>')
        Routes = [crAll]
        ContextRules = dwcLogin
        IgnoreBaseHeader = False
      end>
    BaseContext = 'wemcrud'
    BaseHeader.Strings = (
      '')
    RootContext = 'login'
    Left = 256
    Top = 16
  end
  object dwcLogin: TDWContextRules
    ContentType = 'text/html'
    MasterHtml.Strings = (
      '')
    MasterHtmlTag = '$body'
    IncludeScriptsHtmlTag = '{%incscripts%}'
    Items = <
      item
        ContextTag = 
          '<ul class="navbar-nav"> <li class="nav-item"> <a class="nav-link' +
          '" href="index">Login</a></ul>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'menu'
        TagReplace = '{%LabelMenu%}'
        ObjectName = 'menu'
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="E-Mail">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'email'
        TagReplace = '{%edtEmail%}'
        ObjectName = 'email'
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="Senha">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'esenha'
        TagReplace = '{%edtSenha%}'
        ObjectName = 'esenha'
      end
      item
        ContextTag = '<button {%itemtag%}>Login</button>'
        TypeItem = 'button'
        ClassItem = 'btn btn-primary'
        TagID = 'blogin'
        TagReplace = '{%btnLoginOK%}'
        ObjectName = 'blogin'
      end
      item
        ContextTag = '<button {%itemtag%}>Esqueci minha Senha</button>'
        TypeItem = 'button'
        ClassItem = 'btn btn-warning'
        TagID = 'bescsenha'
        TagReplace = '{%iwBTNSenha%}'
        ObjectName = 'bescsenha'
      end
      item
        ContextTag = '<button {%itemtag%}>Cadastrar Senha</button>'
        TypeItem = 'button'
        ClassItem = 'btn btn-success'
        TagID = 'bcadsenha'
        TagReplace = '{%btnCadastro%}'
        ObjectName = 'bcadsenha'
      end>
    Left = 221
    Top = 167
  end
  object FDMoniRemoteClientLink1: TFDMoniRemoteClientLink
    Left = 221
    Top = 60
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 249
    Top = 60
  end
  object RESTDWDriverRDW1: TRESTDWDriverRDW
    CommitRecords = 100
    Connection = RESTDWDataBase1
    Left = 272
    Top = 160
  end
  object RESTDWDataBase1: TRESTDWDataBase
    Active = False
    Compression = True
    Login = 'testserver'
    Password = 'testserver'
    Proxy = False
    ProxyOptions.Port = 8888
    PoolerService = '127.0.0.1'
    PoolerPort = 8084
    PoolerName = 'TServerMethodDM.RESTDWPoolerDB1'
    StateConnection.AutoCheck = False
    StateConnection.InTime = 1000
    RequestTimeOut = 10000
    EncodeStrings = False
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    ParamCreate = True
    FailOver = False
    FailOverConnections = <>
    FailOverReplaceDefaults = False
    ClientConnectionDefs.Active = False
    Left = 272
    Top = 115
  end
  object RESTDWPoolerRDW: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverRDW1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 272
    Top = 208
  end
  object UniConnection1: TUniConnection
    ProviderName = 'InterBase'
    Port = 3050
    Database = 'D:\Meus Dados\Projetos\Vicenzo\DemoUnidac\Banco\MEDICLINIC.FDB'
    Username = 'sysdba'
    Server = 'localhost'
    Left = 40
    Top = 152
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 68
    Top = 152
  end
  object RESTDWDriverUNIDAC1: TRESTDWDriverUNIDAC
    CommitRecords = 100
    Connection = UniConnection1
    Left = 96
    Top = 152
  end
  object RESTDWPDBUnidac: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverUNIDAC1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 124
    Top = 152
  end
  object RESTDWDBZeos: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverZeos1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 104
    Top = 200
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    ClientCodepage = 'ISO8859_1'
    Catalog = ''
    Properties.Strings = (
      'codepage=ISO8859_1')
    BeforeConnect = ZConnection1BeforeConnect
    HostName = ''
    Port = 0
    Database = ''
    User = ''
    Password = ''
    Protocol = 'firebird-2.5'
    Left = 48
    Top = 200
  end
  object RESTDWDriverZeos1: TRESTDWDriverZeos
    CommitRecords = 100
    Connection = ZConnection1
    Left = 76
    Top = 200
  end
end
