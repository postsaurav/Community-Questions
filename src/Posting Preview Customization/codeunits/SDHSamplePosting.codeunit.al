codeunit 50000 "SDH Sample Posting"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterTestSalesLine', '', false, false)]
    local procedure SDHCustomLedger(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line";PreviewMode: Boolean)
    var
        SampleLedger: Record "SDH Sample Ledger";
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
    begin
        if SalesLine.Type <> SalesLine.Type::Item then
            exit;
            
        if PreviewMode then
            PostingPreviewEventHandler.PreventCommit();

        SampleLedger.Init();
        SampleLedger."Customer No." := SalesHeader."Sell-to Customer No.";
        SampleLedger."Item No." := SalesLine."No.";
        SampleLedger."Document No." := SalesHeader."No.";
        SampleLedger."Qty. To Invoice" := SalesLine."Qty. to Invoice";
        SampleLedger."Qty. To Ship" := SalesLine."Qty. to Ship";
        SampleLedger.Insert(true);
    end;
}
