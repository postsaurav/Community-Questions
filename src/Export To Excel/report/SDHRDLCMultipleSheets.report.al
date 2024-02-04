report 50005 "SDH RDLC Multiple Sheets"
{
    ApplicationArea = All;
    Caption = 'RDLC Multiple Sheets';
    DefaultLayout = RDLC;
    RDLCLayout = '.\src\Export To Excel\report\SDHRDLCMultipleSheets.rdlc';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_Customer; "No.")
            {
                IncludeCaption = true;
            }
            column(Name_Customer; Name)
            {
                IncludeCaption = true;
            }
            column(Name2_Customer; "Name 2")
            {
                IncludeCaption = true;
            }
            column(Balance_Customer; Balance)
            {
                IncludeCaption = true;
            }
        }
        dataitem(Vendor; Vendor)
        {
            column(No_Vendor; "No.")
            {
                IncludeCaption = true;
            }
            column(Name_Vendor; Name)
            {
                IncludeCaption = true;
            }
            column(Name2_Vendor; "Name 2")
            {
                IncludeCaption = true;
            }
            column(Balance_Vendor; Balance)
            {
                IncludeCaption = true;
            }
            column(BalanceDue_Vendor; "Balance Due")
            {
                IncludeCaption = true;
            }
        }
    }
}