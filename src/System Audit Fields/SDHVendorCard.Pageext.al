pageextension 50004 "SDH Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(content)
        {
            group(SystemAudit)
            {
                Caption = 'System Audit';
                field("SDH Created By"; Rec."SDH Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SDH Created By field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field("SDH Modified By"; Rec."SDH Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SDH Modified By field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
            }
        }
    }
}
