page 50003 "SDH Prompt Dialog"
{
    PageType = PromptDialog;
    Extensible = false;
    PromptMode = Prompt;
    Caption = 'Prompt Dialog';
    ApplicationArea = all;
    SourceTable = Customer;
    SourceTableTemporary = true;
    IsPreview = true;
    DataCaptionExpression = UserPrompt;

    layout
    {
        area(Prompt)
        {
            field(UserPrompt; UserPrompt)
            {
                ApplicationArea = All;
                Caption = 'Input your prompt here';
                MultiLine = true;
                ShowCaption = false;
                ToolTip = 'Specifies the value of the Input your prompt here field.';
            }
        }
        area(Content)
        {
            group(Reply)
            {
                field(CopilotReply; CopilotReply)
                {
                    ApplicationArea = All;
                    Caption = 'Copilot Reply';
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the value of the Copilot Reply field.';
                }
            }
        }
        area(PromptOptions)
        {
            field(myoptions; myoptions)
            {
                ApplicationArea = All;
                Caption = 'Options';
                OptionCaption = 'A,B,C,D';
                ToolTip = 'Specifies the value of the Options field.';
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Generates the Copilot Reply';
                trigger OnAction()
                begin
                    CopilotReply := 'Hi from OpenAI';
                end;
            }
            systemaction(Ok)
            {
                Caption = 'Confirm';
                ToolTip = 'Confirms the Copilot Reply';
            }
            systemaction(Cancel)
            {
                ToolTip = 'Cancels the Copilot Reply';
                Caption = 'Delete';
            }
            systemaction(Regenerate)
            {
                Caption = 'Re Generate';
                ToolTip = 'Re Generates the Copilot Reply';
                trigger OnAction()
                begin
                    CopilotReply := 'Hi from OpenAI, Regenerated.';
                end;
            }
            systemaction(Attach)
            {
                Caption = 'Setup';
                ToolTip = 'Setup the Copilot Reply';
                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::OK then
            Message('Thankyou OpenAI');
        if CloseAction = CloseAction::Cancel then
            Message('Cancelled OpenAI');
    end;

    var
        UserPrompt, CopilotReply : Text;
        myoptions: Option A,B,C,D;
}