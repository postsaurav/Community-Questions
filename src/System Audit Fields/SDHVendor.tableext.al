tableextension 50004 "SDH Vendor" extends Vendor
{
    fields
    {
        field(50000; "SDH Created By"; Code[50])
        {
            Caption = 'Created By';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
        }
        field(50001; "SDH Modified By"; Code[50])
        {
            Caption = 'Modified By';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemModifiedBy)));
        }
    }
}
