tableextension 50002 "SDH Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "SDH Demo Description"; Text[250])
        {
            Caption = 'SDH Demo Description';
            DataClassification = CustomerContent;
        }
    }
}