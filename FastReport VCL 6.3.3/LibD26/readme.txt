FD components for FastReport 4.0

Created by: Serega Glazyrin
E-mail: glserega@mezonplus.ru

Extended by: Francisco Armando Duenas Rodriguez 
E-mail: fduenas@gmxsoftware.com

Install
=======

Open frxFDN.dpk, where N corresponds to your Delphi version and compile it.
Open dclfrxFDN.dpk, compile and install it.

Note from Francisco Armando Duenas Rodriguez
============================================
http://www.da-soft.com/forums/anydac-general-english/anydac-connector-for-fast-report-improved-and-submitted-to-support-team.html

From what I have experienced developing these components, the interface for 
the conection is quite inconsistent, especially with the wizards to create 
connections, tables, and queries since it only has 2 fields, The driver (ADO, 
DBX, Zeos, FireDAC, etc) and a databasename which by default is an ADO connexion 
or a file, which for most engines, is not enough. As a matter of fact, of 
the diferent engines I tried, only the ADO Engine works.

 
I was able to make it work with the wizard but I had to make a small change 
in the "frxConnWizard.pas" (Fast report sources) since there seems to be a 
bug and have never been fixed. In this unit, I had to add the line:

  FItemIndex := ConnCB.ItemIndex + 1;

after the line:

  FDatabase := TfrxCustomDatabase(ClassRef.NewInstance);

inside the  procedure TfrxConnectionWizardForm.ConnCBClick(Sender: TObject);

If you have problems with the wizard and you have the source, you may want 
to make this change.

Getting started
===============
To get started with usage FireDAC FR plug-in:
1)  after installing the plugin open Example project
2)  set up FDConnection1 component to connect to your database
3)  ensure FDConnection1 is selected as DefaultDatabase in frxFDComponents1
4)  right click frxReport1 component at design-time and click Edit report... to open the component editor
5)  after the editor is opened select Data page among Code, Data, Page1 ones 
6)  the left most palette allows you to create data components: FD Database, FD Table, FD Query, FD StoredProc 
    that match corresponding FireDAC components: TFDConnection, TFDTable, TFDQuery, TFDStoredProc 
7)  if you want to select data from a table you can choose FD Table or FD Query components
8)  click the chosen one on the palette and then click on the data area next to Report Tree 
9)  after that you’ll be able to set up all the required component properties in the Object Inspector (next to the palette) 
    similarly to how you would do that in Delphi
10) then you’ll be able to work with the data component and its fields: all the data components get available in the Data Tree