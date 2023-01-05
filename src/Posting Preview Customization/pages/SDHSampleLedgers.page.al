page 50000 "SDH Sample Ledgers"
{
    ApplicationArea = All;
    Caption = 'Sample Ledgers';
    PageType = List;
    Editable = false;
    SourceTable = "SDH Sample Ledger";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Qty. To Invoice"; Rec."Qty. To Invoice")
                {
                    ToolTip = 'Specifies the value of the Qty. To Invoice field.';
                }
                field("Qty. To Ship"; Rec."Qty. To Ship")
                {
                    ToolTip = 'Specifies the value of the Qty. To Ship field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
            }
        }
    }
}
