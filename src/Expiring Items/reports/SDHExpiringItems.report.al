report 50003 "SDH Expiring Items"
{
    ApplicationArea = All;
    Caption = 'Expiring Items';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.\src\Expiring Items\reports\SDHExpiringItems.rdlc';
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.") order(ascending) where(Open = const(true));
            RequestFilterFields = "Item No.";
            column(ItemNo; "Item No.")
            {
            }
            column(ExpirationDate; "Expiration Date")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(RemainingQuantity; "Remaining Quantity")
            {
            }
            column(LotNo; "Lot No.")
            {
            }
            column(TillExpirationDate; TillExpirationDate) { }
            trigger OnPreDataItem()
            begin
                if TillExpirationDate <> 0D then
                    ItemLedgerEntry.SetFilter("Expiration Date", '%1..%2', WorkDate(), TillExpirationDate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Filters)
                {
                    field(ExpiringTill; TillExpirationDateFormula)
                    {
                        ApplicationArea = All;
                        Caption = 'Expiring In';
                        ToolTip = 'Specifies the value of the TillExpirationDateFormula field.';
                    }
                }
            }
        }
    }
    labels
    {
        ExpiringInLbl = 'Expiring In..';
    }
    procedure SetParameters(NewDateForumla: DateFormula)
    begin
        TillExpirationDateFormula := NewDateForumla;
    end;

    trigger OnPreReport()
    var
        EmptyDateForumla: DateFormula;
    begin
        if TillExpirationDateFormula <> EmptyDateForumla then
            TillExpirationDate := CalcDate(TillExpirationDateFormula, WorkDate());
    end;

    var
        TillExpirationDateFormula: DateFormula;
        TillExpirationDate: Date;
}
