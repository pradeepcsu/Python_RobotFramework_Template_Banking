*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot
Force Tags        sit


*** Test Cases ***
Account Details - Max Characters in From Date
    [Documentation]    UFT test case: 'Accounts - AccountDetails - FromDate MaxCharacters'
    [Tags]    qa_suite    negative_test    sit
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    select kendo dropdown    AccountDetails_SelectAccount    ${account_namenumber}
    Enter Text    AccountDetails_fromDate    012120162017212
    Click On    AccountDetails_Filter
    Expect Text    AccountDetails_ErrorMessage    Please enter a valid date in mm/dd/yyyy format.
   [Teardown]    Log Out myBranch
   
Account Details - From Date has Invalid Format
    [Documentation]    UFT test case: ' AccountDetails - FromDate And InvalidDate'
    [Tags]    qa_suite    negative_test    sit
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    select kendo dropdown    AccountDetails_SelectAccount    ${account_namenumber}
    Enter Text    AccountDetails_fromDate    121780/34
    Click On    AccountDetails_Filter
    Expect Text    AccountDetails_ErrorMessage    Please enter a valid date in mm/dd/yyyy format.
    [Teardown]    Log Out myBranch
    
Account Details - From Date is Future Date
    [Documentation]    UFT test case: 'Accounts - AccountDetails - FromDate And FutureDate'
    [Tags]    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    select kendo dropdown    AccountDetails_SelectAccount    ${account_namenumber}
    Enter Text    AccountDetails_fromDate    01/21/2017
    Click On    AccountDetails_Filter
    Expect Text    AccountDetails_ErrorMessage    From Date cannot be a future date.
    [Teardown]    Log Out myBranch
    
Account Details - Verify Date Range Should Not Be Empty- Negative Test
    [Documentation]    UFT test case: 'Accounts - Account Details - Verify Date Range Should Not Be Empty- Negative Test'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    select kendo dropdown    AccountDetails_SelectAccount    ${account_namenumber}
    Enter Text    AccountDetails_fromDate    01/21/2017
    Click On    AccountDetails_Filter
    Expect Text    AccountDetails_ErrorMessage    From Date cannot be a future date.
    [Teardown]    Log Out myBranch      
        
Account Details - Verify Date Range - To Date Should Not Be Invalid Format- Negative Test
    [Documentation]    UFT test case: 'Accounts - Account Details - Verify Date Range - To Date Should Not Be Invalid Format- Negative Test'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    select kendo dropdown    AccountDetails_SelectAccount    ${account_namenumber}
    Enter Text    AccountDetails_fromDate    01/21/2017
    Click On    AccountDetails_Filter
    Expect Text    AccountDetails_ErrorMessage    From Date cannot be a future date.
    [Teardown]    Log Out myBranch
