unit frxGlyphSubstitutionClass;

interface

{$I frx.inc}

uses TTFHelpers, frxTrueTypeTable;

    type // Nested Types
        FeatureRecord = packed record
            Feature: Word;
            FeatureTag: Cardinal;
        end;

        GSUB_Header = record
            Version: Cardinal;
            ScriptList: Word;
            FeatureList: Word;
            LookupList: Word;
        end;

        LangSysRecord = packed record
            LangSysTag: Cardinal;
            LangSys: Word;
        end;

        LangSysTable = packed record
            LookupOrder: Word;
            ReqFeatureIndex: Word;
            FeatureCount: Word;
        end;

        ScriptListRecord = packed record
            ScriptTag: Cardinal;
            ScriptOffset: Word;
        end;

        ScriptListTable = packed record
            CountScripts: Word;
        end;

        ScriptTable = packed record
            DefaultLangSys: Word;
            LangSysCount: Word;
        end;


    GlyphSubstitutionClass = class(TrueTypeTable)
      // Fields
//      strict private gsub_ptr: Pointer;
      private header: GSUB_Header;

      // Methods
      public constructor Create(src: TrueTypeTable);
      private procedure ChangeEndian;
      public procedure Load(font: Pointer); override;
//      strict private procedure LoadFeatureList(feature_idx: Cardinal);
//      strict private procedure LoadScriptList;
      public function Save(font: Pointer; offset: Cardinal): Cardinal; override;
    end;

