report 50000 "SDH Group By Demo"
{
    ApplicationArea = All;
    Caption = 'Group By Demo';
    RDLCLayout = '.\src\Generic Grouping - Report\reports\SDHGroupByDemo.Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(GroupByFieldNo; GroupByFieldNo) { }
            column(ItemNo; "Item No.")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(SourceType; "Source Type")
            {
            }
            column(Description_ItemLedgerEntry; Description)
            {
            }
            column(DocumentNo_ItemLedgerEntry; "Document No.")
            {
            }
            column(PostingDate_ItemLedgerEntry; "Posting Date")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(GroupBy; FieldRecord."No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Group By';
                        ToolTip = 'Specifies the value of the Group By field.';
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            FieldRecord.SetRange(TableNo, Database::"Item Ledger Entry");
                            if Page.RunModal(Page::"Fields Lookup", FieldRecord) = Action::LookupOK then
                                GroupByFieldNo := FieldRecord."No.";
                        end;
                    }
                }
            }
        }
    }
    var
        FieldRecord: Record Field;
        GroupByFieldNo: Integer;
}
