
*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../../mybranch_keywords.robot

*** Test Cases ***
View Statements - View Statement
    [Documentation]    View a statment.
    [Tags]    qa_suite    new test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    #Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    # Select Aria List Item    ViewStatements_Account    ${account_namenumber}
    select kendo dropdown    ViewStatements_Account    ${account_namenumber}
    ${month_and_year} =    Get Date    %B %Y    days_modify=-32
    #Select Aria List Item    ViewStatements_StatementPeriod    ${month_and_year}
    select kendo dropdown    ViewStatements_StatementPeriod    ${month_and_year}
    Capture Page Screenshot
    Click On    ViewStatements_View
    Register Window
    Capture Page Screenshot
    Close Window
    Unregister Window
    [Teardown]    Log Out myBranch
