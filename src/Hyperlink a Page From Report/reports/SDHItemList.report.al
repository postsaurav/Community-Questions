report 50001 "SDH Item List"
{
    ApplicationArea = All;
    Caption = 'Item List';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    EnableHyperlinks = true;
    RDLCLayout = '.\src\Hyperlink a Page From Report\reports\SDHItemList.rdlc';
    dataset
    {
        dataitem(Item; Item)
        {
            column(No; "No.")
            {
            }
            column(No2; "No. 2")
            {
            }
            column(Inventory; Inventory)
            {
            }
            column(Description; Description)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(itemURL; itemURL) { }
            column(ItemLedgerEntryURL; ItemLedgerEntryURL) { }
            trigger OnAfterGetRecord()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                PageManagement: Codeunit "Page Management";
                DataTypeManagement: Codeunit "Data Type Management";
                ItemResultRecordRef: RecordRef;
                ItemLedgerResultRecordRef: RecordRef;
            begin
                DataTypeManagement.GetRecordRef(Item, ItemResultRecordRef);
                if not ItemResultRecordRef.HasFilter then
                    ItemResultRecordRef.SetRecFilter();
                itemURL := GetUrl(ClientType::Default, CompanyName, ObjectType::Page, PageManagement.GetPageID(ItemResultRecordRef), ItemResultRecordRef, true);

                ItemLedgerEntry.SetRange("Item No.", Item."No.");
                if ItemLedgerEntry.FindSet() then begin
                    DataTypeManagement.GetRecordRef(ItemLedgerEntry, ItemLedgerResultRecordRef);
                    if not ItemLedgerResultRecordRef.HasFilter then
                        ItemLedgerResultRecordRef.SetRecFilter();
                    ItemLedgerEntryURL := GetUrl(ClientType::Default, CompanyName, ObjectType::Page, PageManagement.GetPageID(ItemLedgerResultRecordRef), ItemLedgerResultRecordRef, true);
                end;
            end;
        }
    }

    var
        ItemURL: Text;
        ItemLedgerEntryURL: Text;
}
