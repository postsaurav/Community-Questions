codeunit 50007 "SDH Email Subject Body"
{
    procedure GeneratePurchaseOrderEmailSubject(PurchaseHeader: Record "Purchase Header"): Text[250]
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                exit('Order Confirmation ' + PurchaseHeader."No.");
        end;
    end;

    procedure GeneratePurchaseOrderEmailBody(PurchaseHeader: Record "Purchase Header"): Text
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                exit('Dear ' + PurchaseHeader."Buy-from Vendor Name" + ',' +
                     'Please find attached the order confirmation for ' + PurchaseHeader."No." +
                     'We will expect you to process it as soon as possible.' +
                     'Kind regards,' +
                     CompanyInformation.Name + ' ' + CompanyInformation.Address + ' ' + CompanyInformation.City + ' ' +
                     CompanyInformation."Post Code" + ' ' + CompanyInformation."Country/Region Code" + ' ' +
                     CompanyInformation."Phone No." + ' ' + CompanyInformation."E-Mail");
        end;
    end;

    procedure GeneratePurchaseOrderHtmlEmailBody(PurchaseHeader: Record "Purchase Header") EmailBody: Text
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    AddEmailHeaderLines(PurchaseHeader, EmailBody);
                    AddEmailFooterLines(EmailBody);
                end;
        end;
    end;

    procedure GeneratePurchaseOrderDetailedHtmlEmailBody(PurchaseHeader: Record "Purchase Header") EmailBody: Text
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    AddEmailHeaderLines(PurchaseHeader, EmailBody);
                    AddEmailBodyLines(PurchaseHeader, EmailBody);
                    AddEmailFooterLines(EmailBody);
                end;
        end;
    end;

    local procedure AddEmailHeaderLines(PurchaseHeader: Record "Purchase Header"; var EmailBody: Text)
    begin
        EmailBody := 'Dear <b>' + PurchaseHeader."Buy-from Vendor Name" + '</b>,</br></br>' +
                     'Please find attached the order confirmation for ' + PurchaseHeader."No." + '</br></br>' +
                     'We will expect you to process it as soon as possible.' + '</br></br></br>';
    end;

    local procedure AddEmailBodyLines(PurchaseHeader: Record "Purchase Header"; var EmailBody: Text)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then begin
            EmailBody := EmailBody + '<table border="1">';
            EmailBody := EmailBody + '<tr>';
            EmailBody := EmailBody + '<th>Item No</th>';
            EmailBody := EmailBody + '<th>Description</th>';
            EmailBody := EmailBody + '<th>Quantity</th>';
            EmailBody := EmailBody + '<th>Qty. To Receive</th>';
            EmailBody := EmailBody + '</tr>';
            repeat
                EmailBody := EmailBody + '<tr>';
                EmailBody := EmailBody + '<td>' + PurchaseLine."No." + '</td>';
                EmailBody := EmailBody + '<td>' + PurchaseLine.Description + '</td>';
                EmailBody := EmailBody + '<td>' + Format(PurchaseLine.Quantity) + '</td>';
                EmailBody := EmailBody + '<td>' + Format(PurchaseLine."Qty. to Receive") + '</td>';
                EmailBody := EmailBody + '</tr>';
            until (PurchaseLine.Next() = 0);
            EmailBody := EmailBody + '</table>';
            EmailBody := EmailBody + '</br></br>';
        end;
    end;

    local procedure AddEmailFooterLines(var EmailBody: Text)
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        EmailBody := EmailBody +
         'Kind regards,' +
         '<b></br>' + CompanyInformation.Name + '</b></br>' + CompanyInformation.Address + '</br>' +
         CompanyInformation.City + '</br>' + CompanyInformation."Post Code" + '</br>' +
         CompanyInformation."Country/Region Code" + '</br>' + CompanyInformation."Phone No." + '</br>' +
         CompanyInformation."E-Mail";
    end;
}