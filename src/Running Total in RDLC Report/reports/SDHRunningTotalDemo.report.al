report 50002 "SDH Running Total Demo"
{
    ApplicationArea = All;
    Caption = 'Running Total Demo';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = FirstLayout;
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.";
            column(GLAccountName; "G/L Account Name")
            {
            }
            column(GLAccountNo; "G/L Account No.")
            {
            }
            column(Description; Description)
            {
            }
            column(GenBusPostingGroup; "Gen. Bus. Posting Group")
            {
            }
            column(Amount; Amount)
            {
            }
        }
    }
    rendering
    {
        layout(FirstLayout)
        {
            Type = RDLC;
            LayoutFile = '.\src\Running Total in RDLC Report\reports\SDHRunningTotalDemo.rdlc';
        }
    }
}
