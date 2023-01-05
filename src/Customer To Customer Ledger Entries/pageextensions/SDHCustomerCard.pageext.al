pageextension 50000 "SDH Customer Card" extends "Customer Card"
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
