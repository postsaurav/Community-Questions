pageextension 50001 "SDH Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("SDH Demo Description"; Rec."SDH Demo Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SDH Demo Description field.';
            }
        }
    }
}
