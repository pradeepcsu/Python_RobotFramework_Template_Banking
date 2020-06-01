*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot

*** Test Cases ***
Account Summary - Display By Account Type
    [Documentation]    UFT test case: 'Account Summary - Group Accounts By Account Type'
    [Tags]    qa_suite    accounts
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Select Aria List Item    AccountSummary_DisplayBy    Account Type
    Verify Account Display    order=Account Type
    [Teardown]    Log Out myBranch

Account Summary - Display By Asset Or Liability
    [Documentation]    UFT test case: 'Account Summary - Group Accounts By Account Type'
    [Tags]    qa_suite    uat2_suite    accounts
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Select Aria List Item    AccountSummary_DisplayBy    Asset/Liability
    Verify Account Display    order=Asset/Liability
    [Teardown]    Log Out myBranch
