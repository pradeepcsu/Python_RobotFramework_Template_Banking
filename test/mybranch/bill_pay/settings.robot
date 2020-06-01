*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../mybranch_keywords.robot

*** Test Cases ***
BillPay - Change Email
    [Documentation]    Bill Pay.
    [Tags]    qa_suite    new_test    incomplete
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_BillPay
    Open TSSO
    Query Member Host    ${cis}
    ${host email} =    Get Email Address
    Expect Text    BillPay_CurrentEmail    ${host email}
    Click On    ChangeEmail
    ${new email} =    Get Random Email
    Enter Text    BillPay_ChangeEmailAddress_NewEmailAddress    ${new email}
    Enter Text    BillPay_ChangeEmailAddress_ConfirmEmailAddress    ${new email}
    Click On    BillPay_SaveNewEmail
    Exists    BillPay_ChangeEmail_Success
    ${host email} =    Get Email Address
    Expect Text    BillPay_CurrentEmail    ${host email}
    [Teardown]    Log Out myBranch

BillPay - Cancel Change Email
    [Documentation]    Bill Pay.
    [Tags]    qa_suite    new_test    incomplete
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_BillPay
    Open TSSO
    Query Member Host    ${cis}
    ${host email} =    Get Email Address
    Expect Text    BillPay_CurrentEmail    ${host email}
    Click On    ChangeEmail
    ${new email} =    Get Random Email
    Enter Text    BillPay_ChangeEmailAddress_NewEmailAddress    ${new email}
    Enter Text    BillPay_ChangeEmailAddress_ConfirmEmailAddress    ${new email}
    Click On    Cancel_ChangeEmail_Button
    ${host email after} =    Get Email Address
    Should Be Equal    ${host email after}    ${host email}
    Expect Text    BillPay_CurrentEmail    ${host email}
    [Teardown]    Log Out myBranch
