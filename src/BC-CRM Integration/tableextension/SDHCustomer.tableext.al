tableextension 50000 "SDH Customer" extends Customer
{
    fields
    {
        field(50001; "SDH Facebook URL"; Text[300]) // Used for BC Crm Sync Scenario
        {
            Caption = 'Facebook URL';
            DataClassification = CustomerContent;
        }
        field(50002; "SDH Twitter URL"; Text[300]) // Used for BC Crm Sync Scenario
        {
            Caption = 'Twitter URL';
            DataClassification = CustomerContent;
        }
    }
}
