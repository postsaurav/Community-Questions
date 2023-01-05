pageextension 50002 "SDH Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SDH Demo Description"; Rec."SDH Demo Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SDH Demo Description field.';
            }
        }
    }
}
