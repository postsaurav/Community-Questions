pageextension 50008 "SDH Purchase Order Subform" extends "Purchase Order Subform"
{
    actions
    {
        addlast("&Line")
        {
            action(GetDimValues)
            {
                ApplicationArea = All;
                Image = Dimensions;
                Caption = 'Get Dimension Values';
                ToolTip = 'Executes the Get Dimension Values action.';
                trigger OnAction()
                var
                    GetshortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
                    ShortcutDimCode: array[8] of Code[20];
                    i: Integer;
                begin
                    GetGLSetup();
                    GetshortcutDimensionValues.GetShortcutDimensions(Rec."Dimension Set ID", ShortcutDimCode);
                    for I := 1 to 8 do
                        if ShortcutDimCode[i] <> '' then
                            Message('Dimension %1, Value %2', GLSetupShortcutDimCode[i], ShortcutDimCode[i]);
                end;
            }
        }
    }

    local procedure GetGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
        GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
        GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
        GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
        GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
        GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
        GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
        GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
    end;

    var
        GLSetupShortcutDimCode: array[8] of Code[20];
}