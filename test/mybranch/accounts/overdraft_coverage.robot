*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***
    

*** Test Cases ***
Overdraft Coverage - Opt In
    [Documentation]    Opt In to overdraft coverage.
    [Tags]    qa_suite    accounts
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Overdraft Coverage Navigation

    ${row} =    Find Table Row With Text In Column    ${account}    Overdraft_Table    col_name=Account
    ${group_id} =    Evaluate    ${row} - ${1}
    Set Overdraft Option    ${row}    Opt-out
    Expect Text In Table Cell    Overdraft_Table    ${row}    6    You are opted-out
    ${group} =    Catenate    SEPARATOR=    AccountList[    ${group_id}    ].DebitATMODProtection
    Select Radio Option    ${group}    True
    Click On    OverDraftCoverage_Next
    Click On    OverDraftCoverage_Submit
    Exists  OverDraftCoverage_Confirmation
    Page Should Contain    ATM/Debit Card Overdraft Coverage - Confirmation
    Page Should Contain    ${account}
    Page Should Contain    Opt-in
    Capture Page Screenshot
    [Teardown]    Log Out myBranch
    
Overdraft Coverage - Opt Out
    [Documentation]    Opt Out to overdraft coverage.
    [Tags]    qa_suite    accounts    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Overdraft Coverage Navigation

    ${row} =    Find Table Row With Text In Column    ${account_namenumber}    Overdraft_Table    col_name=Account
    ${group_id} =    Evaluate    ${row} - ${1}
    Set Overdraft Option    ${row}    Opt-in
    Expect Text In Table Cell    Overdraft_Table    ${row}    6    You are opted-in
    ${group} =    Catenate    SEPARATOR=    AccountList[    ${group_id}    ].DebitATMODProtection
    Select Radio Option    ${group}    False
    Click On    OverDraftCoverage_Next
    Click On    OverDraftCoverage_Submit
    Exists  OverDraftCoverage_Confirmation
    Page Should Contain    ATM/Debit Card Overdraft Coverage - Confirmation
    Page Should Contain    ${account_namenumber}
    Page Should Contain    Opt-out
    Capture Page Screenshot
    [Teardown]    Log Out myBranch
