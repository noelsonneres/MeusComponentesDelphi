object ServerMethodDM: TServerMethodDM
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  Height = 215
  Width = 270
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 52
    Top = 105
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = Server_FDConnection
    Left = 53
    Top = 60
  end
  object Server_FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=D:\Meus Dados\Projetos\SUGV\Componentes\XyberPower\REST' +
        '_Controls\DEMO\EMPLOYEE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'Port=3050'
      'CharacterSet='
      'DriverID=FB')
    FetchOptions.AssignedValues = [evCursorKind]
    FetchOptions.CursorKind = ckDefault
    UpdateOptions.AssignedValues = [uvCountUpdatedRecords]
    ConnectedStoredUsage = []
    LoginPrompt = False
    Transaction = FDTransaction1
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
  object dwsCrudServer: TDWServerContext
    IgnoreInvalidParams = False
    ContextList = <
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'index'
        Routes = [crGet, crPost]
        ContextRules = dwcrIndex
        IgnoreBaseHeader = False
        OnAuthRequest = dwsCrudServerContextListindexAuthRequest
      end
      item
        DWParams = <>
        ContentType = 'text/html'
        ContextName = 'login'
        Routes = [crGet]
        ContextRules = dwcrLogin
        IgnoreBaseHeader = False
      end>
    BaseContext = 'www'
    RootContext = 'login'
    OnBeforeRenderer = dwsCrudServerBeforeRenderer
    Left = 144
    Top = 105
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 193
    Top = 60
  end
  object dwcrIndex: TDWContextRules
    ContentType = 'text/html'
    MasterHtml.Strings = (
      '')
    MasterHtmlTag = '$body'
    IncludeScripts.Strings = (
      '<script type="text/javascript">'
      ''
      'function getCookie(cname) {'
      ' var name = cname + "=";'
      ' var decodedCookie = decodeURIComponent(document.cookie);'
      ' var ca = decodedCookie.split('#39';'#39');'
      ' for(var i = 0; i < ca.length; i++) {'
      '  var c = ca[i];'
      '  while (c.charAt(0) == '#39' '#39') {'
      '   c = c.substring(1);'
      '  }'
      '  if (c.indexOf(name) == 0) {'
      '   return c.substring(name.length, c.length);'
      '  }'
      ' }'
      ' return "";'
      '}'
      ''
      'function reloadDatatable(value){'
      'var mydt = document.getElementById("employeesresut");'
      'var mydiv = document.getElementById("dataFrame");'
      'mydiv.style.visibility="hidden";'
      ' $('#39'#dataFrame'#39').hide();'
      ' mydt.style.visibility="visible";'
      ' $('#39'#employeesresut'#39').slideDown("slow");'
      ' if (!(value))'
      '  $('#39'#my-table'#39').DataTable().ajax.reload();'
      '}'
      ''
      'function loaddatatable(){'
      
        'var datatable = $('#39'#my-table'#39').DataTable({ //dataTable tamb'#233'm fu' +
        'ncionar'
      
        '                dom: "Bfrtip", // Use dom: '#39'Blfrtip'#39', para fazer' +
        ' o seletor "por p'#225'gina" aparecer.'
      '                ajax: {'
      '                    url: '#39'./www/index?dwmark:datatable'#39','
      '                    contentType: false,'
      '                    data: {username: getCookie("username"),'
      '                              password: getCookie("password")},'
      '                    type: '#39'POST'#39','
      '                    dataSrc: '#39#39'},'
      '                stateSave: true,'
      '                responsive: true,'
      '                columns: ['
      '                    {title: '#39'CODIGO'#39', data: '#39'EMP_NO'#39'},'
      '                    {title: '#39'NOME'#39', data: '#39'FIRST_NAME'#39'},'
      '                    {title: '#39'SOBRENOME'#39', data: '#39'LAST_NAME'#39'},'
      '                    {title: '#39'TELEFONE'#39', data: '#39'PHONE_EXT'#39'},'
      '                    {title: '#39'DATA'#39', data: '#39'HIRE_DATE'#39'},'
      
        '                    {title: '#39'EMPREGO/PAIS'#39', data: '#39'JOB_COUNTRY'#39'}' +
        ','
      '                    {title: '#39'SALARIO'#39', data: '#39'SALARY'#39'},'
      
        '                    {title: '#39'A'#231#245'es'#39', data: null, sortable: false' +
        ', render: function (obj) {'
      
        #9#9#9#9'      return '#39'<button type="button" class="btn btn-warning b' +
        'tn-xs" onclick="myActionE('#39'+ obj.EMP_NO +'#39')"><i class="far fa-ed' +
        'it"></i></button> '#39' +'
      
        '                                '#39'<button type="button" class="bt' +
        'n btn-danger btn-xs" onclick="myActionD(\'#39#39' + obj.EMP_NO + '#39'\'#39',\' +
        #39#39' + obj.FIRST_NAME + '#39' '#39' + obj.LAST_NAME + '#39'\'#39')"><i class="far ' +
        'fa-trash-alt"></i></button>'#39'; }}'
      '                              ],'
      '                 columnDefs: ['
      
        '                     {"className": "text-center", "width": "20px' +
        '", "targets": 0 },'
      '                     {"width": "100px", "targets": 1 },'
      '                     {"width": "100px", "targets": 2 },'
      
        '                     {"className": "text-center", "width": "30px' +
        '", "targets": 3},'
      '                     {"width": "70px", "targets": 4 },'
      
        '                     {"className": "text-center", "width": "70px' +
        '", "targets": 5 },'
      
        '                     {"className": "text-right", "width": "50px"' +
        ', "targets": 6 },'
      
        '                     {"className": "text-right", "width": "70px"' +
        ', "targets": 7 }'
      '                                       ],'
      
        '                 <!-- initComplete: function () {$( document ).o' +
        'n("click", "tr[role='#39'row'#39']", function(){myActionE($(this).childr' +
        'en('#39'td:first-child'#39').text())});} -->'
      '            });'
      ' console.log(datatable);'
      ' reloadDatatable(true);'
      '}'
      ''
      '$(document).ready(function () {'
      ' loaddatatable();'
      '});'
      ''
      'function MyHtml(htmlstring){'
      '   var ausername = getCookie("username");'
      '   var apassword = getCookie("password");'
      '   var aurl = '#39#39';'
      '   var mydt  = document.getElementById("employeesresut");'
      '   var divPessoa  = document.getElementById("dataFrame");'
      '   if(ausername != '#39#39' && apassword !='#39#39'){'
      '     aurl =  '#39'./index?dwmark:dwmyhtml&myhtml='#39' + htmlstring;'
      '    }'
      '   $.ajax('
      '                {'
      '                   type: "post",'
      '                   url: aurl,'
      '                   contentType: false,'
      
        '                   data: jQuery.param({username: getCookie("user' +
        'name"), password: getCookie("password")}),'
      
        '                   contentType: '#39'application/x-www-form-urlencod' +
        'ed; charset=UTF-8'#39','
      '                   success: function (data) {'
      
        '                             var mydt = document.getElementById(' +
        '"employeesresut");'
      
        '                             var mydiv = document.getElementById' +
        '("dataFrame");'
      '                             mydt.style.visibility="hidden";'
      
        '                             $('#39'#dataFrameContainer'#39').html(data)' +
        ';'
      '                             $('#39'#employeesresut'#39').hide();'
      '                             mydiv.style.visibility="visible";'
      '                             $('#39'#dataFrame'#39').slideDown("slow");'
      '                   },'
      '                   error: function(result) {'
      
        '                             swal("Aten'#231#227'o", "Erro na autentica'#231 +
        #227'o.", "warning");'
      '                   }'
      '                   });'
      '}'
      '</script>')
    IncludeScriptsHtmlTag = '{%incscripts%}'
    Items = <
      item
        ContextTag = 
          '<main role="main" class="col-md-9 ml-sm-auto col-lg-12 pt-3 px-4' +
          '">'#13#10'        <div class="d-flex justify-content-between flex-wrap' +
          ' flex-md-nowrap align-pessoas-center pb-2 mb-3 border-bottom">'#13#10 +
          '        </div>'#13#10'    </main>'#13#10'    <div class="col-xs-12 col-sm-12' +
          ' col-md-12 col-lg-12">'#13#10'        <div id="data-table_wrapper" cla' +
          'ss="dataTables_wrapper form-inline dt-bootstrap no-footer">'#13#10'   ' +
          '         <table id="my-table"  class="table-striped table-hover ' +
          'bordered display responsive nowrap" style="width:100%"></table>'#13 +
          #10'        </div>'#13#10'    </div>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'iddatatable'
        TagReplace = '{%datatable%}'
        ObjectName = 'datatable'
        OnRequestExecute = dwcrIndexItemsdatatableRequestExecute
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule2">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'cadmodal'
        TagReplace = '{%cadModal%}'
        ObjectName = 'cadModal'
        OnRequestExecute = dwcrIndexItemseditModalRequestExecute
        OnBeforeRendererContextItem = dwcrIndexItemscadModalBeforeRendererContextItem
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule3">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'editmodal'
        TagReplace = '{%editModal%}'
        ObjectName = 'editModal'
        OnRequestExecute = dwcrIndexItemseditModalRequestExecute
      end
      item
        ContextTag = 
          '<div class="modal fade bd-example-modal-lg" tabindex="-1"  id="m' +
          'odal_apagar" role="dialog" >'#13#10'    <div class="modal-dialog" role' +
          '="document">'#13#10'    <div class="modal-content">'#13#10'      <div class=' +
          '"modal-header">'#13#10'        <h5 class="modal-title" id="title">Apag' +
          'ar</h5>'#13#10'        <button type="button" class="close" data-dismis' +
          's="modal" aria-label="Close">'#13#10'          <span aria-hidden="true' +
          '">&times;</span>'#13#10'        </button>'#13#10'      </div>'#13#10'      <div cl' +
          'ass="modal-body">'#13#10#9#9'Voc'#234' deseja realmente deletar o empregado <' +
          'spam id="nome_empregado"></spam>'#9' '#13#10'      </div>'#13#10'      <div cla' +
          'ss="modal-footer">        '#13#10'        <button type="button" class=' +
          '"btn btn-success" id="ok">Ok</button>'#13#10#9#9'<button type="button" c' +
          'lass="btn btn-danger"  id="cancelar">Cancelar</button>'#13#10'      </' +
          'div>'#13#10'    </div>'#13#10'  </div>'#13#10'</div>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'deletemodal'
        TagReplace = '{%deleteModal%}'
        ObjectName = 'deleteModal'
        OnRequestExecute = dwcrIndexItemsdeleteModalRequestExecute
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule5">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'operation'
        TagReplace = '{%operation%}'
        ObjectName = 'operation'
        OnRequestExecute = dwcrIndexItemsoperationRequestExecute
      end
      item
        ContextTag = 
          '<select class="form-control" id="JOB_COUNTRY" name = "JOB_COUNTR' +
          'Y">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'dwcbPaises'
        TagReplace = '{%dwcbPaises%}'
        ObjectName = 'dwcbPaises'
        OnRequestExecute = dwcrIndexItemsdwcbPaisesRequestExecute
        OnBeforeRendererContextItem = dwcrIndexItemsdwcbPaisesBeforeRendererContextItem
      end
      item
        ContextTag = '<select class="form-control" id="JOB_GRADE" name = "JOB_GRADE">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'dwcbCargos'
        TagReplace = '{%dwcbCargos%}'
        ObjectName = 'dwcbCargos'
        OnRequestExecute = dwcrIndexItemsdwcbCargosRequestExecute
      end
      item
        ContextTag = '<li class="header">Menu</li>'#13#10#13#10
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'dwsidemenu'
        TagReplace = '{%dwsidemenu%}'
        ObjectName = 'dwsidemenu'
        OnBeforeRendererContextItem = dwcrIndexItemsdwsidemenuBeforeRendererContextItem
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule9">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'meuloginname'
        TagReplace = '{%meuloginname%}'
        ObjectName = 'meuloginname'
        OnBeforeRendererContextItem = dwcrIndexItemsmeuloginnameBeforeRendererContextItem
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule10">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'LabelMenu'
        TagReplace = '{%LabelMenu%}'
        ObjectName = 'LabelMenu'
        OnBeforeRendererContextItem = dwcrIndexItemsLabelMenuBeforeRendererContextItem
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule11">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'dwmyhtml'
        TagReplace = '{%dwmyhtml%}'
        ObjectName = 'dwmyhtml'
        OnRequestExecute = dwcrIndexItemsdwmyhtmlRequestExecute
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule12">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'dwframe'
        TagReplace = '{%dwframe%}'
        ObjectName = 'dwframe'
        OnBeforeRendererContextItem = dwcrIndexItemsdwframeBeforeRendererContextItem
      end>
    OnBeforeRenderer = dwcrIndexBeforeRenderer
    Left = 172
    Top = 105
  end
  object dwcrLogin: TDWContextRules
    ContentType = 'text/html'
    MasterHtml.Strings = (
      '')
    MasterHtmlTag = '$body'
    IncludeScripts.Strings = (
      '<script>'
      'function setCookie(cname,cvalue,exdays) {'
      ' var d = new Date();'
      ' d.setTime(d.getTime() + (exdays*24*60*60*1000));'
      ' var expires = "expires=" + d.toGMTString();'
      
        ' document.cookie = cname + "=" + cvalue + ";" + expires + ";path' +
        '=/";'
      '}'
      ''
      'function getCookie(cname) {'
      ' var name = cname + "=";'
      ' var decodedCookie = decodeURIComponent(document.cookie);'
      ' var ca = decodedCookie.split('#39';'#39');'
      ' for(var i = 0; i < ca.length; i++) {'
      '  var c = ca[i];'
      '  while (c.charAt(0) == '#39' '#39') {'
      '   c = c.substring(1);'
      '  }'
      '  if (c.indexOf(name) == 0) {'
      '   return c.substring(name.length, c.length);'
      '  }'
      ' }'
      ' return "";'
      '}'
      ''
      ''
      'function mylogin(){'
      '   var ausername = btoa($("#usr").val());  '
      '   var apassword = btoa($("#pwd").val());  '
      '   var aurl = '#39#39';'
      '   if(ausername != '#39#39' && apassword !='#39#39'){'
      '      aurl =  '#39'./index'#39';'
      '   setCookie("username", ausername, 1);'
      '   setCookie("password", apassword, 1);'
      '   $.ajax('
      '                {'
      '                    type: "post",'
      '                    url: aurl,'
      '                    contentType: false,                    '
      
        '                    data: jQuery.param({username: getCookie("use' +
        'rname"),'
      
        '                                                    password: ge' +
        'tCookie("password")}),'
      
        '                   contentType: '#39'application/x-www-form-urlencod' +
        'ed; charset=UTF-8'#39','
      '                   success: function (data) {'
      
        '                                                            docu' +
        'ment.open();'
      
        '                                                            docu' +
        'ment.write(data);'
      
        '                                                            docu' +
        'ment.close();'
      '                    },'
      '                    error: function(result) {'
      
        '                             swal("Aten'#231#227'o", "N'#227'o foi poss'#237'vel f' +
        'azer login...", "warning");'
      '                    }'
      #9#9#9#9' });'#9
      '    }else'
      '   {'
      
        '    swal("Aten'#231#227'o", "N'#227'o foi poss'#237'vel fazer login...", "warning"' +
        ');'
      '   }'
      '}'
      '$(document).ready(function(){'
      '   $("#usr").val(atob(getCookie("username")));'
      '   $("#pwd").val(atob(getCookie("password")));'
      '   $("#myModal").modal({backdrop: '#39'static'#39','
      
        '                                       keyboard: false  // to pr' +
        'event closing with Esc button (if you want this too)'
      '                                      });'
      '});'
      ''
      '</script>'
      '')
    IncludeScriptsHtmlTag = '{%incscripts%}'
    Items = <
      item
        ContextTag = 
          '<button onclick="mylogin()" class="btn btn-primary btn-lg btn-bl' +
          'ock login-btn">Login</button>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'login'
        TagReplace = '{%login%}'
        ObjectName = 'login'
      end
      item
        ContextTag = '<li class="header"></li>'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'LabelMenu'
        TagReplace = '{%LabelMenu%}'
        ObjectName = 'LabelMenu'
      end
      item
        ContextTag = '<input {%itemtag%} placeholder="dwcontextrule3">'
        TypeItem = 'text'
        ClassItem = 'form-control item'
        TagID = 'meuloginname'
        TagReplace = '{%meuloginname%}'
        ObjectName = 'meuloginname'
        OnBeforeRendererContextItem = dwcrLoginItemsmeuloginnameBeforeRendererContextItem
      end>
    OnBeforeRenderer = dwcrLoginBeforeRenderer
    Left = 176
    Top = 152
  end
end
