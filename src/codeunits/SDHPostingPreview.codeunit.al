codeunit 50001 "SDH Posting Preview"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"SDH Sample Ledger", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertSDHSampleLedger(var Rec: Record "SDH Sample Ledger")
    begin
        if Rec.IsTemporary() then
            exit;

        PostingPreviewEventHandler.PreventCommit();
        TempSampleLedger := Rec;
        TempSampleLedger."Document No." := '***';
        TempSampleLedger.Insert();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', false, false)]
    local procedure FillDocumentEntrySampleLedger(var DocumentEntry: Record "Document Entry")
    begin
        PostingPreviewEventHandler.InsertDocumentEntry(TempSampleLedger, DocumentEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterShowEntries', '', false, false)]
    local procedure ShowEntriesSampleLedger(TableNo: Integer)
    begin
        if TableNo = Database::"SDH Sample Ledger" then
            Page.Run(page::"SDH Sample Ledgers", TempSampleLedger);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnBeforeRunPreview', '', false, false)]
    local procedure CleanupTemp()
    begin
        ClearTempVariables();
    end;

    local procedure ClearTempVariables()
    begin
        TempSampleLedger.DeleteAll();
    end;

    var
        TempSampleLedger: Record "SDH Sample Ledger" temporary;
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
}