implementation

    constructor GlyphSubstitutionClass.Create(src: TrueTypeTable);
    begin
      inherited Create(src);
    end;

    procedure GlyphSubstitutionClass.ChangeEndian;
    begin
        self.header.Version := TTF_Helpers.SwapUInt32(self.header.Version);
        self.header.ScriptList := TTF_Helpers.SwapUInt16(self.header.ScriptList);
        self.header.LookupList := TTF_Helpers.SwapUInt16(self.header.LookupList);
        self.header.FeatureList := TTF_Helpers.SwapUInt16(self.header.FeatureList)
    end;

    procedure GlyphSubstitutionClass.Load(font: Pointer);
    var
      gsub: ^GSUB_Header;
    begin
        gsub := TTF_Helpers.Increment(font, self.entry.offset);
        self.header.FeatureList :=  gsub.FeatureList;
        self.header.LookupList := gsub.LookupList;
        self.header.ScriptList := gsub.ScriptList;
        self.header.Version := gsub.Version;
        self.ChangeEndian
    end;

    {
    procedure GlyphSubstitutionClass.LoadFeatureList(feature_idx: Cardinal);
    var
      feature_list_table_ptr:   Pointer;
      feature_count:  Word;
    begin
        feature_list_table_ptr := TTF_Helpers.Increment(self.gsub_ptr, self.header.FeatureList);
        feature_count := TTF_Helpers.SwapUInt16((Marshal.PtrToStructure(feature_list_table_ptr, typeof(Word)) as Word));
        if (feature_idx >= feature_count) then
            raise Exception.Create('Feature index out of bound');
        feature_record := (Marshal.PtrToStructure(TTF_Helpers.Increment(feature_list_table_ptr, (2 + ((feature_idx * 6) as Integer))), typeof(FeatureRecord)) as FeatureRecord);
        FeatureTag := string.Concat(New(array[5] of TObject, ( ( '', (($ff and feature_record.FeatureTag) as Char), (($ff and (feature_record.FeatureTag shr 8)) as Char), (($ff and (feature_record.FeatureTag shr $10)) as Char), (($ff and (feature_record.FeatureTag shr $18)) as Char) ) )))
    end;

    procedure GlyphSubstitutionClass.LoadScriptList;
    var
        lang_sys_rec_ptr: IntPtr;
    begin
        script_list_table_ptr := TTF_Helpers.Increment(self.gsub_ptr, self.header.ScriptList);
        script_list_table := (Marshal.PtrToStructure(script_list_table_ptr, typeof(ScriptListTable)) as ScriptListTable);
        script_list_table.CountScripts := TTF_Helpers.SwapUInt16(script_list_table.CountScripts);
        script_record_ptr := TTF_Helpers.Increment(script_list_table_ptr, Marshal.SizeOf(script_list_table));
        i := 0;
        while ((i < script_list_table.CountScripts)) do
        begin
            script_record := (Marshal.PtrToStructure(script_record_ptr, typeof(ScriptListRecord)) as ScriptListRecord);
            script_record.ScriptOffset := TTF_Helpers.SwapUInt16(script_record.ScriptOffset);
            ScriptTag := string.Concat(New(array[5] of TObject, ( ( '', (($ff and script_record.ScriptTag) as Char), (($ff and (script_record.ScriptTag shr 8)) as Char), (($ff and (script_record.ScriptTag shr $10)) as Char), (($ff and (script_record.ScriptTag shr $18)) as Char) ) )));
            script_table_ptr := TTF_Helpers.Increment(script_list_table_ptr, script_record.ScriptOffset);
            script_table := (Marshal.PtrToStructure(script_table_ptr, typeof(ScriptTable)) as ScriptTable);
            script_table.DefaultLangSys := TTF_Helpers.SwapUInt16(script_table.DefaultLangSys);
            script_table.LangSysCount := TTF_Helpers.SwapUInt16(script_table.LangSysCount);
            if (script_table.DefaultLangSys <> 0) then
            begin
                lang_sys_rec_ptr := TTF_Helpers.Increment(script_table_ptr, script_table.DefaultLangSys);
                lang_sys_table := (Marshal.PtrToStructure(lang_sys_rec_ptr, typeof(LangSysTable)) as LangSysTable);
                lang_sys_table.LookupOrder := TTF_Helpers.SwapUInt16(lang_sys_table.LookupOrder);
                lang_sys_table.ReqFeatureIndex := TTF_Helpers.SwapUInt16(lang_sys_table.ReqFeatureIndex);
                lang_sys_table.FeatureCount := TTF_Helpers.SwapUInt16(lang_sys_table.FeatureCount);
                feature_index_ptr := TTF_Helpers.Increment(lang_sys_rec_ptr, Marshal.SizeOf(lang_sys_table));
                k := 0;
                while ((k < lang_sys_table.FeatureCount)) do
                begin
                    feature_idx := TTF_Helpers.SwapUInt16((Marshal.PtrToStructure(feature_index_ptr, typeof(Word)) as Word));
                    self.LoadFeatureList(feature_idx);
                    feature_index_ptr := TTF_Helpers.Increment(feature_index_ptr, 2);
                    inc(k)
                end
            end;
            lang_sys_rec_ptr := TTF_Helpers.Increment(script_table_ptr, Marshal.SizeOf(script_table));
            j := 0;
            while ((j < script_table.LangSysCount)) do
            begin
                lang_sys_rec := (Marshal.PtrToStructure(lang_sys_rec_ptr, typeof(LangSysRecord)) as LangSysRecord);
                lang_sys_rec.LangSys := TTF_Helpers.SwapUInt16(lang_sys_rec.LangSys);
                LangSysTag := string.Concat(New(array[5] of TObject, ( ( '', (($ff and lang_sys_rec.LangSysTag) as Char), (($ff and (lang_sys_rec.LangSysTag shr 8)) as Char), (($ff and (lang_sys_rec.LangSysTag shr $10)) as Char), (($ff and (lang_sys_rec.LangSysTag shr $18)) as Char) ) )));
                lang_sys_rec_ptr := TTF_Helpers.Increment(lang_sys_rec_ptr, Marshal.SizeOf(lang_sys_rec));
                inc(j)
            end;
            script_record_ptr := TTF_Helpers.Increment(script_record_ptr, Marshal.SizeOf(script_record));
            inc(i)
        end
    end;
}
    function GlyphSubstitutionClass.Save(font: Pointer; offset: Cardinal): Cardinal;
    begin
        Result := inherited Save(font, offset)
    end;
end.
