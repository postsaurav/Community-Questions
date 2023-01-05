tableextension 50001 "SDH Sales Header" extends "Sales Header"
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