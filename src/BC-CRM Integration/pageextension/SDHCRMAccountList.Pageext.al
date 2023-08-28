pageextension 50007 "SDH CRM Account List" extends "CRM Account List"
{
    layout
    {
        addlast(Control2)
        {
            field("SDH Facebook"; Rec."SDH Facebook")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Facebook field.';
            }
            field("SDH Twitter"; Rec."SDH Twitter")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Twitter field.';
            }
        }
    }
}
