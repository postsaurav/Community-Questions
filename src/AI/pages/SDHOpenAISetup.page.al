page 50004 "SDH Open AI Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Open AI Setup';
    PageType = Card;
    SourceTable = "SDH Open AI Setup";

    layout
    {
        area(content)
        {
            group(Authentication)
            {
                Caption = 'Authentication';

                field("Secret Key"; Rec."Secret Key")
                {
                    ToolTip = 'Specifies the value of the Secret Key field.';
                    ShowMandatory = true;
                    Caption = 'Secret Key';
                }
            }
            group(Models)
            {
                Caption = 'Models';
                field("Model (Legacy)"; Rec."Model (Legacy)")
                {
                    ToolTip = 'ID of the model(Legacy) to use.';
                    ShowMandatory = true;
                    Caption = 'Model (Legacy)';
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'ID of the model to use.';
                    ShowMandatory = true;
                    Caption = 'Model';
                }
            }
            group(Parameters)
            {
                Caption = 'Parameters';
                field("Max Tokens"; Rec."Max Tokens")
                {
                    ToolTip = 'The maximum number of tokens to generate in the completion.';
                    Caption = 'Max Tokens';
                }
                field(Temperature; Rec.Temperature)
                {
                    ToolTip = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.';
                    Caption = 'Temperature';
                }
                field("Top P"; Rec."Top P")
                {
                    ToolTip = 'An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.';
                    Caption = 'Top P';
                }
                field("Presence Penalty"; Rec."Presence Penalty")
                {
                    ToolTip = 'Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the models likelihood to talk about new topics.';
                    Caption = 'Presence Penalty';
                }
                field("Frequency Penalty"; Rec."Frequency Penalty")
                {
                    ToolTip = 'Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the models likelihood to repeat the same line verbatim.';
                    Caption = 'Frequency Penalty';
                }
                field("Best of"; Rec."Best of")
                {
                    ToolTip = 'Generates best_of completions server-side and returns the "best" (the one with the highest log probability per token). Results cannot be streamed.';
                    Caption = 'Best of';
                }
            }
            group(TestChatGPT)
            {
                Caption = 'Test Chat GPT';
                field(Input; Input)
                {
                    ToolTip = 'Specifies the value of the Input field.';
                    MultiLine = true;
                    Caption = 'Input';
                }
                field(ExecuteLbl; ExecuteOldLbl)
                {
                    ShowCaption = false;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        OpenAIMgmt: Codeunit "SDH Open AI Mgmt.";
                    begin
                        if Input <> '' then
                            OpenAIMgmt.GetResponseFromChatGPT(Input, false, Output);
                    end;
                }
                field(ExecuteNewLbl; ExecuteNewLbl)
                {
                    ShowCaption = false;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        OpenAIMgmt: Codeunit "SDH Open AI Mgmt.";
                    begin
                        if Input <> '' then
                            OpenAIMgmt.GetResponseFromChatGPT(Input, true, Output);
                    end;
                }
                field(Output; Output)
                {
                    ToolTip = 'Specifies the value of the Output field.';
                    Editable = false;
                    MultiLine = true;
                    Caption = 'Output';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    var
        Input, Output : Text;
        ExecuteOldLbl: Label 'Execute Old';
        ExecuteNewLbl: Label 'Execute New';
}