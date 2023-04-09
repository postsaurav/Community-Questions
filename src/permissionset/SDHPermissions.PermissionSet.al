permissionset 50000 "SDH Permissions"
{
    Assignable = true;
    Caption = 'Custom Permission', MaxLength = 30;
    Permissions = table "SDH Sample Ledger" = X,
        tabledata "SDH Sample Ledger" = RMID,
        codeunit "SDH Sample Posting" = X,
        codeunit "SDH Posting Preview" = X,
        page "SDH Sample Ledgers" = X,
        report "SDH Group By Demo" = X,
        report "SDH Item List" = X,
        report "SDH Running Total Demo" = X,
        codeunit "SDH Sales Posting" = X,
        page "SDH Azure Function Call" = X,
        report "SDH Expiring Items" = X,
        codeunit "SDH Customize Email Subject" = X,
        codeunit "SDH Email Expiring Items" = X,
        codeunit "SDH Export Json" = X;
}