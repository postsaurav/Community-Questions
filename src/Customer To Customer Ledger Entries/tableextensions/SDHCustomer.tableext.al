tableextension 50000 "SDH Customer" extends Customer
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
