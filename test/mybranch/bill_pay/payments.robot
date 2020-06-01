*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Test Cases ***
BillPay - Make Payment
    [Documentation]    Bill Pay.
    [Tags]    qa_suite    new_test    incomplete
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_BillPay
    Register Window
    Pause Testing
    ${bill pay account} =    Get BillPay Account    name=Test Payee
    ...                                             account=1002003
    ...                                             addr1=921 Misty Water Ln
    ...                                             city=San Antonio
    ...                                             state=TX
    ...                                             zip1=78251
    ...                                             zip2=4466
    Make Bill Pay Payment    ${bill pay account}    5.00
    Exists    MakePayments_PaymentConfirmation
    Capture Page Screenshot
    Click Link    Test Payee, *2003
    Click On    MakePayments_PayeeDetails
    Click On    MakePayments_DeletePayee
    Click On    DeletePayee_DeletePayee
    Expect Text RegEx    DeletePayee_Confirmation    .*successfully.*
    Close Window
    Unregister Window
    [Teardown]    Log Out myBranch
