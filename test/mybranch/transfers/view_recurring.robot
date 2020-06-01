*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***
    

*** Test Cases ***

Recurring Transfer - ViewVerify - Checking
    [Documentation]    UFT test case: ' Transfers - View Delete Recurring Transfers - Manage Transfers Payments - View Transfer for Checking'
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    [Tags]    qa_suite    uat2_suite    view_recurring
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    Assert Page Contains    Manage Scheduled Transfers/Payments
    ${row} =     Find Scheduled Transfer    01/26/2007    ${fromaccount_namenumber}    ${toaccount_namenumber}    Monthly    3rd    $300.00    Until I Cancel
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

Recurring Transfer - ViewVerify - Savings
    [Documentation]    UFT test case: ' Transfers - View Delete Recurring Transfers - Manage Transfers Payments - View Transfer for Savings'
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    [Tags]    qa_suite    view_recurring

    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    Assert Page Contains    Manage Scheduled Transfers/Payments
    ${row} =     Find Scheduled Transfer    09/12/2016    ${fromaccount_namenumber}    ${toaccount_namenumber}    Bi-Weekly    Monday    $1.00    Until I Cancel
    Capture Page Screenshot

    [Teardown]    Log Out myBranch
