codeunit 50002 "SDH Sales Posting"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure CopyCustomFields(SellToCustomer: Record Customer; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."SDH Demo Description" := SellToCustomer."SDH Demo Description";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure CopyFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."SDH Demo Description" := SalesHeader."SDH Demo Description";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure CopyFromJournalToLedger(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."SDH Demo Description" := GenJournalLine."SDH Demo Description";
    end;
}